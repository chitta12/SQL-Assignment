/*
Q1. Retrieve all customers who have placed at least one order.
*/
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

/*
Q2. Retrieve all customers and their orders, including customers who have not placed any orders.
*/
SELECT c.*, o.OrderID, o.OrderDate, o.Amount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

/*
Q3. Retrieve all orders and their corresponding customers, including orders placed by unknown customers.
*/
SELECT o.*, c.CustomerName, c.City
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID;

/*
Q4. Display all customers and orders, whether matched or not.
*/
SELECT c.*, o.OrderID, o.OrderDate, o.Amount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT c.*, o.OrderID, o.OrderDate, o.Amount
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

/*
Q5. Find customers who have not placed any orders.
*/
SELECT c.*
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

/*
Q6. Retrieve customers who made payments but did not place any orders.
*/
SELECT DISTINCT c.*
FROM Customers c
JOIN Payments p ON c.CustomerID = p.CustomerID
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

/*
Q7. Generate a list of all possible combinations between Customers and Orders.
*/
SELECT *
FROM Customers c
CROSS JOIN Orders o;

/*
Q8. Show all customers along with order and payment amounts in one table.
*/
SELECT c.*, o.Amount AS OrderAmount, p.Amount AS PaymentAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN Payments p ON c.CustomerID = p.CustomerID;

/*
Q9. Retrieve all customers who have both placed orders and made payments.
*/
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Payments p ON c.CustomerID = p.CustomerID;

