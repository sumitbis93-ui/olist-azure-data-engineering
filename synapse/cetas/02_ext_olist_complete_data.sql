/* ============================================================
   1. OLIST COMPLETE DATA
   ============================================================ */

USE [olist_synapse_db];
GO


/* ============================================================
   STEP 1: DROP EXISTING EXTERNAL TABLE
   ============================================================ */

IF EXISTS
(
    SELECT 1
    FROM sys.external_tables
    WHERE name = 'ext_olist_complete_data'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    DROP EXTERNAL TABLE [dbo].[ext_olist_complete_data];
END;
GO


/* ============================================================
   STEP 2: CREATE EXTERNAL DATA SOURCE
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.external_data_sources
    WHERE name = 'olist_complete_data_file'
)
BEGIN

    CREATE EXTERNAL DATA SOURCE [olist_complete_data_file]
    WITH
    (
        LOCATION =
            'https://ecommoliststorageaccount.blob.core.windows.net/olistdata/gold/served_data',
        CREDENTIAL = [synapsesqladminuser]
    );

END;
GO


/* ============================================================
   STEP 3: CREATE EXTERNAL TABLE USING CETAS
   ============================================================ */

CREATE EXTERNAL TABLE [dbo].[ext_olist_complete_data]
WITH
(
    LOCATION = 'olist/olist_complete_data.parquet/',
    DATA_SOURCE = [olist_complete_data_file],
    FILE_FORMAT = [external_file_format]
)
AS
SELECT [order_id]
,[seller_id]
,[customer_id]
,[product_id]
,[order_status]
,[is_shipped]
,[is_canceled]
,[is_delivered]
,[order_purchase_timestamp]
,[order_approved_at]
,[order_delivered_carrier_date]
,[order_delivered_customer_date]
,[order_estimated_delivery_date]
,[actual_delivery_time_taken]
,[estimated_delivery_time_taken]
,[delivery_delay_time_in_days]
,[order_item_id]
,[shipping_limit_date]
,[price]
,[freight_value]
,[product_category_name]
,[product_category_name_english]
,[product_name_lenght]
,[product_description_lenght]
,[product_photos_qty]
,[product_weight_g]
,[product_length_cm]
,[product_height_cm]
,[product_width_cm]
,[payment_records_count]
,CAST(payment_types AS VARCHAR(500)) AS payment_types_string
,[payment_installments]
,[total_payment_value]
,[customer_unique_id]
,[customer_zip_code_prefix]
,[customer_city]
,[customer_state]
,[geolocation_zip_code_prefix]
,[geolocation_lat]
,[geolocation_lng]
,[geolocation_city]
,[geolocation_state]
,[seller_zip_code_prefix]
,[seller_city]
,[seller_state]
,[review_id]
,[review_score]
,[review_comment_title]
,[review_comment_message]
,[review_creation_date]
,[review_answer_timestamp]
 FROM [dbo].[olist_complete_data];
GO
