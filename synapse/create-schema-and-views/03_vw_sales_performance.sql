/* ============================================================
   DASHBOARD 1 - EXECUTIVE OVERVIEW

   VIEW:
       sales.vw_sales_performance

   GRAIN:
       One row per month

   PURPOSE:
       Executive sales and marketplace performance.
   ============================================================ */

USE olist_synapse_db;
GO;

CREATE OR ALTER VIEW sales.vw_sales_performance
AS

WITH order_level AS
(
    SELECT
        order_id,
        MAX(customer_unique_id) AS customer_unique_id,
        MAX(order_status) AS order_status,
        MAX(is_delivered) AS is_delivered,
        MAX(is_canceled) AS is_canceled,
        MAX(order_purchase_timestamp) AS order_purchase_timestamp
    FROM dbo.olist_complete_data
    GROUP BY order_id
),

order_items AS
(
    SELECT
        order_id,

        SUM(
            TRY_CAST(price AS DECIMAL(18,2))
        ) AS product_revenue,

        SUM(
            TRY_CAST(freight_value AS DECIMAL(18,2))
        ) AS freight_value,

        COUNT(*) AS item_count

    FROM dbo.olist_complete_data
    GROUP BY order_id
)

SELECT

    YEAR(o.order_purchase_timestamp) AS order_year,

    MONTH(o.order_purchase_timestamp) AS order_month,

    CAST(
        DATEFROMPARTS
        (
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        )
        AS DATE
    ) AS month_start_date,

    COUNT(DISTINCT o.order_id)
        AS total_orders,

    COUNT(DISTINCT o.customer_unique_id)
        AS total_customers,

    SUM(i.item_count)
        AS total_items,

    SUM(i.product_revenue)
        AS total_product_revenue,

    SUM(i.freight_value)
        AS total_freight_value,

    SUM(
        i.product_revenue + i.freight_value
    )
        AS total_sales_value,

    CAST
    (
        SUM(
            i.product_revenue + i.freight_value
        )
        /
        NULLIF(COUNT(DISTINCT o.order_id), 0)
        AS DECIMAL(18,2)
    )
        AS average_order_value,

    COUNT
    (
        DISTINCT
        CASE
            WHEN o.is_delivered = 1
            THEN o.order_id
        END
    )
        AS delivered_orders,

    COUNT
    (
        DISTINCT
        CASE
            WHEN o.is_canceled = 1
            THEN o.order_id
        END
    )
        AS cancelled_orders,

    CAST
    (
        COUNT
        (
            DISTINCT
            CASE
                WHEN o.is_canceled = 1
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(COUNT(DISTINCT o.order_id), 0)
        AS DECIMAL(10,2)
    )
        AS cancellation_rate_percentage

FROM order_level o

INNER JOIN order_items i
    ON o.order_id = i.order_id

GROUP BY

    YEAR(o.order_purchase_timestamp),

    MONTH(o.order_purchase_timestamp),

    DATEFROMPARTS
    (
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp),
        1
    );