
/*
### Question 1: Count how many cities are there in each country?

Answer:
-- SQL Query:
SELECT c.Name AS country_name,
       COUNT(ci.ID) AS num_cities
FROM country c
LEFT JOIN city ci
  ON c.Code = ci.CountryCode
GROUP BY c.Name
ORDER BY num_cities DESC;

/*
### Question 2: Display all continents having more than 30 countries.

Answer:


-- SQL Query:
SELECT Continent,
       COUNT(*) AS num_countries
FROM country
GROUP BY Continent
HAVING COUNT(*) > 30
ORDER BY num_countries DESC;

/*
### Question 3: List regions whose total population exceeds 200 million.

Answer:



-- SQL Query:
SELECT Region,
       SUM(Population) AS total_population
FROM country
GROUP BY Region
HAVING SUM(Population) > 200000000
ORDER BY total_population DESC;

/*
### Question 4: Find the top 5 continents by average GNP per country.

Answer:


-- SQL Query:
SELECT Continent,
       AVG(GNP) AS avg_gnp_per_country,
       COUNT(*) AS num_countries
FROM country
GROUP BY Continent
ORDER BY avg_gnp_per_country DESC
LIMIT 5;

/*
### Question 5: Find the total number of official languages spoken in each continent.

Answer:


-- SQL Query (distinct official languages):
SELECT c.Continent,
       COUNT(DISTINCT cl.Language) AS num_distinct_official_languages
FROM country c
JOIN countrylanguage cl
  ON c.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T'   -- or = TRUE depending on DB
GROUP BY c.Continent
ORDER BY num_distinct_official_languages DESC;

/*
### Question 6: Find the maximum and minimum GNP for each continent.

Answer:


-- SQL Query:
SELECT Continent,
       MAX(GNP) AS max_gnp,
       MIN(GNP) AS min_gnp
FROM country
GROUP BY Continent
ORDER BY Continent;

/*
### Question 7: Find the country with the highest average city population.

Answer:


-- SQL Query (single top result):
SELECT c.Name AS country_name,
       AVG(ci.Population) AS avg_city_population
FROM country c
JOIN city ci
  ON c.Code = ci.CountryCode
GROUP BY c.Name
ORDER BY avg_city_population DESC
LIMIT 1;

-- SQL Query (tie-aware: return all countries that share the maximum average):
WITH avg_per_country AS (
  SELECT c.Code, c.Name, AVG(ci.Population) AS avg_city_population
  FROM country c
  JOIN city ci ON c.Code = ci.CountryCode
  GROUP BY c.Code, c.Name
)
SELECT Name, avg_city_population
FROM avg_per_country
WHERE avg_city_population = (SELECT MAX(avg_city_population) FROM avg_per_country);

/*
### Question 8: List continents where the average city population is greater than 200,000.

Answer:



-- SQL Query:
SELECT c.Continent,
       AVG(ci.Population) AS avg_city_population
FROM country c
JOIN city ci
  ON c.Code = ci.CountryCode
GROUP BY c.Continent
HAVING AVG(ci.Population) > 200000
ORDER BY avg_city_population DESC;

/*
### Question 9: Find the total population and average life expectancy for each continent, ordered by average life expectancy descending.

Answer:



-- SQL Query:
SELECT Continent,
       SUM(Population) AS total_population,
       AVG(LifeExpectancy) AS avg_life_expectancy
FROM country
GROUP BY Continent
ORDER BY avg_life_expectancy DESC;

/*
### Question 10: Find the top 3 continents with the highest average life expectancy, but only include those where total population is over 200 million.

Answer:



-- SQL Query:
SELECT Continent,
       SUM(Population) AS total_population,
       AVG(LifeExpectancy) AS avg_life_expectancy
FROM country
GROUP BY Continent
HAVING SUM(Population) > 200000000
ORDER BY avg_life_expectancy DESC
LIMIT 3;

