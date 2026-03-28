package com.swebench.evaluation;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.swebench.model.TaskInstance;
import com.swebench.util.ConfigLoader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.Instant;
import java.util.*;

/**
 * Applies AI-generated patches to repositories and records the outcome.
 *
 * <h2>Two modes of operation</h2>
 * <ol>
 *   <li><b>Manual mode</b> (default): Patch files are already present in
 *       {@code data/predictions/<model-name>/<instance_id>.patch}. The runner
 *       picks them up and applies them. To use this mode, just drop the patch
 *       files in the directory and run the script.</li>
 *   <li><b>AI-generated mode</b>: When {@code ai.enabled=true} is set in
 *       {@code config/application.properties}, the runner calls the configured
 *       AI provider to generate a patch for every task that does not already
 *       have a patch file, saves it to disk, then applies it.</li>
 * </ol>
 *
 * <h2>Multi-model evaluation</h2>
 * Each model gets its own sub-directory under {@code data/predictions/} and
 * its own sub-directory under {@code data/patch_results/}. Run the script
 * once per model:
 * <pre>
 *   ./scripts/run_patch_application.sh gpt-4o
 *   ./scripts/run_patch_application.sh claude-3-5-sonnet
 * </pre>
 * Then compare the result directories to rank models.
 *
 * <h2>Output per task</h2>
 * <pre>
 * data/patch_results/&lt;model-name&gt;/&lt;instance_id&gt;.json
 * {
 *   "instance_id": "apache-commons-lang-PR-1234",
 *   "repo":        "apache/commons-lang",
 *   "model":       "gpt-4o",
 *   "base_commit": "abc123",
 *   "patch_status": "APPLIED",   // APPLIED | APPLY_FAILED | NO_PATCH
 *   "error":        null,
 *   "applied_at":   "2026-03-28T10:00:00Z"
 * }
 * </pre>
 */
public class PatchApplicationRunner {

    private static final Logger logger = LoggerFactory.getLogger(PatchApplicationRunner.class);

    private static final String VALIDATED_TASKS_FILE = "data/processed/validated_tasks.json";
    private static final String RESULTS_ROOT         = "data/patch_results";

    private final ObjectMapper   mapper;
    private final PatchReader    patchReader;

    public PatchApplicationRunner() {
        this.mapper      = new ObjectMapper();
        this.mapper.registerModule(new JavaTimeModule());
        this.patchReader = new PatchReader();
    }

    /**
     * Entry point.  {@code modelName} may be {@code null}, in which case:
     * <ul>
     *   <li>AI mode — uses the model name from config ({@code ai.model})</li>
     *   <li>Manual mode — uses the first model directory found in
     *       {@code data/predictions/}, or {@code "default"} if none exist</li>
     * </ul>
     */
    public void execute(String modelName) throws IOException {
        List<TaskInstance> tasks = loadTasks();
        if (tasks.isEmpty()) {
            logger.error("[PatchApplicationRunner] No tasks found in {}", VALIDATED_TASKS_FILE);
            logger.error("Run 'dataset' command first to build validated_tasks.json");
            return;
        }
        logger.info("[PatchApplicationRunner] Loaded {} tasks", tasks.size());

        // Resolve model name
        if (modelName == null || modelName.isBlank()) {
            modelName = resolveDefaultModel();
        }

        logger.info("[PatchApplicationRunner] Using model: {}", modelName);

        // If AI mode is enabled, generate any missing patches first
        if (AiPatchGenerator.isEnabled()) {
            generateMissingPatches(tasks, modelName);
        }

        // Read patches (manual or AI-saved)
        List<PatchedTask> patchedTasks = patchReader.readForModel(tasks, modelName);

        // Apply each patch and write result
        File resultsDir = new File(RESULTS_ROOT, modelName);
        resultsDir.mkdirs();

        int total   = patchedTasks.size();
        int applied = 0, failed = 0, noPatch = 0, skipped = 0;

        for (int i = 0; i < total; i++) {
            PatchedTask pt = patchedTasks.get(i);
            String instanceId = pt.getTask().getInstanceId();

            File resultFile = new File(resultsDir, instanceId + ".json");
            if (resultFile.exists()) {
                logger.debug("[{}/{}] {} → already processed, skipping", i + 1, total, instanceId);
                skipped++;
                continue;
            }

            PatchStatus status;
            String error = null;

            if (!pt.hasPatch()) {
                status = PatchStatus.NO_PATCH;
                noPatch++;
            } else {
                try {
                    status = applyPatch(pt);
                } catch (Exception e) {
                    status = PatchStatus.APPLY_FAILED;
                    error  = e.getMessage();
                    logger.error("[{}/{}] {} → exception: {}", i + 1, total, instanceId, e.getMessage());
                }
                if (status == PatchStatus.APPLIED) applied++;
                else if (status == PatchStatus.APPLY_FAILED) failed++;
            }

            writeResult(resultFile, pt, status, error);
            logger.info("[{}/{}] {} → {}", i + 1, total, instanceId, status);
        }

        logger.info("[PatchApplicationRunner] Done. APPLIED={} FAILED={} NO_PATCH={} SKIPPED={}",
                applied, failed, noPatch, skipped);
    }

