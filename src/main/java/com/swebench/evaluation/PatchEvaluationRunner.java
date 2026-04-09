package com.swebench.evaluation;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.swebench.model.TaskInstance;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.Instant;
import java.util.*;

/**
 * Evaluation Harness — Issue #16.
 *
 * <p>For every task where the prediction patch applied cleanly (patch_status = APPLIED),
 * this runner:
 * <ol>
 *   <li>Checks out the repo at {@code base_commit} inside Docker</li>
 *   <li>Applies the {@code test_patch} to add the test files</li>
 *   <li>Applies the prediction patch from {@code data/predictions/<model>/<instance_id>.patch}</li>
 *   <li>Runs the {@code FAIL_TO_PASS} tests — these must now pass</li>
 *   <li>Runs the {@code PASS_TO_PASS} tests — these must still pass (no regressions)</li>
 * </ol>
 *
 * <h2>Result status values</h2>
 * <ul>
 *   <li>{@code resolved}           — all FAIL_TO_PASS pass, no regressions</li>
 *   <li>{@code not_resolved}       — FAIL_TO_PASS tests still failing</li>
 *   <li>{@code regression}         — FAIL_TO_PASS pass but PASS_TO_PASS broke</li>
 *   <li>{@code patch_apply_failed} — patch did not apply (carried over from stage 1)</li>
 *   <li>{@code build_failed}       — project failed to compile</li>
 *   <li>{@code no_prediction}      — no patch file found for this task</li>
 * </ul>
 *
 * <h2>Output per task</h2>
 * <pre>
 * data/results/&lt;model&gt;/&lt;instance_id&gt;.json
 * </pre>
 */
public class PatchEvaluationRunner {

    private static final Logger logger = LoggerFactory.getLogger(PatchEvaluationRunner.class);

    private static final String VALIDATED_TASKS_FILE = "data/processed/validated_tasks.json";
    private static final String PATCH_RESULTS_ROOT   = "data/patch_results";
    private static final String RESULTS_ROOT         = "data/results";
    private static final String PREDICTIONS_ROOT     = "data/predictions";

    private final ObjectMapper mapper;

    public PatchEvaluationRunner() {
        this.mapper = new ObjectMapper();
        this.mapper.registerModule(new JavaTimeModule());
    }

    public void execute(String modelName) throws IOException {
        List<TaskInstance> tasks = loadTasks();
        if (tasks.isEmpty()) {
            logger.error("[PatchEvaluationRunner] No tasks found in {}", VALIDATED_TASKS_FILE);
            return;
        }
        logger.info("[PatchEvaluationRunner] Loaded {} tasks for model '{}'", tasks.size(), modelName);

        File resultsDir = new File(RESULTS_ROOT, modelName);
        resultsDir.mkdirs();

        int total = tasks.size();
        int resolved = 0, notResolved = 0, applyFailed = 0, buildFailed = 0, noPred = 0, skipped = 0;

        for (int i = 0; i < total; i++) {
            TaskInstance task = tasks.get(i);
            String instanceId = task.getInstanceId();

            File resultFile = new File(resultsDir, instanceId + ".json");
            if (resultFile.exists()) {
                logger.debug("[{}/{}] {} → already evaluated, skipping", i + 1, total, instanceId);
                skipped++;
                continue;
            }

            // Check patch_status from stage 1
            PatchApplicationRunner.PatchStatus patchStatus = readPatchStatus(modelName, instanceId);

            if (patchStatus == PatchApplicationRunner.PatchStatus.NO_PATCH) {
                writeResult(resultFile, task, modelName, EvalStatus.NO_PREDICTION, null, null, null);
                logger.info("[{}/{}] {} → no_prediction", i + 1, total, instanceId);
                noPred++;
                continue;
            }

            if (patchStatus == PatchApplicationRunner.PatchStatus.APPLY_FAILED) {
                writeResult(resultFile, task, modelName, EvalStatus.PATCH_APPLY_FAILED, null, null, null);
                logger.info("[{}/{}] {} → patch_apply_failed", i + 1, total, instanceId);
                applyFailed++;
                continue;
            }

            // Patch was APPLIED — now run the tests
            EvalResult evalResult;
            try {
                evalResult = runTests(task, modelName);
            } catch (Exception e) {
                logger.error("[{}/{}] {} → exception: {}", i + 1, total, instanceId, e.getMessage());
                writeResult(resultFile, task, modelName, EvalStatus.BUILD_FAILED, null, null, e.getMessage());
                buildFailed++;
                continue;
            }

            writeResult(resultFile, task, modelName, evalResult.status,
                    evalResult.failToPassResults, evalResult.passToPassResults, evalResult.error);
            logger.info("[{}/{}] {} → {}", i + 1, total, instanceId, evalResult.status.value);

            if (evalResult.status == EvalStatus.RESOLVED)          resolved++;
            else if (evalResult.status == EvalStatus.NOT_RESOLVED) notResolved++;
            else if (evalResult.status == EvalStatus.BUILD_FAILED)  buildFailed++;
        }

        logger.info("[PatchEvaluationRunner] Done. resolved={} not_resolved={} apply_failed={} build_failed={} no_pred={} skipped={}",
                resolved, notResolved, applyFailed, buildFailed, noPred, skipped);
    }

