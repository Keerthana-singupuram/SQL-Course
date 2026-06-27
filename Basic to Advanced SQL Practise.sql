CREATE DATABASE Business;
SHOW DATABASES;
USE Business;


#BASIC SQL
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_name VARCHAR(50),
    unit_price DECIMAL(10,2)
);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE,
    total_price DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert into Products first
INSERT INTO Products (product_id, product_name, category_name, unit_price)
VALUES 
(101, 'Laptop', 'Electronics', 500.00),
(102, 'T-Shirt', 'Clothing', 300.00),
(103, 'Python Book', 'Books', 30.00),
(104, 'Mouse', 'Electronics', 20.00),
(105, 'Notebook', 'Stationery', 15.00);

-- Insert into Sales
INSERT INTO Sales (sale_id, product_id, quantity_sold, sale_date, total_price)
VALUES 
(1, 101, 5, '2024-01-01', 2500.00),
(2, 102, 3, '2024-01-02', 900.00),
(3, 103, 2, '2024-01-02', 60.00),
(4, 104, 4, '2024-01-03', 80.00),
(5, 105, 6, '2024-01-03', 90.00);

SELECT * FROM sales;
SELECT * FROM products;

DESC sales;
DESC products;

SELECT COUNT(*) FROM sales;
SELECT COUNT(DISTINCT sale_id) FROM sales;
SELECT DISTINCT sale_id, product_id FROM sales;

SELECT * FROM sales;
SELECT * FROM products;

SELECT * FROM sales WHERE product_id LIKE '1%';

INSERT INTO products VALUES(106,'Pen','Stationery',5.00);
INSERT INTO SALES VALUES(6,106,6,'2024-01-04',100.00);

SELECT * FROM sales WHERE quantity_sold = 6;

SELECT * FROM products WHERE category_name = 'Electronics' AND unit_price >=100.00;

SELECT * FROM sales WHERE total_price BETWEEN 500.00 AND 2500.00;

SELECT * FROM sales WHERE total_price IN(60.00,80.00,90.00,1000.00);

SELECT * FROM sales
WHERE sale_date = '2024-01-03'
GROUP BY sale_id
ORDER BY quantity_sold;

DELETE FROM sales WHERE quantity_sold = 6 AND product_id = 106;

SET SQL_SAFE_UPDATES = 1;

SELECT SUM(total_price) AS Revenue FROM sales;

SELECT product_name, AVG(unit_price) 
FROM products
GROUP BY product_name;

SELECT AVG(unit_price) AS Average_price
FROM products;

SELECT SUM(quantity_sold) FROM sales;

SELECT sale_date, COUNT(quantity_sold) FROM sales
GROUP BY sale_date;

SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 1;

SELECT sale_id,product_id,total_price
FROM sales
WHERE quantity_sold > 4;

SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC;

SELECT ROUND(SUM(total_price),2) AS Total_sale
FROM sales;

SELECT AVG(total_price) AS AVG_Total_Price
FROM sales;

#Calculate the total quantity_sold of products in the 'Electronics' category.
SELECT SUM(quantity_sold) FROM sales
LEFT JOIN products
ON sales.product_id = products.product_id
WHERE products.category_name= 'Electronics';

#Retrieve the product_name and total_price from the Sales table, calculating the total_price as quantity_sold multiplied by unit_price.
SELECT p.product_name, s.quantity_sold*p.unit_price AS total_price
FROM products p
LEFT JOIN sales s 
ON p.product_id = s.product_id;

#Identify the Most Frequently Sold Product from Sales table
SELECT product_id, SUM(quantity_sold) AS qty FROM sales
GROUP BY product_id
ORDER BY qty DESC
LIMIT 1;

#Find the Products Not Sold from Products table
SELECT * FROM sales;
SELECT * FROM products;

SELECT product_id, product_name FROM products 
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM sales);

#Calculate the total revenue generated from sales for each product category.
SELECT category_name, sum(total_price) FROM sales
LEFT JOIN products
ON sales.product_id = products.product_id
GROUP BY category_name;

#Find the product category with the highest average unit price.
SELECT category_name, AVG(unit_price) AS Average_price FROM products
GROUP BY category_name
ORDER BY Average_price DESC
LIMIT 1;

