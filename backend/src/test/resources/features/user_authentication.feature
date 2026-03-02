Feature: User Authentication
  As a user
  I want to securely log into the system
  So that I can access my leave management features

  Background:
    Given the Leave Management System is available
    And the following users exist:
      | username      | password   | role     |
      | john.doe      | pass123   | EMPOYEE |
      | jane.manager  | mgr123    | MANAGER |
      | admin.user    | admin123  | ADMIN   |

  Scenario: Successful login with valid credentials
    Given the user is on the login page
    When the user enters username "john.doe" and password "pass123"
    And the user clicks the "Login" button
    Then the user should be redirected to the dashboard
    And a success message "Welcome back, John!" should be displayed
    And a JWT token should be generated and stored

  Scenario: Failed login with invalid password
    Given the user is on the login page
    When the user enters username "john.doe" and password "wrongpass"
    And the user clicks the "Login" button
    Then an error message "Invalid username or password" should be displayed
    And the user should remain on the login page
    And no token should be generated

  Scenario: Failed login with non-existent user
    Given the user is on the login page
    When the user enters username "nonexistent.user" and password "pass123"
    And the user clicks the "Login" button
    Then an error message "Invalid username or password" should be displayed
    And the user should remain on the login page

  Scenario: Login attempt with empty credentials
    Given the user is on the login page
    When the user clicks the "Login" button without entering credentials
    Then validation errors should be displayed
    And the error message should contain "Username is required"
    And the error message should contain "Password is required"

  Scenario: Account lockout after multiple failed attempts
    Given the user is on the login page
    When the user enters incorrect credentials 5 times
    Then the account should be temporarily locked
    And an error message "Account locked. Please try again in 15 minutes" should be displayed

  Scenario: Role-based access for employee
    Given the user "john.doe" is logged in with role "EMPLOYEE"
    Then the user should have access to:
      | Leave Application  |
      | Leave Dashboard    |
      | Leave History      |
    And the user should NOT have access to:
      | Leave Approval     |
      | Team Reports       |

  Scenario: Role-based access for manager
    Given the user "jane.manager" is logged in with role "MANAGER"
    Then the user should have access to:
      | Leave Application  |
      | Leave Dashboard    |
      | Leave History      |
      | Leave Approval     |
      | Team Reports       |

  Scenario: Session expiration after inactivity
    Given the user "john.doe" is logged in
    When the user is inactive for 30 minutes
    Then the session should expire
    And the user should be redirected to the login page
    And a message "Session expired. Please log in again" should be displayed

  Scenario: Logout functionality
    Given the user "john.doe" is logged in
    When the user clicks the "Logout" button
    Then the user session should be terminated
    And the user should be redirected to the login page
    And the JWT token should be cleared

  Scenario: Password masking during entry
    Given the user is on the login page
    When the user types the password
    Then the password field should display asterisks or dots
    And the actual password text should not be visible

  Scenario: Unauthorized access to protected routes
    Given a user is not logged in
    When the user tries to access the dashboard directly
    Then the user should be redirected to the login page
    And an error message "Please log in to access this page" should be displayed

  Scenario Outline: Login for different roles
    Given the user is on the login page
    When the user enters username "<username>" and password "<password>"
    And the user clicks the "Login" button
    Then the user should be redirected to <destination>
    And the user's role should be <role>

    Examples:
      | username       | password | role     | destination        |
      | john.doe      | pass123 | EMPLOYEE | Employee Dashboard |
      | jane.manager  | mgr123  | MANAGER | Manager Dashboard  |
      | admin.user    | admin123| ADMIN   | Admin Dashboard   |