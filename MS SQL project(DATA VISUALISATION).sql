
SELECT * FROM 
PORTFOLIOPROJECT..COVIDdeaths WHERE CONTINENT IS NOT NULL
ORDER BY 3,4;


SELECT * FROM 
PORTFOLIOPROJECT..COVIDVACCINATIONS ORDER BY 3,4;

--SELECT DATA THAT WE ARE GOING TO USE

SELECT LOCATION,DATE,TOTAL_CASES,TOTAL_DEATHS,
NEW_CASES,POPULATION FROM PORTFOLIOPROJECT..COVIDDEATHS
ORDER BY 1,2;

--LOOKING AT TOTALCASES VS TOTALDEATHS;
--SHOWS % OF DYING DUE TO COVID IN YOUR COUNTRY

SELECT LOCATION,DATE,TOTAL_CASES,TOTAL_DEATHS,
(TOTAL_DEATHS/TOTAL_CASES)*100 AS DEATHPERCENTAGE
 FROM PORTFOLIOPROJECT..COVIDDEATHS
 WHERE LOCATION LIKE '%STATE%'
ORDER BY 1,2;

SELECT LOCATION,DATE,TOTAL_CASES,TOTAL_DEATHS,
(TOTAL_DEATHS/TOTAL_CASES)*100 AS DEATHPERCENTAGE
 FROM PORTFOLIOPROJECT..COVIDDEATHS
 WHERE LOCATION LIKE '%INDIA%' ORDER BY 1,2;


--LOOKING AT TOTALCASES VS POPULATION
 --SHOWS WHAT % OF POPULATION GOT COVID

SELECT LOCATION,DATE,TOTAL_CASES,POPULATION,
(TOTAL_CASES/POPULATION)*100 AS CASEPERCENTAGE
 FROM PORTFOLIOPROJECT..COVIDDEATHS
 WHERE LOCATION LIKE '%STATE%'
ORDER BY 1,2;

SELECT LOCATION,DATE,TOTAL_CASES,POPULATION,
(TOTAL_CASES/POPULATION)*100 AS CASEPERCENTAGE
 FROM PORTFOLIOPROJECT..COVIDDEATHS
 WHERE LOCATION LIKE '%INDIA%'
ORDER BY 1,2;


--LOOKING AT COUNTRIES THAT HAS HIGHEST INFECTION RATE WITH POPULATION
--WHERE LOCATION LIKE STATES,INDIA

SELECT LOCATION,POPULATION, 
MAX (TOTAL_CASES)AS HIGHESTINFECTIONCOUNT
,MAX((TOTAL_CASES/POPULATION))*100 AS PERCENTPOPULATIONINFECTED 
FROM PORTFOLIOPROJECT..COVIDDEATHS GROUP BY 
LOCATION,POPULATION ORDER BY PERCENTPOPULATIONINFECTED DESC;

--TO SEE FOR PARTICULAR COUNTRY
SELECT LOCATION,POPULATION, 
MAX (TOTAL_CASES)AS HIGHESTINFECTIONCOUNT
,MAX((TOTAL_CASES/POPULATION))*100 AS PERCENTPOPULATIONINFECTED 
FROM PORTFOLIOPROJECT..COVIDDEATHS WHERE LOCATION LIKE '%INDIA%' GROUP BY 
LOCATION,POPULATION ORDER BY PERCENTPOPULATIONINFECTED  DESC;



--LOOKING AT COUNTRIES THAT HAS HIGHEST DEATHCOUNT WITH POPULATION

SELECT LOCATION,MAX(CAST(TOTAL_DEATHS AS INT))
AS HIGHESTDEATHCOUNT FROM PORTFOLIOPROJECT..COVIDDEATHS
WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION
ORDER BY HIGHESTDEATHCOUNT DESC;



SELECT LOCATION,MAX(CAST(TOTAL_DEATHS AS INT))
AS HIGHESTDEATHCOUNT,
MAX(TOTAL_DEATHS/POPULATION)*100 AS PERCENTPOPULATIONDEATHS
FROM PORTFOLIOPROJECT..COVIDDEATHS WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION
ORDER BY PERCENTPOPULATIONDEATHS DESC;


--LOOKING AT CONTINENTS THAT HAS HIGHESTDEATHCOUNT

SELECT LOCATION,MAX(CAST(TOTAL_DEATHS AS INT))
AS HIGHESTDEATHCOUNT FROM PORTFOLIOPROJECT..COVIDDEATHS
WHERE CONTINENT IS NULL
GROUP BY LOCATION
ORDER BY HIGHESTDEATHCOUNT DESC;

--GLOBAL NUMBERS
--TOTALCASES,TOTALDEATHS,DEATHPERCENTAGE ACROSS THE WORLD PER DAY

SELECT DATE,SUM(NEW_CASES) AS TOTALCASES
,SUM(CAST(NEW_DEATHS AS INT)) AS TOTALDEATHS ,
(SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES))*100 AS DEATHPERCENTAGE
 FROM PortfolioProject..covidDEATHS 
WHERE CONTINENT IS NOT NULL
GROUP BY DATE ORDER BY 1,2;

--TOTALCASES,TOTALDEATHS UPTO 30APRIL 2021
SELECT SUM(NEW_CASES) AS TOTALCASES
,SUM(CAST(NEW_DEATHS AS INT)) AS TOTALDEATHS ,
(SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES))*100 AS DEATHPERCENTAGE
 FROM PortfolioProject..covidDEATHS 
WHERE CONTINENT IS NOT NULL
 ORDER BY 1,2;

