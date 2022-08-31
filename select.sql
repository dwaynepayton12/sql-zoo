SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')

      SELECT name
FROM world
WHERE continent = 'Europe'
    AND gdp/population > (SELECT gdp/population FROM world WHERE name = 'United Kingdom')

    SELECT name, continent
FROM world
WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina','Australia')) 
ORDER BY name

SELECT name, population
FROM world
WHERE population > (SELECT population FROM world WHERE name = 'United Kingdom') AND population <  (SELECT population FROM world WHERE name = 'Germany')


SELECT name
    FROM world
    WHERE gdp >= ALL(SELECT gdp
                            FROM world
                            WHERE gdp>0 AND continent = 'Europe') AND continent <> 'Europe'




SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0)


SELECT name, continent, population FROM world WHERE continent IN (SELECT continent FROM world  x WHERE 25000000 >= (SELECT MAX(population) FROM world y WHERE x.continent = y.continent));

SELECT name, continent FROM world x
  WHERE population > ALL(SELECT 3*population FROM world y WHERE x.continent = y.continent AND x.name <> y.name)
