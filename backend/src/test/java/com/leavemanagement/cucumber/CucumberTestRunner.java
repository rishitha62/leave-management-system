package com.leavemanagement.cucumber;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

/**
 * Cucumber Test Runner for Leave Management System
 * 
 * This class is the entry point for running Cucumber tests.
 * It configures the location of feature files and step definitions.
 * 
 * @version 1.0
 * @author AI-Generated Test Automation
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/resources/features",
        glue = "com.leavemanagement.cucumber",
        plugin = {
                "pretty",
                "html:target/cucumber-reports/cucumber.html",
                "json:target/cucumber-reports/cucumber.json",
                "junit:target/cucumber-reports/cucumber.xml"
        },
        monochrome = true,
        tags = "not @ignore"
)
public class CucumberTestRunner {
    // This class will be empty. 
    // It serves as a hook to run all CUcumber tests with JUnit.
}