package com.swebench.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Utility for loading configuration properties.
 */
public class ConfigLoader {
    private static final Logger logger = LoggerFactory.getLogger(ConfigLoader.class);
    private static final String CONFIG_FILE = "config/application.properties";
    private static Properties properties;

    static {
        load();
    }

    private static void load() {
        properties = new Properties();

        try (InputStream input = new FileInputStream(CONFIG_FILE)) {
            properties.load(input);
            logger.info("Loaded configuration from {}", CONFIG_FILE);

            // Load environment variables
            properties.forEach((key, value) -> {
                String stringValue = (String) value;
                if (stringValue.startsWith("${") && stringValue.endsWith("}")) {
                    String envVar = stringValue.substring(2, stringValue.length() - 1);
                    String envValue = System.getenv(envVar);
                    if (envValue != null) {
                        properties.put(key, envValue);
                    }
                }
            });

        } catch (IOException e) {
            logger.warn("Could not load configuration file, using defaults: {}", e.getMessage());
        }
    }

    public static String get(String key) {
        return properties.getProperty(key);
    }

    public static String get(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }

    public static int getInt(String key, int defaultValue) {
        String value = properties.getProperty(key);
        if (value == null) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            logger.warn("Invalid integer value for {}: {}", key, value);
            return defaultValue;
        }
    }

    public static boolean getBoolean(String key, boolean defaultValue) {
        String value = properties.getProperty(key);
        if (value == null) {
            return defaultValue;
        }
        return Boolean.parseBoolean(value);
    }
}
