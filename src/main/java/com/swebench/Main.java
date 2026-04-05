package com.swebench;

import com.swebench.evaluation.PatchApplicationRunner;
import com.swebench.evaluation.PatchEvaluationRunner;
import com.swebench.evaluation.ResultsReporter;
import com.swebench.pipeline.RepositoryDiscovery;
import com.swebench.pipeline.AttributeFilter;
import com.swebench.pipeline.ExecutionFilter;
import com.swebench.pipeline.TestingSetup;
import com.swebench.pipeline.DatasetBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Main entry point for Java SWE-Bench benchmark collection and evaluation.
 * Implements a three-stage pipeline: Discovery -> Attribute Filtering -> Execution Filtering
 */
public class Main {
    private static final Logger logger = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) {
        logger.info("Starting Java SWE-Bench Pipeline");

        try {
            if (args.length == 0) {
                printUsage();
                return;
            }

            String command = args[0];
            switch (command) {
                case "discover":
                    runDiscovery(args);
                    break;
                case "filter":
                    runAttributeFilter(args);
                    break;
                case "validate":
                    runExecutionFilter(args);
                    break;
                case "setup-testing":
                    runTestingSetup(args);
                    break;
                case "pipeline":
                    runFullPipeline(args);
                    break;
                case "dataset":
                    runDatasetBuilder(args);
                    break;
                case "patch-apply":
                    runPatchApplication(args);
                    break;
                case "evaluate":
                    runEvaluation(args);
                    break;
                case "report":
                    runReport(args);
                    break;
                default:
                    logger.error("Unknown command: {}", command);
                    printUsage();
            }
        } catch (Exception e) {
            logger.error("Pipeline execution failed", e);
            System.exit(1);
        }
    }

    private static void runDiscovery(String[] args) {
        logger.info("Running repository discovery stage");
        RepositoryDiscovery discovery = new RepositoryDiscovery();
        discovery.execute();
    }

    private static void runAttributeFilter(String[] args) {
        logger.info("Running attribute filtering stage");
        AttributeFilter filter = new AttributeFilter();
        filter.execute();
    }

    private static void runExecutionFilter(String[] args) {
        logger.info("Running execution filtering stage");
        ExecutionFilter filter = new ExecutionFilter();
        filter.execute();
    }

    private static void runTestingSetup(String[] args) {
        logger.info("Setting up testing directory structure");
        TestingSetup setup = new TestingSetup();
        setup.execute();
    }

    private static void runDatasetBuilder(String[] args) throws Exception {
        logger.info("Building validated benchmark dataset");
        DatasetBuilder builder = new DatasetBuilder();
        builder.execute();
    }

    private static void runPatchApplication(String[] args) throws Exception {
        // Optional second argument: model name (e.g. "gpt-4o", "claude-3-5-sonnet")
        String modelName = (args.length > 1) ? args[1] : null;
        logger.info("Running patch application (model={})", modelName != null ? modelName : "<auto>");
        PatchApplicationRunner runner = new PatchApplicationRunner();
        runner.execute(modelName);
    }

    private static void runEvaluation(String[] args) throws Exception {
        String modelName = (args.length > 1) ? args[1] : null;
        if (modelName == null) {
            logger.error("Usage: evaluate <model-name>");
            return;
        }
        logger.info("Running evaluation harness (model={})", modelName);
        PatchEvaluationRunner runner = new PatchEvaluationRunner();
        runner.execute(modelName);
    }

    private static void runReport(String[] args) throws Exception {
        String modelName = (args.length > 1) ? args[1] : null;
        if (modelName == null) {
            logger.error("Usage: report <model-name>");
            return;
        }
        logger.info("Generating results report (model={})", modelName);
        ResultsReporter reporter = new ResultsReporter();
        reporter.execute(modelName);
    }

    private static void runFullPipeline(String[] args) {
        logger.info("Running full pipeline");
        runDiscovery(args);
        runAttributeFilter(args);
        runExecutionFilter(args);
        logger.info("Full pipeline completed");
    }

    private static void printUsage() {
        System.out.println("Java SWE-Bench Pipeline");
        System.out.println("Usage: java -jar java-swe-bench.jar <command> [options]");
        System.out.println();
        System.out.println("Commands:");
        System.out.println("  discover      - Run repository discovery stage");
        System.out.println("  filter        - Run attribute filtering stage");
        System.out.println("  validate      - Run execution filtering stage");
        System.out.println("  setup-testing - Setup testing directory structure with patch files");
        System.out.println("  pipeline      - Run full pipeline (all stages)");
        System.out.println("  dataset       - Build validated_tasks.json from VALID tasks in data/testing/");
        System.out.println("  patch-apply   - Apply patches from data/predictions/<model>/ and record outcomes");
        System.out.println("                  Required arg: model name (e.g. 'gpt-4o')");
        System.out.println("  evaluate      - Run tests on patched repos to determine if issue is resolved");
        System.out.println("                  Required arg: model name");
        System.out.println("  report        - Generate markdown + JSON summary report from evaluation results");
        System.out.println("                  Required arg: model name");
        System.out.println();
        System.out.println("Examples:");
        System.out.println("  java -jar java-swe-bench.jar discover");
        System.out.println("  java -jar java-swe-bench.jar setup-testing");
        System.out.println("  java -jar java-swe-bench.jar pipeline");
        System.out.println("  java -jar java-swe-bench.jar patch-apply gpt-4o");
        System.out.println("  java -jar java-swe-bench.jar evaluate gpt-4o");
        System.out.println("  java -jar java-swe-bench.jar report gpt-4o");
    }
}
