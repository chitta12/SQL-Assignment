USE pwassignment ;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

INSERT INTO Products VALUES
(1, 'Keyboard', 'Electronics', 1200),
(2, 'Mouse', 'Electronics', 800),
(3, 'Chair', 'Furniture', 2500),
(4, 'Desk', 'Furniture', 5500);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);

INSERT INTO Sales VALUES
(1, 1, 4, '2024-01-05'),
(2, 2, 10, '2024-01-06'),
(3, 3, 2, '2024-01-10'),
(4, 4, 1, '2024-01-11');


SELECT * FROM Products ;
SELECT * FROM sales ;

/*
Q1. What is a Common Table Expression (CTE), and how does it improve SQL query readability?
Answer: A CTE is a named temporary result set that exists only during the query execution. Defined using the WITH clause, it functions as a temporary table or named subquery that exists only for the duration of that specific query.
        It improves readability by breaking down complex logic into linear, named steps, avoiding messy nested subqueries.
        CTEs allow queries to follow a linear "story". You can define a dataset, refine it in a second CTE, and then perform the final calculation in the main query, mirroring how a developer naturally thinks through a problem.

Q2. Why are some views updatable while others are read-only? Explain with an example.
Answer: A view is updatable if it has a direct 1-to-1 mapping to the underlying table rows. It becomes read-only if it uses aggregates (SUM, COUNT), DISTINCT, or GROUP BY, because the DB can't map a single view row back to a specific table row.
Example: `SELECT ID, Name FROM Users` is updatable. `SELECT Count(*) FROM Users` is read-only.

Q3. What advantages do stored procedures offer compared to writing raw SQL queries repeatedly?
Answer:  Because they are pre-compiled and optimized by the database engine, they execute much faster than raw SQL, which must be parsed every time it is sent.
         Instead of sending a long SQL script over the network, your application only sends the procedure name and parameters, saving bandwidth.
         They help prevent SQL injection by using parameters. You can also give users permission to "execute" a procedure without giving them direct access to sensitive tables.
         Logic is centralized. If a business rule changes, you update it in one place (the database) rather than searching through lines of application code.
         Once written, a stored procedure can be called by multiple applications or users, ensuring consistent results across your entire system

Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential.

A trigger is a stored SQL procedure that automatically executes in response to a specific event on a table, such as an INSERT, UPDATE, or DELETE.

Key Purposes:
       They eliminate the need for manual intervention by performing tasks automatically when data changes.
       They enforce complex business rules that simple constraints (like CHECK or UNIQUE) cannot handle.
       They capture changes for security and compliance, ensuring every modification is logged.
       They can keep related tables in sync (e.g., updating stock levels when a sale is recorded).
       Audit Logging and Archiving
A trigger is essential for maintaining a history of deleted records. In many industries, you cannot simply let data disappear.
for Example When a product is deleted from the Products table, an AFTER DELETE trigger automatically captures that data and moves it into a ProductArchive table along with a timestamp. This provides a permanent "paper trail" for recovery or security audits that raw SQL alone might miss.

Q5. Explain the need for data modelling and normalization when designing a database.
Answer: Data modelling ensures the database structure actually fits the business needs. Normalization is required to eliminate duplicate data (redundancy) and prevent anomalies during updates or insertions.

 */
 
 
 -- Q6. Write a CTE to calculate the total revenue for each product (Revenues = Price × Quantity), and return only products where  revenue > 3000.
 
 WITH ProductRevenue AS (
    -- Calculateing  revenue for every product by joining Products and Sales tables 
    SELECT p.ProductID,p.ProductName,
        (p.Price * s.Quantity) AS TotalRevenue
    FROM Products p
    JOIN Sales s ON p.ProductID = s.ProductID
)
-- Return only those products where the calculated revenue exceeds 3000
SELECT ProductID, ProductName, TotalRevenue
FROM ProductRevenue
WHERE TotalRevenue > 3000;
 
 -- Q7. Create a view named vw_CategorySummary that shows:  Category, TotalProducts, AveragePrice.
 
CREATE VIEW vw_CategorySummary AS
SELECT Category, 
    COUNT(ProductID) AS TotalProducts, 
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

-- Select to verify
SELECT * FROM vw_CategorySummary;


-- Q8. ate an updatable view containing ProductID, ProductName, and Price.Then update the price of ProductID = 1 using the view.

CREATE VIEW vw_ProductDetails AS
SELECT ProductID, ProductName, Price
FROM Products;

-- Update the price of the Keyboard (ProductID 1) to 1300.00
UPDATE vw_ProductDetails
SET Price = 1300.00
WHERE ProductID = 1;

--  Q9. Create a stored procedure that accepts a category name and returns all products belonging to that category.

DELIMITER //
CREATE PROCEDURE GetProductsByCategory(IN categoryName VARCHAR(50))
BEGIN
    -- Selecting columns from Products where the category matches the input requirement 
    SELECT * FROM Products 
    WHERE Category = categoryName;
END //
DELIMITER ;

-- To see all Furniture
CALL GetProductsByCategory('Furniture');
-- To see all Electronics
CALL GetProductsByCategory('Electronics');

-- Create an AFTER DELETE trigger on the Products table that archives deleted product rows into a new table ProductArchive . The archive should store ProductID, ProductName, Category, Price, and DeletedAt timestamp.

CREATE TABLE ProductArchive (
    ArchiveID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_AfterDeleteProduct
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive (ProductID, ProductName, Category, Price)
    VALUES (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price);
END //
DELIMITER ;

 
 