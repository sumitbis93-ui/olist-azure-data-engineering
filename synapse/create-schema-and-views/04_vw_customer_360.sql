/* ============================================================
   DASHBOARD 2 - CUSTOMER ANALYTICS

   VIEW:
       customer.vw_customer_360

   GRAIN:
       One row per customer_unique_id

   PURPOSE:
       Customer 360, customer value and repeat purchasing.
   ============================================================ */

USE olist_synapse_db;
GO;

CREATE OR ALTER VIEW customer.vw_customer_360
AS

WITH customer_orders AS
(
    SELECT

        customer_unique_id,

        COUNT(DISTINCT order_id)
            AS total_orders,

        MIN(order_purchase_timestamp)
            AS first_order_date,

        MAX(order_purchase_timestamp)
            AS last_order_date,

        COUNT
        (
            DISTINCT
            CASE
                WHEN is_delivered = 1
                THEN order_id
            END
        )
            AS delivered_orders,

        COUNT
        (
            DISTINCT
            CASE
                WHEN is_canceled = 1
                THEN order_id
            END
        )
            AS cancelled_orders,

        MAX(customer_city)
            AS customer_city,

        MAX(customer_state)
            AS customer_state

    FROM dbo.olist_complete_data

    WHERE customer_unique_id IS NOT NULL

    GROUP BY customer_unique_id
),

customer_value AS
(
    SELECT

        customer_unique_id,

        SUM(
            TRY_CAST(price AS DECIMAL(18,2))
        )
            AS total_product_spend,

        SUM(
            TRY_CAST(freight_value AS DECIMAL(18,2))
        )
            AS total_freight_spend,

        SUM(
            TRY_CAST(price AS DECIMAL(18,2))
            +
            TRY_CAST(freight_value AS DECIMAL(18,2))
        )
            AS total_customer_value

    FROM dbo.olist_complete_data

    WHERE customer_unique_id IS NOT NULL

    GROUP BY customer_unique_id
)

SELECT

    o.customer_unique_id,

    o.customer_city,

    o.customer_state,

    o.first_order_date,

    o.last_order_date,

    o.total_orders,

    o.delivered_orders,

    o.cancelled_orders,

    CASE
        WHEN o.total_orders > 1
        THEN 1
        ELSE 0
    END
        AS is_repeat_customer,

    v.total_product_spend,

    v.total_freight_spend,

    v.total_customer_value,

    CAST
    (
        v.total_customer_value
        /
        NULLIF(o.total_orders, 0)
        AS DECIMAL(18,2)
    )
        AS average_order_value,

    CASE

        WHEN o.total_orders >= 5
            THEN 'Very High Frequency'

        WHEN o.total_orders >= 3
            THEN 'High Frequency'

        WHEN o.total_orders = 2
            THEN 'Repeat Customer'

        ELSE 'One-Time Customer'

    END
        AS purchase_frequency_segment,

    CASE

        WHEN v.total_customer_value >= 1000
            THEN 'High Value'

        WHEN v.total_customer_value >= 500
            THEN 'Medium Value'

        ELSE 'Low Value'

    END
        AS customer_value_segment,

    CASE

        WHEN o.total_orders = 1
            THEN 'One-Time Customer'

        WHEN o.total_orders BETWEEN 2 AND 3
            THEN 'Repeat Customer'

        ELSE 'Loyal Customer'

    END
        AS customer_lifecycle_segment

FROM customer_orders o

INNER JOIN customer_value v

    ON o.customer_unique_id =
       v.customer_unique_id;