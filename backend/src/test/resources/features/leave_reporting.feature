Feature: Leave Reporting
  As a manager
  I want to generate reports on leave usage
  So that I can analyze team leave patterns and plan for capacity

  Background:
    Given the Leave Management System is available
    And a manager with username "jane.manager" exists
    And the manager has the following team members:
      | employeeName | leaveType | allocated | used | remaining |
      | john.doe     | ANNUAL    | 20        | 5    | 15        |
      | john.doe     | SICK      | 15        | 2    | 13        |
      | jane.smith   | ANNUAL    | 20        | 10   | 10        |
      | jane.smith   | SICK      | 15        | 0    | 15        |

  Scenario: Generate team leave report
    Given the manager "jane.manager" is logged in
    When the manager navigates to the reports page
    And the manager selects "Team Leave Report"
    Then a report should be generated with:  
      | Employee Name  |
      | Leave Type     |
      | Allocated Days |
      | Used Days      |
      | Remaining Days |

  Scenario: Filter report by date range
    Given the manager "jane.manager" is logged in
    And the manager is on the reports page
    When the manager selects date range "2026-01-01" to "2026-03-31"
    And generates the report
    Then the report should only include leave taken within that period

  Scenario: Filter report by leave type
    Given the manager "jane.manager" is logged in
    And the manager is on the reports page
    When the manager filters by leave type "ANNUAL"
    And generates the report
    Then the report should only show ANOUAL leave data

  Scenario: Filter report by specific employee
    Given the manager "jane.manager" is logged in
    And the manager is on the reports page
    When the manager selects employee "john.doe"
    And generates the report
    Then the report should only show data for "john.doe"

  Scenario: Export report as PDF
    Given the manager "jane.manager" is logged in
    And a leave report has been generated
    When the manager clicks "Export as PDF"
    Then a PDF file should be downloaded
    And the PDF should contain all report data
    And the PDF should be named "leave_report_{date}.pdf"

  Scenario: Export report as Excel
    Given the manager "jane.manager" is logged in
    And a leave report has been generated
    When the manager clicks "Export as Excel"
    Then an Excel file should be downloaded
    And the Excel file should contain all report data
    And the file should be named "leave_report_{date}.xlsx"

  Scenario: Export report as CSV
    Given the manager "jane.manager" is logged in
    And a leave report has been generated
    When the manager clicks "Export as CSV"
    Then a CSV file should be downloaded
    And the CSV file should contain all report data

  Scenario: Report includes visual summary
    Given the manager "jane.manager" is logged in
    When the manager generates a team leave report
    Then the report should include visual summaries such as:
      | Bar chart of leave usage by employee |
      | Pie chart of leave type distribution |
      | Trend line for leave usage over time |

  Scenario: Report generation is timestamped
    Given the manager "jane.manager" is logged in
    When the manager generates a report
    Then the report should include the generation timestamp
    And the report should include the manager's name who generated it

  Scenario: Non-manager cannot access reports
    Given an employee with username "john.doe" is logged in
    And the user is not a manager
    When the user tries to access the reports page
    Then access should be denied
    And an error message "Unauthorized access" should be displayed