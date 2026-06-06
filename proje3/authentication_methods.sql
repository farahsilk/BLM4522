/* ============================================================
   Task 2: Authentication Methods
   Database: WideWorldImporters
   ============================================================ */

/* ============================================================
   Part 1: SQL Server Authentication
   ============================================================ */

USE master;
GO

CREATE LOGIN SQLSecurityUser
WITH PASSWORD = 'StrongPassword123!';
GO

USE WideWorldImporters;
GO

CREATE USER SQLSecurityUser FOR LOGIN SQLSecurityUser;
GO

-- Assign SQL authenticated user to read-only role
ALTER ROLE ReadOnlyRole ADD MEMBER SQLSecurityUser;
GO

-- Test SQLSecurityUser permissions
EXECUTE AS USER = 'SQLSecurityUser';

SELECT TOP 10 *
FROM Sales.Customers;

REVERT;
GO


/* ============================================================
   Part 2: Windows Authentication
   ============================================================ */

USE master;
GO

-- Replace YOUR_DOMAIN\YourWindowsUser with your real Windows account.
-- Example:
-- CREATE LOGIN [DESKTOP-12345\Farah] FROM WINDOWS;

-- CREATE LOGIN [YOUR_DOMAIN\YourWindowsUser] FROM WINDOWS;
GO

USE WideWorldImporters;
GO

-- Create database user for Windows login
-- Replace the account name before running.

-- CREATE USER [YOUR_DOMAIN\YourWindowsUser]
-- FOR LOGIN [YOUR_DOMAIN\YourWindowsUser];
-- GO

-- Assign Windows user to read-only role

-- ALTER ROLE ReadOnlyRole
-- ADD MEMBER [YOUR_DOMAIN\YourWindowsUser];
-- GO


/* ============================================================
   Comparison
   ============================================================ */

-- SQL Server Authentication:
-- Users connect using a username and password created inside SQL Server.
-- It is useful for database-specific users.

-- Windows Authentication:
-- Users connect using their Windows account.
-- It is usually more secure because it uses Windows security policies.