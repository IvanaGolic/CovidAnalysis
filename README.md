# Project Name: COVID-19 Data Analysis with SQL

## Description
This project involves data analysis of COVID-19 statistics using SQL queries. The goal is to extract insights and trends from the provided COVID-19 data and visualize key metrics. The analysis covers aspects like death rates, infection percentages, and vaccination rates for different countries and continents.

## SQL Code Overview
1. The code starts by selecting relevant data from the "CovidDeath" table, including location, date, total cases, new cases, and total deaths.

2. It attempts to calculate the death percentage for each state but encounters a data type error, which is addressed using the CAST function.

3. The analysis continues by comparing total cases vs. total deaths and total cases vs. population to understand the impact of COVID-19.

4. The code then identifies countries and continents with the highest infection rates and death counts using aggregation and grouping.

5. Window functions are utilized to calculate rolling vaccination numbers for each location and date.

6. Common Table Expressions (CTEs) are employed to simplify the queries and improve code readability.

7. Temporary tables are used to store intermediate results, enabling efficient manipulation of data.

8. A view named "PercentPopulationVaccinated" is created to store data for later visualization, including rolling vaccination numbers.

## Contributor's Note
This repository showcases my data analysis skills using SQL and demonstrates my ability to derive meaningful insights from COVID-19 data. The project highlights my proficiency in SQL querying, data manipulation, and visualization. Feel free to explore the SQL code and findings to gain insights into the impact of COVID-19 in various regions.

## Usage
Please ensure you have access to the "PortfolioProject" database and the "CovidDeath" and "CovidVaccinations" tables before running the SQL code. You can use this project as a starting point for your own COVID-19 data analysis or contribute enhancements to the existing analysis.

## License
This project is licensed under the [MIT License](LICENSE).
