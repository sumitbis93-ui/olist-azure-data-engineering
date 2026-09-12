/* ============================================================
   DATABASE
   ============================================================ */

USE [olist_synapse_db];
GO


/* ============================================================
   8. ORDER OPERATIONAL RISK
   Source View:
       operations.vw_order_operational_risk

   External Table:
       operations.ext_order_operational_risk

   ADLS Output:
       operations/vw_order_operational_risk.parquet/
   ============================================================ */


/* ------------------------------------------------------------
   DROP EXISTING EXTERNAL TABLE
   ------------------------------------------------------------ */

IF EXISTS
(
    SELECT 1
    FROM sys.external_tables
    WHERE name = 'ext_order_operational_risk'
      AND schema_id = SCHEMA_ID('operations')
)
BEGIN
    DROP EXTERNAL TABLE [operations].[ext_order_operational_risk];
END;
GO


/* ------------------------------------------------------------
   CREATE EXTERNAL DATA SOURCE IF IT DOES NOT EXIST
   ------------------------------------------------------------ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.external_data_sources
    WHERE name = 'operations_vw_order_operational_risk_file'
)
BEGIN

    CREATE EXTERNAL DATA SOURCE [operations_vw_order_operational_risk_file]
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

CREATE EXTERNAL TABLE [operations].[ext_order_operational_risk]
WITH
(
    LOCATION = 'operations/vw_order_operational_risk.parquet/',
    DATA_SOURCE = [operations_vw_order_operational_risk_file],
    FILE_FORMAT = [external_file_format]
)
AS
SELECT *
FROM [operations].[vw_order_operational_risk];
GO