    // -------------------------------------------------------------------------
    // Test execution
    // -------------------------------------------------------------------------

    private EvalResult runTests(TaskInstance task, String modelName)
            throws IOException, InterruptedException {

        File workspaceDir = new File("data/workspaces/evaluation/" + modelName + "/" + task.getInstanceId());
        workspaceDir.mkdirs();

        // Copy prediction patch into workspace
        File patchSrc = new File(PREDICTIONS_ROOT + "/" + modelName + "/" + task.getInstanceId() + ".patch");
        Files.copy(patchSrc.toPath(), new File(workspaceDir, "ai.patch").toPath(),
                java.nio.file.StandardCopyOption.REPLACE_EXISTING);

        // Write test_patch if present
        if (task.getTestPatch() != null && !task.getTestPatch().isBlank()) {
            Files.writeString(new File(workspaceDir, "test.patch").toPath(), task.getTestPatch());
        }

        // Write evaluation shell script
        Files.writeString(new File(workspaceDir, "evaluate.sh").toPath(), buildEvalScript(task));

        String dockerImage = resolveDockerImage(task);
        String output = runScript(dockerImage, workspaceDir);

        return parseOutput(output, task);
    }

    private String buildEvalScript(TaskInstance task) {
        String repoUrl = "https://github.com/" + task.getRepo() + ".git";
        String testCmd = task.getTestCommand() != null
                ? task.getTestCommand()
                : buildTestCommand(task, task.getFailToPass());

        StringBuilder sb = new StringBuilder();
        sb.append("#!/bin/bash\n");
        sb.append("set -e\n\n");
        sb.append("REPO_DIR=/workspace/repo\n\n");

        // Clone or reuse
        sb.append("if [ ! -d \"$REPO_DIR/.git\" ]; then\n");
        sb.append("  git clone ").append(repoUrl).append(" \"$REPO_DIR\"\n");
        sb.append("fi\n\n");

        sb.append("cd \"$REPO_DIR\"\n");
        sb.append("git fetch --all --quiet\n");
        sb.append("git checkout -f ").append(task.getBaseCommit()).append("\n\n");

        // Apply test patch
        if (task.getTestPatch() != null && !task.getTestPatch().isBlank()) {
            sb.append("# Apply test patch (adds test files)\n");
            sb.append("git apply --whitespace=nowarn /workspace/test.patch\n\n");
        }

        // Apply prediction patch
        sb.append("# Apply prediction patch\n");
        sb.append("git apply --check /workspace/ai.patch 2>/workspace/apply_check.log\n");
        sb.append("if [ $? -ne 0 ]; then\n");
        sb.append("  echo 'PATCH_APPLY_FAILED'\n");
        sb.append("  cat /workspace/apply_check.log\n");
        sb.append("  exit 0\n");
        sb.append("fi\n");
        sb.append("git apply --whitespace=nowarn /workspace/ai.patch\n\n");

        // Run FAIL_TO_PASS tests
        sb.append("# Run FAIL_TO_PASS tests\n");
        sb.append("echo 'RUNNING_FAIL_TO_PASS'\n");
        sb.append("set +e\n");
        sb.append(testCmd).append(" 2>&1\n");
        sb.append("FAIL_EXIT=$?\n");
        sb.append("set -e\n");
        sb.append("if [ $FAIL_EXIT -eq 0 ]; then echo 'FAIL_TO_PASS_PASSED'; else echo 'FAIL_TO_PASS_FAILED'; fi\n\n");

        // Run PASS_TO_PASS tests if any exist
        if (task.getPassToPass() != null && !task.getPassToPass().isEmpty()) {
            String p2pCmd = buildTestCommand(task, task.getPassToPass());
            sb.append("# Run PASS_TO_PASS tests\n");
            sb.append("echo 'RUNNING_PASS_TO_PASS'\n");
            sb.append("set +e\n");
            sb.append(p2pCmd).append(" 2>&1\n");
            sb.append("P2P_EXIT=$?\n");
            sb.append("set -e\n");
            sb.append("if [ $P2P_EXIT -eq 0 ]; then echo 'PASS_TO_PASS_PASSED'; else echo 'PASS_TO_PASS_FAILED'; fi\n");
        } else {
            sb.append("echo 'PASS_TO_PASS_SKIPPED'\n");
        }

        sb.append("\nexit 0\n");
        return sb.toString();
    }

