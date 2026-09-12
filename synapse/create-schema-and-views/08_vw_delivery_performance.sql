/* ============================================================
   DASHBOARD 4 - LOGISTICS & OPERATIONS

   VIEW:
       operations.vw_delivery_performance

   GRAIN:
       One row per order

   PURPOSE:
       Delivery SLA and logistics performance.
   ============================================================ */

USE olist_synapse_db;
GO;

CREATE OR ALTER VIEW operations.vw_delivery_performance
AS

SELECT

    order_id,

    MAX(customer_id)
        AS customer_id,

    MAX(seller_id)
        AS seller_id,

    MAX(customer_state)
        AS customer_state,

    MAX(seller_state)
        AS seller_state,

    MAX(order_status)
        AS order_status,

    MAX(order_purchase_timestamp)
        AS order_purchase_timestamp,

    MAX(order_approved_at)
        AS order_approved_at,

    MAX(order_delivered_carrier_date)
        AS order_delivered_carrier_date,

    MAX(order_delivered_customer_date)
        AS order_delivered_customer_date,

    MAX(order_estimated_delivery_date)
        AS order_estimated_delivery_date,

    MAX(
        TRY_CAST(
            actual_delivery_time_taken AS INT
        )
    )
        AS actual_delivery_time_taken,

    MAX(
        TRY_CAST(
            estimated_delivery_time_taken AS INT
        )
    )
        AS estimated_delivery_time_taken,

    MAX(
        TRY_CAST(
            delivery_delay_time_in_days AS INT
        )
    )
        AS delivery_delay_time_in_days,

    MAX(is_delivered)
        AS is_delivered,

    MAX(is_canceled)
        AS is_canceled,

    CASE

        WHEN MAX(is_canceled) = 1
            THEN 'Cancelled'

        WHEN MAX(is_delivered) = 0
            THEN 'Not Delivered'

        WHEN MAX(delivery_delay_time_in_days) < 0
            THEN 'Early'

        WHEN MAX(delivery_delay_time_in_days) = 0
            THEN 'On Time'

        WHEN MAX(delivery_delay_time_in_days) <= 3
            THEN 'Slightly Late'

        WHEN MAX(delivery_delay_time_in_days) <= 7
            THEN 'Moderately Late'

        ELSE 'Severely Late'

    END
        AS delivery_performance_category,

    CASE

        WHEN
            MAX(is_delivered) = 1
            AND MAX(delivery_delay_time_in_days) <= 0
        THEN 1

        ELSE 0

    END
        AS is_on_time_delivery

FROM dbo.olist_complete_data

GROUP BY order_id;