USE assignment2 ;            -- USING THE DATABASE NAMED assignment2
SELECT * FROM Employee;      -- RETRIVE EMPLOYEE TABLE 
SELECT * FROM Department ;   -- RETRIVE DEPARTMENT TABLE 
SELECT * FROM  sales ;       -- RETRIVE sales TABLE 

--                                  Basic Level

-- 1.Retrieve the names of employees who earn more than the average salary of all employees.

SELECT name  
FROM employee 
WHERE salary > (SELECT AVG(salary) FROM employee);

-- if you want salary to display 
SELECT name , salary 
FROM employee 
WHERE salary > (SELECT AVG(salary) FROM employee);

-- 2. Find the employees who belong to the department with the highest average salary.

SELECT name FROM Employee      -- as question only asked for empolyess so i used "name" only other wise we can choose SELECT * FROM employee
WHERE department_id = (
    SELECT department_id 
    FROM Employee 
    GROUP BY department_id 
    ORDER BY AVG(salary) DESC 
    LIMIT 1
);

-- 3. List all employees who have made at least one sale. 
SELECT DISTINCT Employee.name
FROM Employee 
JOIN sales  ON Employee.emp_id = sales. emp_id;

-- 4. Find the employee with the highest sale amount 

SELECT  name FROM Employee 
WHERE emp_id =(
	SELECT emp_id 
    from sales
    order by sale_amount DESC
    LIMIT 1
);
-- FOR THE ALL THE DATILS OF EMPLOYEE 

SELECT * FROM employee
WHERE emp_id = (SELECT emp_id FROM sales ORDER BY sale_amount DESC LIMIT 1);

-- 5. Retrieve the names of employees whose salaries are higher than Shubham’s salary.

SELECT name 
FROM employee 
WHERE salary > (SELECT salary FROM employee WHERE name = 'Shubham');



--                                                     Intermediate Level

-- 6. Find employees who work in the same department as Abhishek.

SELECT name 
FROM Employee 
WHERE department_id = (SELECT department_id FROM Employee WHERE name = 'Abhishek')
AND name != 'Abhishek';

-- 7. List departments that have at least one employee earning more than ₹60,000 
SELECT DISTINCT  department_name  
FROM department 
WHERE department_id IN (SELECT department_id FROM employee WHERE salary > 60000);

-- 8 . Find the department name of the employee who made the highest sale. 
SELECT department_name 
FROM department 
WHERE department_id = (
    SELECT department_id 
    FROM employee 
    WHERE emp_id = (
		SELECT emp_id FROM sales 
		ORDER BY sale_amount DESC 
		LIMIT 1)
);


-- 9. Retrieve employees who have made sales greater than the average sale amount. 

SELECT DISTINCT employee.name 
FROM employee 
JOIN sales on employee.emp_id = sales.emp_id 
WHERE sales.sale_amount > (SELECT AVG(sale_amount) FROM sales) ;

-- 10 . Find the total sales made by employees who earn more than the average salary. 
SELECT SUM(sale_amount) AS total_sales
FROM sales 
WHERE emp_id IN (
	SELECT emp_id FROM employee 
    WHERE salary > (SELECT AVG(salary) FROM employee)
    );

--                                                             Advanced Level 

-- 11.Find employees who have not made any sales. 

SELECT name 
FROM employee 
WHERE emp_id NOT IN (SELECT DISTINCT emp_id FROM sales);

-- 12. List departments where the average salary is above ₹55,000. 

SELECT department_name 
FROM department 
WHERE department_id IN (
    SELECT department_id 
    FROM employee 
    GROUP BY department_id 
    HAVING AVG(salary) > 55000
);

-- 13. Retrieve department names where the total sales exceed ₹10,000. 

SELECT department.department_name
FROM department 
JOIN employee ON department.department_id = employee.department_id
JOIN sales ON employee.emp_id = sales.emp_id
GROUP BY department.department_name
HAVING SUM(sales.sale_amount) > 10000 ;

-- 14. Find the employee who has made the second-highest sale. 
SELECT name FROM employee  -- to see whole deatils we can use SELECT * FROM employee
WHERE emp_id = (
    SELECT emp_id 
    FROM sales 
    ORDER BY sale_amount DESC 
    LIMIT 1 OFFSET 1
);

-- 15. Retrieve the names of employees whose salary is greater than the highest sale amount recorded.
SELECT name 
FROM employee 
WHERE salary > (SELECT MAX(sale_amount) FROM sales);


