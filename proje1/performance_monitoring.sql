USE WideWorldImporters;
GO

/* =========================================================
   Task 2: Performance Monitoring
   Database: WideWorldImporters
   Platform: SQL Server Management Studio
   ========================================================= */


/* =========================================================
   Part 1: Enable performance statistics
   This shows CPU time, elapsed time, and logical reads
   in the Messages tab.
   ========================================================= */

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO


/* =========================================================
   Part 2: Test query for performance monitoring
   This query joins Sales.Orders and Sales.OrderLines.
   It filters orders from 2015 and a specific StockItemID.
   
   Screenshot needed:
   - Query results
   - Messages tab
   - Actual Execution Plan
   ========================================================= */

SELECT 
    o.OrderID,
    o.OrderDate,
    o.CustomerID,
    ol.StockItemID,
    ol.Quantity,
    ol.UnitPrice
FROM Sales.Orders o
JOIN Sales.OrderLines ol 
    ON o.OrderID = ol.OrderID
WHERE YEAR(o.OrderDate) = 2015
  AND ol.StockItemID = 10;
GO


/* =========================================================
   Part 3: Disable statistics
   ========================================================= */

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/* =========================================================
   Part 4: DMV - Show recently executed expensive queries
   This helps monitor query performance from SQL Server cache.
   
   Screenshot needed:
   - DMV result table
   ========================================================= */

SELECT TOP 20
    qs.execution_count,
    qs.total_elapsed_time / 1000.0 AS TotalElapsedMS,
    qs.total_worker_time / 1000.0 AS TotalCPUMS,
    qs.total_logical_reads AS TotalLogicalReads,
    qs.total_logical_writes AS TotalLogicalWrites,
    qs.last_execution_time,
    SUBSTRING(
        qt.text,
        (qs.statement_start_offset / 2) + 1,
        (
            (
                CASE qs.statement_end_offset
                    WHEN -1 THEN DATALENGTH(qt.text)
                    ELSE qs.statement_end_offset
                END - qs.statement_start_offset
            ) / 2
        ) + 1
    ) AS QueryText
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
WHERE qt.text LIKE '%Sales.Orders%'
   OR qt.text LIKE '%Sales.OrderLines%'
ORDER BY qs.total_elapsed_time DESC;
GO