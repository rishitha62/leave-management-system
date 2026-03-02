Feature: Leave Dashboard
  As an employee
  I want to view my leave balances and summary
  So that I can plan my leave effectively

  Background:
    Given the Leave Management System is available
    And an employee with username "john.doe" exists
    And the employee has the following leave balances:
      | leaveType | allocatedDays | usedDays | remainingDays |
      | ANNUAL    | 20            | 5         | 15            |
      | SICK      | 15            | 2         | 13            |
      | CASUAL    | 10            | 0         | 10            |

  Scenario: View leave balance summary
    Given the employee "john.doe" is logged in
    When the employee navigates to the dashboard
    Then the dashboard should display all leave types and balances
    And the following information should be visible for each leave type:
      | leaveTypeName    |
      | allocatedDays    |
      | usedDays         |
      | remainingDays    |

  Scenario: Leave balance displays real-time data
    Given the employee "john.doe" is logged in
    And the dashboard is displayed
    When the manager approves a new leave request for the employee
    And the employee refreshes the dashboard
    Then the updated leave balance should be displayed
    And the usedDays should be increased
    And the remainingDays should be decreased

  Scenario: View leave type breakdown
    Given the employee "john.doe" is logged in
    When the employee views the dashboard
    Then the dashboard should display a breakdown for each leave type:
      | leaveType | allocatedDays | usedDays | remainingDays |
      | ANKUAL    | 20            | 5         | 15            |
      | SICK      | 15            | 2         | 13            |
      | CASUAL    | 10            | 0         | 10            |
    And each leave type should be clearly labeled

  Scenario: Visual indicators for leave balance
    Given the employee "john.doe" is logged in
    When the employee views the dashboard
    Then visual indicators should be displayed for each leave type
    And the indicators should show usage percentage
    And color coding should indicate:
      | Green  | when remaining days > 70% |
      | Yellow | when remaining days = 30-70% |
      | Red    | when remaining days < 30% |

  Scenario: Dashboard shows pending requests count
    Given the employee "john.doe" is logged in
    And the employee has 3 pending leave requests
    When the employee views the dashboard
    Then the dashboard should display the count of pending requests
    And the count should be 3

  Scenario: Dashboard shows upcoming leaves
    Given the employee "john.doe" is logged in
    And the employee has approved leave from "2026-04-01" to "2026-04-05"
    When the employee views the dashboard
    Then the dashboard should display upcoming leaves
    And the leave dates should be visible
    And the leave type should be displayed

  Scenario: Dashboard accessible from main navigation
    Given the employee "john.doe" is logged in
    When the employee looks at the main navigation menu
    Then a "Dashboard" link should be visible
    And clicking the link should navigate to the dashboard

  Scenario: Empty dashboard for new employee
    Given a new employee with username "new.employee" is logged in
    And the employee has no leave balances setup
    When the employee views the dashboard
    Then a message "Leave balances not yet allocated" should be displayed
    And a "Contact HR" button should be visible

  Scenario Outline: Verify leave balance calculations
    Given the employee "john.doe" is logged in
    And the employee has <allocated> days of <leaveType> allocated
    And <used> days have been used
    When the employee views the dashboard
    Then the remaining days should be <remaining>

    Examples:
      | leaveType | allocated | used | remaining |
      | ANKUAL    | 20        | 5    | 15        |
      | ANKUAL    | 20        | 0    | 20        |
      | ANKUAL    | 20        | 20   | 0         |
      | SICK      | 15        | 5    | 10        |
      | CASUAL    | 10        | 3    | 7         |