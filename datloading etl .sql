/* =========================================================
   Assignment Name: Data Loading 
   ========================================================= */

/* =========================================================
   Question 1: Data Understanding
   Identify all data quality issues present in the dataset
   that can cause problems during data loading.
   ========================================================= */

/*
Answer:
The dataset contains multiple data quality issues that
can cause load failures or incorrect analytics.

Identified Issues:
1. Duplicate primary key values (Order_ID O101 appears twice)
2. Missing values in Sales_Amount column
3. Invalid data type in Sales_Amount (text value: "Three Thousand")
4. Inconsistent date formats in Order_Date column
5. Risk of referential integrity issues with Customer_ID

Conclusion:
The dataset is not load-ready and requires cleaning
and validation before loading.
*/


/* =========================================================
   Question 2: Primary Key Validation
   Assume Order_ID is the Primary Key.
   ========================================================= */

/*
a) Is the dataset violating the Primary Key rule?

Yes.
Order_ID values must be unique, but duplicates exist.

b) Which record(s) cause this violation?

Order_ID = O101 appears more than once.

Impact:
- Insert failure if primary key constraint is enforced
- Possible overwrites if constraints are disabled
- Incorrect order counts and KPIs
*/


/* =========================================================
   Question 3: Missing Value Analysis
   ========================================================= */

/*
Answer:
The Sales_Amount column contains missing values.

Affected Record:
Order_ID = O102 has Sales_Amount = NULL.

Risk of loading without handling:
- Incorrect revenue aggregation
- Misleading Total Sales KPIs
- BI tools may silently ignore NULL values

Conclusion:
Missing values must be handled during ETL transformation.
*/


/* =========================================================
   Question 4: Data Type Validation
   ========================================================= */

/*
a) Which record(s) will fail numeric validation?

Order_ID = O104
Sales_Amount = 'Three Thousand' (text value)

b) What happens if loaded into DECIMAL column?

- Load failure due to conversion error
- Or forced NULL insertion leading to data loss

Conclusion:
Numeric validation is mandatory before loading.
*/


/* =========================================================
   Question 5: Date Format Consistency
   ========================================================= */

/*
a) Date formats present in Order_Date column:

- DD-MM-YYYY   (12-01-2024, 15-01-2024, 20-01-2024, 25-01-2024)
- YYYY/MM/DD   (2024/01/18)

b) Why this is a problem:

- ETL tools expect a single date format
- Incorrect parsing may swap day and month
- Some records may fail to load
- Time-based analysis becomes unreliable

Conclusion:
Date formats must be standardized before loading.
*/


/* =========================================================
   Question 6: Load Readiness Decision
   ========================================================= */

/*
a) Should this dataset be loaded directly?

No.

b) Justification:
1. Duplicate primary keys violate constraints
2. Missing and invalid Sales_Amount values exist
3. Inconsistent date formats cause parsing issues

Conclusion:
Dataset must be cleaned before loading.
*/


/* =========================================================
   Question 7: Pre-Load Validation Checklist
   ========================================================= */

/*
Required Pre-Load Checks:
1. Primary key uniqueness check on Order_ID
2. Missing value detection for Sales_Amount
3. Numeric validation for Sales_Amount
4. Date format standardization for Order_Date
5. Business rule checks (Sales_Amount > 0)
6. Referential integrity validation for Customer_ID

Conclusion:
Pre-load checks prevent failures and protect data quality.
*/


/* =========================================================
   Question 8: Cleaning Strategy
   ========================================================= */

/*
Step-by-step Cleaning Actions:
1. Remove or resolve duplicate Order_ID records
2. Handle NULL Sales_Amount values using business rules
3. Convert textual numeric values to valid numbers
4. Standardize Order_Date to YYYY-MM-DD format
5. Apply business rule validation
6. Log rejected records in error tables

Conclusion:
Cleaning ensures smooth loading and reliable analytics.
*/


/* =========================================================
   Question 9: Loading Strategy Selection
   ========================================================= */

/*
a) Recommended Strategy:
Incremental Load

b) Justification:
- Dataset represents daily sales data
- Incremental load processes only new records
- Improves performance and scalability
- Reduces risk of duplicate reprocessing

Conclusion:
Incremental load is optimal for transactional data.
*/


/* =========================================================
   Question 10: BI Impact Scenario
   ========================================================= */

/*
a) Incorrect KPI results:
- Inflated Total Sales due to duplicates
- Reduced totals due to NULL values
- Incorrect trends due to bad dates

b) Records causing misleading insights:
- O101 (duplicate)
- O102 (NULL Sales_Amount)
- O104 (text Sales_Amount)
- O103 (date format issue)

c) Why BI tools do not detect issues:
- BI tools assume data is clean
- No enforcement of business rules
- Aggregations occur without semantic checks

Conclusion:
Without ETL validation, BI dashboards confidently show
incorrect results.
*/
