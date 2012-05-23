
/*
SELECT konto.name, COUNT(*) FROM kunde, konto, ueberweisung as u
WHERE kunde.blz = konto.blz AND kunde.kundennr = konto.kundennr AND kunde.blz = u.blz AND konto.kontonr = u.kontonr
GROUP BY konto.name, kunde.kundennr
-- brauchen wir nicht, da mindenstens eins mit der existenz gleich steht
-- HAVING COUNT(*) > 0
*/

/*
SELECT k.kontonr, MAX(u.betrag) FROM konto as k, ueberweisung as u
WHERE k.blz = u.blz AND k.kontonr = u.kontonr
GROUP BY k.kontonr
*/

-- c.)

SELECT konto.name, COUNT(*) as count FROM kunde, konto
WHERE kunde.kundennr = konto.kundennr
GROUP BY konto.name
ORDER BY count LIMIT 1;

-- d.)

/*
SELECT * FROM kunde
WHERE kunde.kundennr NOT IN (SELECT kundennr FROM konto);
*/