    private String buildTestCommand(TaskInstance task, List<String> tests) {
        if (tests == null || tests.isEmpty()) return "echo 'no tests configured'";
        String bt = task.getBuildTool() != null ? task.getBuildTool().toLowerCase() : "maven";
        String joined = String.join(",", tests);
        if (bt.contains("gradle")) return "./gradlew test --tests " + joined;
        return "mvn test -Dtest=" + joined + " -q";
    }

    private String runScript(String dockerImage, File workspaceDir)
            throws IOException, InterruptedException {
        List<String> cmd;
        if (dockerImage != null) {
            cmd = Arrays.asList(
                    "docker", "run", "--rm",
                    "-v", workspaceDir.getAbsolutePath() + ":/workspace",
                    dockerImage,
                    "bash", "/workspace/evaluate.sh"
            );
        } else {
            cmd = Arrays.asList("bash", new File(workspaceDir, "evaluate.sh").getAbsolutePath());
        }

        ProcessBuilder pb = new ProcessBuilder(cmd);
        pb.redirectErrorStream(true);
        Process process = pb.start();
        String output = new String(process.getInputStream().readAllBytes());
        process.waitFor();
        return output;
    }

    private EvalResult parseOutput(String output, TaskInstance task) {
        if (output.contains("PATCH_APPLY_FAILED")) {
            return new EvalResult(EvalStatus.PATCH_APPLY_FAILED, null, null, null);
        }

        // Neither marker appeared — build failed before tests ran
        if (!output.contains("FAIL_TO_PASS_PASSED") && !output.contains("FAIL_TO_PASS_FAILED")) {
            return new EvalResult(EvalStatus.BUILD_FAILED, null, null, extractBuildError(output));
        }

        boolean f2pPassed = output.contains("FAIL_TO_PASS_PASSED");
        boolean p2pPassed = !output.contains("PASS_TO_PASS_FAILED"); // skipped = passed

        int f2pTotal = task.getFailToPass() != null ? task.getFailToPass().size() : 0;
        int p2pTotal = task.getPassToPass() != null ? task.getPassToPass().size() : 0;

        Map<String, Integer> f2p = new LinkedHashMap<>();
        f2p.put("total",  f2pTotal);
        f2p.put("passed", f2pPassed ? f2pTotal : 0);
        f2p.put("failed", f2pPassed ? 0 : f2pTotal);

        Map<String, Integer> p2p = new LinkedHashMap<>();
        p2p.put("total",  p2pTotal);
        p2p.put("passed", p2pPassed ? p2pTotal : 0);
        p2p.put("failed", p2pPassed ? 0 : p2pTotal);

        if (!f2pPassed) return new EvalResult(EvalStatus.NOT_RESOLVED, f2p, p2p, null);
        if (!p2pPassed) return new EvalResult(EvalStatus.REGRESSION,   f2p, p2p, null);
        return new EvalResult(EvalStatus.RESOLVED, f2p, p2p, null);
    }

