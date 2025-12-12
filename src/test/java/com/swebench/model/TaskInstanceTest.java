package com.swebench.model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class TaskInstanceTest {

    @Test
    void testTaskInstanceCreation() {
        TaskInstance task = new TaskInstance("test-1", "owner/repo");

        assertEquals("test-1", task.getInstanceId());
        assertEquals("owner/repo", task.getRepo());
    }

    @Test
    void testTaskInstanceSetters() {
        TaskInstance task = new TaskInstance();
        task.setInstanceId("test-2");
        task.setRepo("owner/repo");
        task.setBaseCommit("abc123");
        task.setPatch("diff --git a/file.java");
        task.setProblemStatement("Fix the bug");

        assertEquals("test-2", task.getInstanceId());
        assertEquals("owner/repo", task.getRepo());
        assertEquals("abc123", task.getBaseCommit());
        assertNotNull(task.getPatch());
        assertEquals("Fix the bug", task.getProblemStatement());
    }

    @Test
    void testToString() {
        TaskInstance task = new TaskInstance("test-3", "owner/repo");
        task.setIssueNumber(123);
        task.setPullNumber(456);

        String str = task.toString();
        assertTrue(str.contains("test-3"));
        assertTrue(str.contains("owner/repo"));
        assertTrue(str.contains("123"));
        assertTrue(str.contains("456"));
    }
}
