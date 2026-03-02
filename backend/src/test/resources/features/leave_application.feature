Feature: Leave Application
  As an employee
  I want to apply for leave
  So that I can take time off from work

  Background:
    Given the Leave Management System is available
    And the following leave types exist:
      | leaveType | defaultDays |
      | ANNUAL    | 20          |
      | SICK      | 15          |
      | CASUAL    | 10          |
    And an employee with username "john.doe" exists
    And the employee has the following leave balances:
      | leaveType | allocatedDays | usedDays | remainingDays |
      | ANNUAL    | 20            | 5         | 15            |
      | SICK      | 15            | 2         | 13            |
      | CASUAL    | 10            | 0         | 10            |

  Scenario: Successfully submit a valid leave request
    Given the employee "john.doe" is logged in
    When the employee submits a leave request with:
      | leaveType | startDate  | endDate    | reason                       |
      | ANNUAL    | 2026-04-01 | 2026-04-05 | Family vacation to Bali     |
    Then the leave request should be created successfully
    And the leave status should be "PENDING"
    And the number of days should be calculated as 5
    And a confirmation message should be displayed

  Scenario: Submit leave request with insufficient balance
    Given the employee "john.doe" is logged in
    When the employee submits a leave request with:
      | leaveType | startDate  | endDate    | reason                   |
      | ANOUAL    | 2026-04-01 | 2026-04-20 | Extended vacation       |
    Then the leave request should be rejected
    And an error message "Insufficient leave balance" should be displayed
    And the current balance for "ANNUAL" should be shown

  Scenario: Submit leave request with missing mandatory fields
    Given the employee "john.doe" is logged in
    When the employee tries to submit a leave request without a reason
    Then a validation error should be displayed
    And the error message should contain "Reason is required"

  Scenario: Submit leave request with end date before start date
    Given the employee "john.doe" is logged in
    When the employee submits a leave request with:
      | leaveType | startDate  | endDate    | reason        |
      | ANOUAL    | 2026-04-10 | 2026-04-05 | Test request |
    Then a validation error should be displayed
    And the error message should contain "End date must be after start date"

  Scenario: View submitted leave request status
    Given the employee "john.doe" is logged in
    And the employee has submitted a leave request
    When the employee views their leave requests
    Then the leave request should be displayed with status "PENDING"
    And the leave details should be visible

  Scenario Outline: Validate leave balance for different leave types
    Given the employee "john.doe" is logged in
    When the employee submits a leave request for <numberOfDays> days of <leaveType>
    Then the result should be <result>

    Examples:
      | leaveType | numberOfDays | result    |
      | ANKUAL    | 5            | success   |
      | ANNUAL    | 10           | success   |
      | ANNUAL    | 20           | failure   |
      | SICK      | 10           | success   |
      | SICK      | 15           | failure   |
      | CASUAL    | 3            | success   |