/* ============================================================
   DASHBOARD 5 - CUSTOMER EXPERIENCE & COMMERCIAL

   VIEW:
       commercial.vw_payment_behavior

   GRAIN:
       Payment type / payment composition

   PURPOSE:
       Analyze payment preferences, transaction values
       and installment behavior.
   ============================================================ */

USE olist_synapse_db;
GO;

CREATE OR ALTER VIEW commercial.vw_payment_behavior
AS

WITH order_payment AS
(
    SELECT

        order_id,

        MAX(customer_unique_id)
            AS customer_unique_id,

        MAX(payment_types)
            AS payment_types,

        MAX(
            TRY_CAST(
                payment_installments AS INT
            )
        )
            AS payment_installments,

        MAX(
            TRY_CAST(
                total_payment_value AS DECIMAL(18,2)
            )
        )
            AS total_payment_value

    FROM dbo.olist_complete_data

    GROUP BY order_id
)

SELECT

    payment_types,

    COUNT(DISTINCT order_id)
        AS total_orders,

    COUNT(DISTINCT customer_unique_id)
        AS total_customers,

    SUM(total_payment_value)
        AS total_payment_value,

    AVG(total_payment_value)
        AS average_transaction_value,

    AVG(
        CAST(payment_installments AS FLOAT)
    )
        AS average_installments,

    MAX(payment_installments)
        AS maximum_installments,

    CAST
    (
        COUNT(DISTINCT order_id) * 100.0
        /
        SUM(
            COUNT(DISTINCT order_id)
        ) OVER ()
        AS DECIMAL(10,2)
    )
        AS payment_composition_share_percentage,

    CASE

        WHEN AVG(payment_installments) <= 1
            THEN 'Single Payment'

        WHEN AVG(payment_installments) <= 3
            THEN 'Short Term Installment'

        WHEN AVG(payment_installments) <= 6
            THEN 'Medium Term Installment'

        ELSE 'Long Term Installment'

    END
        AS installment_segment

FROM order_payment

GROUP BY payment_types;