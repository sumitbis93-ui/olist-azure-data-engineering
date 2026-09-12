/* ============================================================
   DATABASE
   ============================================================ */

USE [olist_synapse_db];
GO


/* ============================================================
   2. PRODUCT CATEGORY PERFORMANCE
   Source View:
       sales.vw_product_category_performance

   External Table:
       sales.ext_product_category_performance

   ADLS Output:
       sales/vw_product_category_performance.parquet/
   ============================================================ */


/* ------------------------------------------------------------
   DROP EXISTING EXTERNAL TABLE
   ------------------------------------------------------------ */

IF EXISTS
(
    SELECT 1
    FROM sys.external_tables
    WHERE name = 'ext_product_category_performance'
      AND schema_id = SCHEMA_ID('sales')
)
BEGIN
    DROP EXTERNAL TABLE [sales].[ext_product_category_performance];
END;
GO


/* ------------------------------------------------------------
   CREATE EXTERNAL DATA SOURCE IF IT DOES NOT EXIST
   ------------------------------------------------------------ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.external_data_sources
    WHERE name = 'sales_vw_product_category_performance_file'
)
BEGIN

    CREATE EXTERNAL DATA SOURCE [sales_vw_product_category_performance_file]
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

CREATE EXTERNAL TABLE [sales].[ext_product_category_performance]
WITH
(
    LOCATION = 'sales/vw_product_category_performance.parquet/',
    DATA_SOURCE = [sales_vw_product_category_performance_file],
    FILE_FORMAT = [external_file_format]
)
AS
SELECT *
FROM [sales].[vw_product_category_performance];
GO

