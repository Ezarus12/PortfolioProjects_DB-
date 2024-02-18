/*
Daily caloric supply per person Data Exploration
February 2024
Datasets downloaded from https://ourworldindata.org/grapher/daily-caloric-supply-derived-from-carbohydrates-protein-and-fat

Skills used: CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

Tools used: SQL, SQL Server Management Studio 19, SQL Server 2022, Excel, Google Sheets
*/



SELECT *
FROM PortfolioProject..DailyCaloricSupply;

-- Selecting data to be used
SELECT Entity, Year, [Daily caloric intake per person from carbohydrates], [Daily caloric intake per person from fat], [Daily caloric intake per person that comes from animal protein], [Daily caloric intake per person that comes from vegetal protein]
FROM PortfolioProject..DailyCaloricSupply;


--Looking at daily caloric intake per person from protein
SELECT Entity, Year, CAST([Daily caloric intake per person that comes from animal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person that comes from vegetal protein] AS DECIMAL(10,2))  AS 'Daily caloric intake per person from protein'
FROM PortfolioProject..DailyCaloricSupply
ORDER BY 1,2;


--Looking at daily caloric intake per person from protein in Poland
SELECT Entity, Year, CAST([Daily caloric intake per person that comes from animal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person that comes from vegetal protein] AS DECIMAL(10,2))  AS 'Daily caloric intake per person from protein'
FROM PortfolioProject..DailyCaloricSupply
WHERE Entity = 'Poland';


--Finding the highest caloric intake per person from protein by year in Poland
SELECT Entity, Year, CAST([Daily caloric intake per person that comes from animal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person that comes from vegetal protein] AS DECIMAL(10,2))  AS 'Daily caloric intake per person from protein'
FROM PortfolioProject..DailyCaloricSupply
WHERE Entity = 'Poland'
ORDER BY [Daily caloric intake per person from protein] DESC;


--Finding how many years the data have been collected in Poland
SELECT COUNT(Year)
FROM PortfolioProject..DailyCaloricSupply
WHERE Entity = 'Poland';


--Converting protein caloric intake into grams
SELECT Entity, Year, (CAST([Daily caloric intake per person that comes from animal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person that comes from vegetal protein] AS DECIMAL(10,2)))/4  AS 'Daily caloric intake per person from protein in grams'
FROM PortfolioProject..DailyCaloricSupply
WHERE Entity = 'Poland'
ORDER BY [Daily caloric intake per person from protein in grams];


--Finding Country with the highest caloric intake per person in 2020
SELECT Entity, Year, (CAST([Daily caloric intake per person that comes from animal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person that comes from vegetal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person from carbohydrates] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person from fat] AS DECIMAL(10,2))) AS 'Daily caloric intake per person'
FROM PortfolioProject..DailyCaloricSupply
WHERE Year = 2020
ORDER BY [Daily caloric intake per person] DESC;


--Finding the year with the lowest daily caloric intake per person in European Union
SELECT Entity, Year, (CAST([Daily caloric intake per person that comes from animal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person that comes from vegetal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person from carbohydrates] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person from fat] AS DECIMAL(10,2))) AS 'Daily caloric intake per person'
FROM PortfolioProject..DailyCaloricSupply
WHERE Entity LIKE '%Union (27)'
ORDER BY [Daily caloric intake per person] ASC;


--Temp Table
CREATE TABLE DailyCaloricIntakeinEU
(
Entity nvarchar(255),
Year float,
[Daily caloric intake per person] float
)

INSERT INTO DailyCaloricIntakeinEU
SELECT Entity, Year, (CAST([Daily caloric intake per person that comes from animal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person that comes from vegetal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person from carbohydrates] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person from fat] AS DECIMAL(10,2))) AS 'Daily caloric intake per person'
FROM PortfolioProject..DailyCaloricSupply
WHERE Entity LIKE '%Union (27)';

SELECT *
FROM DailyCaloricIntakeinEU;


--Removing the temp table
DROP TABLE DailyCaloricIntakeinEU;


--Creating view to store data for later visualizations for Daily caloric intake per person in Poland
CREATE VIEW DailyCaloricIntakeinPoland as
SELECT Entity, Year, (CAST([Daily caloric intake per person that comes from animal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person that comes from vegetal protein] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person from carbohydrates] AS DECIMAL(10,2)) + CAST([Daily caloric intake per person from fat] AS DECIMAL(10,2))) AS 'Daily caloric intake per person'
FROM PortfolioProject..DailyCaloricSupply
WHERE Entity = 'Poland';

