
/* Edinburgh Buses
This database consists of two tables: stops and routes
STOPS
This is a list of areas served by buses. The detail does not really include each actual bus stop - just areas within Edinburgh and whole towns near Edinburgh.
Field	    Type	        Notes
id	        INTEGER	    Arbitrary value
name	    CHAR(30)	The name of an area served by at least one bus 
ROUTE
A route is the path through town taken by a bus.
Field	Type	    Notes
num	    CHAR(5)	    The number of the bus - as it appears on the front of the vehicle. Oddly these numbers               often include letters
company	CHAR(3)	Several bus companies operate in Edinburgh. The main one is Lothian Region Transport - LRT
pos	    INTEGER	This indicates the order of the stop within the route. Some routes may revisit a stop. Most buses go in  both directions.
stop	INTEGER	This references the stops table
As different companies use numbers arbitrarily the num and the company are both required to identify a route. */

/* 1.
How many stops are in the database? */

SELECT COUNT(name)
FROM stops

/* 2.
Find the id value for the stop 'Craiglockhart'. */

SELECT id
FROM stops
WHERE name = 'Craiglockhart'

/* 3.
Give the id and the name for the stops on the '4' 'LRT' service. */

SELECT id, name
  FROM stops
  WHERE id IN (SELECT stop
                 FROM route
                 WHERE num = '4'
                   AND company = 'LRT');

/* 4.
The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes. */ 

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) > 1

/* 5.
Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road. */

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53
AND b.stop = 149

/* 6.
The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'. */ 

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
AND stopb.name = 'London Road'

/* 7.
Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith').  */

SELECT DISTINCT a.company, a.num
  FROM route a JOIN route b
  ON (a.company=b.company AND a.num=b.num)
  WHERE a.stop=115 
    AND b.stop=137;

/* 8.
Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' */ 

SELECT a.company, a.num
  FROM route a JOIN route b
  ON (a.company=b.company AND a.num=b.num)
    JOIN stops stopa ON (a.stop=stopa.id)
    JOIN stops stopb ON (b.stop=stopb.id)
  WHERE stopa.name='Craiglockhart'
    AND stopb.name='Tollcross';

/* 9.
Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services. */

SELECT DISTINCT stopb.name, a.company, a.num
  FROM route a JOIN route b
  ON (a.company=b.company AND a.num=b.num)
    JOIN stops stopa ON (a.stop=stopa.id)
    JOIN stops stopb ON (b.stop=stopb.id)
  WHERE stopa.name='Craiglockhart';

/* 10.
Find the routes involving two buses that can go from Craiglockhart to Lochend.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus. */ 

SELECT S.num, S.company, S.name, T.num, T.company 
FROM 
    (SELECT DISTINCT a.num, a.company, sb.name 
     FROM route a JOIN route b ON (a.num = b.num and a.company = b.company) 
                  JOIN stops sa ON sa.id = a.stop 
                  JOIN stops sb ON sb.id = b.stop 
     WHERE sa.name = 'Craiglockhart' AND sb.name <> 'Craiglockhart'
)S

JOIN

    (SELECT x.num, x.company, sy.name 
     FROM route x JOIN route y ON (x.num = y.num and x.company = y.company) 
                  JOIN stops sx ON sx.id = x.stop 
                  JOIN stops sy ON sy.id = y.stop 
     WHERE sx.name = 'Lochend' AND sy.name <> 'Lochend'
    )T

ON (S.name = T.name)
ORDER BY S.num, S.name, T.num