    // -------------------------------------------------------------------------
    // AI generation
    // -------------------------------------------------------------------------

    private void generateMissingPatches(List<TaskInstance> tasks, String modelName) {
        AiPatchGenerator generator = new AiPatchGenerator();

        for (TaskInstance task : tasks) {
            File patchFile = new File("data/predictions/" + modelName + "/" + task.getInstanceId() + ".patch");
            if (patchFile.exists()) {
                continue; // already generated
            }

            logger.info("[PatchApplicationRunner] Generating patch for {} ...", task.getInstanceId());
            String patch = generator.generate(task);

            if (patch != null && !patch.isBlank()) {
                String cleaned = extractPatch(patch);
                try {
                    patchReader.savePatch(modelName, task.getInstanceId(), cleaned);
                    logger.info("[PatchApplicationRunner] Patch saved for {}", task.getInstanceId());
                } catch (IOException e) {
                    logger.error("[PatchApplicationRunner] Could not save patch for {}: {}", task.getInstanceId(), e.getMessage());
                }
            } else {
                logger.warn("[PatchApplicationRunner] AI returned empty patch for {}", task.getInstanceId());
            }
        }
    }

    /**
     * Strips markdown code fences if the AI wrapped the diff in them.
     */
    private String extractPatch(String raw) {
        String trimmed = raw.strip();
        // Remove ```diff / ``` or ``` / ``` wrappers
        if (trimmed.startsWith("```")) {
            int firstNewline = trimmed.indexOf('\n');
            if (firstNewline > 0) {
                trimmed = trimmed.substring(firstNewline + 1);
            }
            if (trimmed.endsWith("```")) {
                trimmed = trimmed.substring(0, trimmed.length() - 3).strip();
            }
        }
        return trimmed;
    }

    // -------------------------------------------------------------------------
    // Patch application (via shell / git apply)
    // -------------------------------------------------------------------------

    private PatchStatus applyPatch(PatchedTask pt) throws IOException, InterruptedException {
        TaskInstance task = pt.getTask();

        // Write the patch to a temp workspace so we can call git apply
        File workspaceDir = new File("data/workspaces/patch-apply/" + task.getInstanceId());
        workspaceDir.mkdirs();

        File patchFile = new File(workspaceDir, "ai.patch");
        Files.writeString(patchFile.toPath(), pt.getPatchContent());

        // Determine Docker image
        String dockerImage = resolveDockerImage(task);

        // Write the apply script
        File scriptFile = new File(workspaceDir, "apply-patch.sh");
        Files.writeString(scriptFile.toPath(), buildApplyScript(task));

        if (dockerImage != null) {
            return runInDocker(dockerImage, workspaceDir, task.getInstanceId());
        } else {
            return runNatively(workspaceDir, task.getInstanceId());
        }
    }

    private String buildApplyScript(TaskInstance task) {
        String repoUrl = "https://github.com/" + task.getRepo() + ".git";
        StringBuilder sb = new StringBuilder();
        sb.append("#!/bin/bash\n");
        sb.append("set -e\n\n");
        sb.append("REPO_DIR=/workspace/repo\n\n");

        sb.append("# Clone or reuse repository\n");
        sb.append("if [ ! -d \"$REPO_DIR/.git\" ]; then\n");
        sb.append("  git clone ").append(repoUrl).append(" \"$REPO_DIR\"\n");
        sb.append("fi\n\n");

        sb.append("cd \"$REPO_DIR\"\n");
        sb.append("git fetch --all --quiet\n");
        sb.append("git checkout -f ").append(task.getBaseCommit()).append("\n\n");

        // Apply test_patch first (adds test files)
        if (task.getTestPatch() != null && !task.getTestPatch().isBlank()) {
            sb.append("# Apply test patch\n");
            sb.append("echo \"$TEST_PATCH\" | git apply --whitespace=nowarn - || true\n\n");
        }

        sb.append("# Check then apply the AI patch\n");
        sb.append("git apply --check /workspace/ai.patch 2>/workspace/apply_check.log\n");
        sb.append("if [ $? -ne 0 ]; then\n");
        sb.append("  cat /workspace/apply_check.log\n");
        sb.append("  echo 'APPLY_FAILED'\n");
        sb.append("  exit 1\n");
        sb.append("fi\n\n");

        sb.append("git apply --whitespace=nowarn /workspace/ai.patch\n");
        sb.append("echo 'APPLIED'\n");
        sb.append("exit 0\n");

        return sb.toString();
    }

