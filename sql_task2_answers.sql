/* sql task2 asnwers */
select * from Orders;
select * from OrderDetails;
select * from Employee;
select * from Products;
select * from Shippers;
select * from Suppliers;

/*1q*/
select Employee.FirstName,Employee.LastName from Employee 
left join 
Orders on Orders.EmployeeID = Employee.EmployeeID 
where Orders.OrderDate between '1996-08-15' and '1997-08-15'; 

/*2q*/
select distinct Orders.EmployeeID from Orders where Orders.OrderDate < '1996-10-16';

/*3q*/
select count(OrderDetails.ProductID) as ProductsOrdered from OrderDetails 
left join 
Orders on Orders.OrderID = OrderDetails.OrderID 
where Orders.OrderDate between '1997-01-13' and '1997-04-16'; 

/*4q*/
 select sum(OrderDetails.Quantity) as TotalQuantity from OrderDetails where OrderDetails.OrderID in 
 (select Orders.OrderId from Orders 
 left join 
 Employee on Orders.EmployeeID = Employee.EmployeeID 
 where concat(Employee.FirstName,Employee.LastName)='AnneDodsworth' and 
 Orders.OrderDate between '1997-01-13' and '1997-04-16');

/*5q*/
select count(Orders.OrderID) as OrdersPlaced from Orders 
left join 
Employee on Orders.EmployeeID = Employee.EmployeeID 
where CONCAT(Employee.FirstName,Employee.LastName)='RobertKing';

/*6q*/
select count(OrderDetails.ProductID) as ProductsOrdered from OrderDetails where OrderDetails.OrderID in (
select Orders.OrderId from Orders left join Employee on Orders.EmployeeID = Employee.EmployeeID 
where CONCAT(Employee.FirstName,Employee.LastName)='RobertKing' and Orders.OrderDate between '1996-07-15' and '1997-07-15');

/*7q*/
select Employee.EmployeeID,CONCAT(Employee.FirstName,Employee.LastName) as EmployeeName,Employee.HomePhone from Employee 
left join Orders on Orders.EmployeeID=Employee.EmployeeID
where Orders.OrderDate between '1997-01-13' and '1997-04-16';

/*8q*/
select Products.ProductId,Products.ProductName,SubqueryResult.OrderCount from Products
inner join (
SELECT top 1 OrderCount,ProductID
FROM (
    SELECT COUNT(OrderDetails.OrderID) AS OrderCount, OrderDetails.ProductID
    FROM OrderDetails
    WHERE OrderDetails.ProductID IN (SELECT Products.ProductID FROM Products)
    GROUP BY OrderDetails.ProductID
) AS SubqueryResult order by OrderCount desc)as SubqueryResult on Products.ProductID = SubqueryResult.ProductID;

/*9q*/
select Products.ProductName,sub.ShippedCount from Products inner join (
select top 5 OrderDetails.ProductID,count(Orders.ShipperID) as ShippedCount from Orders inner join
OrderDetails on OrderDetails.OrderID = Orders.OrderID group by OrderDetails.ProductID
order by ShippedCount) as sub on sub.ProductID = Products.ProductID;

/*10q*/
select (OrderDetails.UnitPrice * OrderDetails.Quantity)-(OrderDetails.UnitPrice * OrderDetails.Quantity * OrderDetails.Discount)
as TotalPrice
from OrderDetails where OrderDetails.OrderId=
(select Orders.OrderID from Orders left join Employee on Orders.EmployeeID = Employee.EmployeeID
where CONCAT(Employee.FirstName,Employee.LastName)='LauraCallahan' and Orders.OrderDate = '1997-01-13');

/*11*/
select count(distinct Orders.EmployeeID) from Orders inner join( 
select OrderDetails.OrderID from OrderDetails left join Products on OrderDetails.ProductID= Products.ProductID 
where Products.ProductName in ('Gorgonzola Telino','Gnocchi di nonna Alice','Raclette Courdavault','Camembert Pierrot')) 
as SubqueryResult on Orders.OrderID=SubqueryResult.OrderID where year(Orders.OrderDate) = '1997' and 
month(Orders.OrderDate) = '01';

/*12*/
select CONCAT(Employee.FirstName,Employee.LastName) as EmployeeName from Employee 
inner join (select Orders.EmployeeId from Orders where Orders.OrderID in (
select SubqueryResult.OrderID from
(select OrderDetails.ProductID,OrderDetails.OrderID from OrderDetails left join Orders on Orders.OrderID=OrderDetails.OrderID 
where Orders.OrderDate between '1997-01-13' and '1997-01-30') as SubqueryResult 
inner join Products on Products.ProductID = SubqueryResult.ProductID where Products.ProductName = 'Tofu')) as RequiredEmployees 
on RequiredEmployees.EmployeeID= Employee.EmployeeID;

