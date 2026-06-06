USE WideWorldImporters;
GO

SELECT 
    name AS DatabaseName,
    create_date,
    compatibility_level,
    collation_name,
    recovery_model_desc
FROM sys.databases
WHERE name = DB_NAME();
GO

SELECT 
    name AS LogicalFileName,
    type_desc AS FileType,
    size * 8 / 1024 AS SizeMB,
    physical_name
FROM sys.database_files;
GO

SELECT 
    name AS SchemaName
FROM sys.schemas
ORDER BY name;
GO

SELECT 
    s.name AS SchemaName,
    t.name AS TableName,
    SUM(p.rows) AS RowCount
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)
GROUP BY s.name, t.name
ORDER BY RowCount DESC;
GO

SELECT 
    s.name AS SchemaName,
    t.name AS TableName,
    SUM(a.total_pages) * 8 / 1024 AS TotalMB,
    SUM(a.used_pages) * 8 / 1024 AS UsedMB,
    SUM(a.data_pages) * 8 / 1024 AS DataMB
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN sys.indexes i ON t.object_id = i.object_id
JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN sys.allocation_units a ON p.partition_id = a.container_id
GROUP BY s.name, t.name
ORDER BY TotalMB DESC;
GO

SELECT TOP 10 * FROM Sales.Customers;
SELECT TOP 10 * FROM Sales.Orders;
SELECT TOP 10 * FROM Sales.OrderLines;
SELECT TOP 10 * FROM Warehouse.StockItems;
SELECT TOP 10 * FROM Purchasing.Suppliers;
GO