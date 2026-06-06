/* ============================================================
   Task 1: Data Cleaning
   Database: WideWorldImporters
   ============================================================ */

USE WideWorldImporters;
GO

/* Step 1: Check original data */

SELECT TOP 20
    CustomerID,
    CustomerName,
    PhoneNumber,
    WebsiteURL
FROM Sales.Customers;
GO

/* Step 2: Detect missing values */

SELECT
    COUNT(*) AS MissingValuesCount
FROM Sales.Customers
WHERE CustomerName IS NULL
   OR PhoneNumber IS NULL
   OR WebsiteURL IS NULL;
GO

/* Step 3: Detect duplicate customer names */

SELECT
    CustomerName,
    COUNT(*) AS DuplicateCount
FROM Sales.Customers
GROUP BY CustomerName
HAVING COUNT(*) > 1;
GO

/* Step 4: Create cleaned data table */

IF OBJECT_ID('dbo.CleanedCustomers', 'U') IS NOT NULL
    DROP TABLE dbo.CleanedCustomers;
GO

SELECT
    CustomerID,
    ISNULL(CustomerName, 'UNKNOWN CUSTOMER') AS CustomerName,
    ISNULL(PhoneNumber, 'NO PHONE') AS PhoneNumber,
    ISNULL(WebsiteURL, 'NO WEBSITE') AS WebsiteURL
INTO dbo.CleanedCustomers
FROM Sales.Customers;
GO

/* Step 5: View cleaned data */

SELECT TOP 20 *
FROM dbo.CleanedCustomers;
GO