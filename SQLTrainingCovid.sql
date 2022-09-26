--Covid Deaths

Select *
From PortfolioProject.. CovidDeaths
Where continent is not null
order by 3,4


--Covid Vaccinations

Select *
From PortfolioProject.. CovidVaccinations
Where continent is not null
order by 3,4


--Covid Deaths Filtered

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.. CovidDeaths
Where continent is not null
order by 1,2


--Total Cases vs Total Deats

Select location, date, total_cases, (total_deaths/total_cases)*100 as DeathPercantage
From PortfolioProject.. CovidDeaths
-- Where location like 'Finland'
order by 1,2


--Total Cases vs Population
--"How many dudes got Covid"

Select location, date,  population, total_cases, (total_cases/population)*100 as GotCovidPercantage
From PortfolioProject.. CovidDeaths
-- Where location like 'Finland'
order by 1,2


--Countries with highest infection rates compared to population

Select location, date, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercantagePopInfected
From PortfolioProject.. CovidDeaths
--Where location like 'Finland'
Group by location, date, population
order by PercantagePopInfected desc


--Countries with Highest Death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.. CovidDeaths
--Where location like 'Finland'
Where continent is not null
Group by location
order by TotalDeathCount desc


--By Continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.. CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercantage
From PortfolioProject.. CovidDeaths
order by 1,2


--Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
 dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/people)*100
From PortfolioProject.. CovidDeaths dea
join PortfolioProject.. CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

with PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)

as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
 dea.Date) as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/people)*100
From PortfolioProject.. CovidDeaths dea
join PortfolioProject.. CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *
From PopVsVac