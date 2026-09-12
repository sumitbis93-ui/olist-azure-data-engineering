USE olist_synapse_db;
GO;

SELECT
    operational_risk_category,
    COUNT(*) AS order_count
FROM operations.vw_order_operational_risk
GROUP BY operational_risk_category
ORDER BY
    CASE operational_risk_category
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
    END;