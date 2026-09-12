USE olist_synapse_db;
GO;

SELECT
    delivery_performance_category,
    COUNT(*) AS order_count
FROM operations.vw_delivery_performance
GROUP BY delivery_performance_category
ORDER BY order_count DESC;