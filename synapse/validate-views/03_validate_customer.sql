USE olist_synapse_db;
GO;

SELECT TOP 20 *
FROM customer.vw_customer_360
ORDER BY total_customer_value DESC;