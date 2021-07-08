SELECT locations, dates, total_cases,new_cases, total_deaths, population
FROM CovidDeaths;

--looking at total cases vs total deaths.
-- Shows the likelyhood of dying from covid

SELECT locations, dates, total_cases, total_deaths, (total_deaths/total_cases::REAL)*100 AS DeathPercent
FROM CovidDeaths
WHERE locations ='United States';

--Looking at the total_cases vs population
 SELECT locations, dates, total_cases, total_deaths, (total_cases/population::REAL)*100 AS PercentPopInfected
 FROM CovidDeaths
 WHERE locations='United States';
 
 --Looking at countries with the highest infection rate compared to population
 SELECT locations, population, MAX(total_cases) AS highestInfecRate, MAX((total_cases/population::REAL))*100 AS PercntPopInfected
FROM CovidDeaths
GROUP BY locations, population
ORDER BY PercntPopInfected DESC;

--Showing the countries with the highest death count per population
SELECT locations, Max(total_deaths) AS TotalDeathCount
FROM CovidDEATHS
WHERE continent != 'null'
GROUP BY locations
order by TotalDeathCount desc;

--BREAKING THINGS DOWN BY CONTINENT

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent <> 'null'
GROUP BY continent
ORDER BY TotalDeathCount desc;


--- SHOWING THE CONTINENTS WITH THE HIGHEST DEATH COUNT
SELECT continent, MAX(total_deaths) AS TotalDeathsCount
FROM CovidDeaths
WHERE continent <> 'null'
GROUP BY continent
ORDER BY TotalDeathsCount desc;

--BREAKING GLOBAL NUMBERS*
SELECT dates, SUM (new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases)::REAL)*100 AS DeathPercent
FROM CovidDeaths
WHERE continent <>'null'
GROUP BY dates;

---JOINING THE TWO TABLES
--- LOKOKING AT Total Population vs Vaccination
SELECT CD.continent, CD.locations, 
	CD.dates, CD.population,CV.new_vaccinations,
	SUM(CV.new_vaccinations) OVER
	(PARTITION BY CD.locations ORDER BY CD.locations,CD.dates) AS RollingPeopleVaccinated
FROM CovidDeaths AS CD
JOIN CovidVac AS CV ON CV.locations = CD.locations
	and CV.dates=CD.dates
WHERE CD.continent<>'null'
;

---CREATING VIEW FRO LATER VISUALIZATION

CREATE VIEW  PercentPopulationVaccinated AS
SELECT CD.continent, CD.locations, 
	CD.dates, CD.population,CV.new_vaccinations,
	SUM(CV.new_vaccinations) OVER
	(PARTITION BY CD.locations ORDER BY CD.locations,CD.dates) AS RollingPeopleVaccinated
FROM CovidDeaths AS CD
JOIN CovidVac AS CV ON CV.locations = CD.locations
	and CV.dates=CD.dates
WHERE CD.continent<>'null'
;

SELECT * FROM PercentPopulationVaccinated;