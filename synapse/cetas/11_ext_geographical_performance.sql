/* ============================================================
   DATABASE
   ============================================================ */

USE [olist_synapse_db];
GO


/* ============================================================
   9. GEOGRAPHICAL PERFORMANCE
   Source View:
       commercial.vw_geographical_performance

   External Table:
       commercial.ext_geographical_performance

   ADLS Output:
       commercial/vw_geographical_performance.parquet/
   ============================================================ */


/* ------------------------------------------------------------
   DROP EXISTING EXTERNAL TABLE
   ------------------------------------------------------------ */

IF EXISTS
(
    SELECT 1
    FROM sys.external_tables
    WHERE name = 'ext_geographical_performance'
      AND schema_id = SCHEMA_ID('commercial')
)
BEGIN
    DROP EXTERNAL TABLE [commercial].[ext_geographical_performance];
END;
GO


/* ------------------------------------------------------------
   CREATE EXTERNAL DATA SOURCE IF IT DOES NOT EXIST
   ------------------------------------------------------------ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.external_data_sources
    WHERE name = 'commercial_vw_geographical_performance_file'
)
BEGIN

    CREATE EXTERNAL DATA SOURCE [commercial_vw_geographical_performance_file]
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

CREATE EXTERNAL TABLE [commercial].[ext_geographical_performance]
WITH
(
    LOCATION = 'commercial/vw_geographical_performance.parquet/',
    DATA_SOURCE = [commercial_vw_geographical_performance_file],
    FILE_FORMAT = [external_file_format]
)
AS
SELECT *
FROM [commercial].[vw_geographical_performance];
GO


