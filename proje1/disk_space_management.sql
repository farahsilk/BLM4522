USE WideWorldImporters;
GO

/* =========================================================
   Task 5: Disk Space Management
   Database: WideWorldImporters
   Platform: SQL Server Management Studio
   ========================================================= */


/* =========================================================
   Step 1: Show database space usage
   This shows total database size and unallocated space.
   ========================================================= */

EXEC sp_spaceused;
GO


/* =========================================================
   Step 2: Show database files size
   This shows data file and log file size.
   ========================================================= */

SELECT 
    name AS LogicalFileName,
    type_desc AS FileType,
    size * 8 / 1024 AS SizeMB,
    max_size,
    growth,
    physical_name
FROM sys.database_files;
GO


/* =========================================================
   Step 3: Show table sizes
   This shows row count and space usage for each table.
   ========================================================= */

SELECT 
    s.name AS SchemaName,
    t.name AS TableName,
    SUM(p.rows) AS RowCount,
    SUM(a.total_pages) * 8 / 1024 AS TotalMB,
    SUM(a.used_pages) * 8 / 1024 AS UsedMB,
    SUM(a.data_pages) * 8 / 1024 AS DataMB
FROM sys.tables t
JOIN sys.schemas s 
    ON t.schema_id = s.schema_id
JOIN sys.indexes i 
    ON t.object_id = i.object_id
JOIN sys.partitions p 
    ON i.object_id = p.object_id 
    AND i.index_id = p.index_id
JOIN sys.allocation_units a 
    ON p.partition_id = a.container_id
GROUP BY s.name, t.name
ORDER BY TotalMB DESC;
GO


/* =========================================================
   Step 4: Check index fragmentation
   This shows how fragmented the indexes are.
   Fragmentation means the index pages are not organized well.
   ========================================================= */

SELECT 
    OBJECT_SCHEMA_NAME(ips.object_id) AS SchemaName,
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.indexes i 
    ON ips.object_id = i.object_id 
    AND ips.index_id = i.index_id
WHERE ips.page_count > 100
ORDER BY ips.avg_fragmentation_in_percent DESC;
GO


/* =========================================================
   Step 5: Reorganize project indexes
   This performs simple index maintenance.
   ========================================================= */

IF EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_Project_Orders_OrderDate'
      AND object_id = OBJECT_ID('Sales.Orders')
)
BEGIN
    ALTER INDEX IX_Project_Orders_OrderDate 
    ON Sales.Orders 
    REORGANIZE;
END
GO

IF EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_Project_OrderLines_StockItemID_OrderID'
      AND object_id = OBJECT_ID('Sales.OrderLines')
)
BEGIN
    ALTER INDEX IX_Project_OrderLines_StockItemID_OrderID 
    ON Sales.OrderLines 
    REORGANIZE;
END
GO


/* =========================================================
   Step 6: Check index fragmentation again after maintenance
   This verifies the index status after reorganizing.
   ========================================================= */

SELECT 
    OBJECT_SCHEMA_NAME(ips.object_id) AS SchemaName,
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.indexes i 
    ON ips.object_id = i.object_id 
    AND ips.index_id = i.index_id
WHERE i.name LIKE 'IX_Project%'
ORDER BY ips.avg_fragmentation_in_percent DESC;
GO