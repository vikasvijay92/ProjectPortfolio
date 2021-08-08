Select *
from PortfolioProject..CovidDeaths$
order by 3,4


--Select *
--from PortfolioProject..CovidVaccinations$
--order by 3,4

--Select Data that we are using
--Looking at Total Death Vs Total Population

select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
order by 1,2

--HIghest Infected Vs Population
select Location, population, Max(total_cases) as HighestInfected, Max((total_cases/population))*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths$
group by location, population
order by PercentagePopulationInfected desc

--Total Death Vs Population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--where continent is null
group by location
order by TotalDeathCount desc

select sum(New_Cases) as total_cases, sum( cast(new_deaths as int)) as total_deaths, sum( cast(new_deaths as int))/sum(New_Cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
--group by date
order by 1,2

With PopvsVac(location, date, continent, population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
On dea.location= vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


Create View PercentPeoplesVaccinated as
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
On dea.location= vac.location
and dea.date=vac.date
where dea.continent is not null

