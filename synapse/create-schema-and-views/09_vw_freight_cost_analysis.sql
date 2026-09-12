/* ============================================================
   DASHBOARD 4 - LOGISTICS & OPERATIONS

   VIEW:
       operations.vw_freight_cost_analysis

   GRAIN:
       Product category

   PURPOSE:
       Analyze shipping/freight burden.
   ============================================================ */

USE olist_synapse_db;
GO;

CREATE OR ALTER VIEW operations.vw_freight_cost_analysis
AS

SELECT

    product_category_name_english,

    COUNT(DISTINCT order_id)
        AS total_orders,

    COUNT(*)
        AS total_items,

    SUM(
        TRY_CAST(price AS DECIMAL(18,2))
    )
        AS total_product_value,

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
        AS freight_percentage_of_product_value,

    CAST
    (
        SUM(
            TRY_CAST(freight_value AS DECIMAL(18,2))
        )
        /
        NULLIF(COUNT(DISTINCT order_id), 0)
        AS DECIMAL(18,2)
    )
        AS average_freight_per_order,

    AVG(
        TRY_CAST(
            actual_delivery_time_taken AS FLOAT
        )
    )
        AS average_delivery_days,

    AVG(
        TRY_CAST(
            delivery_delay_time_in_days AS FLOAT
        )
    )
        AS average_delivery_delay_days

FROM dbo.olist_complete_data

GROUP BY
    product_category_name_english;