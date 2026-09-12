# Olist End-to-End Azure Data Engineering Project

## Project Overview

This project implements an end-to-end data engineering pipeline
using the Brazilian Olist e-commerce dataset.

The solution demonstrates data ingestion, data lake storage,
distributed processing, data transformation, data enrichment,
data warehousing and BI consumption.

## Architecture

Data Sources -> Azure Data Factory -> ADLS Gen2 - Raw Layer -> Azure Databricks -> PySpark Transformation -> ADLS Gen2 - Transformed Layer -> Azure Synapse -> Power BI / Tableau / Fabric
