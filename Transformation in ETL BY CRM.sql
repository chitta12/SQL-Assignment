/* =========================================================
   Assignment: Transformation in ETL
   ========================================================= */


/* ---------------------------------------------------------
   Question 1:
   Define Data Transformation in ETL and explain why it is important.
   --------------------------------------------------------- */

-- Answer:
-- Data Transformation in ETL is the process of converting raw data
-- extracted from different sources into a clean, consistent,
-- and structured format before loading it into a target system.

-- It is important because:
-- 1. It improves data quality by fixing errors and inconsistencies
-- 2. It ensures uniform data format across multiple sources
-- 3. It makes data suitable for analysis and reporting
-- 4. It helps in accurate business decision making


/* ---------------------------------------------------------
   Question 2:
   List any four common activities involved in Data Cleaning.
   --------------------------------------------------------- */

-- Answer:
-- 1. Removing duplicate records
-- 2. Handling missing or NULL values
-- 3. Correcting inconsistent data entries
-- 4. Removing invalid or incorrect data


/* ---------------------------------------------------------
   Question 3:
   What is the difference between Normalization and Standardization?
   --------------------------------------------------------- */

-- Answer:
-- Normalization:
-- It scales data between 0 and 1 using Min-Max scaling.
-- It is sensitive to outliers.

-- Standardization:
-- It scales data so that mean becomes 0 and standard deviation becomes 1.
-- It is less affected by outliers.


/* ---------------------------------------------------------
   Question 4:
   A dataset has missing values in the "Age" column.
   Suggest two techniques to handle this and explain when they should be used.
   --------------------------------------------------------- */

-- Answer:
-- Technique 1: Mean or Median Imputation
-- Used when missing values are few and data is numerical.

UPDATE users
SET age = (
    SELECT AVG(age)
    FROM users
)
WHERE age IS NULL;

-- Technique 2: Removing rows with missing values
-- Used when missing values are very few and dataset size is large.

DELETE FROM users
WHERE age IS NULL;


/* ---------------------------------------------------------
   Question 5:
   Convert the following inconsistent "Gender" entries into
   a standardized format ("Male", "Female"):
   ["M", "male", "F", "Female", "MALE", "f"]
   --------------------------------------------------------- */

-- Answer:

UPDATE users
SET gender = CASE
    WHEN LOWER(gender) IN ('m', 'male') THEN 'Male'
    WHEN LOWER(gender) IN ('f', 'female') THEN 'Female'
    ELSE gender
END;


/* ---------------------------------------------------------
   Question 6:
   What is One-Hot Encoding?
   Give an example with the categories: "Red", "Blue", "Green".
   --------------------------------------------------------- */

-- Answer:
-- One-Hot Encoding is a technique used to convert categorical
-- variables into numerical format by creating binary columns.

-- Example representation:
-- Red   -> 1 0 0
-- Blue  -> 0 1 0
-- Green -> 0 0 1


/* ---------------------------------------------------------
   Question 7:
   Explain the difference between Data Integration and Data Mapping in ETL.
   --------------------------------------------------------- */

-- Answer:
-- Data Integration:
-- It is the process of combining data from multiple sources
-- into a single unified view.

-- Data Mapping:
-- It defines the relationship between source fields and target fields
-- during data transfer.


/* ---------------------------------------------------------
   Question 8:
   Explain why Z-score Standardization is preferred over
   Min-Max Scaling when outliers exist.
   --------------------------------------------------------- */

-- Answer:
-- Z-score Standardization is preferred when outliers exist
-- because it uses mean and standard deviation, which reduces
-- the impact of extreme values.

-- Min-Max Scaling is affected by outliers since it depends
-- on minimum and maximum values, causing data distortion.

