package com.swebench.evaluation;

import com.swebench.model.TaskInstance;

/**
 * Pairs a TaskInstance with the patch content and the model that produced it.
 */
public class PatchedTask {

    private final TaskInstance task;
    private final String modelName;
    private final String patchContent; // null means no patch available

    public PatchedTask(TaskInstance task, String modelName, String patchContent) {
        this.task = task;
        this.modelName = modelName;
        this.patchContent = patchContent;
    }

    public TaskInstance getTask() {
        return task;
    }

    public String getModelName() {
        return modelName;
    }

    public String getPatchContent() {
        return patchContent;
    }

    public boolean hasPatch() {
        return patchContent != null && !patchContent.isBlank();
    }

    @Override
    public String toString() {
        return "PatchedTask{instanceId='" + task.getInstanceId()
                + "', model='" + modelName
                + "', hasPatch=" + hasPatch() + '}';
    }
}
