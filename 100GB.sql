-- Step 1: Create the database if it doesn't already exist
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'testDB')
BEGIN
    CREATE DATABASE testDB;
    PRINT 'Database "testDB" created.';
END;
GO

-- Step 2: Use the "testDB" database
USE testDB;
GO

-- Step 3: Create the "large_data" table if it doesn't already exist
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'large_data')
BEGIN
    CREATE TABLE large_data (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        column1 NVARCHAR(50),
        column2 NVARCHAR(50),
        column3 NVARCHAR(50),
        column4 NVARCHAR(50)
    );
    PRINT 'Table "large_data" created.';
END;
GO

-- Step 4: Create or alter the stored procedure to insert data
CREATE OR ALTER PROCEDURE dbo.FillLargeData
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @batchSize INT = 1000; -- Number of rows per batch
    DECLARE @totalRowsInserted BIGINT = 0; -- Track total rows inserted
    DECLARE @targetRows BIGINT = 300000000; -- Roughly 100GB worth of rows (estimate based on row size)

    PRINT CONCAT('Starting data population. Target rows: ', @targetRows);

    WHILE @totalRowsInserted < @targetRows
    BEGIN
        -- Insert a batch of rows
        INSERT INTO large_data (column1, column2, column3, column4)
        SELECT 
            CAST(NEWID() AS NVARCHAR(50)) AS column1,
            CAST(NEWID() AS NVARCHAR(50)) AS column2,
            CAST(NEWID() AS NVARCHAR(50)) AS column3,
            CAST(NEWID() AS NVARCHAR(50)) AS column4
        FROM master.dbo.spt_values
        WHERE type = 'P' AND number < @batchSize;

        -- Update rows inserted counter
        SET @totalRowsInserted = @totalRowsInserted + @batchSize;

        PRINT CONCAT('Rows inserted: ', @totalRowsInserted);
    END;

    PRINT 'Data population complete.';
END;
GO

-- Step 5: Execute the procedure to populate the table
EXEC dbo.FillLargeData;
GO
