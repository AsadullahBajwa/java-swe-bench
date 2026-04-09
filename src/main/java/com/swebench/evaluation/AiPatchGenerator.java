package com.swebench.evaluation;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.swebench.model.TaskInstance;
import com.swebench.util.ConfigLoader;
import okhttp3.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

/**
 * Generates a unified-diff patch for a task by calling an external AI API.
 *
 * <p>Activated only when {@code ai.enabled=true} is set in
 * {@code config/application.properties}. Supported providers:
 * <ul>
 *   <li>{@code anthropic} — Claude models via Anthropic Messages API</li>
 *   <li>{@code openai}    — GPT models via OpenAI Chat Completions API</li>
 * </ul>
 *
 * <p>Relevant config keys:
 * <pre>
 * ai.enabled=true
 * ai.provider=anthropic          # or openai
 * ai.model=claude-3-5-sonnet-20241022
 * ai.api.key=${AI_API_KEY}
 * ai.max.tokens=4096
 * ai.temperature=0.0
 * </pre>
 */
public class AiPatchGenerator {

    private static final Logger logger = LoggerFactory.getLogger(AiPatchGenerator.class);

    private static final MediaType JSON_MEDIA = MediaType.get("application/json; charset=utf-8");

    private static final String ANTHROPIC_URL  = "https://api.anthropic.com/v1/messages";
    private static final String OPENAI_URL     = "https://api.openai.com/v1/chat/completions";
    private static final String DEEPSEEK_URL   = "https://api.deepseek.com/v1/chat/completions";
    private static final String ANTHROPIC_VER  = "2023-06-01";

    private final OkHttpClient http;
    private final ObjectMapper  mapper;
    private final String        provider;
    private final String        model;
    private final String        apiKey;
    private final int           maxTokens;
    private final double        temperature;

    public AiPatchGenerator() {
        this.provider    = ConfigLoader.get("ai.provider", "anthropic").toLowerCase();
        this.model       = ConfigLoader.get("ai.model", "claude-3-5-sonnet-20241022");
        this.apiKey      = ConfigLoader.get("ai.api.key", "");
        this.maxTokens   = ConfigLoader.getInt("ai.max.tokens", 4096);
        this.temperature = Double.parseDouble(ConfigLoader.get("ai.temperature", "0.0"));
        this.mapper      = new ObjectMapper();
        this.http        = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(120, TimeUnit.SECONDS)
                .build();
    }

    /**
     * Returns {@code true} when AI generation is switched on in config.
     */
    public static boolean isEnabled() {
        return ConfigLoader.getBoolean("ai.enabled", false);
    }

    /**
     * Returns the configured model name (used as the sub-directory / model label).
     */
    public String getModelName() {
        return model;
    }

    /**
     * Generates a unified-diff patch for the given task.
     *
     * @param task the benchmark task (must have {@code problemStatement} set)
     * @return unified diff string, or {@code null} on failure
     */
    public String generate(TaskInstance task) {
        if (apiKey == null || apiKey.isBlank()) {
            logger.error("[AiPatchGenerator] ai.api.key is not configured");
            return null;
        }

        String prompt = buildPrompt(task);
        logger.info("[AiPatchGenerator] Generating patch for {} using {}/{}", task.getInstanceId(), provider, model);

        try {
            return switch (provider) {
                case "anthropic" -> callAnthropic(prompt);
                case "openai"    -> callOpenAiCompatible(OPENAI_URL, prompt);
                case "deepseek"  -> callOpenAiCompatible(DEEPSEEK_URL, prompt);
                default -> {
                    logger.error("[AiPatchGenerator] Unknown provider: {}", provider);
                    yield null;
                }
            };
        } catch (IOException e) {
            logger.error("[AiPatchGenerator] API call failed for {}: {}", task.getInstanceId(), e.getMessage());
            return null;
        }
    }

    // -------------------------------------------------------------------------
    // Prompt construction
    // -------------------------------------------------------------------------

    private String buildPrompt(TaskInstance task) {
        StringBuilder sb = new StringBuilder();
        sb.append("You are an expert Java developer. Your task is to fix a bug in the repository '")
          .append(task.getRepo()).append("'.\n\n");

        sb.append("## Problem Statement\n\n")
          .append(task.getProblemStatement()).append("\n\n");

        if (task.getHintsText() != null && !task.getHintsText().isBlank()) {
            sb.append("## Hints\n\n").append(task.getHintsText()).append("\n\n");
        }

        sb.append("## Instructions\n\n")
          .append("Produce a unified diff patch (git diff format) that fixes the problem described above.\n")
          .append("- Output ONLY the raw unified diff. Do not include explanations, markdown code fences, or prose.\n")
          .append("- The patch must apply cleanly with `git apply` at commit `").append(task.getBaseCommit()).append("`.\n")
          .append("- Do not modify test files.\n\n")
          .append("Output the patch now:");

        return sb.toString();
    }

    // -------------------------------------------------------------------------
    // Provider-specific API calls
    // -------------------------------------------------------------------------

    private String callAnthropic(String prompt) throws IOException {
        ObjectNode body = mapper.createObjectNode();
        body.put("model", model);
        body.put("max_tokens", maxTokens);
        body.put("temperature", temperature);

        ArrayNode messages = body.putArray("messages");
        ObjectNode msg = messages.addObject();
        msg.put("role", "user");
        msg.put("content", prompt);

        Request request = new Request.Builder()
                .url(ANTHROPIC_URL)
                .addHeader("x-api-key", apiKey)
                .addHeader("anthropic-version", ANTHROPIC_VER)
                .addHeader("content-type", "application/json")
                .post(RequestBody.create(mapper.writeValueAsString(body), JSON_MEDIA))
                .build();

        try (Response response = http.newCall(request).execute()) {
            String responseBody = response.body() != null ? response.body().string() : "";
            if (!response.isSuccessful()) {
                logger.error("[AiPatchGenerator] Anthropic API error {}: {}", response.code(), responseBody);
                return null;
            }
            JsonNode json = mapper.readTree(responseBody);
            return json.path("content").path(0).path("text").asText(null);
        }
    }

    private String callOpenAiCompatible(String url, String prompt) throws IOException {
        ObjectNode body = mapper.createObjectNode();
        body.put("model", model);
        body.put("max_tokens", maxTokens);
        body.put("temperature", temperature);

        ArrayNode messages = body.putArray("messages");
        ObjectNode msg = messages.addObject();
        msg.put("role", "user");
        msg.put("content", prompt);

        Request request = new Request.Builder()
                .url(url)
                .addHeader("Authorization", "Bearer " + apiKey)
                .addHeader("content-type", "application/json")
                .post(RequestBody.create(mapper.writeValueAsString(body), JSON_MEDIA))
                .build();

        try (Response response = http.newCall(request).execute()) {
            String responseBody = response.body() != null ? response.body().string() : "";
            if (!response.isSuccessful()) {
                logger.error("[AiPatchGenerator] API error {} from {}: {}", response.code(), url, responseBody);
                return null;
            }
            JsonNode json = mapper.readTree(responseBody);
            return json.path("choices").path(0).path("message").path("content").asText(null);
        }
    }
}
