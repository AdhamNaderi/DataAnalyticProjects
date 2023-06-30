-- Datan esikatselua, data on saatu https://ourworldindata.org/covid-deaths sivustolta


-- T‰ss‰ tarkastelen tapaukset ja kuolemat alkaen 2020-01-03 00:00:00.000  nykyp‰iv‰‰n 2023-06-21 00:00:00.000, sek‰ ymp‰rimaailmaa Suomessa ja ymp‰ri maailmaa
-- Here I review cases and Deaths from 2020-01-03 00:00:00.000 to the present day 2023-06-21 00:00:00.000, as well as around the world in Finland and around the world
SELECT location, date, population, total_cases, total_deaths
FROM PortfolioProject..CovidDeaths
WHERE location = 'Finland'
ORDER BY date ASC


-- N‰ytt‰‰ Suomessa kuinka monta tapausta on per p‰iv‰ alkaen 2020-01-03 00:00:00.000  nykyp‰iv‰‰n 2023-06-21 00:00:00.000, sek‰ ymp‰rimaailmaa
-- Shows how many cases there are in Finland per day from 2020-01-03 00:00:00.000 to today 2023-06-21 00:00:00.000, and around the world
SELECT location, population, date, new_cases AS NewPatients
FROM PortfolioProject..CovidDeaths
WHERE location = 'Finland'
ORDER BY date ASC


-- N‰ytt‰‰ Suomessa kuinka monta ihmist‰ on menehtynyt per p‰iv‰ alkaen 2020-01-03 00:00:00.000 nykyp‰iv‰‰n 2023-06-21 00:00:00.000, sek‰ ymp‰rimaailmaa
-- Shows how many people have died in Finland per day from 2020-01-03 00:00:00.000 to today 2023-06-21 00:00:00.000, as well as around the world
SELECT location, population, date, total_deaths AS DeathCount
FROM PortfolioProject..CovidDeaths
WHERE location = 'Finland'
ORDER BY date ASC


-- N‰ytt‰‰ Suomessa kuinka tapaukset, kuolemat ja kuolleisuuden mahdollisuuden jos henkilˆˆn tarttuu Covid19 alkaen 2020-01-03 00:00:00.000 nykyp‰iv‰‰n 2023-06-21 00:00:00.000, sek‰ ymp‰rimaailmaa.
-- Shows how cases, Deaths and the possibility of mortality if a person catches Covid19 in Finland from 2020-01-03 00:00:00.000 to today 2023-06-21 00:00:00.000, and around the world.
SELECT location, population, date, total_cases, total_deaths,
	(CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100 AS MortalityRate
FROM PortfolioProject..CovidDeaths
WHERE location = 'Finland'
ORDER BY date ASC


-- N‰ytt‰‰ Suomessa tartunnan mahdollisuuden per p‰iv‰ alkaen 2020-01-03 00:00:00.000 nykyp‰iv‰‰n 2023-06-21 00:00:00.000, sek‰ ymp‰rimaailmaa
-- Shows the possibility of infection per day in Finland from 2020-01-03 00:00:00.000 to today 2023-06-21 00:00:00.000, as well as around the world
SELECT location, population, date, total_cases,
	(CAST(total_cases AS float) / population) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location = 'Finland'
ORDER BY date ASC

-- N‰ytt‰‰ Suomessa suurimman m‰‰r‰n mit‰ ihmisi‰ on tarttunut yhden p‰iv‰n aika alkaen 2020-01-03 00:00:00.000 nykyp‰iv‰‰n 2023-06-21 00:00:00.000, sek‰ ymp‰rimaailmaa
-- Shows the largest number of infected people in Finland in one day from 2020-01-03 00:00:00.000 to today 2023-06-21 00:00:00.000, as well as around the world
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((CAST(total_cases AS float) / population)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
-- WHERE location = 'Finland'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC


-- N‰ytt‰‰ valtiot miss‰ on suurin kuolleisuus Covid19 alkaen 2020-01-03 00:00:00.000 nykyp‰iv‰‰n 2023-06-21 00:00:00.000, sek‰ ymp‰rimaailmaa
-- Shows the countries with the highest mortality rate from Covid19 from 2020-01-03 00:00:00.000 to today 2023-06-21 00:00:00.000, as well as around the world
-- Also removed following 'High Income', 'Upper middle income', 'Lower middle income' rows from the column "location", because they looked odd in the results.
DELETE FROM PortfolioProject..CovidDeaths
WHERE location IN ('High Income', 'Upper middle income', 'Lower middle income')
SELECT location, MAX(CAST(total_deaths AS float)) AS HighestDeathCount
FROM PortfolioProject..CovidDeaths
GROUP BY location
ORDER by HighestDeathCount DESC


-- N‰ytt‰‰ miss‰ maanosasso on suurin kuolleisuus Covid19 alkaen 2020-01-03 00:00:00.000 nykyp‰iv‰‰n 2023-06-21 00:00:00.000, sek‰ ymp‰rimaailmaa
-- Shows the countries with the highest mortality rate from Covid19 from 2020-01-03 00:00:00.000 to today 2023-06-21 00:00:00.000, as well as around the world
SELECT continent, MAX(CAST(total_deaths AS float)) AS HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeathCount DESC


-- N‰ytt‰‰ miten paljon ymp‰ri maailmaa on ihmisi‰ saannut Covid19 tartunnan, kuinka paljon on kuollut ja prosentteina myˆs alkaen 2020-01-03 00:00:00.000 nykyp‰iv‰‰n 2023-06-21 00:00:00.000
-- Shows how many people around the world have been infected with Covid19, how many have died and also in percentages from 2020-01-03 00:00:00.000 to today 2023-06-21 00:00:00.000
SELECT
    SUM(CAST(new_cases AS float)) AS TotalCasesGlobal,
    SUM(CAST(new_deaths AS float)) AS TotalDeathsGlobally,
    SUM(CAST(new_deaths AS float)) / SUM(CAST(new_cases AS float)) * 100 AS GlobalDeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1,2


-- Vertaamme populaatiota ja rokotteita.
-- Comparing population and vaccinations

SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
	SUM(CAST(Vac.new_vaccinations as float)) OVER (PARTITION BY Dea.location ORDER BY Dea.location, 
	Dea.date) AS PeopleVaccinated
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
	ON Dea.location = Vac.location
	AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL AND Dea.Location = 'Finland'
ORDER BY 2,3


-- Common Table Expression Testing

WITH Vaccinated (Continent, location, date, population, new_vaccinations, PeopleVaccinated)
AS
(
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
	SUM(CAST(Vac.new_vaccinations as float)) OVER (PARTITION BY Dea.location ORDER BY Dea.location, 
	Dea.date) AS PeopleVaccinated
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
	ON Dea.location = Vac.location
	AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL AND Dea.Location = 'Finland'
-- ORDER BY 2,3
)
SELECT *, (PeopleVaccinated/population)*100 AS PercentagePopulationVaccinated
FROM Vaccinated


-- Creating data for visualizations.

USE PortfolioProject
GO
CREATE VIEW PercentagePopulationVaccinated AS
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
	SUM(CAST(Vac.new_vaccinations as float)) OVER (PARTITION BY Dea.location ORDER BY Dea.location, 
	Dea.date) AS PeopleVaccinated
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
	ON Dea.location = Vac.location
	AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL AND Dea.Location = 'Finland'
-- ORDER BY 2,3