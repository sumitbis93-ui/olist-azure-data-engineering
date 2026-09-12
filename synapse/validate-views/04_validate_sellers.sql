USE olist_synapse_db;
GO;

SELECT TOP 20
    seller_id,
    total_orders,
    total_sales_value,
    average_review_score,
    on_time_delivery_percentage,
    seller_performance_segment
FROM marketplace.vw_seller_performance
ORDER BY total_sales_value DESC;