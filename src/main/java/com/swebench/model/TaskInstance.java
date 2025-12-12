package com.swebench.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;
import java.util.Map;

/**
 * Represents a single task instance in the Java SWE-Bench benchmark.
 * Contains all metadata needed to evaluate a model's ability to resolve a GitHub issue.
 */
public class TaskInstance {
    @JsonProperty("instance_id")
    private String instanceId;

    @JsonProperty("repo")
    private String repo;

    @JsonProperty("base_commit")
    private String baseCommit;

    @JsonProperty("patch")
    private String patch;

    @JsonProperty("test_patch")
    private String testPatch;

    @JsonProperty("problem_statement")
    private String problemStatement;

    @JsonProperty("hints_text")
    private String hintsText;

    @JsonProperty("created_at")
    private String createdAt;

    @JsonProperty("version")
    private String version;

    @JsonProperty("FAIL_TO_PASS")
    private List<String> failToPass;

    @JsonProperty("PASS_TO_PASS")
    private List<String> passToPass;

    @JsonProperty("environment_setup_commit")
    private String environmentSetupCommit;

    @JsonProperty("test_command")
    private String testCommand;

    @JsonProperty("build_tool")
    private String buildTool;

    @JsonProperty("java_version")
    private String javaVersion;

    @JsonProperty("modules")
    private List<String> modules;

    @JsonProperty("issue_number")
    private Integer issueNumber;

    @JsonProperty("pull_number")
    private Integer pullNumber;

    @JsonProperty("metadata")
    private Map<String, Object> metadata;

    // Constructors
    public TaskInstance() {}

    public TaskInstance(String instanceId, String repo) {
        this.instanceId = instanceId;
        this.repo = repo;
    }

    // Getters and Setters
    public String getInstanceId() {
        return instanceId;
    }

    public void setInstanceId(String instanceId) {
        this.instanceId = instanceId;
    }

    public String getRepo() {
        return repo;
    }

    public void setRepo(String repo) {
        this.repo = repo;
    }

    public String getBaseCommit() {
        return baseCommit;
    }

    public void setBaseCommit(String baseCommit) {
        this.baseCommit = baseCommit;
    }

    public String getPatch() {
        return patch;
    }

    public void setPatch(String patch) {
        this.patch = patch;
    }

    public String getTestPatch() {
        return testPatch;
    }

    public void setTestPatch(String testPatch) {
        this.testPatch = testPatch;
    }

    public String getProblemStatement() {
        return problemStatement;
    }

    public void setProblemStatement(String problemStatement) {
        this.problemStatement = problemStatement;
    }

    public String getHintsText() {
        return hintsText;
    }

    public void setHintsText(String hintsText) {
        this.hintsText = hintsText;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public List<String> getFailToPass() {
        return failToPass;
    }

    public void setFailToPass(List<String> failToPass) {
        this.failToPass = failToPass;
    }

    public List<String> getPassToPass() {
        return passToPass;
    }

    public void setPassToPass(List<String> passToPass) {
        this.passToPass = passToPass;
    }

    public String getEnvironmentSetupCommit() {
        return environmentSetupCommit;
    }

    public void setEnvironmentSetupCommit(String environmentSetupCommit) {
        this.environmentSetupCommit = environmentSetupCommit;
    }

    public String getTestCommand() {
        return testCommand;
    }

    public void setTestCommand(String testCommand) {
        this.testCommand = testCommand;
    }

    public String getBuildTool() {
        return buildTool;
    }

    public void setBuildTool(String buildTool) {
        this.buildTool = buildTool;
    }

    public String getJavaVersion() {
        return javaVersion;
    }

    public void setJavaVersion(String javaVersion) {
        this.javaVersion = javaVersion;
    }

    public List<String> getModules() {
        return modules;
    }

    public void setModules(List<String> modules) {
        this.modules = modules;
    }

    public Integer getIssueNumber() {
        return issueNumber;
    }

    public void setIssueNumber(Integer issueNumber) {
        this.issueNumber = issueNumber;
    }

    public Integer getPullNumber() {
        return pullNumber;
    }

    public void setPullNumber(Integer pullNumber) {
        this.pullNumber = pullNumber;
    }

    public Map<String, Object> getMetadata() {
        return metadata;
    }

    public void setMetadata(Map<String, Object> metadata) {
        this.metadata = metadata;
    }

    @Override
    public String toString() {
        return "TaskInstance{" +
                "instanceId='" + instanceId + '\'' +
                ", repo='" + repo + '\'' +
                ", issueNumber=" + issueNumber +
                ", pullNumber=" + pullNumber +
                '}';
    }
}
