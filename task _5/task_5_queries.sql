--Top-Selling Products
SELECT TOP 10 
    t.Name AS TrackName,
    a.Title AS Album,
    SUM(il.Quantity) AS TotalSold,
    SUM(il.Quantity * il.UnitPrice) AS TotalRevenue
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album a ON t.AlbumId = a.AlbumId
GROUP BY t.Name, a.Title
ORDER BY TotalRevenue DESC;


--Revenue per Region
SELECT 
    i.BillingCountry,
    SUM(il.Quantity * il.UnitPrice) AS TotalRevenue
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY i.BillingCountry
ORDER BY TotalRevenue DESC;


--Monthly Performance
SELECT 
    FORMAT(i.InvoiceDate, 'yyyy-MM') AS Month,
    SUM(il.Quantity * il.UnitPrice) AS TotalRevenue
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY FORMAT(i.InvoiceDate, 'yyyy-MM')
ORDER BY Month;


--Top Customers by Revenue
WITH RankedCustomers AS (
    SELECT 
        c.FirstName + ' ' + c.LastName AS CustomerName,
        c.Country,
        SUM(il.Quantity * il.UnitPrice) AS TotalSpent,
        ROW_NUMBER() OVER (ORDER BY SUM(il.Quantity * il.UnitPrice) DESC) AS RowNum
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    GROUP BY c.CustomerId, c.FirstName, c.LastName, c.Country
)
SELECT *
FROM RankedCustomers
WHERE RowNum <= 10
ORDER BY RowNum;
