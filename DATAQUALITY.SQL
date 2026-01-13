/* =========================================================
   Data Quality and Validation in ETL
   ========================================================= */

/* =========================================================
   Question 1: Define Data Quality in the context of ETL pipelines.Why is it more than just data cleaning?
   ========================================================= */

/*
Answer:
In ETL (Extract, Transform, Load) pipelines, Data Quality is the measure of how accurate, complete, consistent, valid, unique, and suitable the data is for business analysis after undergoing the ETL process.
High-quality data must correctly represent real-world
business events and follow defined technical and business rules.

Data Quality is more than just data cleaning because:
- Data cleaning focuses on fixing visible issues such as
  NULL values, incorrect formats, or extra spaces.
- Data Quality includes validation rules, business constraints,
  integrity checks, and prevention mechanisms.

For example:
Replacing a NULL transaction amount with 0 is data cleaning.
Rejecting a transaction where amount must be greater than 0
is data quality enforcement.

Conclusion:
Data cleaning improves data appearance,
while data quality ensures data correctness,
trustworthiness, and business reliability.
*/


/* =========================================================
   Question 2:
   Explain why poor data quality leads to misleading dashboards
   and incorrect decisions.
   ========================================================= */

/*
Answer:
Dashboards and reports are completely dependent on the
quality of underlying data.

Poor data quality issues such as:
- Duplicate records
- Missing values
- Incorrect data types
- Inconsistent business definitions

directly impact calculated metrics and KPIs.

Examples:
- Duplicate sales transactions inflate revenue figures.
- Missing transaction amounts reduce total sales.
- Incorrect dates distort trend and growth analysis.

Decision-makers trust dashboards to take strategic actions.
If data quality is poor, decisions related to pricing,
inventory, marketing, and forecasting will be incorrect.

Conclusion:
Poor data quality results in misleading dashboards and
causes wrong business decisions to be made with high confidence.
*/


/* =========================================================
   Question 3:
   What is duplicate data?
   Explain three causes in ETL pipelines.
   ========================================================= */

/*
Answer:
Duplicate data refers to multiple records that represent
the same real-world entity or transaction within a dataset.

In ETL pipelines, duplicates commonly occur due to:

1. Multiple Source Systems:
   The same data may be extracted from different systems
   without proper reconciliation or de-duplication logic.

2. Incorrect Incremental Load Logic:
   When ETL jobs reload previously processed data due to
   wrong filters or missing checkpoints, duplicates are created.

3. Missing or Weak Business Keys:
   Without a strong business key, the system cannot uniquely
   identify records, leading to repeated inserts.

Conclusion:
Duplicate data inflates metrics, increases storage,
and reduces trust in analytical reports.
*/


/* =========================================================
   Question 4:
   Differentiate between exact, partial, and fuzzy duplicates.
   ========================================================= */

/*
Answer:
Duplicate records are classified based on the level of similarity.

Exact Duplicates:
Records where all relevant fields match exactly.
Usually caused by reprocessing or system errors.

Partial Duplicates:
Records where key fields match but some attributes differ.
Often caused by inconsistent updates or data synchronization issues.

Fuzzy Duplicates:
Records referring to the same entity but with spelling
or formatting differences.
Usually caused by manual data entry errors.

Identifying the duplicate type helps apply the correct
de-duplication technique.
*/


/* =========================================================
   Question 5:
   Why should data validation be performed during transformation
   rather than after loading?
   ========================================================= */

/*
Answer:
The transformation stage is the most effective point
to validate data because data is actively being structured
and standardized.

Validating after loading is risky because:
- Invalid data already enters reporting tables.
- Downstream dashboards may consume incorrect data.
- Fixing errors later increases cost and rework.

During transformation, ETL pipelines can:
- Apply business rules
- Reject or isolate invalid records
- Log errors for auditing
- Prevent bad data from reaching target systems

Conclusion:
Early validation ensures only trusted data reaches
analytics and reporting layers.
*/


/* =========================================================
   Question 6:
   Explain how business rules help in validating data accuracy.
   Give an example.
   ========================================================= */

/*
Answer:
Business rules define logical conditions that data must satisfy
to be considered accurate and meaningful for business use.

They help validate data accuracy by:
- Enforcing real-world constraints
- Preventing logically incorrect values
- Aligning technical data with business expectations

Example:
In a sales system:
- Transaction amount must be greater than zero
- Transaction date cannot be in the future

Records violating these rules are flagged or rejected
during ETL transformation.

Conclusion:
Business rules ensure data is business-correct,
not just technically valid.
*/


/* =========================================================
   Question 7:
   Write an SQL query to list all duplicate keys and their counts
   using the business key:
   (Customer_ID + Product_ID + Txn_Date + Txn_Amount)
   ========================================================= */

SELECT 
    Customer_ID,
    Product_ID,
    Txn_Date,
    Txn_Amount,
    COUNT(*) AS duplicate_count
FROM Sales_Transactions
GROUP BY 
    Customer_ID,
    Product_ID,
    Txn_Date,
    Txn_Amount
HAVING COUNT(*) > 1;


/*
Explanation:
- GROUP BY combines records using the defined business key.
- COUNT(*) calculates how many times each key appears.
- HAVING filters only those combinations that occur more than once.

This query identifies duplicate transactions that may
inflate sales metrics if not handled properly.
*/


/* =========================================================
   Question 8:
   Enforcing Referential Integrity
   Identify Sales_Transactions.Customer_ID values
   that violate referential integrity when joined
   with Customers_Master.
   ========================================================= */

SELECT DISTINCT s.Customer_ID
FROM Sales_Transactions s
LEFT JOIN Customers_Master c
    ON s.Customer_ID = c.CustomerID
WHERE c.CustomerID IS NULL;


/*
Explanation:
- LEFT JOIN retains all transaction records.
- Missing matches in Customers_Master result in NULL values.
- These Customer_IDs violate referential integrity.

Such records indicate invalid or unmanaged customers
and must be corrected before analytics or reporting.
*/
