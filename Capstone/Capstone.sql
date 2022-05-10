-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Hayden French (hmf9kx) Capstone Project

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Overview
-- MAGIC 
-- MAGIC At this point, we have exported all of our dimension data as json files. We will now load those into databricks, clean them, and join them into a fact table. We can then export that table into excel to create visualizations.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC If you are following along, please upload the following files to "/FileStore/tables/":
-- MAGIC 
-- MAGIC   -date.json <br>
-- MAGIC   -products.json <br>
-- MAGIC   -sales_reps.json <br>
-- MAGIC   -transactions.json

-- COMMAND ----------

-- MAGIC %python
-- MAGIC 
-- MAGIC # Using spark to create dataframes from our imported json files
-- MAGIC 
-- MAGIC df_date = spark.read.format("json").load("/FileStore/tables/date.json").select('date_key', 'full_date', 'date_name', 'date_name_us', 'date_name_eu', 'day_of_week', 'day_name_of_week', 'day_of_month', 'day_of_year', 'weekday_weekend', 'week_of_year', 'month_name', 'month_of_year', 'is_last_day_of_month', 'calendar_quarter', 'calendar_year', 'calendar_year_month', 'calendar_year_qtr', 'fiscal_month_of_year', 'fiscal_quarter', 'fiscal_year', 'fiscal_year_month', 'fiscal_year_qtr')
-- MAGIC 
-- MAGIC df_products = spark.read.format("json").load("/FileStore/tables/products.json").select('product_key', 'name', 'price', 'in_stock')
-- MAGIC 
-- MAGIC df_sales_reps = spark.read.format("json").load("/FileStore/tables/sales_reps.json").select('sales_rep_key', 'first_name', 'last_name', 'job_title', 'team', 'email', 'phone_number')
-- MAGIC 
-- MAGIC df_transactions = spark.read.format("json").load("/FileStore/tables/transactions.json").select('transaction_id', 'product_id', 'sales_rep_id', 'quantity', 'date')

-- COMMAND ----------

-- MAGIC %python
-- MAGIC 
-- MAGIC # Verifying that our databases were created properly
-- MAGIC 
-- MAGIC display(df_date)
-- MAGIC display(df_products)
-- MAGIC display(df_sales_reps)
-- MAGIC display(df_transactions)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC 
-- MAGIC # Creating local tables from dataframes for use with SQL
-- MAGIC 
-- MAGIC df_date.createOrReplaceTempView("date")
-- MAGIC df_products.createOrReplaceTempView("products")
-- MAGIC df_sales_reps.createOrReplaceTempView("sales_reps")
-- MAGIC df_transactions.createOrReplaceTempView("transactions")

-- COMMAND ----------

--Creating fact_orders table with relevant information for each transaction--

CREATE TABLE `fact_orders` (
	`fact_key` int,
    `product_id` int,
    `sales_rep_id` int,
    `product_name` varchar(50),
    `quantity` int,
    `price` int,
    `profit` int,
    `date` DATE,
    `sales_rep_lname` varchar(50),
    `sales_rep_job_title` varchar(50),
    `sales_team` varchar(1)
);

-- COMMAND ----------

--Populating fact_orders table. Note that we take advantage of our date dimension by using a date datatype (instead of a string e.g.) and create a new profit column--

INSERT INTO `fact_orders`
(`fact_key`,
`product_id`,
`sales_rep_id`,
`product_name`,
`quantity`,
`price`,
`profit`,
`date`,
`sales_rep_lname`,
`sales_rep_job_title`,
`sales_team`)
SELECT `t`.`transaction_id`,
`p`.`product_key`,
`s`.`sales_rep_key`,
`p`.`name`,
`t`.`quantity`,
`p`.`price`,
`t`.`quantity` * `p`.`price`,
date(`d`.`full_date`),
`s`.`last_name`,
`s`.`job_title`,
`s`.`team`

FROM `transactions` AS `t`
LEFT JOIN `products` AS `p`
ON `t`.`product_id`=`p`.`product_key`
LEFT JOIN `sales_reps` AS `s`
ON `t`.`sales_rep_id`=`s`.`sales_rep_key`
LEFT JOIN `date` AS `d`
ON `t`.`date`=`d`.`date_name`

-- COMMAND ----------

SELECT * FROM `fact_orders`
ORDER BY `date`

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 
-- MAGIC We now have our completed fact table ready for analysis. Please see "export.csv" for the raw export and "visualizations.xlsx" for the Excel Spreadsheet with visualizations.