/*13*/
select Employee.EmployeeID,concat(Employee.FirstName,Employee.LastName) as EmployeeName,Employee.BirthDate from Employee
left join
(select Orders.EmployeeID from Orders where month(Orders.OrderDate) = '7') as SubqueryResult 
on SubqueryResult.EmployeeID=Employee.EmployeeID;

/*14*/
select Shippers.CompanyName,SubqueryResult.OrdersCount from Shippers inner join(
select Orders.ShipperID,Count(Orders.ShipperID) as OrdersCount from Orders left join Shippers on Orders.ShipperID=Shippers.ShipperID group by
Orders.ShipperID) as SubqueryResult on SubqueryResult.ShipperID=Shippers.ShipperID;

/*15*/
select Subquery.ShipperID,count(OrderDetails.ProductID) as ProductCount from OrderDetails 
join (
select Orders.ShipperID,Orders.OrderID from Orders left join Shippers on Orders.ShipperID=Shippers.ShipperID)
as Subquery on OrderDetails.OrderID=Subquery.OrderID
group by Subquery.ShipperID;

/*16*/
select top 1 Shippers.ShipperID,Shippers.CompanyName,SubqueryResult.OrdersCount from Shippers inner join(
select Orders.ShipperID,Count(Orders.ShipperID) as OrdersCount from Orders left join Shippers on Orders.ShipperID=Shippers.ShipperID group by
Orders.ShipperID) as SubqueryResult on SubqueryResult.ShipperID=Shippers.ShipperID 
order by SubqueryResult.OrdersCount desc;

/*17*/
select top 1 Shippers.CompanyName,finaltable.ProductCount from Shippers inner join( 
select Subquery.ShipperID,count(OrderDetails.ProductID) as ProductCount from OrderDetails 
join (
	select Orders.ShipperID,Orders.OrderID from Orders left join Shippers on Orders.ShipperID=Shippers.ShipperID 
	where Orders.OrderDate between '1996-07-10' and '1998-08-20'
	)as Subquery
	on OrderDetails.OrderID=Subquery.OrderID group by Subquery.ShipperID)as finaltable 
	on finaltable.ShipperID=Shippers.ShipperID order by finaltable.ProductCount desc;


/*18*/
select concat(Employee.FirstName,Employee.LastName) as EmployeeName from Employee inner join(
select Orders.EmployeeID from Orders where Orders.OrderDate != '1997-04-04')as sub on sub.EmployeeID=Employee.EmployeeID;

/*19*/
select sum(finaltable.ProductCount) as ProductsDelivered from (
select OrderDetails.OrderID,count(OrderDetails.ProductID) as ProductCount from OrderDetails join(
select Orders.OrderId from Orders where Orders.EmployeeID = (select Employee.EmployeeID from Employee 
where concat(Employee.FirstName,Employee.LastName) = 'StevenBuchanan'))as sub on sub.OrderID=OrderDetails.OrderID 
group by OrderDetails.OrderID)as finaltable;

/*20*/
select count(Orders.OrderID) as OrdersCount from Orders where Orders.EmployeeID = 
(select Employee.EmployeeID from Employee 
where concat(Employee.FirstName,Employee.LastName) = 'MichaelSuyama') and 
Orders.ShipperID=(Select Shippers.ShipperID from Shippers where Shippers.CompanyName = 'Federal Shipping');

/*21*/
select count(OrderDetails.OrderID) as OrdersPlacedFromUKandGermany from OrderDetails inner join Products on Products.ProductId = OrderDetails.ProductID 
where Products.SupplierID in( 
select Suppliers.SupplierID from Suppliers where Suppliers.Country = 'UK' or Suppliers.Country = 'Germany');

/*22*/
select sum(subquery.Quantity) as AmountExoticLiquids from
(select OrderDetails.ProductID,OrderDetails.OrderID,OrderDetails.Quantity from Orders inner join OrderDetails on OrderDetails.OrderID = Orders.OrderID
where month(Orders.OrderDate) = '01' and year(Orders.OrderDate) = '1997') as subquery inner join 
Products on Products.ProductID = subquery.ProductID where Products.SupplierID in(
select Suppliers.SupplierID from Suppliers where Suppliers.CompanyName = 'Exotic Liquids');

/*23*/
select subquery.OrderDate from (
select Orders.OrderDate,OrderDetails.ProductID from Orders inner join OrderDetails on OrderDetails.OrderID = Orders.OrderID
where month(Orders.OrderDate) = '01' and year(Orders.OrderDate) = '1997') as subquery inner join 
Products on Products.ProductID = subquery.ProductID
where Products.SupplierId not in
(
	select Suppliers.SupplierID from Suppliers where Suppliers.CompanyName = 'Tokyo Traders'
);

