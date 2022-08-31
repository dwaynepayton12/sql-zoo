
/* Window Function
The SQL Window functions include LAG, LEAD, RANK and NTILE. These functions operate over a "window" of rows - typically these are rows in the table that are in some sense adjacent. */ 

/* COVID-19 Data
Notes on the data: This data was assembled based on work done by Rodrigo Pombo based on John Hopkins University, based on World Health Organisation. The data was assembled 21st April 2020 - there are no plans to keep this data set up to date. */ 

/* 1.
The example uses a WHERE clause to show the cases in 'Italy' in March 2020.
Modify the query to show data from Spain */

SELECT name, DAY(whn),
 confirmed, deaths, recovered
 FROM covid
WHERE name = 'Spain'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn

/* 2.
The LAG function is used to show data from the preceding row or the table. When lining up rows the data is partitioned by country name and ordered by the data whn. That means that only data from Italy is considered.
Modify the query to show confirmed for the day before */

SELECT name, DAY(whn), confirmed, 
       LAG(confirmed, 1) 
  OVER (PARTITION BY name ORDER BY whn) confirmed_lag1
  FROM covid
 WHERE name = 'Italy'
   AND MONTH(whn) = 3
 ORDER BY whn;

/* 3.
The number of confirmed case is cumulative - but we can use LAG to recover the number of new cases reported for each day.
Show the number of new cases for each day, for Italy, for March. */

SELECT name, DAY(whn), 
       confirmed - LAG(confirmed, 1) 
  OVER (PARTITION BY name ORDER BY whn) newcases
  FROM covid
 WHERE name = 'Italy'
   AND MONTH(whn) = 3
 ORDER BY whn;

/* 4.
The data gathered are necessarily estimates and are inaccurate. However by taking a longer time span we can mitigate some of the effects.
You can filter the data to view only Monday's figures WHERE WEEKDAY(whn) = 0.
Show the number of new cases in Italy for each week in 2020 - show Monday only. */

SELECT name, DATE_FORMAT(whn,'%Y-%m-%d'), 
       confirmed - LAG(confirmed, 1) 
  OVER (PARTITION BY name ORDER BY whn) newcases
  FROM covid
 WHERE name = 'Italy'
   AND WEEKDAY(whn) = 0
 ORDER BY whn;

/* 5.
You can JOIN a table using DATE arithmetic. This will give different results if data is missing.
Show the number of new cases in Italy for each week - show Monday only.
In the sample query we JOIN this week tw with last week lw using the DATE_ADD function. */ 

SELECT tw.name, DATE_FORMAT(tw.whn,'%Y-%m-%d'), 
       tw.confirmed - lw.confirmed newcases
 FROM covid tw LEFT JOIN covid lw 
   ON DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn 
  AND tw.name=lw.name
WHERE tw.name = 'Italy' AND WEEKDAY(tw.whn) = 0
ORDER BY tw.whn;

/* 6.
The query shown shows the number of confirmed cases together with the world ranking for cases.
United States has the highest number, Spain is number 2...
Notice that while Spain has the second highest confirmed cases, Italy has the second highest number of deaths due to the virus.
Include the ranking for the number of deaths in the table. */

SELECT name, 
       confirmed,
       RANK() OVER (ORDER BY confirmed DESC) rank_confirmed,
       deaths,
       RANK() OVER (ORDER BY deaths DESC) rank_deaths
  FROM covid
 WHERE whn = '2020-04-20'
 ORDER BY confirmed DESC;

/* 7.
The query shown includes a JOIN t the world table so we can access the total population of each country and calculate infection rates (in cases per 100,000).
Show the infect rate ranking for each country. Only include countries with a population of at least 10 million. */

SELECT world.name,
       ROUND(100000*confirmed/population,0) infection_rates_per_100000,
       RANK() OVER (ORDER BY confirmed/population) rank_infection_rates
  FROM covid JOIN world ON covid.name = world.name
 WHERE whn = '2020-04-20' AND population > 10000000
 ORDER BY population DESC;

/* 8.
For each country that has had at last 1000 new cases in a single day, show the date of the peak number of new cases. */

SELECT name, date, newcases
  FROM (SELECT name, date, newcases,
               RANK() OVER (PARTITION BY a.name 
                                ORDER BY a.newcases DESC) rank   
          FROM (SELECT name, 
                       DATE_FORMAT(whn,'%Y-%m-%d') date, 
                       confirmed - LAG(confirmed,1) 
                  OVER (PARTITION BY name ORDER BY whn) newcases       
                  FROM covid) a) b 
 WHERE newcases >= 1000 AND rank = 1 
 ORDER BY date;
