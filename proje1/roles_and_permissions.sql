USE WideWorldImporters;
GO

/* =========================================================
   Task 6: User Roles and Permissions Management
   Database: WideWorldImporters
   Platform: SQL Server Management Studio
   ========================================================= */


/* =========================================================
   Step 1: Clean old users and roles if they already exist
   ========================================================= */

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'project_reader')
DROP USER project_reader;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'project_monitor')
DROP USER project_monitor;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'project_editor')
DROP USER project_editor;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Project_ReadOnly')
DROP ROLE Project_ReadOnly;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Project_Monitoring')
DROP ROLE Project_Monitoring;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Project_SalesEditor')
DROP ROLE Project_SalesEditor;
GO


/* =========================================================
   Step 2: Create database users without login
   ========================================================= */

CREATE USER project_reader WITHOUT LOGIN;
CREATE USER project_monitor WITHOUT LOGIN;
CREATE USER project_editor WITHOUT LOGIN;
GO


/* =========================================================
   Step 3: Create database roles
   ========================================================= */

CREATE ROLE Project_ReadOnly;
CREATE ROLE Project_Monitoring;
CREATE ROLE Project_SalesEditor;
GO


/* =========================================================
   Step 4: Add users to roles
   ========================================================= */

ALTER ROLE Project_ReadOnly ADD MEMBER project_reader;
ALTER ROLE Project_Monitoring ADD MEMBER project_monitor;
ALTER ROLE Project_SalesEditor ADD MEMBER project_editor;
GO


/* =========================================================
   Step 5: Grant permissions to roles
   ========================================================= */

-- Read-only user can only read Sales data
GRANT SELECT ON SCHEMA::Sales TO Project_ReadOnly;
GO

-- Monitoring user can view database state
GRANT VIEW DATABASE STATE TO Project_Monitoring;
GO

-- Editor user can read and modify Sales data
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Sales TO Project_SalesEditor;
GO


/* =========================================================
   Step 6: Show users and their roles
   ========================================================= */

SELECT 
    role_principal.name AS DatabaseRole,
    user_principal.name AS DatabaseUser
FROM sys.database_role_members drm
JOIN sys.database_principals role_principal
    ON drm.role_principal_id = role_principal.principal_id
JOIN sys.database_principals user_principal
    ON drm.member_principal_id = user_principal.principal_id
WHERE role_principal.name LIKE 'Project_%';
GO


/* =========================================================
   Step 7: Show granted permissions
   ========================================================= */

SELECT 
    pr.name AS PrincipalName,
    pr.type_desc AS PrincipalType,
    pe.permission_name,
    pe.state_desc,
    OBJECT_SCHEMA_NAME(pe.major_id) AS SchemaName
FROM sys.database_permissions pe
JOIN sys.database_principals pr 
    ON pe.grantee_principal_id = pr.principal_id
WHERE pr.name LIKE 'Project_%'
ORDER BY pr.name, pe.permission_name;
GO


/* =========================================================
   Step 8: Test read-only user
   SELECT should work, DELETE should fail
   ========================================================= */

EXECUTE AS USER = 'project_reader';
GO

SELECT TOP 5 
    CustomerID,
    CustomerName,
    PhoneNumber
FROM Sales.Customers;
GO

BEGIN TRY
    DELETE FROM Sales.Customers
    WHERE CustomerID = -1;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ExpectedPermissionError;
END CATCH;
GO

REVERT;
GO


/* =========================================================
   Step 9: Test monitoring user
   ========================================================= */

EXECUTE AS USER = 'project_monitor';
GO

SELECT 
    name AS LogicalFileName,
    type_desc AS FileType,
    size * 8 / 1024 AS SizeMB
FROM sys.database_files;
GO

REVERT;
GO