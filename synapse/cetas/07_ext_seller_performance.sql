/* ============================================================
   DATABASE
   ============================================================ */

USE [olist_synapse_db];
GO


/* ============================================================
   5. SELLER PERFORMANCE
   Source View:
       marketplace.vw_seller_performance

   External Table:
       marketplace.ext_seller_performance

   ADLS Output:
       marketplace/vw_seller_performance.parquet/
   ============================================================ */


/* ------------------------------------------------------------
   DROP EXISTING EXTERNAL TABLE
   ------------------------------------------------------------ */

IF EXISTS
(
    SELECT 1
    FROM sys.external_tables
    WHERE name = 'ext_seller_performance'
      AND schema_id = SCHEMA_ID('marketplace')
)
BEGIN
    DROP EXTERNAL TABLE [marketplace].[ext_seller_performance];
END;
GO


/* ------------------------------------------------------------
   CREATE EXTERNAL DATA SOURCE IF IT DOES NOT EXIST
   ------------------------------------------------------------ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.external_data_sources
    WHERE name = 'marketplace_vw_seller_performance_file'
)
BEGIN

    CREATE EXTERNAL DATA SOURCE [marketplace_vw_seller_performance_file]
    WITH
    (
        LOCATION =
            'https://ecommoliststorageaccount.blob.core.windows.net/olistdata/gold/served_data',
        CREDENTIAL = [synapsesqladminuser]
    );

END;
GO


/* ------------------------------------------------------------
   CREATE CETAS EXTERNAL TABLE
   ------------------------------------------------------------ */

CREATE EXTERNAL TABLE [marketplace].[ext_seller_performance]
WITH
(
    LOCATION = 'marketplace/vw_seller_performance.parquet/',
    DATA_SOURCE = [marketplace_vw_seller_performance_file],
    FILE_FORMAT = [external_file_format]
)
AS
SELECT *
FROM [marketplace].[vw_seller_performance];
GO