/*24*/
select distinct concat(Employee.FirstName,Employee.LastName) as EmployeeName from (
select OrderDetails.OrderID,Orders.EmployeeID from OrderDetails inner join Orders on OrderDetails.OrderID = Orders.OrderID
where 
  OrderDetails.ProductID not in (
    select Products.ProductID from Products 
    where 
      Products.SupplierID in (
        select SupplierID from Suppliers where Suppliers.CompanyName = 'Ma Maison')
  )
) as sub inner join Employee on Employee.EmployeeID = sub.EmployeeID;

/*25*/
select top 1 subquery.SupplierID,Count(subquery.OrderID) as NoOfOrders from(
select sub.OrderID,Products.SupplierID from (
	select Orders.OrderID,OrderDetails.ProductID,Orders.OrderDate from Orders 
	inner join OrderDetails on OrderDetails.OrderID = Orders.OrderID
	where month(Orders.OrderDate) in (9,10) and year(Orders.OrderDate) = 1997
	)as sub inner join Products on Products.ProductID = sub.ProductID) as subquery group by subquery.SupplierID 
	order by Count(subquery.OrderID);

/*26*/
select Products.ProductName,sub.ShippedDate from Products inner join (
select Orders.OrderID,Orders.ShippedDate,OrderDetails.ProductID from Orders inner join OrderDetails on OrderDetails.OrderID = Orders.OrderID
where month(Orders.ShippedDate) != 8 and year(Orders.ShippedDate) != 1997) as sub on Products.ProductID = sub.ProductID;

/*27*/
CREATE VIEW sample AS
SELECT Orders.EmployeeID, sub.ProductName, sub.ProductID 
FROM (
    SELECT OrderDetails.OrderID, OrderDetails.ProductID, Products.ProductName 
    FROM OrderDetails 
    INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
) AS sub 
INNER JOIN Orders ON Orders.OrderID = sub.OrderID order by Orders.EmployeeID;

create view unorderedproducts 
as
SELECT sample.EmployeeID, Products.ProductID, Products.ProductName
FROM sample
CROSS JOIN Products
LEFT JOIN (
    SELECT Orders.EmployeeID, OrderDetails.ProductID
    FROM Orders
    INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
) AS OrderedProducts ON sample.EmployeeID = OrderedProducts.EmployeeID AND Products.ProductID = OrderedProducts.ProductID
WHERE OrderedProducts.EmployeeID IS NULL;

/*27 answer */
SELECT EmployeeID, ProductID 
FROM unorderedproducts 
GROUP BY EmployeeID, ProductID
order by EmployeeID;



/*28*/
select Shippers.ShipperID,Shippers.CompanyName from Shippers inner join (
select top 1 Orders.ShipperID,count(Orders.OrderID) as ShippedOrders from Orders 
where month(Orders.OrderDate) in (4,5,6) and year(Orders.OrderDate) in (1996,1997)
group by Orders.ShipperID
order by count(Orders.OrderID) desc
) as sub on Shippers.ShipperID = sub.ShipperID;

/*29*/
select top 1 Suppliers.Country,count(subqueryresult.ProductID) as ProductsShipped from Suppliers inner join
(
select subquery.OrderID,Products.ProductID,Products.SupplierID from Products inner join(
select sub.OrderID,OrderDetails.ProductID from OrderDetails inner join(
select Orders.OrderID from Orders where year(Orders.OrderDate) = 1997) as sub on sub.OrderID = OrderDetails.OrderID) 
as subquery on Products.ProductID = subquery.ProductID
) as subqueryresult on subqueryresult.SupplierID = Suppliers.SupplierID 
group by Suppliers.Country
order by count(subqueryresult.ProductID) desc;

/*30*/
select sum(sub.DaysTakenToDeliver)/3 as AverageNoOfDays from 
(
	select Orders.ShipperID,sum(DATEDIFF(day,Orders.OrderDate,Orders.ShippedDate)) as DaysTakenToDeliver
	from Orders group by Orders.ShipperID
) as sub;

/*31*/
select Shippers.CompanyName from Shippers inner join (
select top 1 Orders.ShipperID,sum(DATEDIFF(day,Orders.OrderDate,Orders.ShippedDate)) as DaysTakenToDeliver
from Orders group by Orders.ShipperID 
order by DaysTakenToDeliver) as sub on sub.ShipperID = Shippers.ShipperID;

