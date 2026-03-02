Feature: Data Integrity
  As a system administrator
  I want to ensure accurate tracking of leave balances and history
  So that the system maintains data integrity and auditability

  Background:
    Given the Leave Management System is available
    And the audit logging is enabled

  Scenario: Leave balance deducted only on approval
    Given an employee "john.doe" has 15 days of ANNUAL leave
    And a pending leave request for 5 days exists
    When the manager approves the leave request
    Then the employee's ANNUAL leave balance should be reduced to 10 days
    And the used days should be increased to 10
    And an audit log entry should be created

  Scenario: Leave balance not deducted on rejection
    Given an employee "john.doe" has 15 days of ANNUAL leave
    And a pending leave request for 5 days exists
    When the manager rejects the leave request
    Then the employee's ANNUAL leave balance should remain 15 days
    And the used days should remain unchanged
    And an audit log entry should be created

  Scenario: Prevent double-deduction of leave balance
    Given an employee "john.doe" has 15 days of ANNUAL leave
    And a leave request for 5 days is approved
    When the manager clicks approve multiple times
    Then the leave balance should only be deducted once
    And the final balance should be 10 days
    And only one approval audit log should be created

  Scenario: Audit trail for leave application
    Given an employee "john.doe" is logged in
    When the employee submits a leave request
    Then an audit log entry should be created with:
      | action           | LEAVE_APPLICATION_SUBMITTED |
      | username         | john.doe                   |
      | timestamp        | Current date/time          |
      | ipAddress        | User's IP address          |

  Scenario: Audit trail for leave approval
    Given a manager "jane.manager" is logged in
    And a pending leave request exists
    When the manager approves the leave request
    Then an audit log entry should be created with:
      | action                 | LEAVE_REQUEST_APPROVED |
      | username               | jane.manager         |
      | targetEmployee        | john.doe             |
      | beforeBalance          | 15                   |
      | afterBalance           | 10                   |
      | timestamp              | Current date/time    |

  Scenario: Audit trail for leave rejection
    Given a manager "jane.manager" is logged in
    And a pending leave request exists
    When the manager rejects the leave request with reason
    Then an audit log entry should be created with:
      | action                | LEAVE_REQUEST_REJECTED |
      | username              | jane.manager         |
      | targetEmployee       | john.doe             |
      | rejectionReason      | Provided reason      |
      | timestamp            | Current date/time    |

  Scenario: Audit logs are immutable
    Given multiple audit log entries exist
    When a user tries to modify an audit log entry
    Then the modification should be rejected
    And an error message "Audit logs cannot be modified" should be returned

  Scenario: Audit logs cannot be deleted
    Given audit log entries exist
    When a user tries to delete an audit log entry
    Then the deletion should be rejected
    And an error message "Audit logs cannot be deleted" should be returned

  Scenario: Concurrent leave approval prevention
    Given an employee "john.doe" has 15 days of ANNUAL leave
    And two pending leave requests for 10 days each exist
    When the manager approves the first request
    And the manager tries to approve the second request
    Then the second approval should fail
    And an error message "Insufficient leave balance" should be displayed

  Scenario: Leave balance calculation integrity
    Given an employee has 20 days allocated of ANNUAL leave
    And 5 days have been used
    When the system calculates remaining balance
    Then the remaining balance should be 15 days
    And the formula "remaining = allocated - used" should be applied

  Scenario: Manual balance adjustments are logged
    Given an administrator is logged in
    When the administrator manually adjusts an employee's leave balance
    Then an audit log entry should be created with:
      | action              | MANUAL_BALANCE_ADJUSTMENT |
      | administrator       | admin.user              |
      | targetEmployee     | john.doe                |
      | beforeBalance      | 15                      |
      | afterBalance       | 20                      |
      | justification      | Year-end adjustment     |
      | timestamp          | Current date/time       |