USE [olist_synapse_db];
GO


SELECT
    'sales.vw_sales_performance' AS dataset,
    (SELECT COUNT(*)
     FROM [sales].[vw_sales_performance]) AS view_count,
    (SELECT COUNT(*)
     FROM [sales].[ext_sales_performance]) AS cetas_count;


SELECT
    'sales.vw_product_category_performance' AS dataset,
    (SELECT COUNT(*)
     FROM [sales].[vw_product_category_performance]) AS view_count,
    (SELECT COUNT(*)
     FROM [sales].[ext_product_category_performance]) AS cetas_count;


SELECT
    'customer.vw_customer_360' AS dataset,
    (SELECT COUNT(*)
     FROM [customer].[vw_customer_360]) AS view_count,
    (SELECT COUNT(*)
     FROM [customer].[ext_customer_360]) AS cetas_count;


SELECT
    'customer.vw_customer_satisfaction' AS dataset,
    (SELECT COUNT(*)
     FROM [customer].[vw_customer_satisfaction]) AS view_count,
    (SELECT COUNT(*)
     FROM [customer].[ext_customer_satisfaction]) AS cetas_count;


SELECT
    'marketplace.vw_seller_performance' AS dataset,
    (SELECT COUNT(*)
     FROM [marketplace].[vw_seller_performance]) AS view_count,
    (SELECT COUNT(*)
     FROM [marketplace].[ext_seller_performance]) AS cetas_count;


SELECT
    'operations.vw_delivery_performance' AS dataset,
    (SELECT COUNT(*)
     FROM [operations].[vw_delivery_performance]) AS view_count,
    (SELECT COUNT(*)
     FROM [operations].[ext_delivery_performance]) AS cetas_count;


SELECT
    'operations.vw_freight_cost_analysis' AS dataset,
    (SELECT COUNT(*)
     FROM [operations].[vw_freight_cost_analysis]) AS view_count,
    (SELECT COUNT(*)
     FROM [operations].[ext_freight_cost_analysis]) AS cetas_count;


SELECT
    'operations.vw_order_operational_risk' AS dataset,
    (SELECT COUNT(*)
     FROM [operations].[vw_order_operational_risk]) AS view_count,
    (SELECT COUNT(*)
     FROM [operations].[ext_order_operational_risk]) AS cetas_count;


SELECT
    'commercial.vw_geographical_performance' AS dataset,
    (SELECT COUNT(*)
     FROM [commercial].[vw_geographical_performance]) AS view_count,
    (SELECT COUNT(*)
     FROM [commercial].[ext_geographical_performance]) AS cetas_count;


SELECT
    'commercial.vw_payment_behavior' AS dataset,
    (SELECT COUNT(*)
     FROM [commercial].[vw_payment_behavior]) AS view_count,
    (SELECT COUNT(*)
     FROM [commercial].[ext_payment_behavior]) AS cetas_count;
GO
