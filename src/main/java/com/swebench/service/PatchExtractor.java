package com.swebench.service;

import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.diff.DiffEntry;
import org.eclipse.jgit.diff.DiffFormatter;
import org.eclipse.jgit.lib.ObjectId;
import org.eclipse.jgit.lib.ObjectReader;
import org.eclipse.jgit.revwalk.RevCommit;
import org.eclipse.jgit.revwalk.RevWalk;
import org.eclipse.jgit.treewalk.CanonicalTreeParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.List;

/**
 * Service for extracting patches from Git repositories.
 */
public class PatchExtractor {
    private static final Logger logger = LoggerFactory.getLogger(PatchExtractor.class);

    /**
     * Extract a unified diff patch between two commits
     */
    public String extractPatch(File repoDir, String baseCommit, String patchCommit) {
        try (Git git = Git.open(repoDir)) {
            ObjectId baseId = git.getRepository().resolve(baseCommit);
            ObjectId patchId = git.getRepository().resolve(patchCommit);

            if (baseId == null || patchId == null) {
                logger.error("Could not resolve commits: {} or {}", baseCommit, patchCommit);
                return null;
            }

            try (ObjectReader reader = git.getRepository().newObjectReader()) {
                CanonicalTreeParser oldTreeIter = new CanonicalTreeParser();
                oldTreeIter.reset(reader, new RevWalk(git.getRepository())
                    .parseCommit(baseId).getTree());

                CanonicalTreeParser newTreeIter = new CanonicalTreeParser();
                newTreeIter.reset(reader, new RevWalk(git.getRepository())
                    .parseCommit(patchId).getTree());

                ByteArrayOutputStream out = new ByteArrayOutputStream();
                try (DiffFormatter formatter = new DiffFormatter(out)) {
                    formatter.setRepository(git.getRepository());
                    List<DiffEntry> diffs = formatter.scan(oldTreeIter, newTreeIter);

                    for (DiffEntry diff : diffs) {
                        formatter.format(diff);
                    }
                }

                String patch = out.toString();
                logger.debug("Extracted patch of {} bytes", patch.length());
                return patch;
            }

        } catch (Exception e) {
            logger.error("Failed to extract patch between {} and {}: {}",
                baseCommit, patchCommit, e.getMessage());
            return null;
        }
    }

    /**
     * Extract patch for a specific pull request
     */
    public String extractPatchForPR(File repoDir, String prBranch, String baseBranch) {
        try (Git git = Git.open(repoDir)) {
            // Get the merge base
            ObjectId prId = git.getRepository().resolve(prBranch);
            ObjectId baseId = git.getRepository().resolve(baseBranch);

            if (prId == null || baseId == null) {
                logger.error("Could not resolve branches: {} or {}", prBranch, baseBranch);
                return null;
            }

            return extractPatch(repoDir, baseBranch, prBranch);

        } catch (Exception e) {
            logger.error("Failed to extract PR patch: {}", e.getMessage());
            return null;
        }
    }

    /**
     * Validate that a patch is well-formed
     */
    public boolean validatePatch(String patch) {
        if (patch == null || patch.isEmpty()) {
            return false;
        }

        // Basic validation - should contain diff headers
        return patch.contains("diff --git") &&
               (patch.contains("+++") || patch.contains("---"));
    }

    /**
     * Get statistics about a patch
     */
    public PatchStats analyzePatch(String patch) {
        if (patch == null) {
            return new PatchStats(0, 0, 0);
        }

        int filesChanged = patch.split("diff --git").length - 1;
        int additions = 0;
        int deletions = 0;

        String[] lines = patch.split("\n");
        for (String line : lines) {
            if (line.startsWith("+") && !line.startsWith("+++")) {
                additions++;
            } else if (line.startsWith("-") && !line.startsWith("---")) {
                deletions++;
            }
        }

        return new PatchStats(filesChanged, additions, deletions);
    }

    public static class PatchStats {
        public final int filesChanged;
        public final int additions;
        public final int deletions;

        public PatchStats(int filesChanged, int additions, int deletions) {
            this.filesChanged = filesChanged;
            this.additions = additions;
            this.deletions = deletions;
        }

        @Override
        public String toString() {
            return String.format("%d files, +%d -%d lines", filesChanged, additions, deletions);
        }
    }
}
