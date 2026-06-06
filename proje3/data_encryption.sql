/* ============================================================
   Task 3: Data Encryption
   Database: WideWorldImporters
   ============================================================ */


/* ============================================================
   Part 1: Transparent Data Encryption
   ============================================================ */

USE master;
GO

-- Step 1: Create master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MasterKeyPassword123!';
GO

-- Step 2: Create certificate
CREATE CERTIFICATE WideWorldImportersTDECertificate
WITH SUBJECT = 'Certificate for WideWorldImporters TDE';
GO

USE WideWorldImporters;
GO

-- Step 3: Create database encryption key
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE WideWorldImportersTDECertificate;
GO

-- Step 4: Enable encryption
ALTER DATABASE WideWorldImporters
SET ENCRYPTION ON;
GO

-- Step 5: Check encryption status
SELECT
    db.name AS DatabaseName,
    dek.encryption_state,
    dek.percent_complete,
    dek.key_algorithm,
    dek.key_length
FROM sys.dm_database_encryption_keys dek
JOIN sys.databases db
    ON dek.database_id = db.database_id
WHERE db.name = 'WideWorldImporters';
GO


/* ============================================================
   Part 2: Alternative Column-Level Encryption
   Use this if TDE is not supported.
   ============================================================ */

USE WideWorldImporters;
GO

-- Create test table for sensitive data
CREATE TABLE dbo.CustomerSensitiveData
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100),
    CreditCardNumber VARBINARY(MAX)
);
GO

-- Create database master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'ColumnEncryptionPassword123!';
GO

-- Create certificate
CREATE CERTIFICATE CustomerDataCertificate
WITH SUBJECT = 'Certificate for customer sensitive data';
GO

-- Create symmetric key
CREATE SYMMETRIC KEY CustomerDataSymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CustomerDataCertificate;
GO

-- Insert encrypted data
OPEN SYMMETRIC KEY CustomerDataSymmetricKey
DECRYPTION BY CERTIFICATE CustomerDataCertificate;

INSERT INTO dbo.CustomerSensitiveData
(
    CustomerName,
    CreditCardNumber
)
VALUES
(
    'Test Customer',
    EncryptByKey
    (
        Key_GUID('CustomerDataSymmetricKey'),
        CONVERT(VARBINARY(MAX), '1234-5678-9999-0000')
    )
);

CLOSE SYMMETRIC KEY CustomerDataSymmetricKey;
GO

-- Read decrypted data
OPEN SYMMETRIC KEY CustomerDataSymmetricKey
DECRYPTION BY CERTIFICATE CustomerDataCertificate;

SELECT
    ID,
    CustomerName,
    CONVERT(NVARCHAR(100), DecryptByKey(CreditCardNumber)) AS DecryptedCreditCardNumber
FROM dbo.CustomerSensitiveData;

CLOSE SYMMETRIC KEY CustomerDataSymmetricKey;
GO