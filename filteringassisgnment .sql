USE world ;
SELECT * FROM world.city;
SELECT * FROM world.country;
SELECT * FROM world.countrylanguage;

-- Question 1: Count how many cities are there in each country?

SELECT CountryCode,
COUNT(*) AS Number_Of_Cities
FROM City
GROUP BY CountryCode;

-- Question 2: Display all continents having more than 30 countries.

SELECT Continent FROM Country
GROUP BY Continent
HAVING COUNT(Code) > 30;

-- if you also want to see the count of countries 
SELECT Continent,
COUNT(Code) AS Number_Of_Countries
FROM Country
GROUP BY Continent
HAVING COUNT(Code) > 30;

-- Question 3: List regions whose total population exceeds 200 million.

SELECT Region from country 
GROUP BY Region
HAVING SUM(Population) > 200000000;

-- if you also want to see the count of POPULATION 

SELECT Region ,
SUM(Population) AS Total_Population
from country 
GROUP BY Region
HAVING Total_Population > 200000000;

-- Question 4: Find the top 5 continents by average GNP per country.

SELECT Continent,
AVG(GNP) AS Average_GNP
FROM Country
WHERE GNP IS NOT NULL  -- Excludeing countries having null GNP 
GROUP BY Continent
ORDER BY AverageGNP DESC
LIMIT 5;

-- Question 5: Find the total number of official languages spoken in each continent.

SELECT Country.Continent,
COUNT(CountryLanguage.Language) AS total_Official_Languages
FROM Country
JOIN CountryLanguage ON Country.Code = CountryLanguage.CountryCode
WHERE CountryLanguage.IsOfficial = 'T'
GROUP BY Country.Continent;

-- Question 6: Find the maximum and minimum GNP for each continent. 

SELECT Continent,
MAX(GNP) AS maximum_GNP,
MIN(GNP) AS minimum_GNP
FROM Country
WHERE GNP IS NOT NULL         -- Excludeing  null values 
GROUP BY Continent;

-- Question 7: Find the country with the highest average city population.
SELECT
    T1.Name AS CountryName,
    T2.AvgCityPopulation
FROM Country AS T1
JOIN
    (--  Calculateing the average city population for each country
        SELECT CountryCode,
		AVG(Population) AS AvgCityPopulation
        FROM city
        GROUP BY CountryCode
    ) AS T2 ON T1.Code = T2.CountryCode 
ORDER BY T2.AvgCityPopulation DESC
LIMIT 1; --  it will Show only the country with the highest values

-- Question 8: List continents where the average city population is greater than 200,000.

SELECT
    T1.Continent,
    AVG(T2.AvgCityPopulation) AS ContinentAvgCityPopulation 
FROM Country AS T1
JOIN
    (--  Calculating  the average city population for each country
        SELECT CountryCode,
		AVG(Population) AS AvgCityPopulation
        FROM City
        GROUP BY CountryCode
    ) AS T2 ON T1.Code = T2.CountryCode 
GROUP BY T1.Continent
HAVING AVG(T2.AvgCityPopulation) > 200000; -- Filtering it  to keep only continents whose average is above 2,00,000

-- Question 9 : Find the total population and average life expectancy for each continent, ordered by average life expectancy descending.

SELECT Continent,
	SUM(Population) AS Total_Population,
	AVG(LifeExpectancy) AS average_Life_Expectancy
FROM Country
WHERE LifeExpectancy IS NOT NULL -- Excludeing  null values 
GROUP BY Continent
ORDER BY average_Life_Expectancy DESC;

-- Question 10 : Find the top 3 continents with the highest average life expectancy, but only include those where the total population is over 200 million.

SELECT Continent,
    AVG(LifeExpectancy) AS average_Life_Expectancy,
    SUM(Population) AS Total_Population
FROM Country
WHERE LifeExpectancy IS NOT NULL    -- Excludeing  null values 
GROUP BY Continent
HAVING Total_Population > 200000000
ORDER BY average_Life_Expectancy DESC
LIMIT 3;
