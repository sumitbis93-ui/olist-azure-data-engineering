/* ============================================================
   DASHBOARD 3 - PRODUCT & SELLER ANALYTICS

   VIEW:
       marketplace.vw_seller_performance

   GRAIN:
       One row per seller

   PURPOSE:
       Seller revenue, customer experience and operational
       performance.
   ============================================================ */

USE olist_synapse_db;
GO;

CREATE OR ALTER VIEW marketplace.vw_seller_performance
AS

WITH seller_orders AS
(
    SELECT

        seller_id,

        order_id,

        MAX(is_delivered)
            AS is_delivered,

        MAX(is_canceled)
            AS is_canceled,

        MAX(
            TRY_CAST(
                delivery_delay_time_in_days AS FLOAT
            )
        )
            AS delivery_delay_days,

        MAX(
            TRY_CAST(review_score AS DECIMAL(10,2))
        )
            AS review_score

    FROM dbo.olist_complete_data

    WHERE seller_id IS NOT NULL

    GROUP BY
        seller_id,
        order_id
),

seller_sales AS
(
    SELECT

        seller_id,

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

        AVG(
            TRY_CAST(price AS DECIMAL(18,2))
        )
            AS average_item_price,

        MAX(seller_city)
            AS seller_city,

        MAX(seller_state)
            AS seller_state

    FROM dbo.olist_complete_data

    WHERE seller_id IS NOT NULL

    GROUP BY seller_id
)

SELECT

    s.seller_id,

    s.seller_city,

    s.seller_state,

    s.total_orders,

    s.total_items_sold,

    s.total_product_revenue,

    s.total_freight_value,

    s.total_product_revenue
        + s.total_freight_value
        AS total_sales_value,

    s.average_item_price,

    AVG(o.review_score)
        AS average_review_score,

    SUM(
        CASE
            WHEN o.review_score <= 2
            THEN 1 ELSE 0
        END
    )
        AS negative_reviews,

    AVG(o.delivery_delay_days)
        AS average_delivery_delay_days,

    CAST
    (
        SUM
        (
            CASE
                WHEN o.is_delivered = 1
                     AND o.delivery_delay_days <= 0
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
                    WHEN o.is_delivered = 1
                    THEN 1
                    ELSE 0
                END
            ),
            0
        )
        AS DECIMAL(10,2)
    )
        AS on_time_delivery_percentage,

    CAST
    (
        SUM
        (
            CASE
                WHEN o.is_canceled = 1
                THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        NULLIF(s.total_orders, 0)
        AS DECIMAL(10,2)
    )
        AS cancellation_rate_percentage,

    CASE

        WHEN
            AVG(o.review_score) >= 4
            AND AVG(o.delivery_delay_days) <= 0
        THEN 'High Performer'

        WHEN
            AVG(o.review_score) >= 4
            AND AVG(o.delivery_delay_days) > 0
        THEN 'Good Seller - Delivery Risk'

        WHEN
            AVG(o.review_score) < 4
            AND AVG(o.delivery_delay_days) <= 0
        THEN 'Good Logistics - CX Risk'

        ELSE 'Underperforming Seller'

    END
        AS seller_performance_segment

FROM seller_sales s

INNER JOIN seller_orders o

    ON s.seller_id = o.seller_id

GROUP BY

    s.seller_id,
    s.seller_city,
    s.seller_state,
    s.total_orders,
    s.total_items_sold,
    s.total_product_revenue,
    s.total_freight_value,
    s.average_item_price;