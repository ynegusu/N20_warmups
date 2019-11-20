-- For each country calculate the total spending for each customer, and 
-- include a column (called 'difference') showing how much more each customer 
-- spent compared to the next highest spender in that country. 
-- For the 'difference' column, fill any nulls with zero.
-- ROUND your all of your results to the next penny.

-- hints: 
-- keywords to google - lead, lag, coalesce
-- If rounding isn't working: 
-- https://stackoverflow.com/questions/13113096/how-to-round-an-average-to-2-decimal-places-in-postgresql/20934099
WITH 
spending_info AS ( --first, get the basic necessary info together
SELECT *,
	country 
	customerid,
	Round(od.unitprice*od.quantity*(1-od.discount) as total
	--od.unitprice*od.quantity as previous
	--od.unitprice-od.quantity*(1-od.discount) as different
FROM orders as o 
	JOIN order_details as od ON o.orderid = od.orderid
	JOIN products as p ON od.productid = p.productid
	JOIN customers as c ON o.customerid = c.customerid
),
country_totals as ( 
	select customerid,
	country,
	max(total) as total
FROM spending_info
GROUP BY country   order by total
),
	(SELECT 
	customerid,
 COALESCE (LEAD(country_totals,1) OVER (PARTITION BY country ORDER BY total DESC),0) AS total,country;
	 