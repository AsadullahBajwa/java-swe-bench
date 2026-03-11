// Part of the benchmark dataset pipeline
package com.swebench.pipeline;

import com.swebench.model.TaskInstance;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.*;

/**
 * Builds the final benchmark dataset by aggregating VALID tasks from all repos.
 *
 * Reads:  data/testing/<repo>/tasks.json         — task data
 *         data/testing/<repo>/TASKS_STATUS.md     — validation results
 *
 * Writes: data/processed/validated_tasks.json    — VALID tasks only
 */
public class DatasetBuilder {
    private static final Logger logger = LoggerFactory.getLogger(DatasetBuilder.class);

    private static final String TESTING_DIR  = "data/testing";
    private static final String OUTPUT_FILE  = "data/processed/validated_tasks.json";

    private final ObjectMapper objectMapper;

    public DatasetBuilder() {
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
    }

    public void execute() throws IOException {
        File testingDir = new File(TESTING_DIR);
        if (!testingDir.exists() || !testingDir.isDirectory()) {
            logger.error("Testing directory not found: {}", TESTING_DIR);
            return;
        }

        File[] repoDirs = testingDir.listFiles(File::isDirectory);
        if (repoDirs == null || repoDirs.length == 0) {
            logger.warn("No repo directories found in {}", TESTING_DIR);
            return;
        }

        Arrays.sort(repoDirs, Comparator.comparing(File::getName));

        List<TaskInstance> allValid = new ArrayList<>();

        for (File repoDir : repoDirs) {
            File tasksFile  = new File(repoDir, "tasks.json");
            File statusFile = new File(repoDir, "TASKS_STATUS.md");

            if (!tasksFile.exists()) {
                continue; // not a repo dir (e.g. run-all-docker.sh sitting in testing/)
            }

            if (!statusFile.exists()) {
                logger.warn("[{}] No TASKS_STATUS.md found — skipping", repoDir.getName());
                continue;
            }

            List<TaskInstance> tasks = loadTasks(tasksFile);
            Set<String> validIds    = parseValidInstanceIds(statusFile, tasks);

            List<TaskInstance> valid = new ArrayList<>();
            for (TaskInstance t : tasks) {
                if (validIds.contains(t.getInstanceId())) {
                    valid.add(t);
                }
            }

            logger.info("[DatasetBuilder] {}: {}/{} VALID",
                    repoDir.getName(), valid.size(), tasks.size());

            allValid.addAll(valid);
        }

        writeOutput(allValid);

        logger.info("[DatasetBuilder] Total VALID tasks: {} written to {}",
                allValid.size(), OUTPUT_FILE);
    }

    // -------------------------------------------------------------------------

    private List<TaskInstance> loadTasks(File tasksFile) throws IOException {
        return objectMapper.readValue(
                tasksFile,
                new TypeReference<List<TaskInstance>>() {}
        );
    }

    /**
     * Parses TASKS_STATUS.md and returns the set of instance_ids that are VALID.
     *
     * Table rows look like:
     *   | 1591 | 7bcb03a... | ClassUtilsTest | FAIL (1) | PASS (0) | **VALID** | |
     *
     * The PR number (1st field) is matched against each task's instance_id suffix.
     */
    private Set<String> parseValidInstanceIds(File statusFile, List<TaskInstance> tasks)
            throws IOException {

        // Build a lookup: PR number (string) → instance_id
        Map<String, String> prToInstanceId = new HashMap<>();
        for (TaskInstance t : tasks) {
            String id = t.getInstanceId();
            // instance_id ends with -PR-<number>
            int idx = id.lastIndexOf("-PR-");
            if (idx >= 0) {
                String prNum = id.substring(idx + 4); // e.g. "1591"
                prToInstanceId.put(prNum, id);
            }
        }

        Set<String> validIds = new HashSet<>();
        List<String> lines = Files.readAllLines(statusFile.toPath());

        for (String line : lines) {
            // Only process table data rows (start with |, not header/separator)
            if (!line.startsWith("|")) continue;
            if (line.contains("---")) continue;      // separator row
            if (line.contains("PR #")) continue;     // header row

            String[] fields = line.split("\\|");
            // fields[0] = "" (before first |), fields[1] = PR#, ..., fields[6] = Status
            if (fields.length < 7) continue;

            String status = fields[6].trim();
            if (!status.contains("VALID") || status.contains("INVALID")) continue;

            String prNum = fields[1].trim();
            String instanceId = prToInstanceId.get(prNum);
            if (instanceId != null) {
                validIds.add(instanceId);
            }
        }

        return validIds;
    }

    private void writeOutput(List<TaskInstance> tasks) throws IOException {
        File outputFile = new File(OUTPUT_FILE);
        outputFile.getParentFile().mkdirs();
        objectMapper.writerWithDefaultPrettyPrinter().writeValue(outputFile, tasks);
    }
}