    private String extractBuildError(String output) {
        for (String line : output.split("\n")) {
            String t = line.trim();
            if (t.contains("BUILD FAILURE") || t.startsWith("ERROR") || t.contains("FAILED")) {
                return t;
            }
        }
        return "Build failed — see workspace logs";
    }

    // -------------------------------------------------------------------------
    // Docker image selection
    // -------------------------------------------------------------------------

    private String resolveDockerImage(TaskInstance task) {
        String jv = task.getJavaVersion();
        String bt = task.getBuildTool();
        if (jv == null || bt == null) return null;
        if (bt.trim().toLowerCase().contains("gradle")) return "swe-bench:java17-gradle";
        return switch (jv.trim()) {
            case "21" -> "swe-bench:java21-maven";
            case "23" -> "swe-bench:java23-maven";
            default   -> "swe-bench:java17-maven";
        };
    }

    // -------------------------------------------------------------------------
    // I/O helpers
    // -------------------------------------------------------------------------

    private List<TaskInstance> loadTasks() throws IOException {
        File f = new File(VALIDATED_TASKS_FILE);
        if (!f.exists()) return Collections.emptyList();
        return mapper.readValue(f, new TypeReference<List<TaskInstance>>() {});
    }

    private PatchApplicationRunner.PatchStatus readPatchStatus(String modelName, String instanceId) {
        File f = new File(PATCH_RESULTS_ROOT + "/" + modelName + "/" + instanceId + ".json");
        if (!f.exists()) return PatchApplicationRunner.PatchStatus.NO_PATCH;
        try {
            Map<?, ?> data = mapper.readValue(f, Map.class);
            return PatchApplicationRunner.PatchStatus.valueOf((String) data.get("patch_status"));
        } catch (Exception e) {
            logger.warn("[PatchEvaluationRunner] Could not read patch status for {}: {}", instanceId, e.getMessage());
            return PatchApplicationRunner.PatchStatus.NO_PATCH;
        }
    }

    private void writeResult(File resultFile, TaskInstance task, String modelName,
                             EvalStatus status,
                             Map<String, Integer> f2p,
                             Map<String, Integer> p2p,
                             String error) throws IOException {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("instance_id",          task.getInstanceId());
        result.put("repo",                 task.getRepo());
        result.put("model",                modelName);
        result.put("status",               status.value);
        result.put("fail_to_pass_results", f2p);
        result.put("pass_to_pass_results", p2p);
        result.put("error",                error);
        result.put("evaluated_at",         Instant.now().toString());
        mapper.writerWithDefaultPrettyPrinter().writeValue(resultFile, result);
    }

    // -------------------------------------------------------------------------
    // Inner types
    // -------------------------------------------------------------------------

    public enum EvalStatus {
        RESOLVED("resolved"),
        NOT_RESOLVED("not_resolved"),
        REGRESSION("regression"),
        PATCH_APPLY_FAILED("patch_apply_failed"),
        BUILD_FAILED("build_failed"),
        NO_PREDICTION("no_prediction");

        public final String value;
        EvalStatus(String v) { this.value = v; }
    }

    private static class EvalResult {
        final EvalStatus             status;
        final Map<String, Integer>   failToPassResults;
        final Map<String, Integer>   passToPassResults;
        final String                 error;

        EvalResult(EvalStatus s, Map<String, Integer> f2p, Map<String, Integer> p2p, String err) {
            this.status           = s;
            this.failToPassResults = f2p;
            this.passToPassResults = p2p;
            this.error            = err;
        }
    }
}
