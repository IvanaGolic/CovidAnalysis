Select *
From PortfolioProject..CovidDeath

--Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths
From PortfolioProject..CovidDeath
Order By 1,2

--Looking at Total Cases vs Total deaths


Select location, date, total_cases, total_deaths, (CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100 AS DeathPercentage
From PortfolioProject..CovidDeath
Where location like '%states%'
Order by 1,2

--total_deaths and total_cases - Operand data type nvarchar is invalid for divide operator
--(CAST(total_deaths AS float) / CAST(total_cases AS float))

--Shows likelihood of dying if you contact covid in your country
Select location, date, total_cases, total_deaths, (CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100 AS DeathPercentage
From PortfolioProject..CovidDeath
Where location like '%states%'
Order by 1,2

--Looking at Total Cases VS Population 

Select location, date, total_cases, population, (CAST(total_cases AS float) / CAST(population AS float)) * 100 AS PercentPopulationInfected
From PortfolioProject..CovidDeath
Where location like '%states%'
Order by 1,2


-- Looking at countries with Highest infection rate compared to Population

Select location, population, MAX(CAST(total_cases AS float)) as HighestInfectionCount, MAX 
(CAST(total_cases AS float) / CAST(population AS float)) * 100 AS PercentPopulationInfected
From PortfolioProject..CovidDeath
--Where location like '%states%'
Group by location, population
Order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count Per Population

Select location, MAX(CAST(total_deaths AS float)) as TotalDeathCount
From PortfolioProject..CovidDeath
--Where location like '%states%'
Where continent is not null
Group by location
Order by TotalDeathCount desc

--LET's BREAK THINGS DOWN BY CONTINENT

Select continent, MAX(CAST(total_deaths AS float)) as TotalDeathCount
From PortfolioProject..CovidDeath
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Showing Continents with the highest death count per popilation

Select continent, MAX(CAST(total_deaths AS float)) as TotalDeathCount
From PortfolioProject..CovidDeath
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc



-- Global numbers


Select date, SUM(CAST(new_cases AS int)), SUM(CAST(new_deaths AS int)), SUM(CAST(new_deaths AS int)) / SUM(CAST(new_cases AS int))*100 as DeathPercentage
From PortfolioProject..CovidDeath
--Where location like '%states%'
Where continent is not null
Group by date
Order by 1,2


Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_death, SUM(new_deaths) / NULLIF(SUM(new_cases),0)*100 as DeathPercentage
From PortfolioProject..CovidDeath
--Where location like '%states%'
Where continent is not null
Group by date
Order by 1,2

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_death, SUM(new_deaths) / NULLIF(SUM(new_cases),0)*100 as DeathPercentage
From PortfolioProject..CovidDeath
--Where location like '%states%'
Where continent is not null
--Group by date
Order by 1,2

--Looking at Total Population VS Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.Location)/ NULLIF(vac.new_vaccinations, 0) AS VaccinationPercentage
From PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
Order by 2,3


--In this example, we use the CAST function to convert the "new_vaccinations" column from the "CovidVaccinations" table to the "bigint" data type during the summation. This will prevent any potential overflow errors if the values become too large to be stored in an integer data type.


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVacinated
From PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--With rolling count we calculate 1 amount from row and next and bring total to the first row and then adding new amount form next row and rolling amounts to the end


--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVacinated
From PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
)
SELECT *, RollingPeopleVaccinated / Population * 100
FROM PopvsVac;

--Temp Table

DROP TABLE If exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVacinated
From PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
--order by 2,3



Select *, (RollingPeopleVaccinated / Population) * 100 As RollingPopulation
From #PercentPopulationVaccinated

--Creating View to store data for later visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVacinated
From PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select * 
From PercentPopulationVaccinated