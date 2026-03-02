Feature: Leave History
  As an employee
  I want to view my leave history
  So that I can track my past leave applications and their status

  Background:
    Given the Leave Management System is available
    And an employee with username "john.doe" exists
    And the employee has the following leave history:
      | leaveType | startDate  | endDate    | status   | approvedBy     | reason                 |
      | ANNUAL    | 2026-01-10 | 2026-01-15 | APPROVED | jane.manager   | New Year Vacation     |
      | SICK      | 2026-02-05 | 2026-02-06 | APPROVED | jane.manager   | Medical Emergency     |
      | CASUAL    | 2026-03-01 | 2026-03-01 | REJECTED | jane.manager   | Personal work         |
      | ANNUAL    | 2026-03-10 | 2026-03-12 | PENDING  | Null           | Family Event          |

  Scenario: View personal leave history
    Given the employee "john.doe" is logged in
    When the employee navigates to the leave history page
    Then all past leave applications should be displayed
    And the history should be sorted by date in descending order
    And each entry should display:
      | leaveType       |
      | startDate       |
      | endDate         |
      | numberOfDays    |
      | reason          |
      | status          |
      | submissionDate  |

  Scenario: View approval status in history
    Given the employee "john.doe" is logged in
    When the employee views their leave history
    Then each history entry should show the approval status
    And approved requests should show the approver's name
    And rejected requests should show the rejection reason
    And pending requests should not show an approver

  Scenario: Filter leave history by date range
    Given the employee "john.doe" is logged in
    And the employee is on the leave history page
    When the employee filters by date range "2026-01-01" to "2026-01-31"
    Then only leave requests within that date range should be displayed
    And the count of displayed requests should be 1

  Scenario: Filter leave history by leave type
    Given the employee "john.doe" is logged in
    And the employee is on the leave history page
    When the employee filters by leave type "ANNUAL"
    Then only ANOUAL leave requests should be displayed
    And the count of displayed requests should be 2

  Scenario: Filter leave history by status
    Given the employee "john.doe" is logged in
    And the employee is on the leave history page
    When the employee filters by status "APPROVED"
    Then only approved leave requests should be displayed
    And the count of displayed requests should be 2

  Scenario: View rejection reason in history
    Given the employee "john.doe" is logged in
    And the employee is on the leave history page
    When the employee views a rejected leave request
    Then the rejection reason should be visible
    And the approver's name who rejected should be displayed

  Scenario: Manager views team leave history
    Given a manager with username "jane.manager" is logged in
    And the manager has team members
    When the manager navigates to the team leave history page
    Then the manager should see leave history for all team members
    And each entry should include the employee name
    And the history should be sorted by date

  Scenario: Manager filters team history by employee
    Given a manager with username "jane.manager" is logged in
    And the manager is on the team leave history page
    When the manager filters by employee "john.doe"
    Then only leave history for "john.doe" should be displayed

  Scenario: Empty history for new employee
    Given a new employee with username "new.employee" is logged in
    And the employee has no leave history
    When the employee navigates to the leave history page
    Then a message "No leave history found" should be displayed

  Scenario: Export leave history
    Given the employee "john.doe" is logged in
    And the employee is on the leave history page
    When the employee clicks the "Export" button
    Then the leave history should be downloaded as a CSV file
    And the file should contain all history entries