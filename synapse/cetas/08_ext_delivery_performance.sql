/* ============================================================
   DATABASE
   ============================================================ */

USE [olist_synapse_db];
GO


/* ============================================================
   6. DELIVERY PERFORMANCE
   Source View:
       operations.vw_delivery_performance

   External Table:
       operations.ext_delivery_performance

   ADLS Output:
       operations/vw_delivery_performance.parquet/
   ============================================================ */


/* ------------------------------------------------------------
   DROP EXISTING EXTERNAL TABLE
   ------------------------------------------------------------ */

IF EXISTS
(
    SELECT 1
    FROM sys.external_tables
    WHERE name = 'ext_delivery_performance'
      AND schema_id = SCHEMA_ID('operations')
)
BEGIN
    DROP EXTERNAL TABLE [operations].[ext_delivery_performance];
END;
GO


/* ------------------------------------------------------------
   CREATE EXTERNAL DATA SOURCE IF IT DOES NOT EXIST
   ------------------------------------------------------------ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.external_data_sources
    WHERE name = 'operations_vw_delivery_performance_file'
)
BEGIN

    CREATE EXTERNAL DATA SOURCE [operations_vw_delivery_performance_file]
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

CREATE EXTERNAL TABLE [operations].[ext_delivery_performance]
WITH
(
    LOCATION = 'operations/vw_delivery_performance.parquet/',
    DATA_SOURCE = [operations_vw_delivery_performance_file],
    FILE_FORMAT = [external_file_format]
)
AS
SELECT *
FROM [operations].[vw_delivery_performance];
GO


