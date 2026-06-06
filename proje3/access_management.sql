/* ============================================================
   Task 1: Access Management
   Database: WideWorldImporters
   ============================================================ */

USE WideWorldImporters;
GO

/* Step 1: Create Users */

CREATE USER ReadOnlyUser WITHOUT LOGIN;
CREATE USER EditorUser WITHOUT LOGIN;
CREATE USER MonitoringUser WITHOUT LOGIN;
GO

/* Step 2: Create Roles */

CREATE ROLE ReadOnlyRole;
CREATE ROLE EditorRole;
CREATE ROLE MonitoringRole;
GO

/* Step 3: Assign Users to Roles */

ALTER ROLE ReadOnlyRole ADD MEMBER ReadOnlyUser;
ALTER ROLE EditorRole ADD MEMBER EditorUser;
ALTER ROLE MonitoringRole ADD MEMBER MonitoringUser;
GO

/* Step 4: Grant Permissions */

-- Read-only role
GRANT SELECT ON SCHEMA::Sales TO ReadOnlyRole;
GRANT SELECT ON SCHEMA::Purchasing TO ReadOnlyRole;
GRANT SELECT ON SCHEMA::Warehouse TO ReadOnlyRole;
GO

-- Editor role
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Sales TO EditorRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Purchasing TO EditorRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Warehouse TO EditorRole;
GO

-- Monitoring role
GRANT VIEW DATABASE STATE TO MonitoringRole;
GO

/* Step 5: Test Permissions */

-- Test ReadOnlyUser: SELECT should work
EXECUTE AS USER = 'ReadOnlyUser';

SELECT TOP 10 *
FROM Sales.Customers;

REVERT;
GO

-- Test ReadOnlyUser: DELETE should fail
EXECUTE AS USER = 'ReadOnlyUser';

DELETE FROM Sales.Customers
WHERE CustomerID = -1;

REVERT;
GO

-- Test EditorUser: SELECT should work
EXECUTE AS USER = 'EditorUser';

SELECT TOP 10 *
FROM Sales.Customers;

REVERT;
GO

-- Test EditorUser: UPDATE should work
-- CustomerID = -1 is used to avoid changing real data
EXECUTE AS USER = 'EditorUser';

UPDATE Sales.Customers
SET CustomerName = CustomerName
WHERE CustomerID = -1;

REVERT;
GO