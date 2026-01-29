
/* =========================================================
   SECTION A – THEORETICAL QUESTIONS
   ========================================================= */


/* ---------------------------------------------------------
   Question 1:
   What are the most common reasons for missing data in ETL pipelines?
   --------------------------------------------------------- */

-- Answer:
-- 1. Data not captured at source systems
-- 2. Human errors during data entry
-- 3. Data corruption during extraction or transfer
-- 4. Optional fields skipped by users
-- 5. Integration issues between multiple systems


/* ---------------------------------------------------------
   Question 2:
   Why is blindly deleting rows with missing values considered
   a bad practice in ETL?
   --------------------------------------------------------- */

-- Answer:
-- Blind deletion leads to loss of valuable data
-- It can introduce bias in analytics
-- It reduces dataset size unnecessarily
-- Missing data may itself contain business insights


/* ---------------------------------------------------------
   Question 3:
   Explain the difference between:
   Listwise deletion
   Column deletion
   Also mention one scenario where each is appropriate.
   --------------------------------------------------------- */

-- Answer:
-- Listwise Deletion:
-- Removes entire rows containing missing values
-- Appropriate when missing rows are very few

-- Column Deletion:
-- Removes entire columns containing missing values
-- Appropriate when a column has excessive missing data
-- and is not important for analysis


/* ---------------------------------------------------------
   Question 4:
   Why is median imputation preferred over mean imputation
   for skewed data such as income?
   --------------------------------------------------------- */

-- Answer:
-- Income data is usually right skewed
-- Mean is affected by extreme values
-- Median is robust and represents central tendency better
-- Hence median imputation is preferred


/* ---------------------------------------------------------
   Question 5:
   What is forward fill and in what type of dataset
   is it most useful?
   --------------------------------------------------------- */

-- Answer:
-- Forward fill replaces missing values with the last
-- available non-missing value
-- It is most useful in time-series or sequential data


/* ---------------------------------------------------------
   Question 6:
   Why should flagging missing values be done before
   imputation in an ETL workflow?
   --------------------------------------------------------- */

-- Answer:
-- Flagging preserves information about missingness
-- Helps in analysis and feature engineering
-- Prevents loss of business insights after imputation


/* ---------------------------------------------------------
   Question 7:
   Consider a scenario where income is missing for many customers.
   How can this missingness itself provide business insights?
   --------------------------------------------------------- */

-- Answer:
-- Missing income may indicate unemployed customers
-- It may highlight incomplete onboarding processes
-- Helps identify high-risk or low-engagement customers
-- Guides targeted business strategies


/* =========================================================
   SECTION B – PRACTICAL QUESTIONS
   ========================================================= */


/* ---------------------------------------------------------
   Create sample table as given dataset
   --------------------------------------------------------- */

CREATE TABLE customers (
    Customer_ID INT,
    Name VARCHAR(50),
    City VARCHAR(50),
    Monthly_Sales INT,
    Income INT,
    Region VARCHAR(20)
);

INSERT INTO customers VALUES
(101, 'Rahul Mehta', 'Mumbai', 12000, 65000, 'West'),
(102, 'Anjali Rao', 'Bengaluru', NULL, NULL, 'South'),
(103, 'Suresh Iyer', 'Chennai', 15000, 72000, 'South'),
(104, 'Neha Singh', 'Delhi', NULL, NULL, 'North'),
(105, 'Amit Verma', 'Pune', 18000, 58000, NULL),
(106, 'Karan Shah', 'Ahmedabad', NULL, 61000, 'West'),
(107, 'Pooja Das', 'Kolkata', 14000, NULL, 'East'),
(108, 'Riya Kapoor', 'Jaipur', 16000, 69000, 'North');


/* ---------------------------------------------------------
   Question 8:
   Listwise Deletion
   Remove all rows where Region is missing.
   --------------------------------------------------------- */

-- Identify affected rows
SELECT *
FROM customers
WHERE Region IS NULL;

-- Dataset after deletion
DELETE FROM customers
WHERE Region IS NULL;

SELECT * FROM customers;

-- Count records lost
SELECT COUNT(*) AS Records_Lost
FROM customers
WHERE Region IS NULL;


/* ---------------------------------------------------------
   Question 9:
   Imputation
   Handle missing values in Monthly_Sales using Forward Fill
   --------------------------------------------------------- */

-- Before Forward Fill
SELECT Customer_ID, Monthly_Sales
FROM customers
ORDER BY Customer_ID;

-- Apply Forward Fill using window function
UPDATE customers c
SET Monthly_Sales = (
    SELECT Monthly_Sales
    FROM customers c2
    WHERE c2.Customer_ID < c.Customer_ID
      AND c2.Monthly_Sales IS NOT NULL
    ORDER BY c2.Customer_ID DESC
    LIMIT 1
)
WHERE c.Monthly_Sales IS NULL;

-- After Forward Fill
SELECT Customer_ID, Monthly_Sales
FROM customers
ORDER BY Customer_ID;

-- Explanation:
-- Forward fill is suitable because customer data
-- follows a sequential order


/* ---------------------------------------------------------
   Question 10:
   Flagging Missing Data
   Create a flag column for missing Income
   --------------------------------------------------------- */

ALTER TABLE customers
ADD COLUMN Income_Missing_Flag INT;

UPDATE customers
SET Income_Missing_Flag =
    CASE
        WHEN Income IS NULL THEN 1
        ELSE 0
    END;

-- Show updated dataset
SELECT * FROM customers;

-- Count customers with missing income
SELECT COUNT(*) AS Missing_Income_Count
FROM customers
WHERE Income_Missing_Flag = 1;

