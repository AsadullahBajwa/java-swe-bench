package com.swebench.service;

import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.ApplyCommand;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;

/**
 * Service for applying patches to Git repositories.
 */
public class PatchApplier {
    private static final Logger logger = LoggerFactory.getLogger(PatchApplier.class);

    /**
     * Apply a patch to a repository
     */
    public boolean applyPatch(File repoDir, String patch) {
        if (patch == null || patch.isEmpty()) {
            logger.error("Cannot apply null or empty patch");
            return false;
        }

        try (Git git = Git.open(repoDir)) {
            logger.debug("Applying patch to {}", repoDir.getPath());

            // Convert patch string to input stream
            InputStream patchStream = new ByteArrayInputStream(patch.getBytes());

            // Apply the patch
            ApplyCommand applyCommand = git.apply();
            applyCommand.setPatch(patchStream);
            applyCommand.call();

            logger.info("Successfully applied patch to {}", repoDir.getPath());
            return true;

        } catch (Exception e) {
            logger.error("Failed to apply patch to {}: {}", repoDir.getPath(), e.getMessage());

            // Try git apply as fallback
            return tryGitApply(repoDir, patch);
        }
    }

    /**
     * Fallback method using git command line
     */
    private boolean tryGitApply(File repoDir, String patch) {
        try {
            logger.debug("Trying git apply as fallback");

            // Write patch to temporary file
            File patchFile = File.createTempFile("patch", ".patch");
            java.nio.file.Files.write(patchFile.toPath(), patch.getBytes());

            // Execute git apply
            ProcessBuilder pb = new ProcessBuilder("git", "apply", patchFile.getAbsolutePath());
            pb.directory(repoDir);
            pb.redirectErrorStream(true);

            Process process = pb.start();
            int exitCode = process.waitFor();

            // Cleanup
            patchFile.delete();

            if (exitCode == 0) {
                logger.info("Successfully applied patch using git apply");
                return true;
            } else {
                logger.error("git apply failed with exit code {}", exitCode);
                return false;
            }

        } catch (Exception e) {
            logger.error("git apply fallback failed: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Revert a patch (apply in reverse)
     */
    public boolean revertPatch(File repoDir, String patch) {
        try (Git git = Git.open(repoDir)) {
            logger.debug("Reverting patch from {}", repoDir.getPath());

            // Try using git reset --hard
            git.reset().setMode(org.eclipse.jgit.api.ResetCommand.ResetType.HARD).call();

            logger.info("Successfully reverted changes in {}", repoDir.getPath());
            return true;

        } catch (Exception e) {
            logger.error("Failed to revert patch: {}", e.getMessage());
            return false;
        }
    }
}
