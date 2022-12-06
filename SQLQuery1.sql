Select * 
From PortfolioProject..Covid19Death 
where continent is not null
order by 3,4

--Select * 
--From PortfolioProject..Covid19Vaccination 
--order by 3,4

--select Data that we are going to be using

--Select Location, date, total_cases, new_cases, total_deaths, population
--from PortfolioProject..Covid19Death
--order by 1, 2

--looking at total cases vs total deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..Covid19Death
where location like '%india%'
order by 1, 2

---looking art total case vs population
--shows what percantage of population got covid

Select Location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
from PortfolioProject..Covid19Death
where location like '%india%'
order by 1, 2

--looking at countries with highest infection rate compared to population

Select Location, population, Max(total_cases) as HighestCovidcases, MAX(total_cases/population)*100 as HighestPercentageCovidCases
from PortfolioProject..Covid19Death
group by location, population
--where location like '%india%
order by HighestPercentageCovidCases desc

--showing countries with highest  Death count per population
Select location, Max(total_deaths) as TotalDeathCount
from PortfolioProject..Covid19Death
where continent is not null
group by location
order by TotalDeathCount desc

--lets break things down by continent
Select location, Max(total_deaths) as TotalDeathCount
from PortfolioProject..Covid19Death
where continent is not null
group by location
order by TotalDeathCount desc

--showing continents with highest death per count

Select continent, Max(total_deaths) as TotalDeathCount
from PortfolioProject..Covid19Death
where continent is not null
group by continent
order by TotalDeathCount desc


--breaking of global numbers
Select sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as GlobalDeathPer
from PortfolioProject..Covid19Death
where continent is not null
--group by date
order by 1, 2


------------ new ---------------


--lookin for total population vs total vaxccine


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date)
 as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid19Death dea
join PortfolioProject..Covid19Vaccination vac
	on dea.location =  vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3





--with using CTE
with popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVAccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date)
 as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid19Death dea
join PortfolioProject..Covid19Vaccination vac
	on dea.location =  vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
select *, (RollingPeopleVAccinated/population)*100 as Peopel_vaccinated
from popvsvac





---------------------- TEMP TABLE -------------------------


drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date)
 as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid19Death dea
join PortfolioProject..Covid19Vaccination vac
	on dea.location =  vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 1,2,3
select *, (RollingPeopleVAccinated/population)*100 as Peopel_vaccinated
from #PercentPopulationVaccinated


--creating view to store data for later data visualization



CREATE VIEW PercentPopulationVaccinated
as Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date)
 as RollingPeopleVaccinated
From PortfolioProject..Covid19Death dea
join PortfolioProject..Covid19Vaccination vac
	on dea.location =  vac.location
	and dea.date = vac.date
where dea.continent is not null

Drop view PercentPopulationVaccinated


select * 
from PercentPopulationVaccinated