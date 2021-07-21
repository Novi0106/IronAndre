-- 1. Write a SELECT statement that lists the customerid along with their account number, type, the city the customer lives in and their postalcode.

SELECT c.CustomerID, c.CustomerType, c.AccountNumber, a.city, a.PostalCode
FROM customer c
JOIN customeraddress ca USING(CustomerID)
JOIN address a USING(AddressID);

-- 2. Write a SELECT statement that lists the 20 most recently launched products, their name and colour

SELECT p.Name, p.Color, DATE_FORMAT(p.SellStartDate,"%D %M %Y") as first_sold
FROM product p
ORDER BY first_sold ASC
LIMIT 20;


select*from productinventory;

-- 3. Write a SELECT statement that shows how many products are on each shelf in 2/5/98

SELECT pi.Shelf, count(distinct pi.Quantity) as total_quant, DATE_FORMAT(pi.ModifiedDa,"%D %M %Y") as inventory_date
FROM productinventory pi
GROUP BY inventory_date, pi.Shelf
HAVING inventory_date = "2nd May 1998";

-- 4. I am trying to track down a vendor email address… his name is Stuart and he works at G&K Bicycle Corp. Can you help?

SELECT c.EmailAddress
FROM contact c
JOIN vendorcontact vc USING(ContactID)
JOIN vendor v USING(VendorID)
WHERE c.FirstName = 'Stuart' AND v.Name = 'G & K Bicycle Corp.';

-- 5. What’s the total sales tax amount for sales to Germany? What’s the top region in Germany by sales tax?


SELECT sp.StateProvinceCode, sp.CountryRegionCode, st.TaxRate/100 as Tax,
(sh.SalesYTD * (st.TaxRate/100)) as TaxAmountYTD, (sh.SalesLastYear * (st.TaxRate/100)) as TaxAmountLY
FROM stateprovince sp
JOIN salesterritory sh USING(TerritoryID)
JOIN salestaxrate st USING(StateProvinceID)
WHERE sp.CountryRegionCode = 'DE';

-- 6. 	Summarise the distinct # transactions by month

select*from transactionhistoryarchive;

SELECT count(distinct th.TransactionID) as dist_transactions, DATE_FORMAT(th.TransactionDate,"%M %Y") as transaction_month
FROM transactionhistory th
GROUP BY DATE_FORMAT(th.TransactionDate,"%M %Y");

-- 7.  Which ( if any) of the sales people exceeded their sales quota this year and last year?

select* from salespersonquotahistory;
select* from salesperson;

With performance as(Select s.SalesPersonID, sph.SalesQuota,
CASE
	WHEN (s.SalesYTD - sph.SalesQuota) > 0 THEN "Exceeded"
	ELSE "Underperformed"
END as QuotaYTD,
CASE
	WHEN (s.SalesLastYear - sph.SalesQuota) > 0 THEN "Exceeded"
	ELSE "Underperformed"
END as QuotaLY
FROM salesperson s
JOIN salespersonquotahistory sph using(SalesPersonID))

SELECT p.SalesPersonID
FROM performance p
WHERE QuotaYTD = 'Exceeded' AND QuotaLY = 'Exceeded';

-- 8.  Do all products in the inventory have photos in the database and a text product description? 
-- Answer seems to be no
select * from productinventory;
select * from productproductphoto;
select * from productphoto;
select * from product;
select * from productmodel;
select * from productmodelproductdescriptionculture;
select * from productdescription;

SELECT pi.ProductID, pd.Description, pp.ProductPhotoID 
FROM productinventory pi
LEFT OUTER JOIN productproductphoto ppp using(ProductID)
LEFT OUTER JOIN productphoto pp using(ProductPhotoID)
LEFT OUTER JOIN product p using(ProductID)
LEFT OUTER JOIN productmodel pm using(ProductModelID)
LEFT OUTER JOIN productmodelproductdescriptionculture pmd using(ProductModelID)
LEFT OUTER JOIN productdescription pd using(ProductDescriptionID)
WHERE pd.Description IS NULL OR pp.ProductPhotoID IS NULL;

-- 9.  What's the average unit price of each product name on purchase orders which were not fully, but at least partially rejected?

SELECT * FROM purchaseorderdetail;
SELECT * FROM product;

SELECT p.Name, avg(po.UnitPrice) as avg_unit_price, po.RejectedQty
FROM product p
JOIN purchaseorderdetail po using(ProductID)
GROUP BY p.Name, po.RejectedQty
HAVING po.RejectedQty > 0;

-- 10. How many engineers are on the employee list? Have they taken any sickleave?
SELECT * FROM department;
SELECT * FROM employee;

SELECT count(distinct e.EmployeeID) as Employees, d.Name as Department
FROM employee e
JOIN employeedepartmenthistory edh using(EmployeeID)
JOIN department d using(DepartmentID)
WHERE d.Name = 'Engineering'
GROUP BY d.Name;

-- 11. How many days difference on average between the planned and actual end date of workorders in the painting stages?
SELECT * FROM workorder;
SELECT * FROM product;
SELECT * FROM workorderrouting;
SELECT * FROM location;

SELECT l.Name as Stage, avg(DATEDIFF(w.EndDate, w.DueDate)) as avg_day_diff
FROM workorder w
JOIN workorderrouting wr using(WorkOrderID)
JOIN location l using(LocationID)
WHERE l.Name LIKE 'Paint%'
GROUP BY l.Name;
