/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [date]
      ,[datetime]
      ,[cash_type]
      ,[card]
      ,[money]
      ,[coffee_name]
  FROM [dataDB].[dbo].[raw_data_coffee]

  /*1   */


SELECT *
FROM [dataDB].[dbo].[raw_data_coffee]
WHERE ISNUMERIC(money) = 0 OR ISNUMERIC(card) = 0;

ALTER TABLE [dataDB].[dbo].[raw_data_coffee]
ALTER COLUMN [date] DATE;

SELECT SUM(money + card) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
/*       Total Sales (Cash + Card)   =37508.8799999998*/
SELECT SUM(TRY_CAST(money AS FLOAT)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee];
/*    Total Number of Transactions: 1133*/   
SELECT COUNT(*) AS total_transactions
FROM [dataDB].[dbo].[raw_data_coffee]
/* Average Sale Per Transaction: 33.1058075904676*/
SELECT AVG(TRY_CAST(money AS FLOAT)) AS avg_sale
FROM [dataDB].[dbo].[raw_data_coffee];
/*  Average Sales Per Transaction Across Different Days */
SELECT CONVERT(DATE, [date]) AS sale_date,
       AVG(ISNULL(TRY_CAST(money AS FLOAT), 0) + ISNULL(TRY_CAST(card AS FLOAT), 0)) AS avg_sales_per_day
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY CONVERT(DATE, [date]);
/* Average Sales Per Transaction Across Different Times:*/
SELECT DATEPART(HOUR, [datetime]) AS sale_hour,
       AVG(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS avg_sales_per_hour
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY DATEPART(HOUR, [datetime]);
/* Average Sales Per Transaction Across Different Coffee Types*/
SELECT coffee_name,
       AVG(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS avg_sales_per_coffee
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY coffee_name;
/*Identification of Peak Hours for Coffee Sales:*/
SELECT DATEPART(HOUR, [datetime]) AS sale_hour,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY DATEPART(HOUR, [datetime])
ORDER BY total_sales DESC;
/*Top-Selling Days for Coffee Sales:*/
SELECT DATENAME(WEEKDAY, [date]) AS sale_day,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY DATENAME(WEEKDAY, [date])
ORDER BY total_sales DESC;
/*7 */
SELECT coffee_name,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY coffee_name
ORDER BY total_sales DESC;
/*Week-on-Week Sales Growth*/
SELECT DATEPART(WEEK, [date]) AS week_number,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY DATEPART(WEEK, [date])
ORDER BY week_number;
/* Day-Specific Insights (Best Days for Sales) */
SELECT DATENAME(WEEKDAY, [date]) AS day_of_week,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY DATENAME(WEEKDAY, [date])
ORDER BY total_sales DESC;
/*Peak Coffee Sales During Weekends*/
SELECT DATENAME(WEEKDAY, [date]) AS day_of_week,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
WHERE DATENAME(WEEKDAY, [date]) IN ('Saturday', 'Sunday')
GROUP BY DATENAME(WEEKDAY, [date]);
/*Peak Coffee Sales During Weekdays*/
SELECT DATENAME(WEEKDAY, [date]) AS day_of_week,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
WHERE DATENAME(WEEKDAY, [date]) NOT IN ('Saturday', 'Sunday')
GROUP BY DATENAME(WEEKDAY, [date]);
/*Monthly Sales Trends*/
SELECT DATEPART(MONTH, [date]) AS month,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY DATEPART(MONTH, [date])
ORDER BY month;
/*Coffee Sales by Time of Day*/
SELECT DATEPART(HOUR, [datetime]) AS sale_hour,
       coffee_name,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY DATEPART(HOUR, [datetime]), coffee_name;
/*Day of Week Coffee Sales Performance*/
SELECT DATENAME(WEEKDAY, [date]) AS day_of_week,
       coffee_name,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY DATENAME(WEEKDAY, [date]), coffee_name;
/*Weekend vs. Weekday Coffee Preferences*/
SELECT CASE
         WHEN DATENAME(WEEKDAY, [date]) IN ('Saturday', 'Sunday') THEN 'Weekend'
         ELSE 'Weekday'
       END AS day_type,
       coffee_name,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY CASE
           WHEN DATENAME(WEEKDAY, [date]) IN ('Saturday', 'Sunday') THEN 'Weekend'
           ELSE 'Weekday'
         END, coffee_name;
/* Total Sales Per Hour by Coffee Type*/
SELECT DATEPART(HOUR, [datetime]) AS sale_hour,
       coffee_name,
       SUM(ISNULL(TRY_CAST(money AS FLOAT),0) + ISNULL(TRY_CAST(card AS FLOAT),0)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
GROUP BY DATEPART(HOUR, [datetime]), coffee_name;

/**/
SELECT CONVERT(DATE, [date]) AS sale_date,
       SUM(TRY_CAST(money AS FLOAT) + TRY_CAST(card AS FLOAT)) AS total_sales
FROM [dataDB].[dbo].[raw_data_coffee]
WHERE CONVERT(DATE, [date]) IN ('2024-01-01', '2024-12-25') -- Example: New Year's Day, Christmas
GROUP BY CONVERT(DATE, [date]);



















