package com.swebench.service;

import com.swebench.model.TaskInstance;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class QualityValidatorTest {

    private QualityValidator validator;

    @BeforeEach
    void setUp() {
        validator = new QualityValidator();
    }

    private TaskInstance taskWithPatch(String statement, String patch) {
        TaskInstance task = new TaskInstance("test-id", "owner/repo");
        task.setProblemStatement(statement);
        task.setPatch(patch);
        return task;
    }

    private String bugStatement() {
        return "There is a bug when calling the method with a null argument. " +
               "Expected: no exception. Actual: NullPointerException is thrown. " +
               "Steps to reproduce: pass null to foo(). Because the null check is missing.";
    }

    private String minimalPatch() {
        return "diff --git a/src/Foo.java b/src/Foo.java\n" +
               "--- a/src/Foo.java\n" +
               "+++ b/src/Foo.java\n" +
               "+    if (value == null) return;\n" +
               "+    process(value);\n" +
               "+    log(value);\n" +
               "+    validate(value);\n" +
               "+    save(value);\n" +
               "diff --git a/src/test/FooTest.java b/src/test/FooTest.java\n" +
               "+    @Test\n" +
               "+    void testNullHandling() {\n" +
               "+        assertDoesNotThrow(() -> foo.handle(null));\n" +
               "+    }\n";
    }

    @Test
    void testHighQualityTaskPasses() {
        TaskInstance task = taskWithPatch(bugStatement(), minimalPatch());
        task.setFailToPass(List.of("com.example.FooTest#testNullHandling"));
        assertTrue(validator.isHighQuality(task));
    }

    @Test
    void testShortProblemStatementRejected() {
        TaskInstance task = taskWithPatch("Too short.", minimalPatch());
        assertFalse(validator.isHighQuality(task));
    }

    @Test
    void testNullPatchRejected() {
        TaskInstance task = new TaskInstance("test-id", "owner/repo");
        task.setProblemStatement(bugStatement());
        task.setPatch(null);
        assertFalse(validator.isHighQuality(task));
    }

    @Test
    void testHasValidFailToPassTests_emptyList() {
        TaskInstance task = new TaskInstance("test-id", "owner/repo");
        task.setFailToPass(List.of());
        assertFalse(validator.hasValidFailToPassTests(task));
    }

    @Test
    void testHasValidFailToPassTests_allTestsMarker() {
        TaskInstance task = new TaskInstance("test-id", "owner/repo");
        task.setFailToPass(List.of("__ALL_TESTS__"));
        assertTrue(validator.hasValidFailToPassTests(task));
    }

    @Test
    void testHasValidFailToPassTests_tooMany() {
        TaskInstance task = new TaskInstance("test-id", "owner/repo");
        task.setFailToPass(List.of("t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9", "t10", "t11"));
        assertFalse(validator.hasValidFailToPassTests(task));
    }

    @Test
    void testQualityRating() {
        assertEquals("EXCELLENT", validator.getQualityRating(95));
        assertEquals("GOOD", validator.getQualityRating(80));
        assertEquals("ACCEPTABLE", validator.getQualityRating(65));
        assertEquals("POOR", validator.getQualityRating(50));
        assertEquals("REJECTED", validator.getQualityRating(30));
    }

    @Test
    void testCalculateQualityScore_highQuality() {
        TaskInstance task = taskWithPatch(bugStatement(), minimalPatch());
        task.setFailToPass(List.of("com.example.FooTest#testNullHandling"));
        int score = validator.calculateQualityScore(task);
        assertTrue(score >= 60, "Expected score >= 60 but got " + score);
    }
}