#INTERMEDIATE SQL
#Identify products with total sales exceeding 30.
SELECT p.product_name
FROM products p
JOIN sales s
ON p.product_id = s.product_id
GROUP BY p.product_name
HAVING sum(s.total_price) > 30;

#Count the number of sales made in each month.
SELECT DATE_FORMAT(s.sale_date,'%Y-%m') AS month, COUNT(*) AS sales_count
FROM sales s
GROUP BY month;

#Retrieve Sales Details for Products with 'book' in Their Name
SELECT p.product_id,p.product_name,s.quantity_sold,s.total_price 
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
WHERE p.product_name LIKE '%book%';

#Determine the average quantity sold for products with a unit price greater than $100.
SELECT AVG(quantity_sold) AS qty_sold
FROM sales s
LEFT JOIN products p
ON p.product_id = s.product_id
WHERE p.unit_price > 100;

#Retrieve the product name and total sales revenue for each product.
SELECT p.product_name,SUM(s.total_price)
FROM products p
LEFT JOIN sales s
ON p.product_id = s.product_id
GROUP BY product_name;

#List all sales along with the corresponding product names.
SELECT s.sale_id, p.product_name
FROM sales s
LEFT JOIN products p
ON s.product_id = s.product_id;

#Retrieve the product name and total sales revenue for each product.
SELECT p.category_name,
	   SUM(s.total_price) AS total_price,
       (SUM(s.total_price)/(SELECT SUM(s.total_price) FROM sales s)) * 100 AS revenue_percentage
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.category_name
ORDER BY revenue_percentage
DESC LIMIT 3;

#Rank products based on total sales revenue.
SELECT p.product_name,SUM(s.total_price) AS total_revenue,
RANK() OVER(ORDER BY SUM(s.total_price) DESC) AS revenue_rank
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.product_name;

#Calculate the running total revenue for each product category.
SELECT p.category_name,p.product_name,s.sale_date,
SUM(s.total_price) OVER (PARTITION BY p.category_name ORDER BY s.sale_date) AS Running_total_revenue
FROM sales s
JOIN products p
ON s.product_id = s.product_id;

-- Write notes on windows functions and above 2 questions : Rank and PARTITION BY

#Categorize sales as "High", "Medium", or "Low" based on total price (e.g., > $200 is High, $100-$200 is Medium, < $100 is Low).
SELECT * FROM sales;
SELECT sale_id,
CASE
WHEN total_price > 200 THEN 'High'
WHEN total_price BETWEEN 100 AND 200 THEN 'Mid'
WHEN total_price <100 THEN 'Low'
END AS sale_category
FROM sales;

#Identify sales where the quantity sold is greater than the average quantity sold.
SELECT * FROM sales
WHERE quantity_sold > ( SELECT AVG(quantity_sold) FROM sales);

#Extract the month and year from the sale date and count the number of sales for each month.
SELECT CONCAT(YEAR(sale_date),'-',MONTH(sale_date)) AS Month,count(*) AS sales_count FROM sales
GROUP BY Month;

#Calculate the number of days between the current date and the sale date for each sale.
SELECT sale_id, DATEDIFF(NOW(),sale_date) AS days_since_sale
FROM sales;

#Identify sales made during weekdays versus weekends.
SELECT * FROM sales;
SELECT sale_id,
	CASE
		WHEN DAYOFWEEK(sale_date) IN (1,7) THEN 'Weekend'
		ELSE 'Weekday'
	END AS weekday_type
FROM sales;

#ADVANCED SQL
#List the Top 3 Products by Revenue Contribution Percentage
SELECT * FROM sales;
SELECT * FROM products;
SELECT p.product_name,
	   SUM(s.total_price) AS total_revenue,
       (SUM(s.total_price)/(SELECT sum(s.total_price) FROM sales s)) * 100 AS revenue_percentage
FROM sales s
LEFT JOIN products p
ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY revenue_percentage DESC
LIMIT 3;

#Write a query to create a view named Total_Sales that displays the total sales amount for each product along with their names and categories.
SELECT * FROM sales;
SELECT * FROM products;
DROP VIEW total_sales_view;
CREATE VIEW total_sales_view AS
SELECT p.product_name,p.category_name,SUM(s.total_price) AS total_sales
FROM products p
JOIN sales s
ON p.product_id = s.product_id
GROUP BY p.product_name,p.category_name;

