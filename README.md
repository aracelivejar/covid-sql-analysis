# covid-sql-analysis
SQL analysis of COVID-19 data (cases, deaths, vaccinations)

# COVID-19 Data Analysis (SQL)

## Project Description

This project analyzes global COVID-19 data using SQL. It focuses on key metrics such as infection rates, mortality rates, and vaccination progress across countries and continents.

The objective is to transform raw data into meaningful insights and prepare datasets for visualization tools such as Tableau.

---

## Dataset

The project uses two main tables:

* **CovidDeaths**
* **CovidVaccinations**

The dataset includes:

* Total and new COVID-19 cases
* Total and new deaths
* Population by country
* Vaccination data

---

## Key Analysis

### Infection Rate Analysis

* Calculates the percentage of population infected per country
* Identifies countries with the highest infection rates

### Mortality Analysis

* Computes death percentage (likelihood of death if infected)
* Compares total deaths across countries and continents

### Global Metrics

* Aggregates total global cases and deaths
* Calculates overall death rate

### Vaccination Analysis

* Tracks cumulative vaccinations using window functions
* Calculates percentage of population vaccinated

---

## SQL Techniques Used

* Joins (INNER JOIN)
* Aggregate functions (SUM, MAX)
* Window functions (OVER, PARTITION BY)
* Common Table Expressions (CTE)
* Temporary tables
* Views
* Data type conversion (CAST, TRY_CONVERT)
* NULL handling (NULLIF)

---

## Example Query

```sql
SELECT location, date, total_cases, total_deaths,
(TRY_CONVERT(float, total_deaths) / NULLIF(total_cases, 0)) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'Romania';
```

---

## Key Insights

* Infection rates vary significantly between countries
* Mortality rates differ across regions and time periods
* Vaccination rollout shows uneven global distribution
* A small number of countries account for a large share of total cases

---

## Tools and Technologies

* SQL Server
* Tableau
* Git and GitHub
  

---

## Tableau Dashboards

This project includes interactive Tableau dashboards.

### COVID-19 Vaccinations Dashboard

View it here:  
https://public.tableau.com/views/Covid_Raport/CovidVaccinations

### COVID-19 Cases and Deaths Dashboard

View it here:  
https://public.tableau.com/views/Covid_Deaths_17729092228150/CovidInfectionsDeaths

## Dashboard Preview

### COVID-19 Vaccinations Dashboard
![Vaccinations](vaccination.png)

### COVID-19 Cases and Deaths Dashboard
![Deaths](deaths.png)


## Author

Araceli Bejar
GitHub: https://github.com/aracelivejar

---

## Project Status

Completed and available for portfolio presentation.
