--total sales
select ROUND(SUM(UnitPrice * Quantity), 2) as totalSales
from OnlineSalesDataset

--top products
select Description, SUM(Quantity) as totalQuantity
from OnlineSalesDataset
group by Description
order by totalQuantity desc

--category sales
select category, SUM(Quantity) as totalSales
from OnlineSalesDataset
group by category
order by totalSales desc

--total sales by country
select Country, SUM(Quantity) as totalSales
from OnlineSalesDataset
group by Country
order by totalSales desc

--total sales per product
select Description, ROUND(SUM(Quantity * UnitPrice), 2) as totalSales
from OnlineSalesDataset
group by Description

--sales by day of the week
select DATENAME(WEEKDAY, InvoiceDate) as day, COUNT(*) as totalSales
from OnlineSalesDataset
group by DATENAME(WEEKDAY, InvoiceDate)
order by MIN(DATEPART(WEEKDAY, InvoiceDate))

--monthly sales trend
select MONTH(InvoiceDate), ROUND(SUM(Quantity * UnitPrice), 2) as MonthlySales
from OnlineSalesDataset
group by MONTH(InvoiceDate)
order by MONTH(InvoiceDate)

--year over year growth
select YEAR(InvoiceDate) as year, SUM(Quantity) as totalSales
from OnlineSalesDataset
group by YEAR(InvoiceDate)
order by year

--identyfing customers with the highest total spending
select CustomerID, 
	(select ROUND(SUM(UnitPrice * Quantity), 2) from OnlineSalesDataset where CustomerID = T.CustomerID) as totalSpending
from OnlineSalesDataset T
group by CustomerID
order by totalSpending desc

--finding the total quanitity sold for each product
select StockCode, 
	(select SUM(Quantity) from OnlineSalesDataset where StockCode = T.StockCode) as totalQunatity
from OnlineSalesDataset T
group by StockCode

--calculate the total quantity sold for each product
with totalQuantityCTE as (
	select StockCode, SUM(Quantity) as totalQuantity
	from OnlineSalesDataset
	group by StockCode
)
select * from totalQuantityCTE

--calculate the average discount given for each payment method
with AverageDiscountCTE as (
	select PaymentMethod, AVG(Discount) as avgDiscount
	from OnlineSalesDataset
	group by PaymentMethod
)
select * from AverageDiscountCTE

--average discount by payment method
select Category, ROUND(SUM(ShippingCost), 2) as totalShippingCost
from OnlineSalesDataset
group by Category

--customer lifetime value
select CustomerID, SUM(UnitPrice - Discount) as lifetimeValue
from OnlineSalesDataset
where CustomerID is not null
group by CustomerID
order by lifetimeValue desc

--identifying high-value customers
select CustomerID, COUNT(InvoiceNo) as orderCount, ROUND(SUM(UnitPrice), 2) as totalSpent
from OnlineSalesDataset
where CustomerID is not null
group by CustomerID
having ROUND(SUM(UnitPrice), 0) > 1000
order by totalSpent desc

--average order value by sales channel
select SalesChannel, ROUND(AVG(UnitPrice), 2) as AvgOrderValue
from OnlineSalesDataset
group by SalesChannel

--top products by sales in each category
select Category, Description, ROUND(SUM(UnitPrice), 2) as totalSales
from OnlineSalesDataset
group by Category, Description
order by Category, totalSales desc

--percentage of orders returned
select (COUNT(case when ReturnStatus = 'Returned' then 1 end) * 100 / COUNT(*)) as returnPercentage
from OnlineSalesDataset

--total sales by hours
select FORMAT(DATEPART(HOUR, InvoiceDate), '00') as hour, ROUND(SUM(UnitPrice), 2) as totalSales
from OnlineSalesDataset
group by FORMAT(DATEPART(HOUR, InvoiceDate), '00')
order by hour

--identifying most common shipment providers
select ShipmentProvider, COUNT(*) as shipmentCount
from OnlineSalesDataset
group by ShipmentProvider
order by shipmentCount desc

--most frequently returned items
select StockCode, COUNT(*) as ReturnCount
from OnlineSalesDataset
where ReturnStatus = 'Returned'
group by StockCode
order by ReturnCount desc

--discount and payment method analysis
select Discount, PaymentMethod,COUNT(*) as TransictionCount
from OnlineSalesDataset
group by Discount, PaymentMethod
order by TransictionCount desc

--count orders by warehouse location
select WarehouseLocation, COUNT(*) as orderCount
from OnlineSalesDataset
where WarehouseLocation is not null
group by WarehouseLocation
order by orderCount desc

--total sales by warehouse location
select WarehouseLocation, ROUND(SUM(Quantity * UnitPrice), 2) as totalSales
from OnlineSalesDataset
where WarehouseLocation is not null
group by WarehouseLocation
order by totalSales desc

--return rate by warehouse location
select WarehouseLocation, COUNT(*) as totalOrders, 
SUM(case when ReturnStatus = 'Returned' then 1 else 0 end) as returnOrders
from OnlineSalesDataset
where WarehouseLocation is not null
group by WarehouseLocation
order by returnOrders desc

--average discount by country
select Country, AVG(Discount) as avgDiscount
from OnlineSalesDataset
group by Country