    private PatchStatus runInDocker(String dockerImage, File workspaceDir, String instanceId)
            throws IOException, InterruptedException {
        String absWorkspace = workspaceDir.getAbsolutePath();
        // Convert Windows path to Docker-compatible path if needed
        String dockerWorkspace = absWorkspace.replace('\\', '/');
        if (dockerWorkspace.matches("[A-Za-z]:.*")) {
            dockerWorkspace = "/" + dockerWorkspace.charAt(0) + dockerWorkspace.substring(2);
        }

        List<String> cmd = new ArrayList<>(Arrays.asList(
                "docker", "run", "--rm",
                "-v", absWorkspace + ":/workspace",
                dockerImage,
                "bash", "/workspace/apply-patch.sh"
        ));

        return runProcess(cmd, instanceId);
    }

    private PatchStatus runNatively(File workspaceDir, String instanceId)
            throws IOException, InterruptedException {
        List<String> cmd = Arrays.asList("bash", new File(workspaceDir, "apply-patch.sh").getAbsolutePath());
        return runProcess(cmd, instanceId);
    }

    private PatchStatus runProcess(List<String> cmd, String instanceId)
            throws IOException, InterruptedException {
        ProcessBuilder pb = new ProcessBuilder(cmd);
        pb.redirectErrorStream(true);

        Process process = pb.start();
        String output = new String(process.getInputStream().readAllBytes());
        int exitCode  = process.waitFor();

        if (exitCode == 0 && output.contains("APPLIED")) {
            return PatchStatus.APPLIED;
        } else {
            logger.debug("[PatchApplicationRunner] apply script output for {}:\n{}", instanceId, output);
            return PatchStatus.APPLY_FAILED;
        }
    }

    // -------------------------------------------------------------------------
    // Docker image selection (mirrors the logic from run-all-docker.sh)
    // -------------------------------------------------------------------------

    private String resolveDockerImage(TaskInstance task) {
        String javaVersion = task.getJavaVersion();
        String buildTool   = task.getBuildTool();

        if (javaVersion == null || buildTool == null) {
            return null; // run natively as fallback
        }

        String jv = javaVersion.trim();
        String bt = buildTool.trim().toLowerCase();

        if (bt.contains("gradle")) {
            return "swe-bench:java17-gradle";
        }
        // Maven
        return switch (jv) {
            case "21" -> "swe-bench:java21-maven";
            case "23" -> "swe-bench:java23-maven";
            default   -> "swe-bench:java17-maven"; // covers 8, 11, 17
        };
    }

    // -------------------------------------------------------------------------
    // I/O helpers
    // -------------------------------------------------------------------------

    private List<TaskInstance> loadTasks() throws IOException {
        File f = new File(VALIDATED_TASKS_FILE);
        if (!f.exists()) {
            return Collections.emptyList();
        }
        return mapper.readValue(f, new TypeReference<List<TaskInstance>>() {});
    }

    private String resolveDefaultModel() {
        // AI mode: use configured model name
        if (AiPatchGenerator.isEnabled()) {
            return ConfigLoader.get("ai.model", "ai-generated");
        }
        // Manual mode: pick first available predictions directory
        List<String> available = patchReader.availableModels();
        if (!available.isEmpty()) {
            return available.get(0);
        }
        return "default";
    }

    private void writeResult(File resultFile, PatchedTask pt, PatchStatus status, String error) throws IOException {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("instance_id",  pt.getTask().getInstanceId());
        result.put("repo",         pt.getTask().getRepo());
        result.put("model",        pt.getModelName());
        result.put("base_commit",  pt.getTask().getBaseCommit());
        result.put("patch_status", status.name());
        result.put("error",        error);
        result.put("applied_at",   Instant.now().toString());

        mapper.writerWithDefaultPrettyPrinter().writeValue(resultFile, result);
    }

    // -------------------------------------------------------------------------

    /** Possible outcomes of a patch application attempt. */
    public enum PatchStatus {
        APPLIED,
        APPLY_FAILED,
        NO_PATCH
    }
}
