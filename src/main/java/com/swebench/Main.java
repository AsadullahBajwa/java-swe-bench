package com.swebench;

import com.swebench.pipeline.RepositoryDiscovery;
import com.swebench.pipeline.AttributeFilter;
import com.swebench.pipeline.ExecutionFilter;
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
                case "pipeline":
                    runFullPipeline(args);
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
        System.out.println("  discover   - Run repository discovery stage");
        System.out.println("  filter     - Run attribute filtering stage");
        System.out.println("  validate   - Run execution filtering stage");
        System.out.println("  pipeline   - Run full pipeline (all stages)");
        System.out.println();
        System.out.println("Examples:");
        System.out.println("  java -jar java-swe-bench.jar discover");
        System.out.println("  java -jar java-swe-bench.jar pipeline");
    }
}
