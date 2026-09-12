/* ============================================================
   DASHBOARD 3 - PRODUCT & SELLER ANALYTICS

   VIEW:
       sales.vw_product_category_performance

   GRAIN:
       One row per product

   PURPOSE:
       Product and category performance.
   ============================================================ */

USE olist_synapse_db;
GO;

CREATE OR ALTER VIEW sales.vw_product_category_performance
AS

SELECT

    product_id,

    MAX(product_category_name)
        AS product_category_name,

    MAX(product_category_name_english)
        AS product_category_name_english,

    MAX(
        TRY_CAST(product_name_lenght AS INT)
    )
        AS product_name_length,

    MAX(
        TRY_CAST(product_description_lenght AS INT)
    )
        AS product_description_length,

    MAX(
        TRY_CAST(product_photos_qty AS INT)
    )
        AS product_photos_quantity,

    MAX(
        TRY_CAST(product_weight_g AS DECIMAL(18,2))
    )
        AS product_weight_g,

    MAX(
        TRY_CAST(product_length_cm AS DECIMAL(18,2))
    )
        AS product_length_cm,

    MAX(
        TRY_CAST(product_height_cm AS DECIMAL(18,2))
    )
        AS product_height_cm,

    MAX(
        TRY_CAST(product_width_cm AS DECIMAL(18,2))
    )
        AS product_width_cm,

    COUNT(DISTINCT order_id)
        AS total_orders,

    COUNT(*)
        AS total_items_sold,

    SUM(
        TRY_CAST(price AS DECIMAL(18,2))
    )
        AS total_product_revenue,

    SUM(
        TRY_CAST(freight_value AS DECIMAL(18,2))
    )
        AS total_freight_value,

    SUM(
        TRY_CAST(price AS DECIMAL(18,2))
        +
        TRY_CAST(freight_value AS DECIMAL(18,2))
    )
        AS total_sales_value,

    AVG(
        TRY_CAST(price AS DECIMAL(18,2))
    )
        AS average_product_price,

    AVG(
        TRY_CAST(freight_value AS DECIMAL(18,2))
    )
        AS average_freight_value,

    CAST
    (
        SUM(
            TRY_CAST(freight_value AS DECIMAL(18,2))
        ) * 100.0
        /
        NULLIF
        (
            SUM(
                TRY_CAST(price AS DECIMAL(18,2))
            ),
            0
        )
        AS DECIMAL(10,2)
    )
        AS freight_to_product_ratio_percentage,

    AVG(
        TRY_CAST(review_score AS DECIMAL(10,2))
    )
        AS average_review_score,

    AVG(
        TRY_CAST(
            delivery_delay_time_in_days AS FLOAT
        )
    )
        AS average_delivery_delay_days

FROM dbo.olist_complete_data

WHERE product_id IS NOT NULL

GROUP BY product_id;