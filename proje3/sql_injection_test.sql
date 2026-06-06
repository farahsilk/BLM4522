/* ============================================================
   Task 4: SQL Injection Test
   Database: WideWorldImporters
   ============================================================ */

USE WideWorldImporters;
GO

/* Step 1: Create test table */

CREATE TABLE dbo.LoginTest
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50),
    PasswordValue NVARCHAR(50)
);
GO

/* Step 2: Insert sample data */

INSERT INTO dbo.LoginTest
(
    Username,
    PasswordValue
)
VALUES
('admin', 'admin123'),
('user1', 'pass123'),
('user2', 'test123');
GO


/* ============================================================
   Step 3: Unsafe Dynamic SQL Query
   ============================================================ */

DECLARE @Username NVARCHAR(100);
DECLARE @Password NVARCHAR(100);
DECLARE @SQL NVARCHAR(MAX);

-- SQL injection input
SET @Username = ''' OR 1=1 --';
SET @Password = 'anything';

-- Unsafe query
SET @SQL =
'SELECT * FROM dbo.LoginTest
 WHERE Username = ''' + @Username + '''
 AND PasswordValue = ''' + @Password + '''';

PRINT @SQL;

EXEC(@SQL);
GO


/* ============================================================
   Step 4: Safe Parameterized Query
   ============================================================ */

DECLARE @UsernameSafe NVARCHAR(100);
DECLARE @PasswordSafe NVARCHAR(100);
DECLARE @SQLSafe NVARCHAR(MAX);

-- Same injection input
SET @UsernameSafe = ''' OR 1=1 --';
SET @PasswordSafe = 'anything';

-- Safe query using parameters
SET @SQLSafe =
N'SELECT * FROM dbo.LoginTest
  WHERE Username = @UserParam
  AND PasswordValue = @PassParam';

EXEC sp_executesql
    @SQLSafe,
    N'@UserParam NVARCHAR(100), @PassParam NVARCHAR(100)',
    @UserParam = @UsernameSafe,
    @PassParam = @PasswordSafe;
GO


/* ============================================================
   Step 5: Compare Results
   ============================================================ */

-- The unsafe query may return all rows because OR 1=1 is always true.
-- The safe query treats the input as text, so it prevents SQL injection.