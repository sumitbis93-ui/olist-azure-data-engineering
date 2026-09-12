/* ============================================================
   DASHBOARD 4 - LOGISTICS & OPERATIONS

   VIEW:
       operations.vw_order_operational_risk

   GRAIN:
       One row per order

   PURPOSE:
       Identify orders with cancellation,
       delivery and customer-experience risk.
   ============================================================ */

USE olist_synapse_db;
GO;

CREATE OR ALTER VIEW operations.vw_order_operational_risk
AS

WITH order_level AS
(
    SELECT

        order_id,

        MAX(seller_id)
            AS seller_id,

        MAX(customer_id)
            AS customer_id,

        MAX(customer_state)
            AS customer_state,

        MAX(seller_state)
            AS seller_state,

        MAX(product_category_name_english)
            AS product_category,

        MAX(order_status)
            AS order_status,

        MAX(is_canceled)
            AS is_canceled,

        MAX(is_delivered)
            AS is_delivered,

        MAX(
            TRY_CAST(
                delivery_delay_time_in_days AS INT
            )
        )
            AS delivery_delay_days,

        MAX(
            TRY_CAST(
                review_score AS INT
            )
        )
            AS review_score,

        SUM(
            TRY_CAST(price AS DECIMAL(18,2))
        )
            AS order_product_value,

        SUM(
            TRY_CAST(freight_value AS DECIMAL(18,2))
        )
            AS order_freight_value

    FROM dbo.olist_complete_data

    GROUP BY order_id
)

SELECT

    order_id,

    seller_id,

    customer_id,

    customer_state,

    seller_state,

    product_category,

    order_status,

    order_product_value,

    order_freight_value,

    delivery_delay_days,

    review_score,

    CASE
        WHEN is_canceled = 1
        THEN 1
        ELSE 0
    END
        AS cancellation_risk_flag,

    CASE
        WHEN delivery_delay_days > 7
        THEN 1
        ELSE 0
    END
        AS severe_delivery_risk_flag,

    CASE
        WHEN review_score <= 2
        THEN 1
        ELSE 0
    END
        AS customer_experience_risk_flag,

    (
        CASE
            WHEN is_canceled = 1
            THEN 1 ELSE 0
        END
        +
        CASE
            WHEN delivery_delay_days > 7
            THEN 1 ELSE 0
        END
        +
        CASE
            WHEN review_score <= 2
            THEN 1 ELSE 0
        END
    )
        AS operational_risk_score,

    CASE

        WHEN is_canceled = 1
            THEN 'Critical'

        WHEN
            delivery_delay_days > 7
            AND review_score <= 2
            THEN 'Critical'

        WHEN
            delivery_delay_days > 7
            OR review_score <= 2
            THEN 'High'

        WHEN
            delivery_delay_days > 3
            THEN 'Medium'

        ELSE 'Low'

    END
        AS operational_risk_category

FROM order_level;