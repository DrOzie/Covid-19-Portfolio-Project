-- Looking at the entire data
-- Data last updated on 2023-06-13

Select *
From [Portfolio Database]..CovidData
Order by 3,4


-- Looking at the data under the following column names

Select 
	location, 
	date, 
	continent, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
From [Portfolio Database]..CovidData
Order by 1,2


-- Global total number of confirmed cases, deaths, and mortality rate of Covid19

Select
    SUM(CAST(new_cases AS INT)) AS Total_Cases,
    SUM(CAST(new_deaths AS INT)) AS Total_Deaths,
    Case
        When SUM(CAST(new_cases AS INT)) = 0 THEN NULL
        Else ((SUM(CAST(new_deaths AS float)) * 100 / NULLIF(SUM(CAST(new_cases AS float)), 0)))
    End as Mortality_Rate
From [Portfolio Database]..CovidData
Where continent IS NOT NULL


-- Global total confirmed cases per day and deaths per day

Select
    date,
    SUM(CAST(new_cases as int)) as Total_Cases,
    SUM(CAST(new_deaths AS INT)) as Total_Deaths,
    Case
        When SUM(CAST(new_cases as int)) = 0 THEN NULL
        Else ((SUM(CAST(new_deaths as int)) * 100 / NULLIF(SUM(CAST(new_cases AS INT)), 0)))
    End as Mortality_Rate
From [Portfolio Database]..CovidData
Where continent IS NOT NULL
Group by date
Order by 1,2 desc;


-- Total number of confirmed cases and deaths in each Continent

Select 
	continent, 
	max(cast(total_cases as int)) as Total_cases,
	max(cast(total_deaths as int)) as Total_deaths
From [Portfolio Database]..CovidData
where continent is not NULL
Group by continent
Order by Total_cases desc



-- Total number of confirmed cases and deaths per million in each Continent

Select 
	continent, 
	max(cast(total_cases_per_million as float)) as Total_cases_per_million,
	max(cast(total_deaths_per_million as float)) as Total_deaths_per_million
From [Portfolio Database]..CovidData
where continent is not NULL
Group by continent
Order by Total_cases_per_million desc



-- Daily number of confirmed cases and deaths in countries

Select 
	location, 
	date, 
	new_cases, 
	new_deaths
From [Portfolio Database]..CovidData
Where continent is not null
Order by 1,2


-- Daily number of new confirmed cases and deaths per million in countries

Select 
	location, 
	date, 
	new_cases_per_million, 
	new_deaths_per_million
From [Portfolio Database]..CovidData
Where continent is not null
Order by 1,2


-- Daily cummulative number of confirmed cases, deaths, and mortality rate per country

Select 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	Case
		When total_cases = 0 then NULL 
		Else (CAST(total_deaths as float))*100 /(CAST(total_cases as float))
		end as Mortality_Rate
From [Portfolio Database]..CovidData
Where continent is not null
Order by 1,2


-- Daily cummulative number of confirmed cases, deaths per million in countries

Select
	location,
	date,
    total_cases_per_million,
    total_deaths_per_million
From [Portfolio Database]..CovidData
Where continent IS NOT NULL
Order by 1,2;



-- What is the daily likelihood of dying from COVID19 after infection in the United States?

Select 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	Case
		When total_cases = 0 then NULL 
		Else (CAST(total_deaths as float))*100 /(CAST(total_cases as float))
		end as Mortality_Rate
From [Portfolio Database]..CovidData
Where location like '%United States%'
Order by location,date DESC



-- Percentage of the population of Brazil with Covid per time

Select 
	location, 
	date, 
	total_cases, 
	population, 
	Case
		When total_cases = 0 then NULL 
		Else (CAST(total_deaths as float))*100 /(CAST(population as float))
		end as Percent_Population_with_covid
From [Portfolio Database]..CovidData
Where location like '%Brazil%'
Order by location,date 



-- Country with highest prevalence of COVID19

Select 
	location,
	max(cast(total_cases as int)) as total_number_of_Infected, 
	population, 
	Case
		when population = 0 then NULL
		else round(avg((cast(total_cases as bigint)*100)/population), 2)
		end as Percentage_Population_Infected
From [Portfolio Database]..CovidData
Group by location, population
Order by Percentage_Population_Infected desc



-- Checking the numbers in the United Kingdom

Select
    location,
    population,
    max(total_cases) as highestNumofInfected,
	Case
		when population = 0 then NULL
		else round(avg((cast(total_cases as bigint)*100)/population), 2)
		end as Percentage_Population_Infected
From [Portfolio Database]..CovidData
Where location LIKE '%united kingdom%'
Group by location, population
Order by Percentage_Population_Infected DESC;



--Countries with the highest mortality

Select 
	location, 
	max(cast(total_deaths as int)) as Totaldeaths
From [Portfolio Database]..CovidData
where continent is not NULL
Group by location
Order by Totaldeaths desc




-- Checking for any observable relationship between total deaths, cases and median age;

Select
	location,
	max(cast(total_cases as int)) as TotalCases,
	max(cast(total_deaths as int)) as TotalDeaths,
	aged_70_older
From [Portfolio Database]..CovidData
Where continent IS NOT NULL
Group by location, aged_70_older
Order by 4 desc




-- COVID VACCINATIONS

-- Populations and Vaccinations per Day

Select
	continent, 
	location,
	CAST(date AS date) AS DATE,
	population,
	new_vaccinations
From [Portfolio Database]..CovidData dea
	order by 2,3


-- Cummulative Vaccinations in Countries

Select
	location,
	CAST(date AS date) AS DATE,
	population,
	new_vaccinations,
	sum(cast(new_vaccinations AS bigint)) OVER (PARTITION BY location ORDER BY location, date) as Cummulative_Vaccination
From [Portfolio Database]..CovidData
Where continent is not null
	Group by location, date, population, new_vaccinations
	order by 1,2
