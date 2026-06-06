/* ============================================================
   Task 2: Data Transformation
   Database: WideWorldImporters
   ============================================================ */

USE WideWorldImporters;
GO

/* Step 1: Create transformed table */

IF OBJECT_ID('dbo.TransformedCustomers', 'U') IS NOT NULL
    DROP TABLE dbo.TransformedCustomers;
GO

SELECT
    CustomerID,
    UPPER(TRIM(CustomerName)) AS StandardCustomerName,
    REPLACE(REPLACE(REPLACE(PhoneNumber, ' ', ''), '-', ''), '(', '') AS StandardPhoneNumber,
    LOWER(TRIM(WebsiteURL)) AS StandardWebsiteURL
INTO dbo.TransformedCustomers
FROM dbo.CleanedCustomers;
GO

/* Step 2: View transformed data */

SELECT TOP 20 *
FROM dbo.TransformedCustomers;
GO

/* Step 3: Check transformed text format */

SELECT TOP 20
    CustomerID,
    StandardCustomerName,
    StandardPhoneNumber,
    StandardWebsiteURL
FROM dbo.TransformedCustomers;
GO