SELECT * FROM total_sales_view;

#Retrieve the product details (name, category, unit price) for products that have a quantity sold greater than the average quantity sold across all products.
SELECT * FROM sales;
SELECT * FROM products;
SELECT p.product_name, p.category_name, unit_price
FROM products p
WHERE p.product_id IN (
SELECT s.product_id
FROM sales s
GROUP BY s.product_id
HAVING SUM(s.quantity_sold) > (SELECT AVG(quantity_sold) FROM sales) 
);

#Explain the significance of indexing in SQL databases and provide an example scenario where indexing could significantly improve query performance in the given schema.
# Syntax for creatiing index in SQL is 
# >create index index_name ON table_name (column name);
# indexing helps in allowing database engine to find rows without scanning entire table 

SELECT * FROM sales;
SELECT * FROM products;
CREATE INDEX index_on_sale_date ON sales (sale_date);
SELECT * FROM sales
WHERE sale_date = '2024-01-03'; #querying with indexing as we created an index on sale date from sales table

#Add a foreign key constraint to the Sales table that references the product_id column in the Products table.
#> Referential Integrity : Foreign keys prevent actions that would destroy links between tables or lead to inconsistent data.
#> Ex : You cannot insert a record into the child table if its foreign key value does not have a matching record in the parent table.
#> syntax : ALTER TABLE child_table
#> 			ADD CONSTRAINT fk_child_parent -- Optional: Name the foreign key constraint
#> 			FOREIGN KEY (parent_id)
#> 			REFERENCES parent_table(parent_id)
ALTER TABLE sales
ADD CONSTRAINT fk_product_id
FOREIGN KEY (product_id)
REFERENCES products(product_id);

#Create a view named Top_Products that lists the top 3 products based on the total quantity sold.
CREATE OR REPLACE view top_products AS
SELECT p.product_name,SUM(s.quantity_sold) AS total_qty_sold
FROM products p
LEFT JOIN sales s
ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY total_qty_sold DESC LIMIT 3;

SELECT * FROM top_products;

#Create a query that lists the product names along with their corresponding sales count.
USE business;
SELECT * FROM sales;
SELECT * FROM products;
SELECT p.product_name,COUNT(s.sale_id)
FROM products p
LEFT JOIN sales s
ON p.product_id = s.product_id
GROUP BY p.product_id;

#Write a query to find all sales where the total price is greater than the average total price of all sales.
SELECT * FROM sales s
WHERE total_price > (SELECT AVG(total_price) FROM sales s);

#Add a check constraint to the quantity_sold column in the Sales table to ensure that the quantity sold is always greater than zero.
ALTER TABLE sales
ADD CONSTRAINT check_qty_sold CHECK (quantity_sold > 0);
SELECT * FROM sales;

#Create a view named Product_Sales_Info that displays product details along with the total number of sales made for each product.
SELECT * FROM products;
CREATE OR REPLACE VIEW product_sales_info AS
SELECT p.product_id,p.product_name,p.category_name,COUNT(s.sale_id) AS sale_count
FROM products p
LEFT JOIN sales s
ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.category_name;
SELECT * FROM product_sales_info; 


#Develop a stored procedure named Update_Unit_Price that updates the unit price of a product in the Products table based on the provided product_id.
#A stored procedure is a piece of SQL code that you save in the database so you can reuse it over and over again by "calling" it, 
#rather than typing the whole query every time.
#A Stored Procedure is a block of code that contains multiple internal SQL statements, each ending with a semicolon (;). So we use Delimiter//
DELIMITER //
CREATE PROCEDURE Update_Unit_Price(
IN p_product_id INT,
IN p_new_price DECIMAL(10,2)
)
BEGIN
UPDATE products
SET unit_price = p_new_price
WHERE product_id = p_product_id;
END//
DELIMITER ;

#Write a query that calculates the total revenue generated from each category of products for the year 2024.
SELECT * FROM sales;
SELECT * FROM products;
SELECT p.category_name, SUM(s.total_price) AS total_revenue
FROM products p
LEFT JOIN sales s
ON p.product_id = s.product_id
WHERE YEAR(s.sale_date) = '2024'
GROUP BY p.category_name;