/*32*/
SELECT top 1 sq.OrderID,CONCAT(Employee.FirstName, Employee.LastName) AS EmployeeName,sq.NoofProducts,
sq.DaysTakenToDeliver,Shippers.CompanyName
FROM Employee
INNER JOIN (
    SELECT sub.OrderID,sub.EmployeeID,sub.ShipperID,COUNT(OrderDetails.ProductID) AS NoofProducts,sub.DaysTakenToDeliver
    FROM OrderDetails 
    INNER JOIN (
        SELECT Orders.OrderID,Orders.EmployeeID,Orders.ShipperID,
		DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate) AS DaysTakenToDeliver
        FROM 
            Orders 
        WHERE Orders.ShippedDate IS NOT NULL
    ) AS sub ON sub.OrderID = OrderDetails.OrderID
    GROUP BY sub.DaysTakenToDeliver,sub.OrderID,sub.EmployeeID,sub.ShipperID
) AS sq ON sq.EmployeeID = Employee.EmployeeID
INNER JOIN Shippers ON sq.ShipperID = Shippers.ShipperID order by sq.DaysTakenToDeliver;

/*33*/
SELECT top 1 sq.OrderID,CONCAT(Employee.FirstName, Employee.LastName) AS EmployeeName,sq.NoofProducts,
sq.DaysTakenToDeliver,Shippers.CompanyName
FROM Employee
INNER JOIN (
    SELECT sub.OrderID,sub.EmployeeID,sub.ShipperID,COUNT(OrderDetails.ProductID) AS NoofProducts,sub.DaysTakenToDeliver
    FROM OrderDetails 
    INNER JOIN (
        SELECT Orders.OrderID,Orders.EmployeeID,Orders.ShipperID,
		DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate) AS DaysTakenToDeliver
        FROM 
            Orders 
        WHERE Orders.ShippedDate IS NOT NULL
    ) AS sub ON sub.OrderID = OrderDetails.OrderID
    GROUP BY sub.DaysTakenToDeliver,sub.OrderID,sub.EmployeeID,sub.ShipperID
) AS sq ON sq.EmployeeID = Employee.EmployeeID
INNER JOIN Shippers ON sq.ShipperID = Shippers.ShipperID order by sq.DaysTakenToDeliver;

SELECT top 1 sq.OrderID,CONCAT(Employee.FirstName, Employee.LastName) AS EmployeeName,sq.NoofProducts,
sq.DaysTakenToDeliver,Shippers.CompanyName
FROM Employee
INNER JOIN (
    SELECT sub.OrderID,sub.EmployeeID,sub.ShipperID,COUNT(OrderDetails.ProductID) AS NoofProducts,sub.DaysTakenToDeliver
    FROM OrderDetails 
    INNER JOIN (
        SELECT Orders.OrderID,Orders.EmployeeID,Orders.ShipperID,
		DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate) AS DaysTakenToDeliver
        FROM 
            Orders 
        WHERE Orders.ShippedDate IS NOT NULL
    ) AS sub ON sub.OrderID = OrderDetails.OrderID
    GROUP BY sub.DaysTakenToDeliver,sub.OrderID,sub.EmployeeID,sub.ShipperID
) AS sq ON sq.EmployeeID = Employee.EmployeeID
INNER JOIN Shippers ON sq.ShipperID = Shippers.ShipperID order by sq.DaysTakenToDeliver desc;

/*34*/
select top 1 sub.ProductID,Products.ProductName,Products.UnitPrice from (
select Orders.OrderID,OrderDetails.ProductID,
((OrderDetails.UnitPrice * OrderDetails.Quantity) - (OrderDetails.UnitPrice * OrderDetails.Discount)) as Money
from Orders inner join OrderDetails on OrderDetails.OrderID=Orders.OrderID 
where day(Orders.OrderDate) in (8,9,10,11,12,13,14) and month(Orders.OrderDate) = 10 
and year(Orders.OrderDate) = 1997) as sub inner join Products on Products.ProductID = sub.ProductID order by Money;

select top 1 sub.ProductID,Products.ProductName,Products.UnitPrice from (
select Orders.OrderID,OrderDetails.ProductID,
((OrderDetails.UnitPrice * OrderDetails.Quantity) - (OrderDetails.UnitPrice * OrderDetails.Discount)) as Money
from Orders inner join OrderDetails on OrderDetails.OrderID=Orders.OrderID 
where day(Orders.OrderDate) in (8,9,10,11,12,13,14) and month(Orders.OrderDate) = 10 
and year(Orders.OrderDate) = 1997) as sub inner join Products on Products.ProductID = sub.ProductID order by Money desc;

/*35*/
select Orders.OrderID,Orders.ShipperID,
case 
	when Orders.ShipperID = 2 then 'Express Speedy'
	when Orders.ShipperID = 1 then 'Shipping Federal'
	when Orders.ShipperID = 3 then 'United Package'
end as ShipperCompanyName
from Orders where Orders.EmployeeID in (1,3,5,7) order by Orders.OrderID;




