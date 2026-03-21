package com.swebench.util;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class FileUtilsTest {

    @Test
    void testGetExtensionJava() {
        assertEquals("java", FileUtils.getExtension("Foo.java"));
    }

    @Test
    void testGetExtensionNoExtension() {
        assertEquals("", FileUtils.getExtension("Makefile"));
    }

    @Test
    void testGetExtensionEmpty() {
        assertEquals("", FileUtils.getExtension(""));
    }

    @Test
    void testIsJavaFile() {
        assertTrue(FileUtils.isJavaFile("Main.java"));
        assertFalse(FileUtils.isJavaFile("build.gradle"));
        assertFalse(FileUtils.isJavaFile(null));
    }

    @Test
    void testIsTestFile() {
        assertTrue(FileUtils.isTestFile("FooTest.java"));
        assertTrue(FileUtils.isTestFile("FooTests.java"));
        assertTrue(FileUtils.isTestFile("TestFoo.java"));
        assertFalse(FileUtils.isTestFile("Main.java"));
        assertFalse(FileUtils.isTestFile(null));
    }
}
