/* ============================================================
   Task 4: Data Quality Reports
   Database: WideWorldImporters
   ============================================================ */

USE WideWorldImporters;
GO

/* Step 1: Create data quality report table */

IF OBJECT_ID('dbo.DataQualityReport', 'U') IS NOT NULL
    DROP TABLE dbo.DataQualityReport;
GO

CREATE TABLE dbo.DataQualityReport
(
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    ReportName NVARCHAR(100),
    ReportValue INT,
    ReportDate DATETIME DEFAULT GETDATE()
);
GO

/* Step 2: Insert total records report */

INSERT INTO dbo.DataQualityReport
(
    ReportName,
    ReportValue
)
SELECT
    'Total Loaded Records',
    COUNT(*)
FROM dbo.FinalCustomersETL;
GO

/* Step 3: Insert missing values report */

INSERT INTO dbo.DataQualityReport
(
    ReportName,
    ReportValue
)
SELECT
    'Missing Values After Cleaning',
    COUNT(*)
FROM dbo.FinalCustomersETL
WHERE CustomerName IS NULL
   OR PhoneNumber IS NULL
   OR WebsiteURL IS NULL;
GO

/* Step 4: Insert duplicate customer report */

INSERT INTO dbo.DataQualityReport
(
    ReportName,
    ReportValue
)
SELECT
    'Duplicate Customer Names',
    COUNT(*)
FROM
(
    SELECT CustomerName
    FROM dbo.FinalCustomersETL
    GROUP BY CustomerName
    HAVING COUNT(*) > 1
) AS DuplicateData;
GO

/* Step 5: View final data quality report */

SELECT *
FROM dbo.DataQualityReport;
GO