--JOINING OUR 2 TABLES ON LOCATION,DATE

 SELECT * FROM PORTFOLIOPROJECT..COVIDDEATHS DEA JOIN
 PORTFOLIOPROJECT..COVIDVACCINATIONS VAC 
 ON DEA.LOCATION=VAC.LOCATION AND DEA.DATE=VAC.DATE;


 --LOOKING AT TOTALPOPULATION VS VACCINATIONS

SELECT DEA.CONTINENT,DEA.LOCATION,
DEA.DATE,DEA.POPULATION,VAC.NEW_VACCINATIONS
FROM PORTFOLIOPROJECT..COVIDDEATHS DEA JOIN
PORTFOLIOPROJECT..COVIDVACCINATIONS VAC 
ON DEA.LOCATION=VAC.LOCATION AND DEA.DATE=VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL  ORDER BY 1,2,3;

--FOR A PARTICULAR COUNTRY/CONTINENT


SELECT DEA.CONTINENT,DEA.LOCATION,
DEA.DATE,DEA.POPULATION,VAC.NEW_VACCINATIONS
FROM PORTFOLIOPROJECT..COVIDDEATHS DEA JOIN
PORTFOLIOPROJECT..COVIDVACCINATIONS VAC 
ON DEA.LOCATION=VAC.LOCATION AND DEA.DATE=VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL AND
DEA.LOCATION LIKE '%INDIA%'  ORDER BY 2,3;

--FOR A PARTICULAR DATE

SELECT DEA.CONTINENT,DEA.LOCATION,
DEA.DATE,DEA.POPULATION,VAC.NEW_VACCINATIONS
FROM PORTFOLIOPROJECT..COVIDDEATHS DEA JOIN
PORTFOLIOPROJECT..COVIDVACCINATIONS VAC 
ON DEA.LOCATION=VAC.LOCATION AND DEA.DATE=VAC.DATE
WHERE DAY(DEA.DATE)='01' AND
MONTH(DEA.DATE)='03' AND YEAR(DEA.DATE)='2021' AND
 DEA.CONTINENT IS NOT NULL ORDER BY 2,3;


 --FOR PARTITION BY LOCATION

SELECT DEA.CONTINENT,DEA.LOCATION,
DEA.DATE,DEA.POPULATION,VAC.NEW_VACCINATIONS,
SUM(CONVERT(INT,VAC.NEW_VACCINATIONS))  
OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,DEA.DATE) AS TOTALVACCINATIONS
FROM PORTFOLIOPROJECT..COVIDDEATHS DEA JOIN
PORTFOLIOPROJECT..COVIDVACCINATIONS VAC 
ON DEA.LOCATION=VAC.LOCATION AND DEA.DATE=VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL  ORDER BY 1,2,3;


--USING CTE TO FIND PERCENTAGE OF VACCINATION BY DATE


WITH CTE_VACCINATIONS AS
(SELECT DEA.CONTINENT,DEA.LOCATION,
DEA.DATE,DEA.POPULATION,VAC.NEW_VACCINATIONS,
SUM(CONVERT(INT,VAC.NEW_VACCINATIONS))  
OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,DEA.DATE)
AS TOTALVACCINATIONS
FROM PORTFOLIOPROJECT..COVIDDEATHS DEA JOIN
PORTFOLIOPROJECT..COVIDVACCINATIONS VAC 
ON DEA.LOCATION=VAC.LOCATION AND DEA.DATE=VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL)
SELECT *,(TOTALVACCINATIONS/POPULATION)*100
AS VACCINATIONPERCENTAGE FROM CTE_VACCINATIONS;


--USING TEMP TABLE

DROP TABLE IF EXISTS #PERCENTPOPULATIONVACCINATED 
CREATE TABLE #PERCENTPOPULATIONVACCINATED
(
CONTINENT NVARCHAR(255),
LOCATION NVARCHAR(255),
DATE DATETIME,
POPULATION NUMERIC,
NEW_VACCINATIONS NUMERIC,
TOTALVACCINATIONS NUMERIC
)

INSERT INTO #PERCENTPOPULATIONVACCINATED 
SELECT DEA.CONTINENT,DEA.LOCATION,
DEA.DATE,DEA.POPULATION,VAC.NEW_VACCINATIONS,
SUM(CONVERT(INT,VAC.NEW_VACCINATIONS))  
OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,DEA.DATE)
AS TOTALVACCINATIONS
FROM PORTFOLIOPROJECT..COVIDDEATHS DEA JOIN
PORTFOLIOPROJECT..COVIDVACCINATIONS VAC 
ON DEA.LOCATION=VAC.LOCATION AND DEA.DATE=VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL

SELECT *,(TOTALVACCINATIONS/POPULATION)*100
 FROM #PERCENTPOPULATIONVACCINATED;



 --CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

 CREATE VIEW PERCENTPOPULATIONVACCINATED AS
SELECT DEA.CONTINENT,DEA.LOCATION,
DEA.DATE,DEA.POPULATION,VAC.NEW_VACCINATIONS,
SUM(CONVERT(INT,VAC.NEW_VACCINATIONS))  
OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,DEA.DATE)
AS TOTALVACCINATIONS
FROM PORTFOLIOPROJECT..COVIDDEATHS DEA JOIN
PORTFOLIOPROJECT..COVIDVACCINATIONS VAC 
ON DEA.LOCATION=VAC.LOCATION AND DEA.DATE=VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL;



SELECT * FROM PERCENTPOPULATIONVACCINATED;




