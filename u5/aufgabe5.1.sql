-- a.)

-- b.)

INSERT INTO likes
SELECT user_name, user_mediumname, id as beitrag_id
FROM beitrag
WHERE user_name='Ellie5';

-- c.)

UPDATE wotd
SET kategorie='allgemein'
WHERE wort IN (SELECT wotd.wort FROM wotd, hatwotd
               WHERE hatwotd.medium_name='Google+'
               AND wotd.wort=hatwotd.wort
               AND wotd.kategorie='category1');

-- d.)

