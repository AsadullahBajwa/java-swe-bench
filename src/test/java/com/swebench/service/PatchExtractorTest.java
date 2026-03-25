package com.swebench.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class PatchExtractorTest {

    private PatchExtractor extractor;

    @BeforeEach
    void setUp() {
        extractor = new PatchExtractor();
    }

    // -------------------------------------------------------------------------
    // validatePatch
    // -------------------------------------------------------------------------

    @Test
    void validatePatch_null_returnsFalse() {
        assertFalse(extractor.validatePatch(null));
    }

    @Test
    void validatePatch_empty_returnsFalse() {
        assertFalse(extractor.validatePatch(""));
    }

    @Test
    void validatePatch_missingDiffHeader_returnsFalse() {
        String patch = "--- a/Foo.java\n+++ b/Foo.java\n+new line\n";
        assertFalse(extractor.validatePatch(patch));
    }

    @Test
    void validatePatch_wellFormed_returnsTrue() {
        String patch = "diff --git a/Foo.java b/Foo.java\n" +
                       "--- a/Foo.java\n" +
                       "+++ b/Foo.java\n" +
                       "+added line\n";
        assertTrue(extractor.validatePatch(patch));
    }

    @Test
    void validatePatch_multiFile_returnsTrue() {
        String patch = "diff --git a/Foo.java b/Foo.java\n" +
                       "--- a/Foo.java\n+++ b/Foo.java\n+line\n" +
                       "diff --git a/Bar.java b/Bar.java\n" +
                       "--- a/Bar.java\n+++ b/Bar.java\n-removed\n";
        assertTrue(extractor.validatePatch(patch));
    }

    // -------------------------------------------------------------------------
    // analyzePatch
    // -------------------------------------------------------------------------

    @Test
    void analyzePatch_null_returnsZeros() {
        PatchExtractor.PatchStats stats = extractor.analyzePatch(null);
        assertEquals(0, stats.filesChanged);
        assertEquals(0, stats.additions);
        assertEquals(0, stats.deletions);
    }

    @Test
    void analyzePatch_singleFileAdditions() {
        String patch = "diff --git a/Foo.java b/Foo.java\n" +
                       "--- a/Foo.java\n" +
                       "+++ b/Foo.java\n" +
                       "+line one\n" +
                       "+line two\n" +
                       "+line three\n";
        PatchExtractor.PatchStats stats = extractor.analyzePatch(patch);
        assertEquals(1, stats.filesChanged);
        assertEquals(3, stats.additions);
        assertEquals(0, stats.deletions);
    }

    @Test
    void analyzePatch_mixedChanges() {
        String patch = "diff --git a/Foo.java b/Foo.java\n" +
                       "--- a/Foo.java\n" +
                       "+++ b/Foo.java\n" +
                       "+added\n" +
                       "-removed\n" +
                       "diff --git a/Bar.java b/Bar.java\n" +
                       "--- a/Bar.java\n" +
                       "+++ b/Bar.java\n" +
                       "+more added\n";
        PatchExtractor.PatchStats stats = extractor.analyzePatch(patch);
        assertEquals(2, stats.filesChanged);
        assertEquals(2, stats.additions);
        assertEquals(1, stats.deletions);
    }

    @Test
    void analyzePatch_headerLinesNotCounted() {
        // Lines starting with +++ or --- are headers, not code changes
        String patch = "diff --git a/Foo.java b/Foo.java\n" +
                       "--- a/Foo.java\n" +
                       "+++ b/Foo.java\n" +
                       "+actual addition\n";
        PatchExtractor.PatchStats stats = extractor.analyzePatch(patch);
        assertEquals(1, stats.additions);
        assertEquals(0, stats.deletions);
    }

    @Test
    void patchStats_toStringFormat() {
        PatchExtractor.PatchStats stats = new PatchExtractor.PatchStats(3, 10, 5);
        assertEquals("3 files, +10 -5 lines", stats.toString());
    }
}
