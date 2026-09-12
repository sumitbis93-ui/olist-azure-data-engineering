/* ============================================================
   DATABASE
   ============================================================ */

USE [olist_synapse_db];
GO


/* ============================================================
   3. CUSTOMER 360
   Source View:
       customer.vw_customer_360

   External Table:
       customer.ext_customer_360

   ADLS Output:
       customer/vw_customer_360.parquet/
   ============================================================ */


/* ------------------------------------------------------------
   DROP EXISTING EXTERNAL TABLE
   ------------------------------------------------------------ */

IF EXISTS
(
    SELECT 1
    FROM sys.external_tables
    WHERE name = 'ext_customer_360'
      AND schema_id = SCHEMA_ID('customer')
)
BEGIN
    DROP EXTERNAL TABLE [customer].[ext_customer_360];
END;
GO


/* ------------------------------------------------------------
   CREATE EXTERNAL DATA SOURCE IF IT DOES NOT EXIST
   ------------------------------------------------------------ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.external_data_sources
    WHERE name = 'customer_vw_customer_360_file'
)
BEGIN

    CREATE EXTERNAL DATA SOURCE [customer_vw_customer_360_file]
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

CREATE EXTERNAL TABLE [customer].[ext_customer_360]
WITH
(
    LOCATION = 'customer/vw_customer_360.parquet/',
    DATA_SOURCE = [customer_vw_customer_360_file],
    FILE_FORMAT = [external_file_format]
)
AS
SELECT *
FROM [customer].[vw_customer_360];
GO


