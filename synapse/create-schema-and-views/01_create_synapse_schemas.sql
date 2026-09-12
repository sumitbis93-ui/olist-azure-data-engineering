/* ============================================================
   OLIST PROJECT
   SYNAPSE SERVING LAYER
   STEP 1 - CREATE BUSINESS DOMAIN SCHEMAS
   ============================================================ */

USE olist_synapse_db;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'sales'
)
BEGIN
    EXEC('CREATE SCHEMA sales');
END;


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'customer'
)
BEGIN
    EXEC('CREATE SCHEMA customer');
END;


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'marketplace'
)
BEGIN
    EXEC('CREATE SCHEMA marketplace');
END;


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'operations'
)
BEGIN
    EXEC('CREATE SCHEMA operations');
END;


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'commercial'
)
BEGIN
    EXEC('CREATE SCHEMA commercial');
END;