/* ============================================================
   OLIST BIG DATA ENGINEERING PROJECT
   SYNAPSE SERVING LAYER - CETAS SETUP
   ============================================================

   Database:
       olist_synapse_db
 
   Purpose:
       1. Create Database Master Key
       2. Create Managed Identity credential
       3. Create Parquet external file format

   IMPORTANT:
       The Master Key password is NOT a Managed Identity password.
       It protects the database-scoped credential.
   ============================================================ */


USE [olist_synapse_db];
GO


/* ============================================================
   STEP 1: CREATE DATABASE MASTER KEY
   ============================================================

   Replace the placeholder with your secure password.

   Do NOT store the production password in source control.
   ============================================================ */

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Sunny_sqluser@93#';
GO


/* ============================================================
   STEP 2: CREATE DATABASE SCOPED CREDENTIAL
   ============================================================

   Managed Identity authentication is used.

   Credential name:
       synapsesqladminuser
   ============================================================ */

CREATE DATABASE SCOPED CREDENTIAL [synapsesqladminuser]
WITH IDENTITY = 'Managed Identity';
GO


/* ============================================================
   STEP 3: CREATE EXTERNAL FILE FORMAT
   ============================================================

   Output format:
       Parquet

   Compression:
       Snappy
   ============================================================ */

CREATE EXTERNAL FILE FORMAT [external_file_format]
WITH
(
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
);
GO
