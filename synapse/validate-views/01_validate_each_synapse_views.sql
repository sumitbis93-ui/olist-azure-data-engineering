USE olist_synapse_db;
GO;

SELECT
    SCHEMA_NAME(v.schema_id) AS schema_name,
    v.name AS view_name
FROM sys.views v
WHERE SCHEMA_NAME(v.schema_id) IN
(
    'sales',
    'customer',
    'marketplace',
    'operations',
    'commercial'
)
ORDER BY
    schema_name,
    view_name;