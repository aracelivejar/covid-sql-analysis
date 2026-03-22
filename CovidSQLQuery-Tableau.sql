
--Interogari folosite pentru proiectul Tableau -- dashboard covid deaths and covid Infections


-- 1 Calcularea valorilor globale pentru cazurile si decesele Covid

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2



-- 2 Afisarea numarul total de de decese Covid pentru fiecare continent 

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3 Analiza tarile cu cea mai mare rata de infectare in comparatie cu populatia
-- Arata porcentul populatie infectate descrescator

select location,
population,
max(total_cases) as HighestInfectionCount,
max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
group by location,population
order by PercentPopulationInfected desc


-- 4 Analiza data din tarile cu cea mai mare rata de infectare in comparatie cu populatia
-- Arata porcentul populatie infectate descrescator


Select Location,
Population,
date,
MAX(total_cases) as HighestInfectionCount,  
Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc



-- --Interogari folosite pentru proiectul Tableau -- dashboard covid Vaccinations


/* 5 Analiza populatiei totale vs vaccinare prin combinarea tabelelor CovidDeaths si CovidVaccinations
afisand numarul de vaccinari noi si totalul vaccinarilor pentru fiecare locatie */

select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.Location order by dea.location, dea.date) as Total_VaccinatoinsCount
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not null
and vac.new_vaccinations is not null
order by 2,3


-- 6 Afisarea numarului total de Vaccinari pentru fiecare continent 

Select location, SUM(cast(new_vaccinations as float)) as TotalVaccinationsCount
From PortfolioProject..CovidVaccinations
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalVaccinationsCount desc





-- 7 Crearea unei CTE (Common Table Expression) numita PopvsVac
-- pentru a analiza relatia dintre populatie si numarul de vaccinari
with PopvsVac
(continent, location, date, population,new_vaccinations,Total_VaccinatoinsCount)
as
(select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations,b879kl0-e
sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.Location order by dea.location, dea.date) as Total_VaccinatoinsCount
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date  
where dea.continent is not null
and vac.new_vaccinations is not null)

select *,(Total_VaccinatoinsCount/population)*100 as Total_VaccinatoinsPercentage
from PopvsVac 

