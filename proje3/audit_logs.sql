/* ============================================================
   Task 5: Audit Logs
   Database: WideWorldImporters
   ============================================================ */


/* ============================================================
   Step 1: Create Server Audit
   ============================================================ */

USE master;
GO

-- Before running this code, create this folder:
-- C:\SQLAudit\

CREATE SERVER AUDIT WideWorldImportersAudit
TO FILE
(
    FILEPATH = 'C:\SQLAudit\',
    MAXSIZE = 100 MB,
    MAX_ROLLOVER_FILES = 10
);
GO


/* ============================================================
   Step 2: Enable Audit
   ============================================================ */

ALTER SERVER AUDIT WideWorldImportersAudit
WITH (STATE = ON);
GO


/* ============================================================
   Step 3: Create Database Audit Specification
   ============================================================ */

USE WideWorldImporters;
GO

CREATE DATABASE AUDIT SPECIFICATION WideWorldImportersDatabaseAuditSpec
FOR SERVER AUDIT WideWorldImportersAudit
ADD (SELECT ON DATABASE::WideWorldImporters BY public),
ADD (INSERT ON DATABASE::WideWorldImporters BY public),
ADD (UPDATE ON DATABASE::WideWorldImporters BY public),
ADD (DELETE ON DATABASE::WideWorldImporters BY public)
WITH (STATE = ON);
GO


/* ============================================================
   Step 4: Perform User Actions
   ============================================================ */

SELECT TOP 10 *
FROM Sales.Customers;
GO

UPDATE Sales.Customers
SET CustomerName = CustomerName
WHERE CustomerID = -1;
GO

DELETE FROM Sales.Customers
WHERE CustomerID = -1;
GO


/* ============================================================
   Step 5: View Audit Results
   ============================================================ */

SELECT
    event_time,
    server_principal_name,
    database_name,
    object_name,
    statement,
    action_id,
    succeeded
FROM sys.fn_get_audit_file
(
    'C:\SQLAudit\*.sqlaudit',
    DEFAULT,
    DEFAULT
);
GO