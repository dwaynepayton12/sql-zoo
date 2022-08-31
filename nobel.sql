SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950

 SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'literature'

   SELECT yr, subject
  FROM nobel
WHERE winner = 'Albert Einstein';

SELECT winner
  FROM nobel
WHERE yr >= 2000
  AND subject = 'Peace';

  SELECT yr, subject, winner
  FROM nobel
WHERE yr BETWEEN 1980 AND 1989
AND subject = 'Literature'


SELECT *
  FROM nobel
WHERE winner IN ('Theodore Roosevelt', 'Woodrow Wilson', 'Jimmy Carter', 'Barack Obama');

SELECT winner
FROM nobel
WHERE winner LIKE 'John%'


SELECT yr, subject, winner 
FROM nobel 
WHERE (subject = 'Physics'
  AND yr = 1980)
  OR (subject = 'Chemistry'
  AND yr = 1984);

  SELECT yr, subject, winner
FROM nobel
WHERE yr = 1980
AND subject NOT IN ('Chemistry', 'Medicine');

SELECT yr, subject, winner
FROM nobel 
WHERE (subject = 'Medicine'
and yr = 1920)
AND (subject = 'Literature'
and yr >= 2004)

SELECT *
FROM nobel
WHERE winner = 'PETER GRÜNBERG'


SELECT *
FROM nobel
WHERE winner = 'EUGENE O''NEILL' 


SELECT winner, yr, subject 
FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC, winner

select winner, subject
from nobel
where yr = '1984'
order by ( case subject
           when 'Chemistry' then 1
           when 'Physics'   then 2
           else 0
           end), subject, winner
