/* ============================================================
   DASHBOARD 5 - CUSTOMER EXPERIENCE & COMMERCIAL

   VIEW:
       commercial.vw_geographical_performance

   GRAIN:
       Customer state

   PURPOSE:
       Regional sales, customer and logistics performance.
   ============================================================ */

USE olist_synapse_db;
GO;

CREATE OR ALTER VIEW commercial.vw_geographical_performance
AS

SELECT

    customer_state,

    COUNT(DISTINCT customer_unique_id)
        AS total_customers,

    COUNT(DISTINCT order_id)
        AS total_orders,

    COUNT(DISTINCT seller_id)
        AS active_sellers,

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

    CAST
    (
        SUM(
            TRY_CAST(price AS DECIMAL(18,2))
            +
            TRY_CAST(freight_value AS DECIMAL(18,2))
        )
        /
        NULLIF(COUNT(DISTINCT order_id), 0)
        AS DECIMAL(18,2)
    )
        AS average_order_value,

    AVG(
        TRY_CAST(review_score AS DECIMAL(10,2))
    )
        AS average_review_score,

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
        AS average_delivery_delay_days,

    CAST
    (
        SUM
        (
            CASE
                WHEN
                    is_delivered = 1
                    AND delivery_delay_time_in_days <= 0
                THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        NULLIF
        (
            SUM
            (
                CASE
                    WHEN is_delivered = 1
                    THEN 1
                    ELSE 0
                END
            ),
            0
        )
        AS DECIMAL(10,2)
    )
        AS on_time_delivery_percentage

FROM dbo.olist_complete_data

GROUP BY customer_state;