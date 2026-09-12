/* ============================================================
   DATABASE
   ============================================================ */

USE [olist_synapse_db];
GO


/* ============================================================
   7. FREIGHT COST ANALYSIS
   Source View:
       operations.vw_freight_cost_analysis

   External Table:
       operations.ext_freight_cost_analysis

   ADLS Output:
       operations/vw_freight_cost_analysis.parquet/
   ============================================================ */


/* ------------------------------------------------------------
   DROP EXISTING EXTERNAL TABLE
   ------------------------------------------------------------ */

IF EXISTS
(
    SELECT 1
    FROM sys.external_tables
    WHERE name = 'ext_freight_cost_analysis'
      AND schema_id = SCHEMA_ID('operations')
)
BEGIN
    DROP EXTERNAL TABLE [operations].[ext_freight_cost_analysis];
END;
GO


/* ------------------------------------------------------------
   CREATE EXTERNAL DATA SOURCE IF IT DOES NOT EXIST
   ------------------------------------------------------------ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.external_data_sources
    WHERE name = 'operations_vw_freight_cost_analysis_file'
)
BEGIN

    CREATE EXTERNAL DATA SOURCE [operations_vw_freight_cost_analysis_file]
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

CREATE EXTERNAL TABLE [operations].[ext_freight_cost_analysis]
WITH
(
    LOCATION = 'operations/vw_freight_cost_analysis.parquet/',
    DATA_SOURCE = [operations_vw_freight_cost_analysis_file],
    FILE_FORMAT = [external_file_format]
)
AS
SELECT *
FROM [operations].[vw_freight_cost_analysis];
GO


