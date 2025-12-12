package com.swebench.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;
import java.util.stream.Stream;

/**
 * Utility methods for file operations.
 */
public class FileUtils {
    private static final Logger logger = LoggerFactory.getLogger(FileUtils.class);

    /**
     * Delete a directory recursively
     */
    public static void deleteDirectory(File directory) throws IOException {
        if (!directory.exists()) {
            return;
        }

        try (Stream<Path> walk = Files.walk(directory.toPath())) {
            walk.sorted(Comparator.reverseOrder())
                .map(Path::toFile)
                .forEach(File::delete);
        }

        logger.debug("Deleted directory: {}", directory.getPath());
    }

    /**
     * Ensure a directory exists, create if needed
     */
    public static void ensureDirectory(String path) throws IOException {
        File dir = new File(path);
        if (!dir.exists()) {
            if (dir.mkdirs()) {
                logger.debug("Created directory: {}", path);
            } else {
                throw new IOException("Failed to create directory: " + path);
            }
        }
    }

    /**
     * Read file contents as string
     */
    public static String readFile(File file) throws IOException {
        return Files.readString(file.toPath());
    }

    /**
     * Write string to file
     */
    public static void writeFile(File file, String content) throws IOException {
        Files.writeString(file.toPath(), content);
        logger.debug("Wrote {} bytes to {}", content.length(), file.getPath());
    }

    /**
     * Get file extension
     */
    public static String getExtension(String filename) {
        int lastDot = filename.lastIndexOf('.');
        if (lastDot > 0) {
            return filename.substring(lastDot + 1);
        }
        return "";
    }

    /**
     * Check if file is a Java source file
     */
    public static boolean isJavaFile(String filename) {
        return filename != null && filename.endsWith(".java");
    }

    /**
     * Check if file is a test file
     */
    public static boolean isTestFile(String filename) {
        if (filename == null) {
            return false;
        }
        String lower = filename.toLowerCase();
        return lower.contains("test") ||
               lower.endsWith("test.java") ||
               lower.endsWith("tests.java");
    }
}
