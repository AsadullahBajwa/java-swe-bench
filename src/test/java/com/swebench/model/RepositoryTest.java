package com.swebench.model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class RepositoryTest {

    @Test
    void testRepositoryCreation() {
        Repository repo = new Repository("owner/project");

        assertEquals("owner/project", repo.getFullName());
        assertEquals("owner", repo.getOwner());
        assertEquals("project", repo.getName());
    }

    @Test
    void testBasicCriteria() {
        Repository repo = new Repository("owner/project");
        repo.setFork(false);
        repo.setStars(100);
        repo.setLanguage("Java");
        repo.setJavaPercentage(90.0);
        repo.setHasIssues(true);
        repo.setOpenIssuesCount(10);
        repo.setHasTests(true);
        repo.setBuildTool("maven");

        assertTrue(repo.meetsBasicCriteria());
    }

    @Test
    void testBasicCriteriaFails() {
        Repository repo = new Repository("owner/project");
        repo.setFork(true); // Forked repo should fail

        assertFalse(repo.meetsBasicCriteria());
    }

    @Test
    void testInsufficientStars() {
        Repository repo = new Repository("owner/project");
        repo.setFork(false);
        repo.setStars(10); // Less than 50
        repo.setLanguage("Java");
        repo.setJavaPercentage(90.0);
        repo.setHasIssues(true);
        repo.setOpenIssuesCount(10);
        repo.setHasTests(true);
        repo.setBuildTool("maven");

        assertFalse(repo.meetsBasicCriteria());
    }

    @Test
    void testInsufficientJavaPercentage() {
        Repository repo = new Repository("owner/project");
        repo.setFork(false);
        repo.setStars(100);
        repo.setLanguage("Java");
        repo.setJavaPercentage(50.0); // Less than 75%
        repo.setHasIssues(true);
        repo.setOpenIssuesCount(10);
        repo.setHasTests(true);
        repo.setBuildTool("maven");

        assertFalse(repo.meetsBasicCriteria());
    }

    @Test
    void testJavaPercentageEdgeCase() {
        Repository repo = new Repository("owner/project");
        repo.setFork(false);
        repo.setStars(100);
        repo.setLanguage("Java");
        repo.setJavaPercentage(90.0); // Exactly 90% (new threshold)
        repo.setHasIssues(true);
        repo.setOpenIssuesCount(10);
        repo.setHasTests(true);
        repo.setBuildTool("maven");

        assertTrue(repo.meetsBasicCriteria());
    }

    @Test
    void testJavaPercentageBelowNewThreshold() {
        Repository repo = new Repository("owner/project");
        repo.setFork(false);
        repo.setStars(100);
        repo.setLanguage("Java");
        repo.setJavaPercentage(85.0); // 85% is now below 90% threshold
        repo.setHasIssues(true);
        repo.setOpenIssuesCount(10);
        repo.setHasTests(true);
        repo.setBuildTool("maven");

        assertFalse(repo.meetsBasicCriteria());
    }
}
