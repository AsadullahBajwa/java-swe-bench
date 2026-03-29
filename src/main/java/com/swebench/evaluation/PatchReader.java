package com.swebench.evaluation;

import com.swebench.model.TaskInstance;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

/**
 * Reads AI-generated patch files from {@code data/predictions/<model-name>/}.
 *
 * <p>Directory layout expected on disk:
 * <pre>
 * data/predictions/
 *   gpt-4o/
 *     apache-commons-lang-PR-1234.patch
 *     apache-commons-lang-PR-5678.patch
 *   claude-3-5-sonnet/
 *     apache-commons-lang-PR-1234.patch
 * </pre>
 *
 * <p>For each task, if no matching {@code <instance_id>.patch} file is found a
 * {@link PatchedTask} with {@code patchContent == null} is returned so that the
 * runner can record a {@code NO_PATCH} outcome without throwing.
 */
public class PatchReader {

    private static final Logger logger = LoggerFactory.getLogger(PatchReader.class);

    /** Root directory that contains one sub-directory per model. */
    private static final String PREDICTIONS_ROOT = "data/predictions";

    /**
     * Returns a {@link PatchedTask} for every task in {@code tasks}, matched
     * against the patch files found under {@code data/predictions/<modelName>/}.
     *
     * @param tasks     tasks to match
     * @param modelName sub-directory name (e.g. {@code "gpt-4o"})
     */
    public List<PatchedTask> readForModel(List<TaskInstance> tasks, String modelName) {
        File modelDir = new File(PREDICTIONS_ROOT, modelName);
        if (!modelDir.exists()) {
            logger.warn("[PatchReader] Directory not found: {} — all tasks will have NO_PATCH", modelDir);
        }

        List<PatchedTask> result = new ArrayList<>();
        for (TaskInstance task : tasks) {
            String patchContent = loadPatch(modelDir, task.getInstanceId());
            if (patchContent == null) {
                logger.warn("[PatchReader] No patch for {} in model '{}'", task.getInstanceId(), modelName);
            }
            result.add(new PatchedTask(task, modelName, patchContent));
        }
        return result;
    }

    /**
     * Lists all model names that have a sub-directory under
     * {@code data/predictions/}.
     */
    public List<String> availableModels() {
        File root = new File(PREDICTIONS_ROOT);
        List<String> models = new ArrayList<>();
        if (!root.exists() || !root.isDirectory()) {
            return models;
        }
        File[] dirs = root.listFiles(File::isDirectory);
        if (dirs != null) {
            for (File d : dirs) {
                models.add(d.getName());
            }
        }
        return models;
    }

    /**
     * Saves a generated patch to disk so it can be reused on re-runs.
     *
     * @param modelName  sub-directory name
     * @param instanceId task instance id
     * @param content    unified diff content
     */
    public void savePatch(String modelName, String instanceId, String content) throws IOException {
        File modelDir = new File(PREDICTIONS_ROOT, modelName);
        modelDir.mkdirs();
        File patchFile = new File(modelDir, instanceId + ".patch");
        Files.writeString(patchFile.toPath(), content);
        logger.debug("[PatchReader] Saved patch to {}", patchFile);
    }

    // -------------------------------------------------------------------------

    private String loadPatch(File modelDir, String instanceId) {
        if (!modelDir.exists()) {
            return null;
        }
        File patchFile = new File(modelDir, instanceId + ".patch");
        if (!patchFile.exists()) {
            return null;
        }
        try {
            return Files.readString(patchFile.toPath());
        } catch (IOException e) {
            logger.error("[PatchReader] Failed to read {}: {}", patchFile, e.getMessage());
            return null;
        }
    }
}
