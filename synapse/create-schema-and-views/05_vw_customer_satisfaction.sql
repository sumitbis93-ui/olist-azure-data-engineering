/* ============================================================
   DASHBOARD 2 - CUSTOMER ANALYTICS

   VIEW:
       customer.vw_customer_satisfaction

   GRAIN:
       One row per customer

   PURPOSE:
       Customer satisfaction and delivery experience.
   ============================================================ */

USE olist_synapse_db;
GO;

CREATE OR ALTER VIEW customer.vw_customer_satisfaction
AS

WITH reviews AS
(
    SELECT

        customer_unique_id,

        COUNT(DISTINCT review_id)
            AS total_reviews,

        AVG(
            TRY_CAST(review_score AS DECIMAL(10,2))
        )
            AS average_review_score,

        SUM(
            CASE
                WHEN TRY_CAST(review_score AS INT) = 1
                THEN 1 ELSE 0
            END
        )
            AS one_star_reviews,

        SUM(
            CASE
                WHEN TRY_CAST(review_score AS INT) = 2
                THEN 1 ELSE 0
            END
        )
            AS two_star_reviews,

        SUM(
            CASE
                WHEN TRY_CAST(review_score AS INT) = 3
                THEN 1 ELSE 0
            END
        )
            AS three_star_reviews,

        SUM(
            CASE
                WHEN TRY_CAST(review_score AS INT) = 4
                THEN 1 ELSE 0
            END
        )
            AS four_star_reviews,

        SUM(
            CASE
                WHEN TRY_CAST(review_score AS INT) = 5
                THEN 1 ELSE 0
            END
        )
            AS five_star_reviews

    FROM dbo.olist_complete_data

    WHERE review_id IS NOT NULL

    GROUP BY customer_unique_id
),

delivery AS
(
    SELECT

        customer_unique_id,

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

    WHERE is_delivered = 1

    GROUP BY customer_unique_id
)

SELECT

    r.customer_unique_id,

    r.total_reviews,

    r.average_review_score,

    r.one_star_reviews,

    r.two_star_reviews,

    r.three_star_reviews,

    r.four_star_reviews,

    r.five_star_reviews,

    d.average_delivery_days,

    d.average_delivery_delay_days,

    CASE

        WHEN r.average_review_score >= 4
            THEN 'Satisfied'

        WHEN r.average_review_score = 3
            THEN 'Neutral'

        WHEN r.average_review_score < 3
            THEN 'Dissatisfied'

        ELSE 'Unknown'

    END
        AS satisfaction_segment,

    CASE

        WHEN d.average_delivery_delay_days <= 0
            THEN 'On Time / Early'

        WHEN d.average_delivery_delay_days <= 3
            THEN 'Slightly Late'

        WHEN d.average_delivery_delay_days <= 7
            THEN 'Moderately Late'

        ELSE 'Severely Late'

    END
        AS delivery_experience_segment

FROM reviews r

LEFT JOIN delivery d

    ON r.customer_unique_id =
       d.customer_unique_id;