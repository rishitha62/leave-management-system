Feature: Leave Approval and Rejection
  As a manager
  I want to approve or reject leave requests
  So that I can manage my team's leave effectively

  Background:
    Given the Leave Management System is available
    And a manager with username "jane.manager" exists
    And an employee "john.doe" reports to "jane.manager"
    And the employee has a pending leave request:
      | leaveType | startDate  | endDate    | numberOfDays | status |
      | ANKUAL    | 2026-04-01 | 2026-04-05 | 5             | PENDING |

  Scenario: Manager views pending leave requests
    Given the manager "jane.manager" is logged in
    When the manager navigates to the pending requests page
    Then the manager should see a list of pending leave requests
    And each request should display:
      | field           |
      | employeeName    |
      | leaveType       |
      | startDate       |
      | endDate         |
      | numberOfDays    |
      | reason          |
      | submissionDate  |

  Scenario: Manager approves a leave request
    Given the manager "jane.manager" is logged in
    And a pending leave request exists for "john.doe"
    When the manager approves the leave request with comment "Approved for vacation"
    Then the leave request status should be updated to "APPROVED"
    And the employee's leave balance should be deducted by 5 days
    And the approver should be recorded as "jane.manager"
    And the approval timestamp should be recorded
    And the employee should receive a notification
    And an audit log entry should be created

  Scenario: Manager rejects a leave request
    Given the manager "jane.manager" is logged in
    And a pending leave request exists for "john.doe"
    When the manager rejects the leave request with reason "Insufficient coverage during that period"
    Then the leave request status should be updated to "REJECTED"
    And the employee's leave balance should remain unchanged
    And the rejection reason should be stored
    And the approver should be recorded as "jane.manager"
    And the rejection timestamp should be recorded
    And the employee should receive a notification with reason
    And an audit log entry should be created

  Scenario: Manager tries to approve without sufficient balance
    Given the manager "jane.manager" is logged in
    And an employee "john.doe" has a pending request for 20 days of ANNUAL leave
    And the employee has only 15 days of ANNUAL leave available
    When the manager tries to approve the leave request
    Then an error message "Insufficient leave balance" should be displayed
    And the leave request status should remain "PENDING"

  Scenario: Manager rejects without reason
    Given the manager "jane.manager" is logged in
    And a pending leave request exists for "john.doe"
    When the manager tries to reject the leave request without providing a reason
    Then a validation error should be displayed
    And the error message should contain "Rejection reason is required"

  Scenario: Manager filters pending requests by leave type
    Given the manager "jane.manager" is logged in
    And multiple pending leave requests exist with different leave types
    When the manager filters by leave type "ANNUAL"
    Then only ANOUAL leave requests should be displayed

  Scenario: Manager views leave request details
    Given the manager "jane.manager" is logged in
    And a pending leave request exists for "john.doe"
    When the manager clicks on the leave request
    Then a detailed view should be displayed with:
      | employeeInformation  |
      | leaveType            |
      | startDate            |
      | endDate              |
      | numberOfDays        |
      | reason               |
      | currentLeaveBalance |
      | approveButton        |
      | rejectButton         |

  Scenario: Non-manager cannot access approval functionality
    Given an employee with username "john.doe" is logged in
    And the user is not a manager
    When the user tries to access the leave approval page
    Then access should be denied
    And an error message "Unauthorized access" should be displayed