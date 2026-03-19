CREATE WAREHOUSE emp_wh
WITH WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 300
AUTO_RESUME = TRUE;

USE WAREHOUSE emp_wh;

CREATE DATABASE emp_db;
USE DATABASE emp_db;

CREATE SCHEMA emp_schema;
USE SCHEMA emp_schema;

CREATE TABLE customers (
customer_id INT,
customer_name STRING,
city STRING
);

CREATE TABLE orders (
order_id INT,
customer_id INT,
order_date DATE,
amount INT
);

INSERT INTO customers VALUES
(1,'Ali','Karachi'),
(2,'Sara','Lahore'),
(3,'Ahmed','Karachi');

INSERT INTO orders VALUES
(1,1,'2024-01-01',1200),
(2,2,'2024-01-02',900),
(3,1,'2024-01-03',1500),
(4,3,'2024-01-04',800);

-- JOIN DATA

SELECT c.customer_name,
o.order_date,
o.amount
FROM customers c
JOIN  orders o
ON c.customer_id = o.customer_id;


-- Total Sales per Customer

SELECT 
c.customer_name,
SUM(o.amount) AS total_sales
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name;


-- Running Total (Window Function)

SELECT 
order_date,
amount,
SUM(amount) OVER(ORDER BY order_date) AS running_total
FROM orders;


-- CTE
 
WITH customer_sales AS (
SELECT 
customer_id,
SUM(amount) AS total
FROM orders
GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total > 1000;