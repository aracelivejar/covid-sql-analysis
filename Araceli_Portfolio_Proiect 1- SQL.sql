-- Afisarea datelor CovidDeaths
select *
from PortfolioProject..CovidDeaths


--Afisarea datelor covid pentru fiecare tara
--Filtrarea fara continent si sortarea dupa data si populatie
select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by date,population;


--Afisearea datelor CovidVaccionation 
-- filtratea fara continent
SELECT *
FROM PortfolioProject..CovidVaccinations
where continent is not null



-- Afisera total de cazuri,decese,cazuri noi si populatie
--ordonate dupa locatie si data
Select location, date, total_cases,new_cases, total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2;


--Probalitatea de a muri daca contractezi Covid in Tara ta
-- Total de cazuri vs total de decese
--Coloana total_deaths este  nvarchar

select location, 
date, 
total_cases, 
total_deaths, 
(try_convert(float,total_deaths)/
nullif(total_cases,0))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location = 'MEXICO'
order by 1,2

select location, 
date, 
total_cases, 
total_deaths, 
cast(total_deaths as float)/
nullif(total_cases,0)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location = 'Romania'
order by 1,2


-- Arata populatie din tara ta care a contractat Covid
-- Total de cazuri vs Populatia

select location, 
date,
population, 
total_cases,
(total_cases*100/population) as InfectionPercentage
from PortfolioProject..CovidDeaths
where location = 'Romania'
order by 1,2

-- Analiza tarile cu cea mai mare rata de infectare in comparatie cu populatia


select location,
population,
max(total_cases) as HighestInfectionCount,
max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by 1,2

-- Analiza tarile cu cea mai mare rata de infectare in comparatie cu populatia
-- Arata porcentul populatie infectate descrescator
select location,
population,
max(total_cases) as HighestInfectionCount,
max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by PercentPopulationInfected desc

-- Analiza data din tarile cu cea mai mare rata de infectare in comparatie cu populatia
-- Arata porcentul populatie infectate descrescator

Select Location,
Population,
date,
MAX(total_cases) as HighestInfectionCount,  
Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc

--Afisarea numarul maxim de decese Covid pentru fiecare continent
select continent, max(cast(total_deaths as float)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

-- Afisarea numarul total de decese Covid pentru fiecare continent 
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- Afiserea tarilor cu cel mai mare numar de decese pe populatie
--Coloana total_deaths este  nvarchar
select Location,
max(cast(total_deaths as float)) as TotaldeathsCount,
max((total_deaths / population))* 100 AS TotalDeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotaldeathsCount desc


 
--Afiserea total de decese pe continente
--Coloana new_deaths este  nvarchar
select continent,
sum(cast(new_deaths as float))
from PortfolioProject..CovidDeaths
where continent is not null
group by continent

--Afisarea continentului cu cel mai mare numar de decese per populatie
select continent,
max(cast(total_deaths as float)) as MaxDeathsCount,
max((total_deaths/population))*100 as MaxDeathsPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by continent


-- afisarea continentele existente 
select distinct continent
from PortfolioProject..CovidDeaths

select distinct continent
from PortfolioProject..CovidDeaths
where continent is not null


-- afisierea locati existente 
select distinct location 
from PortfolioProject..CovidDeaths
where continent is  null 

-- afiserea locati care nu sunt continente 
select distinct location
from PortfolioProject..CovidDeaths
where location in ('European Union', 'World', 'International');

-- afisare datelor CovidVaccinations
select * 
from PortfolioProject..CovidVaccinations

--Calcularea valorilor globale pentru cazurile si decesele Covid
select sum(new_cases) as total_cases, sum(cast(new_deaths as float)) as total_dethas,
sum(cast(new_deaths as float))/sum(new_cases)*100 as deathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


--Afisarea tuturor datelor despre cazurile Covid si Vaccinari prin combinarea tabelelor
-- CovidDeaths si CovidVaccinations pe baza locatiei si datei
select * 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
 
/*Analiza populatiei totale vs vaccinare prin combinarea tabelelor CovidDeaths si CovidVaccinations
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

-- Crearea unei CTE (Common Table Expression) numita PopvsVac
-- pentru a analiza relatia dintre populatie si numarul de vaccinari

with PopvsVac
(continent, location, date, population,new_vaccinations,Total_VaccinatoinsCount)
as
-- Selectarea datelor despre continent, tara, data si populatie
-- din tabelul CovidDeaths si a vaccinarilor noi din tabelul CovidVaccinations
(select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations,
    -- Calcularea numarului total cumulativ de vaccinari pentru fiecare tara
    -- PARTITION BY imparte calculul pentru fiecare locatie (tara)
    -- ORDER BY date permite acumularea vaccinarilor in ordine cronologica
sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.Location order by dea.location, dea.date) as Total_VaccinatoinsCount
from PortfolioProject..CovidDeaths dea
    -- Join intre tabelul CovidDeaths si CovidVaccinations
    -- pentru a combina datele pe baza locatiei si datei
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
    -- Eliminarea randurilor care nu au continent
    -- (ex: World, International) si a celor fara date despre vaccinari
where dea.continent is not null
and vac.new_vaccinations is not null)
-- Selectarea datelor din CTE
-- Calcularea procentului populatiei vaccinate
select *,(Total_VaccinatoinsCount/population)*100 as Total_VaccinatoinsPercentage
from PopvsVac  


--Crearea unui tabel temporar ( #PercentPopulationVaccinated) pentru a stoca date despre populatie si vaccinari

create table #PercentPopulationVacciated
( continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
Total_VaccinatoinsCount numeric
)

-- Inserarea datelor in tabelul temporar
-- Se combina datele din tabelul CovidDeaths si CovidVaccinations
-- folosind location si date pentru a potrivi informatiile corecte

insert into #PercentPopulationVacciated

select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.Location order by dea.location, dea.date) as Total_VaccinatoinsCount

from PortfolioProject..CovidDeaths dea

-- Join intre tabelul de decese si tabelul de vaccinari
-- pentru a combina datele despre populatie si vaccinari

join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
-- Eliminarea inregistrarilor care nu au continent si a celor fara date despre vaccinari
where dea.continent is not null
--and vac.new_vaccinations is not null

-- Selectarea datelor din tabelul temporar
-- Calcularea procentului populatiei vaccinate
select *,(Total_VaccinatoinsCount/population)*100 as Total_VaccinatoinsPercentage
from  #PercentPopulationVacciated 


--Stergerea si modificarea unui tabel temporar

drop table if exists #PercentPopulationVacciated
create table #PercentPopulationVacciated
( continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
Total_VaccinatoinsCount numeric)
insert into #PercentPopulationVacciated
select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.Location order by dea.location, dea.date) as Total_VaccinatoinsCount
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not null
--and vac.new_vaccinations is not null
select *,(Total_VaccinatoinsCount/population)*100 as Total_VaccinatoinsPercentage
from  #PercentPopulationVacciated


-- crearea unei vizualizari pentru stocarea datelor 
-- care vor fi utilizate ulterior pentru vizualizare si analiza 
create view PercentPopulationVacciated as
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

--Selectarea datelor din vizializarea PercentPopulationVacciated
select *
from PercentPopulationVacciated

