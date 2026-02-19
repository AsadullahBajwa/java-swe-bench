package com.swebench.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.LocalDateTime;

/**
 * Represents a GitHub repository candidate for task extraction.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class Repository {
    @JsonProperty("full_name")
    private String fullName;

    @JsonProperty("name")
    private String name;

    @JsonProperty("owner")
    private String owner;

    @JsonProperty("stars")
    private int stars;

    @JsonProperty("forks")
    private int forks;

    @JsonProperty("language")
    private String language;

    @JsonProperty("is_fork")
    private boolean isFork;

    @JsonProperty("last_updated")
    private LocalDateTime lastUpdated;

    @JsonProperty("has_issues")
    private boolean hasIssues;

    @JsonProperty("open_issues_count")
    private int openIssuesCount;

    @JsonProperty("build_tool")
    private String buildTool;

    @JsonProperty("has_tests")
    private boolean hasTests;

    @JsonProperty("default_branch")
    private String defaultBranch;

    @JsonProperty("clone_url")
    private String cloneUrl;

    @JsonProperty("java_percentage")
    private double javaPercentage;

    @JsonProperty("java_version")
    private String javaVersion;

    // Constructors
    public Repository() {}

    public Repository(String fullName) {
        this.fullName = fullName;
        String[] parts = fullName.split("/");
        if (parts.length == 2) {
            this.owner = parts[0];
            this.name = parts[1];
        }
    }

    // Getters and Setters
    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public int getStars() {
        return stars;
    }

    public void setStars(int stars) {
        this.stars = stars;
    }

    public int getForks() {
        return forks;
    }

    public void setForks(int forks) {
        this.forks = forks;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public boolean isFork() {
        return isFork;
    }

    public void setFork(boolean fork) {
        isFork = fork;
    }

    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public boolean isHasIssues() {
        return hasIssues;
    }

    public void setHasIssues(boolean hasIssues) {
        this.hasIssues = hasIssues;
    }

    public int getOpenIssuesCount() {
        return openIssuesCount;
    }

    public void setOpenIssuesCount(int openIssuesCount) {
        this.openIssuesCount = openIssuesCount;
    }

    public String getBuildTool() {
        return buildTool;
    }

    public void setBuildTool(String buildTool) {
        this.buildTool = buildTool;
    }

    public boolean isHasTests() {
        return hasTests;
    }

    public void setHasTests(boolean hasTests) {
        this.hasTests = hasTests;
    }

    public String getDefaultBranch() {
        return defaultBranch;
    }

    public void setDefaultBranch(String defaultBranch) {
        this.defaultBranch = defaultBranch;
    }

    public String getCloneUrl() {
        return cloneUrl;
    }

    public void setCloneUrl(String cloneUrl) {
        this.cloneUrl = cloneUrl;
    }

    public double getJavaPercentage() {
        return javaPercentage;
    }

    public void setJavaPercentage(double javaPercentage) {
        this.javaPercentage = javaPercentage;
    }

    public String getJavaVersion() {
        return javaVersion;
    }

    public void setJavaVersion(String javaVersion) {
        this.javaVersion = javaVersion;
    }

    /**
     * Checks if repository meets basic criteria for inclusion
     */
    public boolean meetsBasicCriteria() {
        return !isFork
            && stars >= 50
            && "Java".equalsIgnoreCase(language)
            && javaPercentage >= 90.0  // At least 90% Java code (very strict)
            && hasIssues
            && openIssuesCount > 0
            && hasTests
            && buildTool != null;
    }

    @Override
    public String toString() {
        return "Repository{" +
                "fullName='" + fullName + '\'' +
                ", stars=" + stars +
                ", buildTool='" + buildTool + '\'' +
                '}';
    }
}
