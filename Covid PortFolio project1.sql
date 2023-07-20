
FIRST PROJECT 

select *
from PortfolioProject..CovidDeaths

select *
from PortfolioProject..CovidVaccinations

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 3,4

--looking at total cases vs tatal Death

Select location, date, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where location like '%Nigeria%'
order by 1,2

--looking at total cases vs population
--show what percentage of population got Covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentOfPopulationInfected 
FROM PortfolioProject..CovidDeaths
where location like '%Nigeria%'


Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentOfPopulationInfected 
FROM PortfolioProject..CovidDeaths
Group by location, population
order by PercentOfPopulationInfected desc


Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
Group by location, population
order by TotalDeathCount desc

--Lets Break things down to continent

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null
Group by location
order by TotalDeathCount desc

--Global Numbers

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM
  (new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
Group by date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM
  (new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
--Group by date
order by 1,2


--looking at total population vs vaccinations
SELECT *
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

select new_vaccination
from PortfolioProject..CovidVaccinations
	
ALTER TABLE PortfolioProject..CovidVaccinations
ADD new_vaccinations varchar(255)


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccination
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
order by 2,3







