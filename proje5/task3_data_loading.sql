/* ============================================================
   Task 3: Data Loading
   Database: WideWorldImporters
   ============================================================ */

USE WideWorldImporters;
GO

/* Step 1: Create final target table */

IF OBJECT_ID('dbo.FinalCustomersETL', 'U') IS NOT NULL
    DROP TABLE dbo.FinalCustomersETL;
GO

CREATE TABLE dbo.FinalCustomersETL
(
    CustomerID INT,
    CustomerName NVARCHAR(100),
    PhoneNumber NVARCHAR(50),
    WebsiteURL NVARCHAR(256),
    LoadDate DATETIME DEFAULT GETDATE()
);
GO

/* Step 2: Load transformed data */

INSERT INTO dbo.FinalCustomersETL
(
    CustomerID,
    CustomerName,
    PhoneNumber,
    WebsiteURL
)
SELECT
    CustomerID,
    StandardCustomerName,
    StandardPhoneNumber,
    StandardWebsiteURL
FROM dbo.TransformedCustomers;
GO

/* Step 3: Verify loaded data */

SELECT TOP 20 *
FROM dbo.FinalCustomersETL;
GO

/* Step 4: Count loaded records */

SELECT COUNT(*) AS TotalLoadedRecords
FROM dbo.FinalCustomersETL;
GO