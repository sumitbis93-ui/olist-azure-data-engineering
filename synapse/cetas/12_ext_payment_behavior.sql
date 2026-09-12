/* ============================================================
   DATABASE
   ============================================================ */

USE [olist_synapse_db];
GO


/* ============================================================
   10. PAYMENT BEHAVIOR
   Source View:
       commercial.vw_payment_behavior

   External Table:
       commercial.ext_payment_behavior

   ADLS Output:
       commercial/vw_payment_behavior.parquet/
   ============================================================ */


/* ------------------------------------------------------------
   DROP EXISTING EXTERNAL TABLE
   ------------------------------------------------------------ */

IF EXISTS
(
    SELECT 1
    FROM sys.external_tables
    WHERE name = 'ext_payment_behavior'
      AND schema_id = SCHEMA_ID('commercial')
)
BEGIN
    DROP EXTERNAL TABLE [commercial].[ext_payment_behavior];
END;
GO


/* ------------------------------------------------------------
   CREATE EXTERNAL DATA SOURCE IF IT DOES NOT EXIST
   ------------------------------------------------------------ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.external_data_sources
    WHERE name = 'commercial_vw_payment_behavior_file'
)
BEGIN

    CREATE EXTERNAL DATA SOURCE [commercial_vw_payment_behavior_file]
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

CREATE EXTERNAL TABLE [commercial].[ext_payment_behavior]
WITH
(
    LOCATION = 'commercial/vw_payment_behavior.parquet/',
    DATA_SOURCE = [commercial_vw_payment_behavior_file],
    FILE_FORMAT = [external_file_format]
)
AS
SELECT *
FROM [commercial].[vw_payment_behavior];
GO


