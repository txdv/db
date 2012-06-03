
DROP TABLE IF EXISTS ueberweisung;
DROP TABLE IF EXISTS konto;
DROP TABLE IF EXISTS kunde;
DROP TABLE IF EXISTS bank;

CREATE TABLE bank(
  blz integer NOT NULL,
  name text,
  ort text,
  PRIMARY KEY(blz)
);

CREATE TABLE kunde(
  blz integer NOT NULL,
  kundennr integer NOT NULL,
  name text,
  geburtsdatum date,
  PRIMARY KEY (blz, kundennr),
  FOREIGN KEY (blz) REFERENCES bank (blz)
);

CREATE TABLE konto(
  blz integer NOT NULL,
  kontonr integer NOT NULL,
  kundennr integer,
  kontostand integer,
  name text,
  PRIMARY KEY (blz, kontonr),
  FOREIGN KEY(blz) REFERENCES bank(blz),
  FOREIGN KEY(blz, kundennr) REFERENCES kunde(blz, kundennr)
);

CREATE TABLE ueberweisung(
  id integer NOT NULL,
  blz integer,
  kontonr integer,
  zublz integer,
  zukontonr integer,
  datum date,
  betrag integer,
  PRIMARY KEY(id),
  FOREIGN KEY(blz, kontonr) REFERENCES konto (blz, kontonr),
  FOREIGN KEY(zublz, zukontonr) REFERENCES konto(blz, kontonr)
);


COPY bank(blz, name, ort) from stdin;
1050100	Eine Bank	Aachen
1234567	Grosse Bank	Berlin
7654321	Kleine Bank	Osnabrueck
\.

COPY kunde(blz, kundennr, name, geburtsdatum) from stdin;
1050100	11	A	2010-10-1
1234567	73	B	2010-10-1
7654321	3	C	2010-10-1
1050100	17	D	2010-10-1
7654321	13	F	2010-10-1
1234567	3	D	2010-10-1
1234567	6	S	2006-06-06
\.

COPY konto(blz, kontonr, kundennr, kontostand, name) from stdin;
1050100	2099	11	127	Spardose
1234567	2207	73	8377	Sparbuch
7654321	2339	3	37	Spardose
1050100	2339	17	42	Sparstrumpf
1050100	2111	11	1201	Spartaschenbuch
7654321	2729	13	89	Sparstudium
1234567	3011	3	23	Sparbuch
\.

COPY ueberweisung(id, blz, kontonr, zublz, zukontonr, datum, betrag) from stdin;
0	1050100	2339	7654321	2339	2009-01-10	1627
1	7654321	2339	1234567	3011	2010-11-22	61
2	7654321	2729	7654321	2339	2011-07-01	563
3	7654321	2729	1234567	3011	2011-08-12	223
4	1050100	2099	1050100	2111	2011-12-23	137
5	1050100	2111	1050100	2099	2012-02-01	59
6	1050100	2111	7654321	2729	2012-04-23	97
\.
