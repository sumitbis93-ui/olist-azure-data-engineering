USE olist_synapse_db;
GO;


SELECT TOP 100 *
FROM sales.vw_sales_performance
ORDER BY month_start_date;


SELECT
    SUM(total_orders) AS total_orders,
    SUM(total_product_revenue) AS total_product_revenue,
    SUM(total_freight_value) AS total_freight
FROM sales.vw_sales_performance;