
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

-- Joining CovidDeath and CovidVaccination
SELECT *
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

--Looking at total population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
As CountingPeopleVaccinated
--, (CountingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Use CTE

WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, CountingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
As CountingPeopleVaccinated
--, (CountingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (CountingPeopleVaccinated/Population)*100
from PopvsVac

--TEMP TABLE
Drop Table if exists #PercentagePeopleVaccinated
CREATE TABLE #PercentagePeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric,
New_Vaccinations numeric,
CountingPeopleVaccinated numeric
)

insert into #PercentagePeopleVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
As CountingPeopleVaccinated
--, (CountingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (CountingPeopleVaccinated/Population)*100
from #PercentagePeopleVaccinated

select *
from #PercentagePeopleVaccinated



--Creating View to staore data for later visualization

Create view PercentagePeopleVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
As CountingPeopleVaccinated
--, (CountingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
from PercentagePeopleVaccinated
