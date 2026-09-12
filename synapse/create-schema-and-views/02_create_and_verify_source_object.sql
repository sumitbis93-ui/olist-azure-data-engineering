USE olist_synapse_db;
GO;

-- Drop the view if it already exists
DROP VIEW IF EXISTS dbo.olist_complete_data;
GO;

-- Create the view safely
CREATE VIEW dbo.olist_complete_data
AS
    SELECT
        *
    FROM OPENROWSET(
        BULK 'https://ecommoliststorageaccount.blob.core.windows.net/olistdata/silver/04_final_integrated_data/olist_complete_data.parquet',
        FORMAT = 'PARQUET'
    ) as olist_complete_data;
GO;

-- Verify the result from view
SELECT 
    TOP 10 *
FROM dbo.olist_complete_data;

SELECT COUNT(*) AS total_rows
FROM dbo.olist_complete_data;