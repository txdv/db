-- a.)

SELECT name, url
FROM medium
WHERE typ='Blog' OR typ='Netzwerk';

-- b.)

SELECT id
FROM element
WHERE     id     IN (SELECT element_id FROM bild)
      AND id NOT IN (SELECT element_id FROM text)
      AND id NOT IN (SELECT element_id FROM link);

-- c.)

SELECT user_name, user_mediumname
FROM beitrag
WHERE beitrag.id IN (SELECT beitrag_id FROM antwort);

-- d.)

SELECT name, url
FROM medium
WHERE name in (SELECT medium_name
               FROM benutzer
               WHERE person_geburtsdatum < DATE('1996-05-31'));


-- e.)

SELECT datum FROM beitrag
WHERE id IN (SELECT likes.beitrag_id FROM likes
             GROUP BY likes.beitrag_id
             HAVING COUNT(*) >= 2);

-- oder das funktioniert hier auch

SELECT beitrag.datum FROM beitrag, likes
WHERE beitrag.id = likes.beitrag_id
GROUP BY beitrag.id, beitrag.datum
HAVING COUNT(*) >= 2;

-- f.)

SELECT beitrag.user_mediumname, text.sprache FROM element, text, beitrag
WHERE text.element_id = element.id AND element.beitrag_id = beitrag.id
GROUP BY text.sprache, beitrag.user_mediumname;

-- g.)

SELECT target.user_mediumname as medium, target.user_name as target, source.user_name as source
FROM beitrag as target, beitrag as source, antwort
WHERE target.user_mediumname = source.user_mediumname AND source.id = antwort.beitrag_id AND target.id = antwort.antwort_id
