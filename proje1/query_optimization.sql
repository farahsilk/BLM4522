USE WideWorldImporters;
GO

/* =========================================================
   Task 4: Query Optimization
   Database: WideWorldImporters
   Platform: SQL Server Management Studio
   ========================================================= */


/* =========================================================
   Step 1: Make sure useful indexes exist
   These indexes help the optimized query run faster.
   ========================================================= */

IF NOT EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_Project_Orders_OrderDate'
      AND object_id = OBJECT_ID('Sales.Orders')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Project_Orders_OrderDate
    ON Sales.Orders(OrderDate)
    INCLUDE (CustomerID);
END
GO

IF NOT EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_Project_OrderLines_StockItemID_OrderID'
      AND object_id = OBJECT_ID('Sales.OrderLines')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Project_OrderLines_StockItemID_OrderID
    ON Sales.OrderLines(StockItemID, OrderID)
    INCLUDE (Quantity, UnitPrice);
END
GO


/* =========================================================
   Step 2: Bad query before optimization
   Problem:
   - Uses SELECT *
   - Uses YEAR(OrderDate), which makes index usage harder
   ========================================================= */

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Before Optimization
SELECT TOP 200 *
FROM Sales.Orders o
JOIN Sales.OrderLines ol
    ON o.OrderID = ol.OrderID
WHERE YEAR(o.OrderDate) = 2015
  AND ol.StockItemID = 10;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/* =========================================================
   Step 3: Optimized query after improvement
   Improvements:
   - Selects only needed columns
   - Replaces YEAR(OrderDate) with date range
   - Uses columns supported by indexes
   ========================================================= */

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- After Optimization
SELECT TOP 200
    o.OrderID,
    o.OrderDate,
    o.CustomerID,
    ol.StockItemID,
    ol.Quantity,
    ol.UnitPrice
FROM Sales.Orders o
JOIN Sales.OrderLines ol
    ON o.OrderID = ol.OrderID
WHERE o.OrderDate >= '2015-01-01'
  AND o.OrderDate < '2016-01-01'
  AND ol.StockItemID = 10;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/* =========================================================
   Step 4: DMV check for recently executed queries
   Used to monitor query cost after execution.
   ========================================================= */

SELECT TOP 20
    qs.execution_count,
    qs.total_elapsed_time / 1000.0 AS TotalElapsedMS,
    qs.total_worker_time / 1000.0 AS TotalCPUMS,
    qs.total_logical_reads AS TotalLogicalReads,
    qs.last_execution_time,
    qt.text AS QueryText
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
WHERE qt.text LIKE '%Sales.Orders%'
   OR qt.text LIKE '%Sales.OrderLines%'
ORDER BY qs.last_execution_time DESC;
GO