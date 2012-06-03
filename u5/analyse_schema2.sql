--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: netzwerkanalyse_v2; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE netzwerkanalyse_v2 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';


\connect netzwerkanalyse_v2

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: antwort; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE antwort (
    antwort_id integer NOT NULL,
    beitrag_id integer NOT NULL
);


ALTER TABLE public.antwort OWNER TO postgres;

--
-- Name: beitrag; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE beitrag (
    id integer NOT NULL,
    datum date,
    titel pg_catalog.text,
    user_name pg_catalog.text,
    user_mediumname pg_catalog.text
);


ALTER TABLE public.beitrag OWNER TO postgres;

--
-- Name: antwortbeitrag; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW antwortbeitrag AS
    SELECT DISTINCT ON (b.id, c.id) c.id AS antwortid, b.id AS beitragid, c.user_mediumname AS antwortusermedium, b.user_mediumname AS beitragusermedium, c.user_name AS antwortuser, b.user_name AS beitraguser FROM beitrag b, beitrag c WHERE ((b.user_mediumname = c.user_mediumname) AND (b.datum < c.datum));


ALTER TABLE public.antwortbeitrag OWNER TO postgres;

--
-- Name: beitrag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE beitrag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.beitrag_id_seq OWNER TO postgres;

--
-- Name: beitrag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE beitrag_id_seq OWNED BY beitrag.id;


--
-- Name: beitrag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('beitrag_id_seq', 1, false);


--
-- Name: benutzer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE benutzer (
    name pg_catalog.text NOT NULL,
    medium_name pg_catalog.text NOT NULL,
    person_name pg_catalog.text,
    person_geburtsdatum date,
    datum date
);


ALTER TABLE public.benutzer OWNER TO postgres;

--
-- Name: betreiber; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE betreiber (
    umsatzidnr character varying(255) NOT NULL,
    name character varying(255),
    stadt character varying(255),
    plz integer,
    strasse character varying(255)
);


ALTER TABLE public.betreiber OWNER TO postgres;

--
-- Name: bild; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE bild (
    element_id integer NOT NULL,
    groesse integer,
    pfad pg_catalog.text
);


ALTER TABLE public.bild OWNER TO postgres;

--
-- Name: blog; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE blog (
    medium_name character varying(255) NOT NULL
);


ALTER TABLE public.blog OWNER TO postgres;

--
-- Name: element; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE element (
    id integer NOT NULL,
    beitrag_id integer,
    "position" integer
);


ALTER TABLE public.element OWNER TO postgres;

--
-- Name: text; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE text (
    element_id integer NOT NULL,
    sprache pg_catalog.text,
    text pg_catalog.text
);


ALTER TABLE public.text OWNER TO postgres;

--
-- Name: createwotd; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW createwotd AS
    SELECT DISTINCT ON (b.datum, b.user_mediumname) b.user_mediumname, lower(rtrim(split_part(t.text, ' '::pg_catalog.text, 1), '.'::pg_catalog.text)) AS wordoftheday, t.text, (((length(t.text) - length(replace(t.text, lower(rtrim(split_part(t.text, ' '::pg_catalog.text, 1), '.'::pg_catalog.text)), ''::pg_catalog.text))) / length(lower(rtrim(split_part(t.text, ' '::pg_catalog.text, 1), '.'::pg_catalog.text)))) + 1) AS count, b.datum FROM text t, beitrag b, element e WHERE ((t.element_id = e.id) AND (b.id = e.beitrag_id)) ORDER BY b.datum, b.user_mediumname;


ALTER TABLE public.createwotd OWNER TO postgres;

--
-- Name: element_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE element_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.element_id_seq OWNER TO postgres;

--
-- Name: element_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE element_id_seq OWNED BY element.id;


--
-- Name: element_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('element_id_seq', 1, false);


--
-- Name: emailadresse; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE emailadresse (
    adresse pg_catalog.text NOT NULL,
    person_name pg_catalog.text NOT NULL,
    person_geburtsdatum date NOT NULL
);


ALTER TABLE public.emailadresse OWNER TO postgres;

--
-- Name: forum; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE forum (
    medium_name character varying(255) NOT NULL,
    regeln character varying(255)
);


ALTER TABLE public.forum OWNER TO postgres;

--
-- Name: hatwotd; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hatwotd (
    wort character varying(255) NOT NULL,
    medium_name character varying(255) NOT NULL,
    datum date NOT NULL,
    staerke integer NOT NULL
);


ALTER TABLE public.hatwotd OWNER TO postgres;

--
-- Name: likes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE likes (
    user_name pg_catalog.text NOT NULL,
    user_mediumname pg_catalog.text NOT NULL,
    beitrag_id integer NOT NULL
);


ALTER TABLE public.likes OWNER TO postgres;

--
-- Name: likesbeitrag; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW likesbeitrag AS
    SELECT DISTINCT ON (b.user_name, b.id) b.user_name, b.user_mediumname, b.id, u.name, u.medium_name, u.person_name, u.person_geburtsdatum, u.datum FROM beitrag b, benutzer u WHERE ((b.user_mediumname = u.medium_name) AND (b.datum > u.datum));


ALTER TABLE public.likesbeitrag OWNER TO postgres;

--
-- Name: link; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE link (
    element_id integer NOT NULL,
    url pg_catalog.text
);


ALTER TABLE public.link OWNER TO postgres;

--
-- Name: medium; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE medium (
    name pg_catalog.text NOT NULL,
    url pg_catalog.text,
    typ character varying(255),
    betreiber_umsatzidnr character varying(255),
    CONSTRAINT check_typ CHECK (((typ)::pg_catalog.text = ANY (ARRAY[('Netzwerk'::character varying)::pg_catalog.text, ('Forum'::character varying)::pg_catalog.text, ('Blog'::character varying)::pg_catalog.text, ('Newsgroup'::character varying)::pg_catalog.text])))
);


ALTER TABLE public.medium OWNER TO postgres;

--
-- Name: netzwerk; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE netzwerk (
    medium_name character varying(255) NOT NULL,
    ausrichtung character varying(255)
);


ALTER TABLE public.netzwerk OWNER TO postgres;

--
-- Name: newsgroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE newsgroup (
    medium_name character varying(255) NOT NULL,
    thema character varying(255)
);


ALTER TABLE public.newsgroup OWNER TO postgres;

--
-- Name: person; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE person (
    name pg_catalog.text NOT NULL,
    geburtsdatum date NOT NULL
);


ALTER TABLE public.person OWNER TO postgres;

--
-- Name: verantwortliche; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE verantwortliche (
    verantwortliche character varying(255) NOT NULL,
    blog character varying(255) NOT NULL
);


ALTER TABLE public.verantwortliche OWNER TO postgres;

--
-- Name: wotd; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE wotd (
    wort character varying(255) NOT NULL,
    kategorie character varying(255)
);


ALTER TABLE public.wotd OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY beitrag ALTER COLUMN id SET DEFAULT nextval('beitrag_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY element ALTER COLUMN id SET DEFAULT nextval('element_id_seq'::regclass);


--
-- Data for Name: antwort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY antwort (antwort_id, beitrag_id) FROM stdin;
36	1
99	1
238	1
303	1
337	1
366	1
492	1
7	2
29	2
31	2
33	2
55	2
62	2
74	2
77	2
86	2
93	2
103	2
110	2
132	2
138	2
153	2
168	2
182	2
187	2
201	2
209	2
215	2
233	2
269	2
271	2
287	2
301	2
304	2
317	2
319	2
322	2
333	2
404	2
409	2
414	2
439	2
468	2
470	2
495	2
25	3
90	3
101	3
109	3
181	3
202	3
220	3
225	3
231	3
260	3
316	3
336	3
349	3
350	3
352	3
361	3
372	3
373	3
406	3
440	3
455	3
460	3
489	3
494	3
40	4
75	4
80	4
89	4
106	4
107	4
121	4
130	4
156	4
158	4
167	4
207	4
223	4
247	4
250	4
277	4
285	4
302	4
345	4
370	4
380	4
402	4
415	4
426	4
436	4
446	4
6	5
197	5
328	5
473	5
314	8
375	8
392	8
484	8
46	9
152	9
204	9
212	9
217	9
232	9
261	9
297	9
313	9
466	9
8	10
16	10
51	10
52	10
104	10
113	10
126	10
139	10
162	10
213	10
264	10
268	10
273	10
278	10
282	10
358	10
367	10
390	10
420	10
425	10
431	10
454	10
482	10
57	11
71	11
118	11
163	11
171	11
270	11
291	11
307	11
310	11
342	11
351	11
354	11
355	11
407	11
412	11
418	11
479	11
488	11
493	11
499	11
1	12
23	12
28	12
30	12
49	12
73	12
79	12
81	12
157	12
211	12
222	12
263	12
318	12
334	12
386	12
413	12
422	12
478	12
481	12
490	12
15	13
17	13
22	13
35	13
53	13
64	13
68	13
72	13
85	13
112	13
120	13
123	13
135	13
140	13
148	13
164	13
170	13
172	13
177	13
185	13
188	13
189	13
190	13
196	13
198	13
205	13
226	13
262	13
266	13
274	13
306	13
321	13
329	13
330	13
353	13
368	13
384	13
385	13
405	13
419	13
430	13
435	13
438	13
461	13
483	13
486	13
487	13
4	14
32	14
34	14
41	14
145	14
159	14
242	14
257	14
309	14
335	14
346	14
408	14
429	14
447	14
452	14
66	18
95	18
98	18
108	18
131	18
134	18
141	18
165	18
186	18
193	18
206	18
216	18
236	18
259	18
281	18
289	18
298	18
324	18
357	18
395	18
450	18
476	18
480	18
2	19
100	19
10	20
166	20
218	20
290	20
293	20
331	20
376	20
19	21
146	21
155	21
295	21
423	21
5	24
111	24
116	24
143	24
178	24
191	24
299	24
445	24
458	24
467	24
474	24
9	26
70	26
82	26
91	26
133	26
150	26
184	26
194	26
219	26
221	26
229	26
248	26
255	26
267	26
344	26
360	26
365	26
374	26
379	26
421	26
448	26
462	26
3	27
97	27
144	27
199	27
245	27
275	27
288	27
338	27
371	27
400	27
437	27
18	37
38	37
43	37
44	37
56	37
83	37
88	37
124	37
136	37
175	37
224	37
230	37
239	37
243	37
256	37
292	37
300	37
340	37
343	37
417	37
443	37
497	37
12	39
67	39
94	39
96	39
154	39
237	39
244	39
323	39
381	39
387	39
416	39
203	42
39	45
78	45
252	45
286	45
294	45
326	45
356	45
411	45
472	45
477	45
491	45
20	47
69	47
195	47
42	48
151	48
249	48
254	48
441	48
26	50
60	50
61	50
76	50
125	50
128	50
137	50
161	50
169	50
173	50
284	50
312	50
363	50
403	50
410	50
427	50
433	50
444	50
469	50
24	54
105	54
114	54
122	54
127	54
183	54
251	54
280	54
296	54
\.


--
-- Data for Name: beitrag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY beitrag (id, datum, titel, user_name, user_mediumname) FROM stdin;
1	2010-01-14	Our all be life god deep years moveth night.	Anton	Tagesschau Blog
2	2003-05-30	Moveth for midst you beast.	Ryan2	entwicklerforum.datenbanken.mysql
3	2004-10-18	Fruit they're brought tree make face our great all of	Anton316	Linux Forum
4	2005-06-30	It grass he lesser over greater. Lesser.	Scotty550	Facebook
5	2011-05-26	Sea above	Sophie44	Developer-Blog
6	2011-08-24	Make bring the for in above don't.	Sharon214	Developer-Blog
7	2006-05-18	Doesn't. Tree god lesser his for replenish is night let.	Tom094	entwicklerforum.datenbanken.mysql
8	2010-07-02	Behold blessed fourth fourth moving they're.	Scottie08	rwth.informatik.hauptstudium
9	2010-03-24	Won't creepeth behold forth so. Whales grass second.	Albert5	Google+
10	2003-10-31	Over. Fill divide whales meat creepeth unto evening after.	Bess013	rwth.informatik.hauptstudium
11	2007-03-26	Very may fish creature. Light called divided whose years beast.	Maggie02	StudiVZ
12	2006-12-11	Sea deep give night male creepeth midst.	Oliver13	Tagesschau Blog
13	2001-05-17	Firmament may he fly	Alexis	entwicklerforum.datenbanken.postgresql
14	2001-07-06	Was beast. Void you'll. Sea morning above.	Herb70	Facebook
15	2001-06-09	Were a gathering. Called beast it of. So form.	Nicky439	entwicklerforum.datenbanken.postgresql
16	2009-04-02	Fourth have that in fly third creeping very every unto.	Callum5	rwth.informatik.hauptstudium
17	2010-04-16	Which together whose so. Lights heaven abundantly.	Jeanne	entwicklerforum.datenbanken.postgresql
18	2005-05-15	Seed male isn't i man wherein open good.	Kaylee	rwth.jobs
19	2002-09-09	Hath green form night. Dry sixth gathering.	Cristian827	entwicklerforum.datenbanken.mysql
20	2003-04-01	Great fly deep lesser thing	Annie	rwth.informatik.hauptstudium
21	2001-04-05	Great their their fifth. Multiply i one their without created.	Tara1	entwicklerforum.datenbanken.mysql
22	2010-02-26	Shall multiply there from after seed.	Fons75	entwicklerforum.datenbanken.postgresql
23	2009-12-17	Unto let	Netty	Tagesschau Blog
24	2007-11-03	Brought face creature fifth blessed.	Rolla15	Developer-Blog
25	2008-10-24	Morning lights beast evening	Alfons0	Linux Forum
26	2004-10-03	Midst dry set beast. Fruit him you'll without give given. Morning.	Cian40	Google+
27	2002-04-22	Subdue make make don't. God fifth deep which. Beginning.	Mart95	Linux Forum
28	2009-12-11	Rule man great lesser. Let you image. Sixth the be.	Lucille264	Tagesschau Blog
29	2011-06-05	Stars waters light seasons moved doesn't. Second air may Shall i.	Nico	entwicklerforum.datenbanken.mysql
30	2011-12-28	Lesser second were can't saying fowl.	Paul	Tagesschau Blog
31	2005-08-10	Firmament light cattle isn't firmament kind all. Cattle air.	Kim1	entwicklerforum.datenbanken.mysql
32	2004-06-26	Rule morning from herb male land.	Dick	Facebook
33	2004-01-16	Bearing hath spirit of living years thing in.	Sjaak723	entwicklerforum.datenbanken.mysql
34	2005-04-02	Under called rule. Years earth.	Ulla3	Facebook
35	2001-10-28	Were it stars she'd kind fruitful.	Pawel338	entwicklerforum.datenbanken.postgresql
36	2011-01-06	Forth subdue female called dry give whose god.	Rich49	Tagesschau Blog
37	2002-11-19	Firmament cattle yielding can't beginning you're.	Zofia099	rwth.jobs
38	2004-02-02	Dry signs earth. Called multiply. Waters light yielding day don't.	Ron3	rwth.jobs
39	2003-12-25	Land	Ben	Tagesschau Blog
40	2007-06-22	Behold dry void she'd which face place cattle morning every male.	Jeanette742	Facebook
41	2004-10-01	Living good seas fowl god signs grass night land. Don't to.	Ashley004	Facebook
42	2011-03-15	Image whales place have creeping spirit Whales sixth created bring grass.	Ron7	rwth.informatik.grundstudium
43	2003-08-11	Also deep itself thing was. Stars be.	Rosa	rwth.jobs
44	2005-05-03	Bring them from him years. Over fruit. For.	Sjon463	rwth.jobs
45	2001-06-29	Morning saying creature fowl third us appear signs were us.	Klaas1	Tagesschau Blog
46	2010-06-08	Over	Sjanie6	Google+
47	2002-04-16	Great very seasons earth good a seasons saying	Mathilde23	rwth.informatik.hauptstudium
48	2008-10-31	Fruit man greater won't face his	Martina0	rwth.informatik.grundstudium
49	2008-02-07	For given that she'd appear moved of was isn't rule saw.	Sophie062	Tagesschau Blog
50	2001-02-08	Winged. Fish cattle. Open image beast beginning. Herb man creature.	Tomas52	Google+
51	2010-03-17	Multiply Form divided place creeping land dominion you.	Manuel3	rwth.informatik.hauptstudium
52	2006-04-16	Multiply stars Us blessed	Harold	rwth.informatik.hauptstudium
53	2010-12-03	Seas moving set	Vincent4	entwicklerforum.datenbanken.postgresql
54	2004-09-19	Bring moving. Two isn't	Caroline4	Developer-Blog
55	2005-05-20	Upon heaven. God beast fish first had. Us creeping was.	Babette9	entwicklerforum.datenbanken.mysql
56	2004-08-24	Lights. Earth you'll moving	Pieter	rwth.jobs
57	2007-11-19	Beginning fruitful forth over them tree herb.	Jorge01	StudiVZ
58	2001-10-08	Is whales open whose spirit may created. Firmament. Said grass green.	GoPlaat	rwth.informatik.hauptstudium
59	2003-07-21	Abundantly light cattle the seasons image.	Mart857	Developer-Blog
60	2003-04-18	Moving be second appear morning was creeping be moved don't i.	Diego	Google+
61	2004-02-27	Fly void. Itself have moving after.	Megan002	Google+
62	2005-07-10	Given fowl above a won't. Can't.	Patty0	entwicklerforum.datenbanken.mysql
63	2001-02-28	Earth night so sixth cattle brought yielding.	Gillian06	Tagesschau Blog
64	2011-11-24	Yielding. First	Lewis09	entwicklerforum.datenbanken.postgresql
65	2001-03-26	Unto one isn't saw beginning second together first called.	Sharon948	rwth.informatik.grundstudium
66	2005-09-19	Wherein. That him multiply have fly light his won't.	Megan885	rwth.jobs
67	2006-08-31	Can't seas first sea form Had fill form grass form.	Katie	Tagesschau Blog
68	2008-01-04	Second. Creeping	Camila565	entwicklerforum.datenbanken.postgresql
69	2003-01-21	Life moveth dry whose seed may saw a two seas.	Catharine8	rwth.informatik.hauptstudium
70	2007-04-29	Years. Us great evening meat said give moveth he. Be saw.	Luis7	Google+
71	2010-01-03	Third won't fruitful morning them bearing all lights evening.	Pedro331	StudiVZ
72	2010-06-23	First in whose light us bring dominion.	Paula9	entwicklerforum.datenbanken.postgresql
73	2007-04-30	Creeping likeness subdue brought yielding a thing firmament fourth fruitful.	Sherm3	Tagesschau Blog
74	2010-09-13	Female day. Multiply bearing may isn't dry fruit it. Fly won't.	Ashley79	entwicklerforum.datenbanken.mysql
75	2010-05-11	Give Moveth from you'll winged image waters days fill	Lauren	Facebook
76	2003-03-04	So behold set is sixth void.	Lucille838	Google+
77	2010-02-28	Creepeth image. To lesser male all.	Alice929	entwicklerforum.datenbanken.mysql
78	2002-05-05	And above divided beast multiply greater rule upon. Gathered.	Daniela006	Tagesschau Blog
79	2007-06-03	Him let to for	Hugo477	Tagesschau Blog
80	2008-04-27	Form you're open have. Fifth very is fifth.	Matthew164	Facebook
81	2009-04-27	Cattle above creepeth their which years.	Herb8	Tagesschau Blog
82	2009-07-16	Fly and. Darkness every dry let firmament that.	Pete3	Google+
83	2003-07-11	Air firmament third saying. God is heaven. Saying	Victor	rwth.jobs
84	2008-08-20	May fruitful evening years moving face great likeness Given beast.	Will2	rwth.informatik.grundstudium
85	2004-10-06	Fill great fill days	Alejandro3	entwicklerforum.datenbanken.postgresql
86	2005-12-31	Moving. Him. Bearing deep abundantly fowl created. Make. The herb.	GoPlaat0	entwicklerforum.datenbanken.mysql
87	2001-05-17	Night grass. Earth. Winged very given so and.	Lewis1	entwicklerforum.datenbanken.postgresql
88	2003-03-24	All said likeness forth creature.	Andrzej8	rwth.jobs
89	2010-07-05	Them herb stars	Marta160	Facebook
90	2006-05-07	Had she'd can't. Be all i.	Emil7	Linux Forum
91	2009-07-02	Open fly. Moving may light hath for herb. Heaven beginning.	Callum	Google+
92	2002-12-03	Seas us for creeping said.	Javier54	Developer-Blog
93	2009-01-24	Seed she'd fifth evening day earth had land itself.	Emil408	entwicklerforum.datenbanken.mysql
94	2004-07-11	Yielding midst given female isn't. Morning dominion the.	Jace01	Tagesschau Blog
95	2007-08-27	Give said also forth first don't morning whales.	Edwina08	rwth.jobs
96	2005-03-01	It deep that rule a.	Liza87	Tagesschau Blog
97	2003-07-27	Over their all have. One fruitful set. Doesn't there bearing life.	Anthony607	Linux Forum
98	2005-07-27	Likeness two good. Creature void. Fourth seasons waters. Under. Dominion.	Sharon	rwth.jobs
99	2011-08-21	Years deep days. Third in.	Jurre9	Tagesschau Blog
100	2002-12-01	Image. In. Can't darkness. Subdue our without without	Syd	entwicklerforum.datenbanken.mysql
101	2006-10-09	Green. Fish form beginning	Sally	Linux Forum
102	2001-09-09	A air	Joseph63	rwth.informatik.grundstudium
103	2004-12-05	Which night so them earth gathered is stars. Moving.	Jordy	entwicklerforum.datenbanken.mysql
104	2007-03-03	Called over gathered. Third blessed. Third.	Jamie	rwth.informatik.hauptstudium
105	2007-09-20	So. In place fourth. Gathering together which Unto darkness let lights.	Ross6	Developer-Blog
106	2008-05-12	Be. Blessed also rule creature let.	Joanne	Facebook
107	2009-12-08	Fourth moving	Scottie9	Facebook
108	2010-06-29	God let from. Fourth Whose. Deep good don't.	Co	rwth.jobs
109	2006-12-04	I. Heaven lights that	Patty91	Linux Forum
110	2009-10-28	Wherein you'll waters herb have sixth him fowl.	Sjanie1	entwicklerforum.datenbanken.mysql
111	2008-07-30	From forth	Dylan2	Developer-Blog
112	2008-06-30	From own also fowl grass morning.	Ulla9	entwicklerforum.datenbanken.postgresql
113	2006-07-30	Divide their first he together is heaven that.	Carla21	rwth.informatik.hauptstudium
114	2005-03-25	He appear land subdue and us i us.	Robert3	Developer-Blog
115	2003-11-22	Have life	Pauline8	Developer-Blog
116	2009-06-02	Together stars	Amy02	Developer-Blog
117	2004-04-07	Isn't. Second void he	Jan2	Developer-Blog
118	2007-10-08	Winged face second yielding day form won't midst have firmament called.	Siska337	StudiVZ
119	2004-08-21	Midst	Krystyna928	StudiVZ
120	2002-09-25	Creepeth fruitful after bearing his face cattle made.	Eleanor603	entwicklerforum.datenbanken.postgresql
121	2010-10-19	Man their gathering creepeth after fourth days moved so.	Maximilian	Facebook
122	2006-12-08	Place one Their void tree. Without.	Kaylee694	Developer-Blog
123	2006-03-19	Forth Fowl seasons midst. Thing that set.	Emil317	entwicklerforum.datenbanken.postgresql
124	2004-09-17	Won't lesser created fish wherein Under fifth life.	Tom4	rwth.jobs
125	2002-07-22	Seed male midst set form fill darkness. Form every.	Milan97	Google+
126	2010-03-29	Open saying fill so give.	Mary70	rwth.informatik.hauptstudium
127	2006-10-28	Whose creature life hath it fruitful made.	William0	Developer-Blog
128	2003-01-10	Image make sixth second gathered.	Leontien136	Google+
129	2003-02-14	Female Meat night night isn't let greater.	Mike	rwth.informatik.grundstudium
130	2006-08-01	Let them you'll form seed abundantly days.	Ciska8	Facebook
131	2011-02-12	Fifth subdue. God make brought creepeth greater he gathering together to tree them.	Scotty248	rwth.jobs
132	2004-12-25	Divided likeness. Gathered in form face moved.	Elena31	entwicklerforum.datenbanken.mysql
133	2008-08-06	Heaven i which to blessed beast of darkness set.	Rick166	Google+
134	2005-05-18	Deep moveth firmament. Whose replenish without dry won't very every.	Joop	rwth.jobs
135	2001-07-24	Unto	Rolla2	entwicklerforum.datenbanken.postgresql
136	2005-02-02	It together them greater face may second creepeth was	Oscar6	rwth.jobs
137	2002-04-27	Their morning two made heaven dry very face over.	Siska82	Google+
138	2009-04-07	Set midst over	Ivan92	entwicklerforum.datenbanken.mysql
139	2004-05-05	Us. Have divided a creepeth. Day.	Ross935	rwth.informatik.hauptstudium
140	2002-09-25	Fish replenish Midst lights without there upon fifth they're moveth firmament.	Theo2	entwicklerforum.datenbanken.postgresql
141	2009-08-11	Replenish very them. She'd female created divided	Catharine	rwth.jobs
142	2003-02-11	Seas fifth. The created. Replenish be fruitful lights.	Malgorzata	rwth.informatik.grundstudium
143	2011-04-24	Own creature. Place Saw saying a you'll dry.	Michel1	Developer-Blog
144	2003-08-03	Without doesn't. Saying creepeth. Fourth. Multiply midst fruitful	Leah	Linux Forum
145	2001-09-16	Meat bring saying don't make.	Ana6	Facebook
146	2002-05-31	Wherein above. Doesn't appear called were.	Alfons13	entwicklerforum.datenbanken.mysql
147	2001-06-08	Made. Of for open sea appear evening she'd. Of.	Sharon98	Developer-Blog
148	2004-04-28	Unto moved third cattle that light great.	Pablo89	entwicklerforum.datenbanken.postgresql
149	2001-02-26	Living male place i open. Every may together kind saw beast.	Ellie5	Developer-Blog
150	2008-11-29	Set is moveth beast stars it make deep rule form.	Martin15	Google+
151	2009-01-01	Abundantly all days abundantly herb saying was have the created.	Cathy	rwth.informatik.grundstudium
152	2010-08-02	Bring made you to. Herb the were.	Tinus3	Google+
153	2008-09-19	Fruit fifth shall second fish under appear	Lincoln52	entwicklerforum.datenbanken.mysql
154	2006-05-08	Second fruitful green second seasons also all make one.	Martina49	Tagesschau Blog
155	2002-05-30	Own god good after upon itself said.	Jurre68	entwicklerforum.datenbanken.mysql
156	2006-08-22	Waters after. Isn't years a.	Sanne0	Facebook
157	2009-07-11	Make all one from great. Us which deep.	Lea94	Tagesschau Blog
158	2006-07-03	Which gathering dominion winged very lights. Was moveth the don't earth.	Tara7	Facebook
159	2005-06-15	Called creeping beginning waters gathering beast the forth beast two.	Caitlin8	Facebook
160	2003-10-26	A. Multiply void said gathering.	Marty167	Developer-Blog
161	2003-10-23	To air. Sixth saying fowl face second days.	Manuel82	Google+
162	2006-08-04	Over abundantly land divide meat.	Thelma81	rwth.informatik.hauptstudium
163	2010-09-27	Seed midst so greater there.	Jaap7	StudiVZ
164	2007-06-05	Set them give	Marta06	entwicklerforum.datenbanken.postgresql
165	2010-08-26	Blessed let there bring living all subdue beast. Every upon in.	Joseph68	rwth.jobs
166	2003-09-13	It and	Rolla9	rwth.informatik.hauptstudium
167	2010-08-22	Them replenish were called darkness years greater.	Martien149	Facebook
168	2004-07-21	Have bearing days so shall let.	Lena403	entwicklerforum.datenbanken.mysql
169	2004-01-30	A brought made replenish let.	Jim	Google+
170	2006-03-07	Tree face. Replenish morning shall tree. Created there.	Jill364	entwicklerforum.datenbanken.postgresql
171	2007-06-18	Stars there	Freja95	StudiVZ
172	2011-10-07	All so dry morning good of. Above. Without.	Stanislaw	entwicklerforum.datenbanken.postgresql
173	2003-05-21	Our you're beast he deep subdue	Andy	Google+
174	2005-11-22	Given	Will0	rwth.informatik.grundstudium
175	2004-03-26	Us creeping fifth sea forth fruitful. So heaven.	Sarah8	rwth.jobs
176	2004-06-19	Darkness set our. Make fifth there. Upon their. For you're.	Carla	Developer-Blog
177	2008-08-11	Wherein him said place you're behold	Rogier06	entwicklerforum.datenbanken.postgresql
178	2008-01-31	To. Don't itself him saying don't is.	Luis49	Developer-Blog
179	2006-11-16	Called to abundantly he that bring.	Alex88	StudiVZ
180	2002-05-02	Life was. Lesser good in. Day void good greater in. Form.	Niklas6	rwth.informatik.grundstudium
181	2009-01-29	Heaven signs i spirit his all it.	Andrew2	Linux Forum
182	2005-04-02	Lesser waters. Their and cattle abundantly unto great let one bring.	Oliver9	entwicklerforum.datenbanken.mysql
183	2007-10-03	Unto living second greater hath.	Harry329	Developer-Blog
184	2006-08-07	Yielding fruit be fruitful beginning signs. Given for multiply heaven.	Matthew319	Google+
185	2011-02-08	Itself above above made wherein. Be.	David178	entwicklerforum.datenbanken.postgresql
186	2007-05-17	Lights their replenish second i living dry night fish face.	Nigel	rwth.jobs
187	2006-03-21	Living lights face. Void bearing it they're living all.	Sem8	entwicklerforum.datenbanken.mysql
188	2002-12-01	Brought seasons over us him seas don't in two earth image.	Bengie	entwicklerforum.datenbanken.postgresql
189	2006-12-20	Dry upon every cattle	Paul2	entwicklerforum.datenbanken.postgresql
190	2005-01-28	Land in him seasons it said.	Steph59	entwicklerforum.datenbanken.postgresql
191	2009-06-24	Fruit lights dominion seas beast seasons moving said life bring dominion.	Cristina21	Developer-Blog
192	2002-06-10	Fish grass of dominion bearing. Tree of.	Mathilde6	Developer-Blog
193	2007-09-29	First	Nate70	rwth.jobs
194	2005-06-15	To above place. Second above you'll lesser face after above.	Jorge562	Google+
195	2002-12-17	Air to moveth one so give.	Marta40	rwth.informatik.hauptstudium
196	2002-09-27	Over he two him behold firmament.	Sean	entwicklerforum.datenbanken.postgresql
197	2011-06-07	Void doesn't midst seasons after heaven.	Simon45	Developer-Blog
198	2003-11-25	Bearing second fruitful Whose. Lesser over may moveth he all.	Joanne249	entwicklerforum.datenbanken.postgresql
199	2003-01-02	Hath night winged first night you image. Him. Very own without.	Rachel038	Linux Forum
200	2001-08-22	God have also	Samantha1	rwth.informatik.hauptstudium
201	2007-08-29	So herb above image appear beast. Made beast.	Joop455	entwicklerforum.datenbanken.mysql
202	2004-12-09	Deep fourth. Was so. Wherein dry he the hath. Thing.	Juan	Linux Forum
203	2011-08-29	Meat. The years third. Fly.	Drew568	rwth.informatik.grundstudium
204	2010-08-03	Give great. Morning i for of sixth.	Ciara1	Google+
205	2001-08-07	Place. Seasons the seas under called years.	Elin926	entwicklerforum.datenbanken.postgresql
206	2008-01-21	Subdue stars heaven hath. Created said divide.	Jeffery	rwth.jobs
207	2005-07-31	Creepeth given fifth isn't For	Willy	Facebook
208	2008-06-01	He days air	Simon7	rwth.informatik.grundstudium
209	2011-04-05	Day moveth sixth man said the gathering dominion set. Seas. Him.	Hank	entwicklerforum.datenbanken.mysql
210	2005-07-06	Divide is was Itself also own male open bring moveth give.	Andrea94	StudiVZ
211	2009-05-03	One said	Stephen	Tagesschau Blog
212	2011-01-26	Stars unto let earth seasons.	Piet	Google+
213	2010-01-20	So wherein	Laura84	rwth.informatik.hauptstudium
214	2004-07-17	Doesn't	John8	Developer-Blog
215	2010-09-25	Can't seasons Given creeping cattle bearing from was. Them there.	Cath528	entwicklerforum.datenbanken.mysql
216	2006-05-23	Creeping good lights you the man gathered him.	Madison	rwth.jobs
217	2010-12-03	Fill made thing	Teun76	Google+
218	2003-09-04	Cattle stars third every you fish hath and over wherein Yielding.	Jolanda71	rwth.informatik.hauptstudium
219	2009-06-10	Unto life have i saw.	Jordy2	Google+
220	2011-03-11	Us subdue unto to said seed bring. Likeness seas there cattle.	Dylan11	Linux Forum
221	2005-03-18	Abundantly kind replenish our man.	Ross3	Google+
222	2009-04-09	Man. Is appear darkness his so own dry fly upon.	Camilla579	Tagesschau Blog
223	2010-07-12	You're	Ester43	Facebook
224	2004-01-19	Fifth firmament own all living light fowl without days can't fowl.	Klaas928	rwth.jobs
225	2005-11-27	And winged from have fly.	Emil2	Linux Forum
226	2011-11-03	Spirit land together doesn't a fly brought.	Thomas2	entwicklerforum.datenbanken.postgresql
227	2005-10-13	Years own subdue they're void likeness air.	Patty630	StudiVZ
228	2005-03-10	Light creeping there evening multiply.	Anna93	rwth.informatik.grundstudium
229	2006-09-24	Yielding. They're his us image.	Ainhoa	Google+
230	2005-03-02	Fish god isn't face wherein may. Divide all creeping that blessed.	Martina37	rwth.jobs
231	2011-03-28	Thing brought i it i male land thing.	Marie	Linux Forum
232	2011-04-23	Stars she'd void whose upon won't hath let. Sea that third.	Alejandro	Google+
233	2008-10-14	Heaven was from saying likeness is.	Paula425	entwicklerforum.datenbanken.mysql
234	2001-08-06	Fish isn't whose earth fill.	Jo28	rwth.informatik.hauptstudium
235	2001-12-02	Winged dominion first morning rule.	Daan1	rwth.jobs
236	2011-02-11	Earth That be tree night creeping she'd	Katharina31	rwth.jobs
237	2005-05-20	Seasons forth to fifth lesser given. Replenish. Said lights	Viktor2	Tagesschau Blog
238	2010-08-18	Give man firmament midst thing signs god form creeping all abundantly.	Aoife7	Tagesschau Blog
239	2003-02-09	Don't. So give you're all whose female were gathering.	Viktor	rwth.jobs
240	2005-03-05	Years above you beginning he midst isn't also male.	Richard53	rwth.informatik.grundstudium
241	2002-08-17	Behold make unto form dominion face.	Filip28	rwth.informatik.grundstudium
242	2002-01-29	Replenish. Moving rule fill herb to bearing were have in midst.	Luis9	Facebook
243	2005-05-07	Greater days cattle Was land.	Amy48	rwth.jobs
244	2006-01-31	I very man kind wherein.	Carolina37	Tagesschau Blog
245	2004-05-01	Fill of him fly over had	Manuel8	Linux Forum
246	2002-01-20	Earth tree first open bring fly greater from she'd blessed.	Amber17	rwth.informatik.hauptstudium
247	2011-04-14	Form. Darkness whose were evening i after. A grass.	Netty186	Facebook
248	2006-12-16	I void Give called there. Heaven.	Jacob	Google+
249	2010-04-30	Kind image signs evening sea.	Jordy35	rwth.informatik.grundstudium
250	2009-09-24	Behold. God light you moved to great creepeth divide void.	Luka7	Facebook
251	2006-12-13	Replenish heaven appear a two set to god from third.	Kimberly48	Developer-Blog
252	2002-01-13	They're saying don't. Greater. Very the fill morning. Lights.	Susan	Tagesschau Blog
253	2003-09-12	Beast firmament fifth replenish. Fifth earth two cattle.	Christa	Developer-Blog
254	2010-08-07	Together. Fruit give whose. Behold. Two	Mariska93	rwth.informatik.grundstudium
255	2005-07-30	Made. Darkness	Ivan6	Google+
256	2004-03-03	Image cattle fifth. Given the form.	Marieke6	rwth.jobs
257	2002-01-16	Is dry said brought	Cath5	Facebook
258	2006-03-20	Tree above may thing you over earth.	Rolla68	StudiVZ
259	2008-04-28	Waters evening open lights gathered second.	Richard80	rwth.jobs
260	2010-01-09	Man waters signs together bring created Night don't and fruit wherein.	Alva54	Linux Forum
261	2010-08-19	Also	Helen	Google+
262	2008-12-29	Rule wherein yielding seas. Darkness days third spirit fourth place light.	Sid61	entwicklerforum.datenbanken.postgresql
263	2008-08-31	Also have in waters. So fruit creeping. Give itself.	Tonnie	Tagesschau Blog
264	2005-06-23	Lights place. Dry meat appear unto i land living	Trevor	rwth.informatik.hauptstudium
265	2002-03-24	Thing sixth. Meat under them you A.	GoSix3	Linux Forum
266	2004-09-11	Divided moved days sixth seas.	Lincoln	entwicklerforum.datenbanken.postgresql
267	2009-09-17	Morning life created	Tyler77	Google+
268	2008-07-10	Fly forth he yielding. Said beast the yielding won't.	Ciara55	rwth.informatik.hauptstudium
269	2004-09-29	A air don't stars great fowl.	Gabbie3	entwicklerforum.datenbanken.mysql
270	2007-05-12	Divided isn't Made abundantly you male.	Jeanne142	StudiVZ
271	2003-07-03	Sea set Won't he from female yielding whales green	Liam3	entwicklerforum.datenbanken.mysql
272	2007-02-18	Night bring behold first years fifth they're seasons green living seed.	Max	rwth.informatik.grundstudium
273	2007-11-11	Give spirit. Place gathered for fish	Bert1	rwth.informatik.hauptstudium
274	2009-06-19	Moveth beginning day divided third lights. Fly was. Years kind.	Thelma	entwicklerforum.datenbanken.postgresql
275	2002-05-14	Forth. Unto of female every spirit.	Delphine	Linux Forum
276	2003-12-23	Dominion. You're image made god. After third bring him years.	Linnea415	rwth.informatik.grundstudium
277	2005-07-23	Appear morning made us blessed bring. Fourth	Cath15	Facebook
278	2009-05-10	Sixth from our isn't sixth whose years isn't brought stars.	Alba69	rwth.informatik.hauptstudium
279	2002-01-25	Let beast waters were own spirit in there.	Sylvia	rwth.informatik.grundstudium
280	2005-03-13	Waters. May also likeness Have.	Cees82	Developer-Blog
281	2010-08-31	You'll dry winged. Face given	Pieter838	rwth.jobs
282	2009-07-24	Fish you'll winged winged rule. Bring unto.	Joey	rwth.informatik.hauptstudium
283	2006-11-22	Whose earth isn't whales years.	Matthijs681	StudiVZ
284	2003-01-16	A man Moved air one all.	Bram615	Google+
285	2010-02-12	Herb won't without i his meat	Sylvia165	Facebook
286	2001-11-03	Under. All sixth heaven their years darkness of void also air.	Matthijs5	Tagesschau Blog
287	2007-10-01	Above winged the unto. Living replenish created hath green replenish darkness.	Erin394	entwicklerforum.datenbanken.mysql
288	2002-07-16	The living may tree god called you're called two kind in.	Roger	Linux Forum
289	2005-10-02	Without air stars a life.	Herb9	rwth.jobs
290	2003-05-08	Hath that you'll make seed and living which.	Zoe45	rwth.informatik.hauptstudium
291	2007-09-02	One thing gathering days him two morning stars it.	Ed3	StudiVZ
292	2003-09-21	Dominion dominion lesser life they're creepeth from third moveth creepeth winged.	Jill079	rwth.jobs
293	2003-09-22	Gathering. Called they're fourth beginning together. Behold earth our.	Cecilie1	rwth.informatik.hauptstudium
294	2001-12-02	Third isn't midst void likeness to after own brought.	Victor1	Tagesschau Blog
295	2002-08-25	Light fruitful under fruit is. Had dominion.	Matt316	entwicklerforum.datenbanken.mysql
296	2005-10-14	Don't make. Fowl appear the.	Alice8	Developer-Blog
297	2011-03-25	God of fill them whose.	Nicholas7	Google+
298	2008-12-18	Night light called greater they're moving evening great.	Christa26	rwth.jobs
299	2010-01-21	Face called Fill bearing days. Have land. And saying. Whales.	Jaap04	Developer-Blog
300	2003-10-19	The deep abundantly she'd form third can't.	Marcin652	rwth.jobs
301	2007-06-14	Was dry i earth thing	PieterJan367	entwicklerforum.datenbanken.mysql
302	2009-04-04	Fifth over you'll midst firmament. Subdue.	Karin1	Facebook
303	2010-10-08	Whales divide whose seed you earth be fly gathering.	Lucia26	Tagesschau Blog
304	2003-09-18	Evening man yielding gathered there days likeness is the.	Cristina7	entwicklerforum.datenbanken.mysql
305	2005-09-08	Bearing living deep abundantly fill	Sjef41	Developer-Blog
306	2010-01-30	Appear days. Day fourth they're male	Betty09	entwicklerforum.datenbanken.postgresql
307	2007-05-03	Multiply. Multiply sea. Tree to appear. Fish. Said.	Niek45	StudiVZ
308	2008-01-07	Fruit thing god rule female lesser.	Pieter0	rwth.informatik.grundstudium
309	2004-01-24	Be. Void. Winged dominion creepeth. Sea spirit fly. Morning.	Roger86	Facebook
310	2010-11-19	Seed without man Day him evening fourth very.	Jo136	StudiVZ
311	2008-01-18	Tree stars fruit multiply deep abundantly.	Pawel70	rwth.informatik.grundstudium
312	2003-08-09	Fill behold. Fish and void i wherein.	Mathilde94	Google+
313	2011-10-22	Midst that she'd face	Sandra9	Google+
314	2010-11-29	Morning firmament one night gathered in days appear place had.	Daniel	rwth.informatik.hauptstudium
315	2001-09-18	He Upon signs Saying of his. Rule.	Hannah7	rwth.jobs
316	2005-04-15	Fowl our shall bearing	Daniela07	Linux Forum
317	2005-01-01	Stars years from he void fill fruitful dominion.	Sally11	entwicklerforum.datenbanken.mysql
318	2009-04-27	And. One seed herb fly doesn't.	Ruth	Tagesschau Blog
319	2006-01-25	Fruitful bearing and they're creature hath whose i days called.	Luca	entwicklerforum.datenbanken.mysql
320	2004-04-30	Isn't can't god. Seas god fly.	Andrzej45	rwth.informatik.grundstudium
321	2004-04-20	Creeping. Don't own fourth day appear behold. Place.	Juan8	entwicklerforum.datenbanken.postgresql
322	2009-01-17	Evening wherein. Brought image were.	Sydney578	entwicklerforum.datenbanken.mysql
323	2005-02-09	Sixth yielding fish all which Living behold.	Nienke	Tagesschau Blog
324	2011-06-23	Beginning greater dry above female.	Florian	rwth.jobs
325	2001-10-09	Created years creature said above lights. Great behold give.	Jean	rwth.informatik.hauptstudium
326	2002-02-19	Our created dry fish	Julie982	Tagesschau Blog
327	2001-02-27	Bring and from made unto Their gathering.	Ellie13	entwicklerforum.datenbanken.mysql
328	2011-06-01	They're their	Jane	Developer-Blog
329	2007-01-22	Grass meat lights form is	Steph305	entwicklerforum.datenbanken.postgresql
330	2011-10-05	Were is. Wherein called. Made dominion days deep.	Esther	entwicklerforum.datenbanken.postgresql
331	2003-10-09	Give Let life fish. And evening.	Hanna989	rwth.informatik.hauptstudium
332	2008-10-03	Fish fly. From beast make.	Daniel4	rwth.informatik.grundstudium
333	2007-12-31	Gathered spirit said night you'll you'll lesser life was spirit you'll.	Fabian	entwicklerforum.datenbanken.mysql
334	2007-04-07	Fowl saying divided bearing fruit face.	Kimberly12	Tagesschau Blog
335	2002-11-08	Fruit bearing from bring seas a forth. Likeness.	Niklas498	Facebook
336	2011-08-13	Dry	Stephanie261	Linux Forum
337	2011-02-09	You're moved. Creepeth	Sid41	Tagesschau Blog
338	2002-11-15	Deep abundantly called third. Meat make fly won't. Creeping. Isn't day.	Sjaak6	Linux Forum
339	2005-04-09	Them make great dry	Bram61	StudiVZ
340	2005-01-17	Land i creeping Winged. Whose firmament kind of us seas created.	Joe7	rwth.jobs
341	2001-05-20	Lights said image deep image gathering signs day you'll midst. Their.	Henry	rwth.informatik.grundstudium
342	2010-01-23	Fly first also had fly.	Siska7	StudiVZ
343	2004-10-03	Every creature have make form isn't green.	Hanna1	rwth.jobs
344	2009-01-19	Greater. A. Saw i shall fruit created fly you.	Philip172	Google+
345	2011-05-06	Seas. Behold it you're	Andy95	Facebook
346	2004-02-24	Fifth greater. Cattle brought in. Kind creeping	Liza	Facebook
347	2001-10-07	You're stars	Pip	rwth.jobs
348	2006-06-21	Moved rule. Wherein darkness kind moveth. Years.	Tim	StudiVZ
349	2008-05-03	Man. Above. Fill man said which. Female.	Marty46	Linux Forum
350	2009-04-30	Signs us. Seasons evening evening together.	Lizzy5	Linux Forum
351	2010-04-03	Us itself seasons after is lesser	Sue	StudiVZ
352	2009-09-18	Can't land midst forth bring whose bearing face under. Without years.	Dorothy571	Linux Forum
353	2009-08-21	Fowl green made night. For gathering fish Fly darkness meat Firmament.	Sophie	entwicklerforum.datenbanken.postgresql
354	2011-11-06	After is	Rick	StudiVZ
355	2011-10-23	Sixth unto dry he day stars seas night. Give. She'd.	Stephanie	StudiVZ
356	2002-01-01	Winged herb very so moving you'll.	Juana0	Tagesschau Blog
357	2011-12-30	Herb our form gathered from kind years. Let.	Nathan	rwth.jobs
358	2009-02-05	Place sea bearing make his won't.	Liza97	rwth.informatik.hauptstudium
359	2008-08-01	Divide that. Midst and. Bring us.	Camille	rwth.informatik.grundstudium
360	2007-07-08	Without	Jeanne2	Google+
361	2007-06-01	Divide. Of. Rule green set face earth make.	Theodore9	Linux Forum
362	2004-02-09	Abundantly his thing shall won't green They're good bring.	Lukas88	StudiVZ
363	2001-07-24	Very. I abundantly creature	Pawel7	Google+
364	2001-06-01	Moved thing	Erin	Tagesschau Blog
365	2008-09-12	Life shall created male saw hath.	Scottie	Google+
366	2011-08-02	Shall from. Day that cattle.	Fons2	Tagesschau Blog
367	2005-03-10	Called great replenish upon above	Patty	rwth.informatik.hauptstudium
368	2010-06-06	So created saw moving can't.	Ivan914	entwicklerforum.datenbanken.postgresql
369	2006-12-02	Created	Phil595	Developer-Blog
370	2011-06-17	So divide Days void rule appear living seasons. To creature open.	Juana5	Facebook
371	2004-04-04	Created whose winged kind to above creepeth	Sue508	Linux Forum
372	2007-02-26	Lesser after deep abundantly first living his meat called.	Phil788	Linux Forum
373	2006-08-20	Firmament. Which. Day their to it.	Martin270	Linux Forum
374	2008-01-26	Cattle multiply. Were. Itself moving had.	Matthew	Google+
375	2010-11-06	Air living shall days creepeth.	Koos	rwth.informatik.hauptstudium
376	2003-10-14	Them wherein. Light set. Green in called air	Lu59	rwth.informatik.hauptstudium
377	2003-12-04	Open them open one all. Blessed have cattle of saying	Giel41	Developer-Blog
378	2001-07-16	Herb	Anna8	StudiVZ
379	2008-04-20	Image heaven over sixth all earth had greater.	Kaylee12	Google+
380	2011-07-05	Moving subdue rule. Beginning. The	Raul711	Facebook
381	2004-05-16	I shall so days air fruit. Wherein i was.	Emily	Tagesschau Blog
382	2003-03-18	Divided them. Given him saying gathered to.	Matthijs2	Developer-Blog
383	2001-10-20	All yielding won't moved fourth. Don't heaven great sea.	Jack	rwth.jobs
384	2003-12-13	Fish also bearing Appear. His void a female a. Without. Was.	Bertje6	entwicklerforum.datenbanken.postgresql
385	2002-11-25	Dry it herb Own kind fruitful.	Lea	entwicklerforum.datenbanken.postgresql
386	2008-11-07	Heaven. Lesser in thing tree created beast without.	James	Tagesschau Blog
387	2005-08-24	Very grass tree isn't. Moved dry is replenish.	Ciara83	Tagesschau Blog
388	2006-07-06	Signs be sea said their there.	Luka58	Developer-Blog
389	2004-04-25	Deep them of third them beginning said let	Mads	StudiVZ
390	2004-10-19	Lights days you'll divide give.	Gert	rwth.informatik.hauptstudium
391	2002-10-30	Deep abundantly creature. Over grass over.	Michel	rwth.informatik.grundstudium
392	2010-07-13	Creature. Form place form moved you. You're.	Jose509	rwth.informatik.hauptstudium
393	2002-01-26	Whose have which had they're cattle subdue.	Siem83	rwth.informatik.hauptstudium
394	2001-02-04	Good man first he under appear forth them grass. Thing seed.	Sherman	entwicklerforum.datenbanken.mysql
395	2009-01-12	Female gathering she'd. One cattle gathered second.	Katharina2	rwth.jobs
396	2003-07-17	You're good wherein beast whose life Firmament kind form shall give.	Sherman2	rwth.informatik.grundstudium
397	2006-03-09	Meat isn't own fowl second he. Creature.	Lu168	rwth.informatik.grundstudium
398	2004-01-18	That replenish likeness fly moveth saying fruit moveth whales.	Magnus34	StudiVZ
399	2002-09-13	Made	Jaap489	StudiVZ
400	2003-03-22	Living thing air was years. Divided.	Benjy51	Linux Forum
401	2001-08-18	Was winged fifth fowl. Can't wherein air. Very.	Linnea786	rwth.informatik.grundstudium
402	2008-10-15	Form	Truus	Facebook
403	2004-09-28	Also behold and made night.	GoPlaat65	Google+
404	2003-07-16	Light dry fruitful years was beginning	Alejandro0	entwicklerforum.datenbanken.mysql
405	2004-07-16	Lights creepeth she'd to	Sammy02	entwicklerforum.datenbanken.postgresql
406	2006-01-06	Days fifth whose his. Sea us divide dominion also for fourth.	Sara268	Linux Forum
407	2010-01-15	Saw so our seasons. Abundantly waters face so bring creeping waters.	Marcin	StudiVZ
408	2001-07-18	Land. Male beast they're you'll	Callum60	Facebook
409	2006-09-11	Yielding face earth morning i let.	Cameron	entwicklerforum.datenbanken.mysql
410	2003-12-04	He	Marco3	Google+
411	2002-10-15	Void abundantly called. Multiply the evening saw created hath unto waters.	Juan7	Tagesschau Blog
412	2008-06-15	Firmament fifth without Earth spirit.	Rogier	StudiVZ
413	2009-06-15	Itself there waters in moved sea. That.	Truus34	Tagesschau Blog
414	2003-07-07	Fifth you're divided Meat two isn't.	Kayleigh8	entwicklerforum.datenbanken.mysql
415	2010-03-12	Two land. He above two together sixth.	Klaas2	Facebook
416	2006-02-13	Blessed and our second grass. Were deep you're.	Catharine538	Tagesschau Blog
417	2003-06-23	After creepeth us firmament image itself. Form whose god.	Gabbie9	rwth.jobs
418	2010-03-13	Likeness blessed isn't. Is good be for. Male them.	Hero96	StudiVZ
419	2004-11-30	Fill you'll deep. Make. Were days fill a tree two subdue.	Sjanie119	entwicklerforum.datenbanken.postgresql
420	2005-07-09	Fish whose meat. Void third.	Tom828	rwth.informatik.hauptstudium
421	2005-05-20	Winged and Called air beginning make.	Liza311	Google+
422	2008-08-07	Saw creeping greater bearing lights	Adam2	Tagesschau Blog
423	2001-06-12	Evening morning also bearing land which living which.	Joey2	entwicklerforum.datenbanken.mysql
424	2004-08-15	Blessed their he wherein seed likeness his. Fruit fish.	Betty1	rwth.informatik.grundstudium
425	2005-06-12	Image male all stars and of spirit darkness herb fruitful.	Joost918	rwth.informatik.hauptstudium
426	2005-12-28	Every their every is also divide.	Sherm493	Facebook
427	2004-02-18	Midst signs creature multiply creepeth.	Andrea3	Google+
428	2002-12-13	That whales place from called.	Siem6	rwth.informatik.grundstudium
429	2002-10-19	Behold every bring moving sea.	Cian664	Facebook
430	2009-10-16	He air days beginning own behold	Rando424	entwicklerforum.datenbanken.postgresql
431	2009-08-07	Midst greater itself midst after. Created dry is kind hath.	Georgina5	rwth.informatik.hauptstudium
432	2002-03-04	Face you'll. Given second life was	Ciska5	StudiVZ
433	2003-02-15	Evening creature every. Gathering rule so Won't there isn't unto.	Isabel981	Google+
434	2001-06-02	That divide can't be it you're likeness.	Michel2	StudiVZ
435	2010-07-25	Fly upon can't a life our were made said.	Pip656	entwicklerforum.datenbanken.postgresql
436	2005-12-05	Herb creepeth deep abundantly earth.	Katarzyna282	Facebook
437	2004-02-03	May one great life. So heaven had.	Christian1	Linux Forum
438	2006-07-04	Years kind. Fly won't tree it	Mike073	entwicklerforum.datenbanken.postgresql
439	2006-01-27	After also you fish. Midst made creature years for	Matt1	entwicklerforum.datenbanken.mysql
440	2009-11-06	A them. Doesn't above signs whose that.	Miriam6	Linux Forum
441	2010-07-28	Without fifth. A our years our	Oliver377	rwth.informatik.grundstudium
442	2007-10-31	Own. Fish saying gathered given. Open form days. Upon.	Simon36	rwth.informatik.grundstudium
443	2004-01-18	Firmament so subdue female appear.	Vincent0	rwth.jobs
444	2001-07-12	God fly. Herb bearing won't divided dominion blessed void.	Peggy	Google+
445	2010-10-31	Together. Two very. Isn't over. Thing fruitful.	Emma621	Developer-Blog
446	2007-08-29	Seas fifth all also beginning	Scotty51	Facebook
447	2001-07-09	Gathering seas so wherein. Gathering. Life. You'll first above whose fish.	Cloe862	Facebook
448	2005-07-21	Above in and land don't form first face dominion.	Catherine	Google+
449	2006-06-25	Can't grass won't they're rule he said sixth.	Nienke69	rwth.informatik.grundstudium
450	2009-08-01	Is that sea you're of land herb man sixth male.	Milan89	rwth.jobs
451	2006-08-31	Had sixth seed unto above were fish	Rich8	StudiVZ
452	2003-10-24	From above. Their wherein which fly tree.	Anna	Facebook
453	2004-04-19	Together meat fly moving set days male.	Giel4	Developer-Blog
454	2010-06-02	Thing fish rule hath i face good.	Bess4	rwth.informatik.hauptstudium
455	2008-11-07	Fourth saw rule it was from to.	Bram7	Linux Forum
456	2001-01-31	Lights. Be. Midst gathering whose he greater	Sean176	rwth.jobs
457	2002-09-06	Place abundantly had whales you be.	Jolanda33	StudiVZ
458	2010-06-27	Moving creepeth god void. She'd form.	Jorge	Developer-Blog
459	2001-04-13	May replenish fruit seed first waters it.	Liza48	rwth.informatik.grundstudium
460	2009-09-13	Bearing rule dominion very sixth greater moved were.	Peg51	Linux Forum
461	2005-09-19	Seas rule herb	Bengie5	entwicklerforum.datenbanken.postgresql
462	2008-11-23	Was won't in sea years heaven.	Thomas5	Google+
463	2007-03-04	Winged face spirit	Scottie53	Developer-Blog
464	2002-04-26	Fourth said open abundantly rule	Herman	rwth.informatik.grundstudium
465	2001-05-24	Air. Shall saying us air and forth fruitful seas replenish abundantly.	Drew	Facebook
466	2010-05-30	Said green given also firmament.	Joshua465	Google+
467	2008-11-05	Open together form divide Wherein midst.	Raul01	Developer-Blog
468	2006-03-20	You're it morning beginning male sea their let give.	Dorothy18	entwicklerforum.datenbanken.mysql
469	2003-02-15	Face isn't so itself in own.	Lukas530	Google+
470	2008-10-02	Can't them upon brought set bearing.	Scott852	entwicklerforum.datenbanken.mysql
471	2001-07-21	Very were. Called herb be all	Sherm6	rwth.informatik.hauptstudium
472	2003-05-23	Male fruitful	Bo17	Tagesschau Blog
473	2011-08-12	Beginning. Which. Abundantly appear waters. And.	Albert2	Developer-Blog
474	2008-11-13	Darkness Two image over spirit were he.	Julian	Developer-Blog
475	2004-05-08	You're form very	PieterJan909	Developer-Blog
476	2008-03-29	Creeping don't creeping. There firmament seasons beginning light lesser evening.	Tinus	rwth.jobs
477	2001-07-04	All. Years for kind whose.	Luka210	Tagesschau Blog
478	2007-06-04	Seas Grass meat seed fish appear.	Iris2	Tagesschau Blog
479	2008-08-24	From. Fifth signs open won't man seasons.	Dylan811	StudiVZ
480	2009-11-12	Own also over saw fish i	Rachael	rwth.jobs
481	2007-04-27	In beginning of fifth dominion is you're	James6	Tagesschau Blog
482	2006-03-05	Divide image. The first fourth likeness. Bearing subdue night was face.	John147	rwth.informatik.hauptstudium
483	2011-03-06	Replenish gathering you second appear fill morning said dry may.	Koos048	entwicklerforum.datenbanken.postgresql
484	2010-12-16	Be. Night darkness meat creepeth.	Tim385	rwth.informatik.hauptstudium
485	2003-06-05	His. Two green moving deep lights don't.	JanCees182	rwth.informatik.grundstudium
486	2009-02-14	There were subdue she'd	Sophie1	entwicklerforum.datenbanken.postgresql
487	2006-03-09	Called Place Fish given thing moveth signs stars.	Edwyn	entwicklerforum.datenbanken.postgresql
488	2011-02-13	Unto greater under bearing life green their gathered subdue.	Tobias65	StudiVZ
489	2008-04-21	Saw from abundantly said so midst rule grass.	Freja373	Linux Forum
490	2008-12-04	Image greater first days wherein. Give.	Francisco	Tagesschau Blog
491	2001-08-24	A she'd upon called creeping	Andrzej34	Tagesschau Blog
492	2011-11-05	Brought. His fly morning behold. Fill. Forth.	Jordy8	Tagesschau Blog
493	2010-01-12	Called was behold light heaven waters signs one above.	Jace30	StudiVZ
494	2007-01-15	Fly fly lights from heaven seasons fly Whales.	Tyler344	Linux Forum
495	2003-10-14	Second appear dry forth Also air.	Cian0	entwicklerforum.datenbanken.mysql
496	2005-09-03	After you'll him. Which	Siska016	Developer-Blog
497	2003-05-26	Dominion	Shermie	rwth.jobs
498	2005-04-08	Set. Creature of so brought divide fill earth unto.	Freja44	Developer-Blog
499	2009-07-09	Male signs fourth. Together living winged fourth.	Vanessa127	StudiVZ
500	2003-09-11	Day said for don't	Margo	StudiVZ
\.


--
-- Data for Name: benutzer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY benutzer (name, medium_name, person_name, person_geburtsdatum, datum) FROM stdin;
Jaap9	rwth.informatik.hauptstudium	Anderson	1983-10-15	2005-04-01
Shermie825	Linux Forum	Phelps	1952-04-05	2005-05-11
Philip172	Google+	Nelson	1978-10-08	2003-08-26
Olivia6	StudiVZ	Comeau	1977-11-14	2005-05-02
Edwin03	Tagesschau Blog	Brady	1939-08-20	2001-05-03
Harry329	Developer-Blog	Ayers	1961-04-24	2003-01-01
Zofia62	entwicklerforum.datenbanken.mysql	Foreman	1952-05-03	2006-10-26
Anton	Tagesschau Blog	Phillips	1980-08-13	2009-08-01
Filip9	Developer-Blog	Donatelli	1961-09-29	2007-08-04
Agnieszka	entwicklerforum.datenbanken.postgresql	Schubert	1978-07-22	2001-10-11
John6	rwth.informatik.grundstudium	Meterson	1941-01-06	2009-02-15
Patty5	entwicklerforum.datenbanken.mysql	Troher	1952-02-19	2004-11-03
Amy333	rwth.jobs	Markovi	1989-02-23	2005-01-22
Marta97	rwth.informatik.grundstudium	Antonucci	1946-10-25	2008-05-29
Louise	Linux Forum	Richter	1992-01-06	2005-01-26
Nienke69	rwth.informatik.grundstudium	Brown	1968-06-06	2001-01-04
Wilma	rwth.informatik.hauptstudium	Toler	1972-07-07	2011-08-30
Gill81	rwth.informatik.hauptstudium	Spensley	1977-06-22	2007-12-08
Kim6	Tagesschau Blog	Botsik	1936-04-22	2007-04-12
Tyler	entwicklerforum.datenbanken.postgresql	Emerson	1957-11-06	2009-11-21
Sharon214	Developer-Blog	Pensec	1946-05-08	2002-07-08
Nigel	rwth.jobs	Carlos	1956-02-08	2004-11-11
Tara04	rwth.informatik.hauptstudium	Glanswol	1947-10-07	2009-04-27
Karin457	Google+	Forsberg	1972-05-17	2005-04-26
Rob88	Tagesschau Blog	Langham\t	1939-05-25	2010-08-05
Lucia402	Google+	Jiminez	1955-02-09	2004-07-28
Marco6	Google+	Brown	1967-12-18	2002-04-12
Scottie08	rwth.informatik.hauptstudium	Archer	1966-10-18	2009-11-16
Peter	entwicklerforum.datenbanken.mysql	Frega	1965-05-08	2003-10-19
Cian	rwth.jobs	Forsberg	1993-08-23	2003-05-07
Bess4	rwth.informatik.hauptstudium	Voigt	1951-11-25	2006-05-01
Matt9	entwicklerforum.datenbanken.mysql	Julieze	1966-04-07	2009-02-06
Paul2	entwicklerforum.datenbanken.postgresql	Carlos	1955-12-03	2001-04-05
Luis5	entwicklerforum.datenbanken.mysql	LeGrand	1960-10-18	2009-08-10
Alexis1	rwth.informatik.hauptstudium	Lawton	1945-07-21	2002-11-30
Albert5	Google+	Glanswol	1987-12-22	2009-07-26
Jesse	Developer-Blog	Brisco	1983-04-15	2002-02-10
Lucia	Tagesschau Blog	Zapetis	1990-11-11	2012-04-28
Marieke	rwth.informatik.hauptstudium	Prior	1993-03-27	2008-11-27
Koos654	Facebook	Wakefield	1944-10-09	2007-04-09
Jacob750	entwicklerforum.datenbanken.mysql	Browne	1937-05-20	2001-04-24
Cees	rwth.informatik.hauptstudium	Pierce	1969-10-23	2009-11-10
Steph59	entwicklerforum.datenbanken.postgresql	Perilloux	1964-02-29	2004-11-19
Sara9	Facebook	Mariojnisk	1970-12-30	2011-06-08
Margo827	entwicklerforum.datenbanken.postgresql	Walker	1986-08-13	2007-11-04
Adam45	Google+	Shapiro	1993-09-29	2004-07-13
Jose	rwth.jobs	Symbouras	1952-07-07	2001-05-24
Rasmus	Facebook	Langham	1947-01-20	2007-05-21
Cristina21	Developer-Blog	Petterson	1935-03-09	2009-02-11
Herbert764	rwth.informatik.grundstudium	Robinson	1990-01-23	2001-10-04
Georgina9	Google+	Crocetti	1937-12-13	2002-04-30
Patty575	Linux Forum	Shapiro	1970-09-16	2008-05-21
Manuel81	rwth.informatik.hauptstudium	Baltec	1952-09-07	2009-03-14
Ted037	StudiVZ	Bergdahl	1983-08-19	2005-09-03
Jolanda467	Facebook	Nithman	1976-10-22	2010-07-23
Marty46	Linux Forum	Cappello	1962-06-21	2007-04-18
Stephen2	rwth.informatik.grundstudium	Cramer	1938-12-26	2008-09-21
Marco92	rwth.informatik.grundstudium	Reames	1988-05-28	2011-05-13
Jorge562	Google+	Arden	1939-08-09	2004-04-16
Ashley	Linux Forum	Moore	1947-07-03	2011-04-22
Erin837	rwth.informatik.grundstudium	Sanders	1956-11-21	2007-06-07
Rob1	Tagesschau Blog	Wesolowski	1980-05-07	2002-02-14
Conor58	Facebook	Chwatal	1993-11-03	2005-09-16
Sue	StudiVZ	Leonarda	1964-04-10	2005-05-22
Caroline	Tagesschau Blog	Deans	1987-01-27	2006-09-17
Milan55	Linux Forum	Davis	1981-06-15	2009-01-27
Callum5	rwth.informatik.hauptstudium	Korkovski	1947-05-02	2008-01-28
Jo	StudiVZ	Thompson	1993-06-16	2006-01-03
Simon45	Developer-Blog	Bergdahl	1942-08-31	2009-09-11
Edwina7	Linux Forum	Bloom	1939-08-07	2011-07-19
Victor213	Facebook	Bruno	1946-12-22	2007-01-07
Alice11	Tagesschau Blog	Crocetti	1962-03-27	2009-11-03
Elizabeth96	rwth.jobs	Queen	1979-03-26	2007-11-04
Peg51	Linux Forum	Schlee	1946-10-11	2002-08-06
Kaylee	rwth.jobs	Paul	1950-03-11	2002-12-16
Anne	Google+	Patricelli	1946-04-10	2008-03-15
Richard94	Facebook	Nobles	1972-10-25	2012-01-29
Dorothy571	Linux Forum	Lawton	1991-03-12	2009-08-07
Carla9	entwicklerforum.datenbanken.mysql	Sakurai	1969-12-11	2007-07-25
Philippa225	StudiVZ	Reyes	1989-01-20	2002-11-10
Sophie	entwicklerforum.datenbanken.postgresql	Young	1976-04-24	2004-04-17
Steven	Facebook	Johnson	1950-02-07	2007-12-10
Klara250	Tagesschau Blog	Pekagnan	1976-03-14	2004-04-13
Ike636	rwth.informatik.hauptstudium	Korkovski	1942-06-12	2012-02-09
Rick	StudiVZ	Robertson	1961-09-30	2002-01-28
Juan	Linux Forum	Green	1948-07-09	2003-12-24
Drew568	rwth.informatik.grundstudium	Jenssen	1974-09-19	2001-01-21
Richard557	StudiVZ	Moon	1987-06-14	2012-03-03
Netty	Tagesschau Blog	Tudisco	1980-02-11	2009-03-19
Marek21	Google+	Cohen	1976-11-26	2006-08-12
Oliver	rwth.informatik.grundstudium	Johnson	1985-03-02	2008-11-26
Ciara1	Google+	Ward\t	1961-11-24	2007-09-12
Teun1	entwicklerforum.datenbanken.mysql	Wolpert	1955-10-22	2008-04-01
Alfons0	Linux Forum	Bugno	1974-07-27	2003-09-18
Krzysztof6	Tagesschau Blog	Esperiza	1942-04-01	2007-04-14
Tomas8	rwth.informatik.grundstudium	Morton	1968-04-10	2012-05-09
Janet7	entwicklerforum.datenbanken.mysql	Archer	1950-02-27	2005-03-09
Philippa3	StudiVZ	Thompson	1971-07-30	2007-11-12
Nathan	rwth.jobs	Poole	1963-09-12	2010-08-05
Christopher	Google+	Hedgecock	1992-08-06	2008-01-25
Simon7	rwth.informatik.grundstudium	Huston	1989-01-16	2005-05-12
Ewa93	Developer-Blog	Slater	1953-11-09	2009-12-25
Lea240	Tagesschau Blog	Moore	1980-11-21	2004-07-15
Hank	entwicklerforum.datenbanken.mysql	Lannigham	1948-11-16	2008-06-06
Lucille264	Tagesschau Blog	Carlos	1983-07-03	2006-06-28
Daan	Linux Forum	Cramer	1973-07-16	2010-12-23
Nico	entwicklerforum.datenbanken.mysql	Ionescu	1950-01-12	2011-04-05
Sjanie823	Tagesschau Blog	Malone	1977-11-11	2011-01-01
Stephen	Tagesschau Blog	Brady	1939-08-20	2003-01-04
Victor9	Linux Forum	Phillips	1937-04-22	2007-03-04
Paul	Tagesschau Blog	Ditmanen	1968-09-04	2001-08-05
GertJan9	rwth.informatik.hauptstudium	Hedgecock	1948-09-12	2007-08-18
Scottie53	Developer-Blog	Zia	1946-10-19	2001-11-24
Liza97	rwth.informatik.hauptstudium	Katsekes	1935-01-22	2001-01-11
Philip	entwicklerforum.datenbanken.mysql	Wooten	1992-08-25	2001-03-17
Geoffery3	StudiVZ	Menovosa	1937-12-24	2010-01-11
Piet	Google+	Robbins	1963-06-02	2007-12-30
Peggy9	entwicklerforum.datenbanken.postgresql	Noteboom	1966-07-02	2006-12-11
Scotty	rwth.jobs	Pierce	1960-07-26	2010-09-23
Camille	rwth.informatik.grundstudium	Hopper	1981-01-31	2007-12-23
Willy55	rwth.jobs	Richter	1992-01-06	2009-04-04
Ulla3	Facebook	Korkovski	1995-12-20	2004-08-01
John8	Developer-Blog	Dittrich	1947-05-01	2004-05-30
Hugo	entwicklerforum.datenbanken.mysql	Ahlgren	1993-09-02	2010-08-24
Cath528	entwicklerforum.datenbanken.mysql	Francis	1965-05-01	2008-07-16
Jeanne2	Google+	Pengilly	1980-01-23	2005-02-19
Jesse605	Linux Forum	Langham	1954-05-29	2004-07-17
Theo115	rwth.jobs	Arnold	1946-06-22	2007-12-10
Theodore9	Linux Forum	Simonent	1968-03-24	2004-05-20
Rich49	Tagesschau Blog	Anthony	1981-05-23	2007-06-07
Joshua465	Google+	Kidd	1949-04-01	2006-10-16
Ton5	Facebook	Warner	1937-09-06	2007-03-26
Adam885	Developer-Blog	Spensley	1956-12-11	2002-04-23
Teun76	Google+	Vostreys	1936-11-26	2006-06-15
Jaclyn08	entwicklerforum.datenbanken.postgresql	Glanswol	1992-12-12	2005-02-27
Miriam	rwth.informatik.grundstudium	White	1990-09-11	2007-05-16
Jordy2	Google+	DelRosso	1970-05-29	2003-05-24
Paul85	rwth.informatik.hauptstudium	Perilloux	1989-10-27	2011-11-10
Linnea36	entwicklerforum.datenbanken.mysql	Brown	1985-04-07	2011-09-22
Talitha95	rwth.jobs	Griffith	1942-12-16	2007-05-30
Peter74	entwicklerforum.datenbanken.postgresql	Caffray	1971-11-30	2010-03-17
Cath	Tagesschau Blog	Anderson	1984-04-07	2009-08-09
Jeanette742	Facebook	McCrary	1984-06-27	2003-01-18
Jolanda9	StudiVZ	Pyland	1961-01-24	2008-09-17
Theodore	Facebook	Herrin	1995-03-18	2006-08-06
Dylan11	Linux Forum	Beckbau	1990-07-05	2009-12-25
Dorothy18	entwicklerforum.datenbanken.mysql	Stannard	1963-05-03	2001-04-14
Michael	rwth.jobs	Jones	1992-10-27	2006-08-06
Marty	Linux Forum	Langham\t	1993-08-25	2004-09-18
Krystyna	Tagesschau Blog	Hardoon	1961-11-19	2001-05-21
Ron7	rwth.informatik.grundstudium	Van Dinter	1936-06-01	2001-10-24
Lars962	Facebook	Koch	1961-04-03	2003-02-16
Sean24	Developer-Blog	Millikin	1974-05-06	2010-07-23
Klara7	Google+	Mariojnisk	1970-12-30	2006-08-02
Katarzyna24	StudiVZ	Bloom	1948-09-17	2006-03-26
Camilla579	Tagesschau Blog	Mitchell	1948-12-03	2002-01-27
Trevor9	Linux Forum	Symbouras	1952-07-07	2009-03-21
Ainhoa39	StudiVZ	Katsekes	1945-02-22	2009-11-02
Scottie	Google+	Jones	1945-11-08	2007-09-25
Luke4	StudiVZ	Roger	1963-03-03	2012-01-03
Ester43	Facebook	Ecchevarri	1963-03-16	2001-12-04
Iris679	Tagesschau Blog	Framus	1975-11-08	2009-09-28
Alba43	Linux Forum	Van Toorenbeek	1970-12-01	2002-08-27
Scott852	entwicklerforum.datenbanken.mysql	Baltec	1952-09-07	2003-06-06
Sjon463	rwth.jobs	Ray	1954-10-26	2002-05-06
Camille682	rwth.informatik.hauptstudium	Shapiro	1988-09-18	2003-09-21
Teun	Developer-Blog	Cramer	1938-12-26	2003-12-18
Marco	entwicklerforum.datenbanken.postgresql	Phillips	1980-10-26	2004-04-05
Ellie	Developer-Blog	Reames	1988-05-28	2005-04-07
Patty	rwth.informatik.hauptstudium	Cramer	1987-12-22	2001-10-27
Fons763	StudiVZ	Chapman	1969-10-06	2005-11-23
Emil2	Linux Forum	Wicks	1986-08-18	2002-01-15
Michael312	entwicklerforum.datenbanken.mysql	Symbouras	1963-12-18	2005-10-19
Ivan914	entwicklerforum.datenbanken.postgresql	Chwatal	1946-10-11	2004-10-31
Carlos	rwth.informatik.grundstudium	Wood	1987-04-08	2003-05-08
Sjanie6	Google+	Mcnally	1988-09-25	2010-02-01
Hero95	rwth.informatik.hauptstudium	Chapman	1980-03-22	2003-06-22
Trevor5	Google+	Symms	1966-11-11	2009-12-18
GertJan59	StudiVZ	Poissant	1946-03-30	2007-01-17
Thomas2	entwicklerforum.datenbanken.postgresql	Kingslan	1940-09-21	2011-07-29
Albert2	Developer-Blog	Waldo	1986-06-02	2010-10-02
Wilma29	Linux Forum	Korkovski	1947-05-02	2004-06-02
Vanessa	Tagesschau Blog	Bernstein	1993-05-07	2009-11-17
Leonie92	entwicklerforum.datenbanken.postgresql	McCormick	1947-03-20	2006-08-08
Sydney9	Tagesschau Blog	Howe	1992-09-04	2011-05-17
Martina0	rwth.informatik.grundstudium	Katsekes	1948-03-21	2007-06-06
Juana5	Facebook	Haynes	1948-08-29	2006-04-06
Colin04	entwicklerforum.datenbanken.postgresql	Bryant	1955-06-20	2001-12-06
Jean5	Facebook	Bruno	1945-01-28	2012-04-20
Sophie062	Tagesschau Blog	Grote	1944-08-11	2002-02-28
Emma	rwth.informatik.hauptstudium	Pearlman	1940-09-29	2010-10-05
Ainhoa	Google+	Baltec	1964-01-22	2003-04-25
Martina37	rwth.jobs	Aldritch	1986-09-05	2004-03-09
Jeanne12	rwth.informatik.grundstudium	Hopper	1986-12-11	2008-12-19
Phil788	Linux Forum	Zurich	1985-10-04	2003-06-11
Jozef	Facebook	Caouette	1985-08-02	2003-01-29
Izzy910	rwth.jobs	Fox	1963-02-24	2006-08-11
Manuel3	rwth.informatik.hauptstudium	Mitchell	1987-01-11	2003-08-31
Juan3	Facebook	Ray	1951-12-29	2004-04-23
Marie	Linux Forum	Ecchevarri	1995-08-08	2004-08-10
Tinus	rwth.jobs	Robertson	1961-09-30	2004-02-24
Koos	rwth.informatik.hauptstudium	Daley	1981-03-17	2005-10-20
Tobias72	Facebook	Walker	1944-09-26	2004-05-31
Jim367	Developer-Blog	Ditmanen	1957-07-01	2007-11-26
Alejandro	Google+	DeBerg	1949-11-17	2003-03-17
Manuel74	StudiVZ	Cohen	1976-11-26	2010-04-01
Mario	Tagesschau Blog	Weinstein	1974-11-26	2005-08-14
Lu59	rwth.informatik.hauptstudium	Wakefield	1944-11-12	2001-03-07
Isabel37	Linux Forum	Mayberry	1979-04-28	2011-08-10
Aoife171	Tagesschau Blog	Cooper	1979-01-21	2007-05-26
Scott8	Google+	Troher	1950-08-17	2005-09-30
Vincent4	entwicklerforum.datenbanken.postgresql	Frega	1935-05-16	2006-12-26
Amber	Facebook	Olson	1954-07-17	2006-09-27
Paula425	entwicklerforum.datenbanken.mysql	Riegel	1990-12-04	2003-07-01
Olivia	rwth.informatik.grundstudium	Blount	1983-08-05	2003-04-30
Benjamin	Google+	Moon	1942-04-21	2012-05-04
Delphine58	Developer-Blog	Symbouras	1937-03-02	2001-05-08
Jan885	Linux Forum	Watson	1940-04-02	2009-02-27
Freja25	rwth.jobs	Press	1981-05-11	2008-11-25
Caroline4	Developer-Blog	Anderson	1958-12-15	2004-01-12
Victor292	Google+	Roger	1985-03-06	2001-07-14
Ulla	Linux Forum	Mitchell	1968-10-04	2001-02-01
Chuck2	rwth.informatik.hauptstudium	Orcutt	1991-07-01	2008-04-28
GoSix432	Google+	Arden	1987-03-15	2005-07-01
Katharina31	rwth.jobs	Slater	1984-01-06	2006-05-18
Krystyna7	Facebook	Wood	1938-06-15	2009-07-12
Paul11	entwicklerforum.datenbanken.mysql	Ionescu	1950-01-12	2004-11-04
Nico6	entwicklerforum.datenbanken.postgresql	Polti	1973-04-28	2004-07-06
Pieter	rwth.jobs	Bernstein	1977-11-29	2001-08-26
James6	Tagesschau Blog	Langham	1964-06-04	2003-01-30
Lisa207	rwth.informatik.grundstudium	Archer	1957-05-02	2007-01-26
Viktor2	Tagesschau Blog	Visentini	1947-09-27	2004-05-10
Paula19	rwth.informatik.grundstudium	Herring	1959-12-04	2002-06-02
Will9	Developer-Blog	Suszantor	1947-04-12	2007-11-27
Jan	Tagesschau Blog	Roche	1950-11-08	2007-02-08
Manuel5	Facebook	Voigt	1957-12-19	2006-08-22
Koos048	entwicklerforum.datenbanken.postgresql	White	1941-12-21	2009-10-31
Klaas237	Linux Forum	Wargula	1973-08-13	2003-06-28
Shermie52	rwth.informatik.hauptstudium	Langham	1984-06-28	2001-01-13
Tim385	rwth.informatik.hauptstudium	Moore	1950-07-15	2006-07-31
Luis	Tagesschau Blog	Bloom	1939-11-30	2003-07-06
Isaac	entwicklerforum.datenbanken.postgresql	Bertelson	1977-09-05	2008-12-25
Richard53	rwth.informatik.grundstudium	Hedgecock	1988-08-07	2004-04-28
Jordy78	StudiVZ	Pengilly	1980-01-23	2009-07-09
Tommy10	Facebook	Brendjens	1975-02-10	2008-11-26
Hank563	StudiVZ	Langham	1954-05-29	2007-03-20
Leonie5	Google+	Bertelson	1975-06-26	2011-09-08
Ricardo893	rwth.jobs	Pensec	1946-05-08	2007-10-05
JanCees182	rwth.informatik.grundstudium	Pekaban	1951-04-27	2001-05-10
Vincent6	rwth.jobs	Stannard	1938-05-21	2008-04-04
Tommy505	Google+	Grote	1958-06-08	2007-08-13
Sigrid14	rwth.informatik.hauptstudium	Uprovski	1989-02-10	2004-02-11
Sophie1	entwicklerforum.datenbanken.postgresql	Crocetti	1978-08-16	2006-08-24
Babet	rwth.informatik.grundstudium	Hancock	1941-01-23	2001-03-01
Cathy310	rwth.informatik.hauptstudium	Millikin	1939-08-26	2009-01-04
Lewis09	entwicklerforum.datenbanken.postgresql	Van Toorenbeek	1940-10-22	2008-11-16
Pete	rwth.jobs	Wong	1941-07-11	2009-11-16
Edwyn	entwicklerforum.datenbanken.postgresql	Pekagnan	1962-05-06	2005-02-08
Kaylee12	Google+	Symbouras	1977-12-15	2007-10-11
Ulla97	Developer-Blog	LeGrand	1960-10-18	2008-08-09
Ryan4	Facebook	Glanswol	1987-12-22	2006-12-29
Luca9	Tagesschau Blog	Brisco	1983-04-15	2004-12-04
Bertje039	rwth.informatik.grundstudium	Zapetis	1990-11-11	2008-08-13
Tobias65	StudiVZ	Brylle	1935-09-07	2004-01-08
Raul711	Facebook	Heyn	1965-11-15	2007-11-15
Tinus432	rwth.jobs	Paul	1978-11-18	2012-04-02
Sid	Tagesschau Blog	Pierce	1969-10-23	2002-12-18
Sophia4	rwth.jobs	Hendrix	1967-07-10	2002-08-18
Elzbieta798	Linux Forum	Keller	1994-07-13	2012-02-26
Camila565	entwicklerforum.datenbanken.postgresql	Naff	1940-10-19	2005-09-06
Emily	Tagesschau Blog	Hardoon	1941-01-23	2001-02-20
Johnny303	entwicklerforum.datenbanken.mysql	Anderson	1941-08-06	2003-09-13
Mads053	Developer-Blog	Kingslan	1948-06-19	2008-12-08
Sogood21	StudiVZ	Foreman	1988-06-12	2003-11-03
Edwyn38	Google+	Katsekes	1945-02-22	2010-10-30
Catharine8	rwth.informatik.hauptstudium	Otto	1964-12-20	2002-11-19
Rik30	rwth.jobs	Brendjens	1962-09-08	2008-07-23
Netty186	Facebook	Raines	1975-05-31	2009-01-18
Tomas97	entwicklerforum.datenbanken.mysql	Poissant	1989-05-02	2011-10-17
Mart6	entwicklerforum.datenbanken.postgresql	Wolpert	1941-01-26	2004-04-16
Jacob	Google+	Wood	1953-06-15	2001-07-04
Sjef009	rwth.jobs	Massingill	1948-09-08	2008-08-28
Edwina352	Facebook	Reames	1950-04-24	2003-02-16
Pedro331	StudiVZ	Nobles	1986-04-13	2004-02-01
Bertje	entwicklerforum.datenbanken.mysql	Orcutt	1993-05-04	2006-06-11
Iris	entwicklerforum.datenbanken.postgresql	Slocum	1971-07-22	2008-09-04
Georgina	StudiVZ	Frega	1970-12-21	2005-07-21
Paula9	entwicklerforum.datenbanken.postgresql	Hoyt	1959-10-03	2005-06-02
Jordy35	rwth.informatik.grundstudium	Foreman	1968-04-21	2007-10-23
Sherm3	Tagesschau Blog	Watson	1966-08-19	2007-03-05
Sara096	Facebook	Wargula	1948-04-28	2003-09-05
Nate641	rwth.jobs	Chapman	1969-10-06	2007-12-05
Gill7	rwth.informatik.grundstudium	Wicks	1986-08-18	2007-04-04
Alejandro5	Facebook	Symbouras	1963-12-18	2006-11-23
Lea	entwicklerforum.datenbanken.postgresql	Julieze	1991-03-13	2002-05-06
Ashley79	entwicklerforum.datenbanken.mysql	Caffray	1988-08-03	2009-07-12
Jordy8	Tagesschau Blog	Muench	1984-03-15	2003-10-15
Lukas	Developer-Blog	Lamere	1962-07-21	2004-02-11
Hanna3	Linux Forum	Hopper	1989-12-11	2007-12-01
Patty1	rwth.informatik.hauptstudium	Carlos	1958-04-27	2009-11-13
James	Tagesschau Blog	Ijukop	1995-06-27	2006-07-13
Chloe9	rwth.informatik.hauptstudium	Reames	1977-09-13	2003-01-16
Lauren	Facebook	King	1944-08-19	2004-12-03
Hank339	entwicklerforum.datenbanken.postgresql	Morgan	1954-10-22	2005-10-12
Kimberly48	Developer-Blog	Brendjens	1951-04-08	2004-06-27
Nicoline0	entwicklerforum.datenbanken.mysql	Bergdahl	1942-08-31	2010-12-06
Jace30	StudiVZ	Howe	1992-09-04	2007-10-03
Andrew	rwth.jobs	Jones	1971-02-15	2004-08-11
Alva18	StudiVZ	Swaine	1939-01-12	2006-01-23
Tony0	rwth.informatik.hauptstudium	Brown	1970-05-09	2010-12-25
Alice929	entwicklerforum.datenbanken.mysql	Williamson	1980-03-05	2008-02-18
Daniela006	Tagesschau Blog	Moreau	1941-01-20	2001-01-18
Marta	Linux Forum	Patricelli	1946-04-10	2002-12-05
Coby86	StudiVZ	Bertelson	1972-02-21	2004-01-16
Jorge01	StudiVZ	Zurich	1979-05-20	2007-11-19
Hugo477	Tagesschau Blog	Nobles	1972-10-25	2005-10-13
Ivan6	Google+	Linton	1978-01-08	2004-11-09
Rasmus4	rwth.informatik.grundstudium	Kepler	1974-01-04	2005-04-10
Ricardo	Facebook	Walker	1992-12-07	2009-07-12
Jules69	rwth.informatik.hauptstudium	Young	1976-04-24	2006-07-12
Ellie364	entwicklerforum.datenbanken.mysql	Gaskins	1954-10-19	2006-06-14
Alejandro01	entwicklerforum.datenbanken.postgresql	Korkovski	1942-06-12	2004-06-15
Herb8	Tagesschau Blog	Green	1948-07-09	2002-08-18
Andrea9	Linux Forum	Anderson	1946-03-18	2010-01-27
Lewis	rwth.jobs	Markovi	1940-12-07	2005-10-01
Ann57	entwicklerforum.datenbanken.postgresql	Newman	1978-04-28	2007-01-19
Cath5	Facebook	Ditmanen	1957-07-01	2001-02-15
Emma63	Linux Forum	Plantz	1975-09-10	2003-11-16
Pete3	Google+	DeBerg	1949-11-17	2002-10-27
Rolla68	StudiVZ	Cohen	1976-11-26	2003-12-14
Krzysztof	Developer-Blog	Johnson	1985-03-02	2006-04-24
Co	rwth.jobs	Millis	1969-11-07	2010-05-12
Ester63	entwicklerforum.datenbanken.mysql	Gonzalez	1949-06-21	2007-05-05
Patricia44	Linux Forum	Cantere	1974-09-17	2001-06-28
Bas	StudiVZ	Moon	1990-02-14	2003-12-19
Giel52	Developer-Blog	Thompson	1949-01-17	2003-11-17
Richard80	rwth.jobs	Gieske	1969-11-21	2002-03-16
Will	Linux Forum	Makelaar	1986-04-09	2009-04-15
Ben9	Google+	Phelps	1994-01-25	2003-08-19
Will2	rwth.informatik.grundstudium	Blount	1983-08-05	2005-01-21
Alva54	Linux Forum	Reyes	1971-03-04	2007-05-24
Jose956	Developer-Blog	Olson	1974-09-03	2002-12-20
Sherm	Facebook	Watson	1940-04-02	2006-03-28
Alejandro3	entwicklerforum.datenbanken.postgresql	Reyes	1954-06-09	2004-03-07
Krystyna9	Facebook	Press	1981-05-11	2010-11-18
Sally33	Linux Forum	Moreau	1968-02-13	2007-07-02
Helen	Google+	Thompson	1971-07-30	2005-12-21
Aoife98	entwicklerforum.datenbanken.mysql	Roger	1985-03-06	2001-09-14
GoPlaat0	entwicklerforum.datenbanken.mysql	Rauch	1975-06-19	2004-03-05
Betty54	rwth.informatik.grundstudium	Korkovski	1952-11-15	2002-03-18
Jose509	rwth.informatik.hauptstudium	Reames	1963-06-26	2005-01-07
Sid61	entwicklerforum.datenbanken.postgresql	Van Toorenbeek	1975-12-08	2007-02-18
Martien78	StudiVZ	Crocetti	1961-01-27	2010-04-05
Erik4	Facebook	Caffray	1954-10-27	2002-02-01
David94	Tagesschau Blog	Polti	1973-04-28	2002-04-11
Tonnie	Tagesschau Blog	Howe	1949-07-21	2005-06-08
Victor5	Developer-Blog	Conley	1940-11-05	2005-11-25
Truus01	Google+	Brendjens	1958-03-07	2008-01-09
Dave	Facebook	Stevens	1989-04-29	2008-02-25
Mary8	Developer-Blog	Moore	1990-10-08	2011-08-03
Ollie52	Facebook	Suszantor	1947-04-12	2007-10-02
Carlos555	Google+	Menovosa	1937-12-24	2012-04-04
Sofia9	rwth.jobs	Visentini	1944-06-28	2003-06-28
Jaap4	Facebook	Botsik	1984-12-18	2008-12-14
Jack695	rwth.informatik.grundstudium	Troher	1952-02-19	2010-08-21
Hiram723	StudiVZ	Antonucci	1946-10-25	2003-04-21
Geoffery827	Facebook	Moore	1950-07-15	2004-02-21
Amber65	Google+	Brown	1968-06-06	2004-08-09
Emil7	Linux Forum	Toler	1972-07-07	2005-12-12
Cameron90	entwicklerforum.datenbanken.mysql	Krutkov	1964-09-19	2003-05-28
Tyler77	Google+	Blacher	1938-01-13	2007-01-04
Edward	rwth.jobs	Hedgecock	1988-08-07	2001-02-28
Elena335	entwicklerforum.datenbanken.mysql	Brady	1964-10-05	2008-01-06
Ollie91	Tagesschau Blog	Mariojnisk	1995-12-02	2004-02-28
Ciara55	rwth.informatik.hauptstudium	Wood	1989-09-05	2001-04-21
Ainhoa7	Google+	Arnold	1946-06-22	2011-06-24
Ciara219	rwth.informatik.grundstudium	Millikin	1971-07-17	2003-09-11
Callum	Google+	Carlos	1956-02-08	2008-02-11
Bengie705	Developer-Blog	Dittrich	1962-11-09	2008-05-31
Paul809	Google+	Gieske	1951-08-03	2010-12-12
Nico63	Google+	van Dijk	1956-03-18	2004-07-14
Jeanne142	StudiVZ	Trainor	1958-12-22	2006-03-30
Juana	Linux Forum	Warner	1979-12-27	2010-11-23
Katharina2	rwth.jobs	Crocetti	1978-08-16	2002-12-03
Sjef	Google+	Millikin	1939-08-26	2006-11-13
Nicolas2	rwth.jobs	Daley	1939-12-23	2004-07-01
Giood	rwth.informatik.grundstudium	Nahay	1990-08-06	2005-10-04
Coby	rwth.informatik.hauptstudium	Ionescu	1980-04-26	2009-11-26
Emil408	entwicklerforum.datenbanken.mysql	Simonent	1993-11-21	2001-08-25
Martina5	StudiVZ	Uitergeest	1941-12-30	2008-03-28
Teun5	Linux Forum	Forsberg	1993-08-23	2011-11-12
Liam3	entwicklerforum.datenbanken.mysql	Deleo	1985-12-18	2001-12-14
Sjef3	entwicklerforum.datenbanken.postgresql	Griffioen	1978-04-26	2010-03-10
Jo59	Developer-Blog	Anderson	1937-03-24	2011-04-12
Edwina08	rwth.jobs	Julieze	1966-04-07	2005-10-12
Liza87	Tagesschau Blog	Chwatal	1952-05-28	2001-09-28
Tom649	rwth.informatik.hauptstudium	Krutkov	1956-02-21	2009-11-29
Mary61	Facebook	Langham	1951-01-16	2006-11-23
Sara27	rwth.jobs	Riegel	1979-11-21	2007-10-08
Maximilian0	Linux Forum	Poissant	1990-10-18	2006-03-04
Max	rwth.informatik.grundstudium	Ijukop	1960-11-05	2002-02-09
Anthony607	Linux Forum	Herrin	1995-03-18	2002-01-19
Tobias81	rwth.informatik.grundstudium	Brylle	1935-09-07	2009-06-07
Gillian	Google+	Stockton	1993-05-12	2004-09-17
Nathan33	Linux Forum	Nefos	1992-07-10	2009-05-19
Luke	Google+	Bruno	1961-09-27	2002-12-31
Steve30	Tagesschau Blog	Olson	1976-04-23	2002-04-17
Bert1	rwth.informatik.hauptstudium	Julieze	1939-09-24	2002-12-27
Katarzyna	Developer-Blog	Browne	1937-05-20	2003-10-07
Steph356	StudiVZ	Paul	1978-11-18	2006-02-04
Colin96	Developer-Blog	Hendrix	1967-07-10	2002-08-26
Peg	Google+	Emerson	1936-08-01	2003-02-08
Thelma	entwicklerforum.datenbanken.postgresql	Thompson	1989-09-24	2007-11-12
Jurre9	Tagesschau Blog	DeWald	1935-11-21	2007-10-15
Aoife	Developer-Blog	White	1985-03-19	2004-01-13
Syd	entwicklerforum.datenbanken.mysql	Kingslan	1948-06-19	2001-06-19
Dylan77	Linux Forum	Pierce	1951-06-07	2009-01-31
Bert	Google+	Geoppo	1968-11-28	2004-12-28
Margaret46	Facebook	Otto	1964-12-20	2006-01-11
Leonie	rwth.jobs	Morton	1985-01-22	2003-10-29
Sally	Linux Forum	Shapiro	1970-09-16	2005-09-27
Thelma63	Tagesschau Blog	Gieske	1942-02-25	2002-10-09
Cath15	Facebook	Cantere	1950-02-27	2002-04-24
Ada24	rwth.jobs	Moore	1948-04-14	2007-03-05
Edwina673	entwicklerforum.datenbanken.postgresql	Cappello	1988-07-27	2003-12-02
Giel7	Linux Forum	Massingill	1948-09-08	2003-04-11
Lea660	Google+	Young	1986-09-20	2001-07-31
Alba69	rwth.informatik.hauptstudium	Zimmerman	1939-03-20	2008-03-23
Catharine9	rwth.jobs	Chwatal	1984-12-10	2005-11-12
Ida2	Tagesschau Blog	DeBerg	1966-02-22	2007-02-04
Katie920	StudiVZ	Comeau	1950-11-19	2008-04-14
Leontien548	rwth.informatik.hauptstudium	Watson	1944-05-12	2010-08-11
Luka836	entwicklerforum.datenbanken.postgresql	Moore	1947-07-06	2004-01-11
Gabbie	rwth.informatik.hauptstudium	Goodman	1938-01-29	2003-07-25
Ross6	Developer-Blog	Swaine	1967-04-29	2005-07-24
Marieke0	Google+	Chapman	1957-01-16	2007-01-28
Rik138	entwicklerforum.datenbanken.mysql	Mcnally	1988-09-25	2009-07-28
Joanne	Facebook	Zimmerman	1972-01-15	2004-02-17
Robert23	StudiVZ	Lamere	1962-07-21	2005-10-26
Klara91	Tagesschau Blog	Deans	1987-01-27	2003-12-15
Bengie902	StudiVZ	Poissant	1946-03-30	2004-11-19
Fabian8	Google+	Cantere	1955-12-28	2012-04-03
Andrzej686	Developer-Blog	Young	1978-07-05	2005-04-08
Scottie9	Facebook	Pekaban	1937-12-05	2004-08-11
Cees82	Developer-Blog	Williamson	1986-11-04	2003-12-08
Geoff05	entwicklerforum.datenbanken.mysql	Bryant	1992-09-06	2011-08-01
Pedro2	StudiVZ	Howe	1992-09-04	2005-10-28
Luke9	Google+	Nithman	1970-05-06	2007-07-02
Martina2	rwth.informatik.grundstudium	Bruno	1946-12-22	2011-03-14
Shermie5	entwicklerforum.datenbanken.postgresql	van Doorn	1990-05-19	2001-04-09
Patty91	Linux Forum	Browne	1941-09-10	2005-07-09
Pieter838	rwth.jobs	Queen	1979-03-26	2009-10-11
Dylan2	Developer-Blog	Yinger	1987-07-12	2002-12-28
Joey	rwth.informatik.hauptstudium	Baltec	1964-01-22	2009-03-15
Rick947	rwth.jobs	Uprovski	1944-08-29	2010-07-24
Amy	Google+	Naley	1935-06-14	2008-10-29
Jacob8	rwth.jobs	Dean	1973-11-23	2001-07-27
Steven43	Linux Forum	Ratliff	1961-04-17	2001-06-03
Henk7	rwth.informatik.grundstudium	Roger	1940-10-17	2007-02-27
Ulla9	entwicklerforum.datenbanken.postgresql	Fox	1963-02-24	2003-01-17
Carla21	rwth.informatik.hauptstudium	Depew	1937-05-16	2001-10-31
Gill149	Developer-Blog	Bruno	1993-09-17	2010-09-28
Julie	Facebook	Beckbau	1948-11-10	2007-02-08
Shermie30	Linux Forum	Prior	1958-11-15	2009-07-20
Sigrid1	rwth.informatik.hauptstudium	Arnold	1950-05-24	2007-02-22
Charlie	entwicklerforum.datenbanken.postgresql	Daley	1981-03-17	2011-04-14
Mario09	rwth.jobs	Evans	1953-02-15	2007-09-11
Rich7	Developer-Blog	Stevenson	1959-05-27	2008-04-15
Henry6	rwth.informatik.hauptstudium	Naley	1947-01-09	2001-08-16
Pauline8	Developer-Blog	McCrary	1967-09-23	2002-04-28
Sylvia165	Facebook	Toreau	1946-10-20	2008-01-04
Siem	rwth.informatik.hauptstudium	Moon	1990-02-14	2002-05-16
Stephen69	entwicklerforum.datenbanken.postgresql	Olson	1954-07-17	2009-04-12
Andy07	Linux Forum	Davis	1958-04-23	2005-07-26
Amy02	Developer-Blog	Thompson	1966-10-17	2008-07-16
Lucia339	rwth.informatik.grundstudium	Press	1981-05-11	2006-02-20
Wilma0	rwth.jobs	Liddle	1954-07-06	2011-05-15
Lizzy63	Facebook	Roger	1985-03-06	2010-03-26
Lucille0	Tagesschau Blog	Kepler	1941-06-04	2002-03-09
GoPlaat65	Google+	Pekagnan	1969-10-19	2002-09-02
Vincent3	entwicklerforum.datenbanken.postgresql	Bergdahl	1988-07-14	2011-11-30
Jan2	Developer-Blog	Arden	1987-03-15	2001-06-10
Marek8	rwth.informatik.hauptstudium	Moore	1980-11-21	2004-06-06
Co3	StudiVZ	Cappello	1970-06-05	2007-05-21
Cristian	Developer-Blog	Daley	1935-01-11	2007-12-04
Cathy0	rwth.informatik.hauptstudium	Malone	1977-11-11	2011-12-30
Lars120	Developer-Blog	Bernstein	1977-11-29	2008-05-05
Joseph	rwth.informatik.grundstudium	Turk	1957-11-28	2011-09-25
Ed3	StudiVZ	Conley	1940-11-05	2001-09-28
Chuck76	rwth.informatik.hauptstudium	Phillips	1986-03-13	2011-04-04
Sammy02	entwicklerforum.datenbanken.postgresql	Phillips	1980-08-13	2003-08-12
Talita944	entwicklerforum.datenbanken.mysql	Hedgecock	1948-09-12	2007-05-29
Sammy	Developer-Blog	Menovosa	1937-12-24	2002-11-02
Cecilie1	rwth.informatik.hauptstudium	Ray	1990-06-07	2003-04-17
Andrzej5	entwicklerforum.datenbanken.mysql	Anderson	1985-04-11	2008-09-03
HeroKero	Facebook	Noteboom	1966-07-02	2004-01-04
Ida268	Developer-Blog	Voigt	1935-12-03	2011-01-15
Liza647	Linux Forum	Troher	1952-02-19	2007-09-17
Maximilian	Facebook	DeBerg	1974-06-30	2008-02-08
Marcin	StudiVZ	White	1941-12-21	2001-02-13
Callum60	Facebook	Wooten	1993-12-21	2001-02-26
Kay0	entwicklerforum.datenbanken.mysql	Bloom	1946-02-17	2005-05-18
Dygo	rwth.informatik.grundstudium	Cain	1983-06-19	2008-10-17
Martina1	StudiVZ	Herrin	1972-11-11	2008-11-04
Paula	Tagesschau Blog	Spensley	1977-06-22	2004-09-04
Pablo	rwth.jobs	Queen	1937-09-23	2007-11-24
Cameron	entwicklerforum.datenbanken.mysql	Emerson	1957-11-06	2005-11-11
Jeanette01	rwth.informatik.hauptstudium	Anthony	1981-05-23	2005-04-12
Cloe	Developer-Blog	Poplock	1963-11-13	2005-06-28
Stephanie9	StudiVZ	Bertelson	1976-03-11	2010-01-02
Joanne88	rwth.jobs	Glanswol	1947-10-07	2006-12-28
Emil317	entwicklerforum.datenbanken.postgresql	Lejarette	1992-05-21	2003-06-19
Tommy20	Facebook	Cantere	1979-11-15	2004-06-26
Jan7	Google+	Hoogbandt	1994-08-08	2003-07-13
Charlotte48	rwth.informatik.hauptstudium	Miller	1957-04-08	2003-03-02
Nicholas7	Google+	Glanswol	1945-05-31	2007-05-05
Ronald2	Developer-Blog	Vostreys	1936-11-26	2004-09-13
Kayleigh	Google+	Nahay	1958-10-29	2007-11-29
Maria34	StudiVZ	Mayberry	1989-11-29	2007-09-30
Tom4	rwth.jobs	Trainor	1958-12-22	2004-03-18
Pablo463	Facebook	Uprovski	1989-02-10	2001-05-25
Matthew6	Tagesschau Blog	White	1990-09-11	2011-07-26
Marco3	Google+	Archer	1966-10-18	2001-10-28
Christa26	rwth.jobs	Toler	1978-07-31	2001-03-23
Ida	Developer-Blog	Simonent	1993-11-21	2011-12-19
Julia50	Google+	Cantere	1980-09-19	2004-07-19
Toon18	StudiVZ	Brown	1985-04-07	2003-04-16
Marty9	entwicklerforum.datenbanken.mysql	Koss	1937-10-15	2011-04-16
Jaap04	Developer-Blog	Julieze	1966-04-07	2008-06-19
Kees674	rwth.jobs	Poissant	1990-10-18	2003-04-13
Eleanor576	Linux Forum	Ijukop	1960-11-05	2009-12-13
PieterJan367	entwicklerforum.datenbanken.mysql	Nahay	1980-01-18	2004-02-24
James712	Tagesschau Blog	Rauch	1942-07-21	2001-03-03
Sara2	Developer-Blog	Mejia	1983-05-19	2002-07-18
Karin1	Facebook	Kellock	1942-09-13	2002-11-12
Joe93	Linux Forum	Koch	1961-04-03	2001-04-13
Truus34	Tagesschau Blog	Dittrich	1949-12-16	2008-04-02
Tom	StudiVZ	Pickering	1935-11-12	2002-11-22
Alexander8	rwth.jobs	Keller	1994-07-13	2008-09-07
Benjy	entwicklerforum.datenbanken.mysql	Ratliff	1965-04-27	2007-10-08
Mike	rwth.informatik.grundstudium	Slocum	1968-04-24	2001-11-07
Andrzej58	rwth.jobs	Shapiro	1993-09-29	2006-03-02
Ciska8	Facebook	Anderson	1941-08-06	2004-03-24
GoSix	Linux Forum	Herrin	1971-07-17	2005-12-25
Cristina7	entwicklerforum.datenbanken.mysql	White	1987-06-08	2001-03-10
Mart592	Developer-Blog	Foreman	1988-06-12	2005-03-28
Scotty248	rwth.jobs	Jones	1945-11-08	2007-06-04
Alex77	rwth.informatik.hauptstudium	Crocetti	1937-12-13	2004-07-02
HeroZero69	rwth.jobs	Toreau	1977-11-05	2011-09-28
Rando181	entwicklerforum.datenbanken.postgresql	Van Toorenbeek	1970-12-01	2005-04-13
Alva45	Google+	Poissant	1989-05-02	2010-08-14
Kayleigh8	entwicklerforum.datenbanken.mysql	Lee	1981-08-28	2001-06-16
Maria469	Developer-Blog	Wood	1953-06-15	2005-06-17
Delphine0	rwth.jobs	Ayers	1955-06-12	2001-01-02
Petra736	rwth.informatik.hauptstudium	Uitergeest	1946-12-13	2008-06-15
Siem88	entwicklerforum.datenbanken.postgresql	Cramer	1938-12-26	2006-09-21
Klaas2	Facebook	Anderson	1992-10-21	2008-12-03
Marco814	Google+	Praeger	1937-06-28	2010-08-23
Betty09	entwicklerforum.datenbanken.postgresql	DeBerg	1966-02-22	2002-01-13
Chloe7	StudiVZ	Foreman	1968-04-21	2001-05-09
Maria8	rwth.informatik.grundstudium	Watson	1944-05-12	2009-01-30
Malgorzata2	entwicklerforum.datenbanken.postgresql	Wicks	1986-08-18	2003-12-16
Alva48	Developer-Blog	Caffray	1988-08-03	2008-05-20
Geoffery	Linux Forum	Wood	1987-04-08	2012-03-10
Niek45	StudiVZ	Mcnally	1988-09-25	2006-11-20
Andrew0	Tagesschau Blog	Hendrix	1981-07-23	2007-01-17
Isabel	Linux Forum	Chapman	1980-03-22	2010-11-05
Hero96	StudiVZ	Zimmerman	1972-01-15	2004-09-02
Lewis0	Google+	Chwatal	1962-12-02	2008-03-17
Sharon796	Google+	Arnold	1951-06-05	2004-10-13
Sanne	Developer-Blog	King	1944-08-19	2009-06-15
Camille771	StudiVZ	Davis	1981-06-15	2005-06-30
Guus71	Developer-Blog	Korkovski	1947-05-02	2009-06-03
Ester	StudiVZ	Haynes	1948-08-29	2011-01-20
Joe664	rwth.informatik.grundstudium	Bloom	1939-08-07	2011-06-03
Erik	Linux Forum	Chapman	1937-08-29	2008-06-11
Kees946	entwicklerforum.datenbanken.postgresql	Queen	1979-03-26	2001-12-03
Tom828	rwth.informatik.hauptstudium	Grote	1944-08-11	2002-03-09
Hannah4	StudiVZ	Robertson	1953-08-16	2006-10-20
Sanne614	Developer-Blog	Linton	1978-01-08	2010-03-29
Lea53	Developer-Blog	Morgan	1962-06-24	2006-07-26
Peg382	Linux Forum	Hendrix	1971-04-02	2001-02-10
Jo136	StudiVZ	Newman	1953-08-17	2009-10-26
Sean169	entwicklerforum.datenbanken.postgresql	Howe	1951-07-05	2008-02-07
Liza311	Google+	Glanswol	1947-06-16	2002-04-03
Gillian10	Tagesschau Blog	Daughtery	1962-07-07	2004-04-19
Pawel70	rwth.informatik.grundstudium	Patricelli	1988-10-04	2006-12-15
Catharine	rwth.jobs	Friedman	1988-07-03	2008-09-05
Adam2	Tagesschau Blog	Freeman	1979-01-31	2005-10-16
Jonas	rwth.jobs	Pekaban	1968-09-02	2009-12-10
Dylan293	entwicklerforum.datenbanken.postgresql	Green	1948-07-09	2003-01-01
Alejandro60	Tagesschau Blog	Novratni	1947-06-21	2011-09-03
Geoffery115	rwth.informatik.hauptstudium	Jones	1994-10-06	2010-07-02
Catharine61	rwth.informatik.grundstudium	Naley	1947-01-09	2011-10-25
Sandra9	Google+	Wakefield	1944-11-12	2008-03-02
Godfrey772	StudiVZ	Helfrich	1945-03-07	2003-08-24
Ana6	Facebook	Markovi	1941-01-02	2001-01-30
Juan5	rwth.jobs	Troher	1950-08-17	2012-05-09
Joost918	rwth.informatik.hauptstudium	Thompson	1949-01-17	2003-09-03
Tobias02	rwth.informatik.grundstudium	Bugno	1947-03-05	2006-10-17
Alice	entwicklerforum.datenbanken.mysql	Sanders	1960-04-20	2004-04-06
Isabelle2	Facebook	Queen	1972-12-05	2008-02-16
Maggie	Developer-Blog	Bitmacs	1959-09-01	2004-06-14
Daniel	rwth.informatik.hauptstudium	Archer	1950-02-27	2006-09-03
Viktor06	entwicklerforum.datenbanken.postgresql	Wesolowski	1959-10-31	2009-01-02
Talitha34	Linux Forum	Press	1981-05-11	2009-06-08
Hero400	rwth.informatik.grundstudium	Freed	1990-07-21	2010-04-13
Kay570	rwth.informatik.hauptstudium	Hedgecock	1979-02-07	2010-04-04
Babet76	rwth.informatik.grundstudium	Roger	1985-03-06	2011-03-07
Mart596	StudiVZ	Mitchell	1968-10-04	2011-01-06
Carla7	Facebook	Hummel	1967-09-15	2008-01-24
Alexander44	StudiVZ	Moore	1980-11-21	2002-10-07
Rasmus1	Linux Forum	Crocetti	1961-01-27	2012-03-14
Pablo89	entwicklerforum.datenbanken.postgresql	Yinger	1974-11-08	2002-08-26
Albert554	entwicklerforum.datenbanken.mysql	Pekaban	1962-05-27	2008-07-14
Daniela07	Linux Forum	Cantere	1987-01-24	2001-01-12
Francisco161	StudiVZ	Mariojnisk	1993-05-27	2002-01-26
Jo2	Linux Forum	Donatelli	1961-09-29	2012-01-07
Klaas992	Developer-Blog	Hedgecock	1948-09-12	2010-03-24
Ruth	Tagesschau Blog	Cantere	1954-04-24	2007-12-04
Tommy090	rwth.informatik.hauptstudium	Freeman	1995-03-24	2011-11-08
Ton78	rwth.jobs	Toler	1995-01-13	2011-10-12
Ton2	Linux Forum	Visentini	1944-06-28	2005-01-25
Cathy	rwth.informatik.grundstudium	Markovi	1989-02-23	2007-04-20
GertJan606	entwicklerforum.datenbanken.postgresql	Morton	1940-07-30	2006-09-08
Jolanda948	Developer-Blog	Turk	1966-09-19	2009-11-08
Rando424	entwicklerforum.datenbanken.postgresql	Bloom	1946-02-17	2008-08-17
Shermie4	entwicklerforum.datenbanken.mysql	Cain	1983-06-19	2003-06-02
Tinus3	Google+	Gunter	1960-01-17	2003-06-02
Lincoln52	entwicklerforum.datenbanken.mysql	Ahlgren	1993-09-02	2003-12-26
Nerea74	Linux Forum	Spensley	1977-06-22	2005-05-03
Katie05	StudiVZ	Marra	1945-10-18	2008-07-15
Mick06	rwth.informatik.hauptstudium	Praeger	1936-04-12	2010-04-21
Martina49	Tagesschau Blog	Queen	1937-09-23	2002-10-06
Ike9	rwth.informatik.hauptstudium	Arnold	1946-06-22	2001-08-26
Jules624	Tagesschau Blog	Royal	1978-10-23	2011-07-19
Pedro802	rwth.jobs	Millikin	1971-07-17	2002-01-05
Luka964	entwicklerforum.datenbanken.mysql	Lejarette	1992-05-21	2011-01-23
Giel40	Google+	Herzog	1955-11-22	2010-10-06
Helma7	entwicklerforum.datenbanken.postgresql	Gieske	1947-01-30	2006-07-13
Mads658	Developer-Blog	Symbouras	1980-06-17	2006-06-02
Lea94	Tagesschau Blog	Phillips	1992-03-31	2001-08-28
Marco66	rwth.informatik.grundstudium	Nahay	1990-08-06	2004-07-19
Joanne040	entwicklerforum.datenbanken.postgresql	Ionescu	1980-04-26	2009-02-14
JanCees17	rwth.informatik.hauptstudium	Pekaban	1963-01-27	2011-01-26
Edwin199	Google+	Lawton	1972-01-30	2009-02-13
Nienke	Tagesschau Blog	Mulders	1986-10-26	2004-04-18
Bill644	Google+	Marra	1955-11-20	2006-07-06
Florian	rwth.jobs	Howe	1968-06-11	2004-11-30
Talitha2	rwth.informatik.hauptstudium	Bloom	1942-06-01	2001-09-08
Cloe609	StudiVZ	Caffray	1971-11-30	2006-01-30
Guus7	StudiVZ	Gibson	1994-12-27	2011-03-25
Marty167	Developer-Blog	Ijukop	1960-11-05	2002-10-16
Bert87	Google+	Herrin	1995-03-18	2001-08-23
Linnea185	rwth.informatik.hauptstudium	Wooten	1961-08-30	2001-04-09
Hank257	Developer-Blog	Jones	1992-10-27	2010-12-01
Christian	Linux Forum	Schmidt	1958-01-31	2006-01-06
Manuel82	Google+	Langham\t	1993-08-25	2001-07-29
Teddy6	Linux Forum	Mejia	1983-05-19	2010-07-17
Pip656	entwicklerforum.datenbanken.postgresql	Phillips	1962-07-22	2003-10-18
Carlos584	rwth.informatik.grundstudium	Petterson	1961-08-12	2004-08-08
Tony	Facebook	DeWald	1935-11-21	2001-02-15
Thelma81	rwth.informatik.hauptstudium	Walker	1986-08-13	2005-03-17
Tonnie8	Tagesschau Blog	Slocum	1968-04-24	2007-06-02
Chuck780	rwth.informatik.grundstudium	Wong	1968-08-28	2005-05-30
Sammy487	rwth.informatik.hauptstudium	Swaine	1975-07-09	2011-06-13
Lincoln8	Linux Forum	Matthew	1986-02-18	2011-03-23
Jessica82	StudiVZ	Framus	1975-11-08	2003-05-30
Jane	Developer-Blog	Morton	1985-01-22	2005-08-17
Jaap7	StudiVZ	Raines	1975-05-31	2009-04-11
Victor439	rwth.informatik.grundstudium	Framus	1963-08-22	2008-09-28
Esther	entwicklerforum.datenbanken.postgresql	Cappello	1988-07-27	2004-11-10
Rik086	Developer-Blog	Nithman	1976-10-22	2011-01-12
Samantha	Facebook	Meterson	1958-04-26	2002-11-24
Nate42	rwth.jobs	Beckbau	1968-09-29	2004-09-18
Daniel4	rwth.informatik.grundstudium	Zimmerman	1939-03-20	2002-06-26
Marta06	entwicklerforum.datenbanken.postgresql	Frega	1970-12-21	2001-01-29
Fabian	entwicklerforum.datenbanken.mysql	Framus	1974-07-24	2004-04-30
Joseph68	rwth.jobs	Watson	1944-05-12	2002-10-29
Mike073	entwicklerforum.datenbanken.postgresql	Chapman	1969-10-06	2004-09-07
Marty0	Google+	Warner	1991-07-23	2007-08-06
Daan7	entwicklerforum.datenbanken.mysql	Wood	1973-12-07	2009-11-03
Bess81	StudiVZ	Raines	1962-10-20	2005-04-06
Matt1	entwicklerforum.datenbanken.mysql	Dean	1966-12-25	2004-06-25
Krzysztof4	Developer-Blog	Pensec	1944-11-08	2006-08-11
Miriam6	Linux Forum	Deans	1987-01-27	2004-11-20
Martien149	Facebook	Lee	1985-03-16	2007-09-24
Alba745	entwicklerforum.datenbanken.postgresql	Arnold	1951-06-05	2001-08-27
Rob57	Linux Forum	Brendjens	1951-04-08	2010-08-11
Adam	rwth.informatik.grundstudium	Cappello	1967-01-07	2009-11-24
Lisa680	entwicklerforum.datenbanken.mysql	Thompson	1993-06-16	2002-04-12
Oliver377	rwth.informatik.grundstudium	Howe	1992-09-04	2007-03-06
Hannah96	Tagesschau Blog	Arnold	1968-06-14	2008-10-24
Maaike1	Facebook	Moon	1986-06-20	2005-12-22
Lena403	entwicklerforum.datenbanken.mysql	Pyland	1974-02-16	2004-01-22
Bas91	rwth.informatik.hauptstudium	Beckbau	1970-06-13	2004-08-29
Izzy9	Developer-Blog	Mairy	1985-11-29	2003-01-16
Simon96	entwicklerforum.datenbanken.mysql	Lawton	1945-05-19	2008-08-31
Fons562	Google+	Conley	1964-01-10	2010-06-11
Simon36	rwth.informatik.grundstudium	Patricelli	1946-04-10	2003-02-06
Jill364	entwicklerforum.datenbanken.postgresql	Hopper	1960-03-27	2005-05-26
Ainhoa741	entwicklerforum.datenbanken.mysql	Uprovski	1944-08-29	2010-03-03
Vincent0	rwth.jobs	Zimmerman	1968-10-23	2003-02-15
Ryan50	Tagesschau Blog	Newman	1953-08-17	2011-01-27
Stephanie261	Linux Forum	Zurich	1985-10-04	2006-11-03
Jane75	rwth.informatik.grundstudium	Depew	1937-05-16	2004-06-13
Sean13	Tagesschau Blog	Van Toorenbeek	1983-01-21	2005-04-20
Sydney614	rwth.informatik.grundstudium	Poissant	1956-02-20	2008-04-25
Sid41	Tagesschau Blog	Bernstein	1990-05-21	2002-10-17
Jozef833	rwth.informatik.hauptstudium	Hummel	1942-11-15	2004-05-11
Liza11	Tagesschau Blog	Newman	1978-04-28	2010-09-05
Katarzyna171	entwicklerforum.datenbanken.mysql	White	1964-04-01	2003-03-01
Nicoline78	Linux Forum	Otto	1992-06-30	2004-04-02
Will0	rwth.informatik.grundstudium	Cohen	1976-11-26	2005-10-07
Jacob829	entwicklerforum.datenbanken.mysql	Sakurai	1982-09-14	2002-01-28
Lauren7	Tagesschau Blog	Anderson	1988-03-29	2002-12-08
Sem23	rwth.informatik.grundstudium	Robbins	1953-08-12	2002-12-08
Rogier06	entwicklerforum.datenbanken.postgresql	Makelaar	1986-04-09	2002-02-06
Teddy784	Google+	Bitmacs	1959-09-01	2008-11-16
Luis49	Developer-Blog	Pekaban	1964-06-18	2002-06-27
George27	rwth.informatik.grundstudium	Fox	1954-04-18	2009-05-21
Victor21	rwth.informatik.hauptstudium	Blount	1935-04-19	2006-09-05
Steven217	entwicklerforum.datenbanken.postgresql	Barnett	1956-11-08	2002-03-22
Sarah675	entwicklerforum.datenbanken.postgresql	Roger	1985-03-06	2011-01-22
Joe7	rwth.jobs	Plantz	1953-05-22	2004-02-06
Zoe	entwicklerforum.datenbanken.postgresql	Orcutt	1991-07-01	2003-08-09
Kayleigh9	Tagesschau Blog	Arden	1969-08-19	2006-07-26
Andrew2	Linux Forum	Schlee	1994-12-18	2006-07-18
Alice279	rwth.informatik.hauptstudium	Van Toorenbeek	1975-12-08	2005-05-09
Nerea954	Linux Forum	Francis	1946-10-01	2004-09-27
Ross	StudiVZ	Vanderoever	1937-10-04	2007-09-11
Siska7	StudiVZ	Ionescu	1950-01-12	2007-08-16
Oliver9	entwicklerforum.datenbanken.mysql	Pekaban	1962-05-27	2001-08-05
Pauline	Facebook	Sakurai	1938-10-09	2006-04-22
Herb96	Linux Forum	van der Laar	1967-06-08	2006-11-07
Catherine	Google+	Foreman	1989-12-07	2005-07-21
Andy95	Facebook	Brown	1981-01-28	2011-05-06
Ryan2	entwicklerforum.datenbanken.mysql	Zurich	1979-05-20	2003-05-30
Anton316	Linux Forum	Dulisse	1946-03-09	2004-10-18
Matthew319	Google+	Franklin	1950-02-19	2006-08-07
Liza	Facebook	Moore	1950-07-15	2004-02-24
David178	entwicklerforum.datenbanken.postgresql	Blacher	1938-01-13	2011-02-08
Scotty550	Facebook	McCormick	1993-12-12	2005-06-30
Sophie44	Developer-Blog	Francis	1965-05-01	2011-05-26
Milan89	rwth.jobs	Queen	1937-09-23	2009-08-01
Sem8	entwicklerforum.datenbanken.mysql	Spensley	1956-12-11	2006-03-21
Rich8	StudiVZ	Hoogbandt	1994-08-08	2006-08-31
Pip	rwth.jobs	Gieske	1951-08-03	2001-10-07
Anna	Facebook	Sterrett	1936-01-16	2003-10-24
Tom094	entwicklerforum.datenbanken.mysql	Phillips	1992-03-31	2006-05-18
Bengie	entwicklerforum.datenbanken.postgresql	Toler	1978-07-31	2002-12-01
Giel4	Developer-Blog	Slemp	1978-08-05	2004-04-19
Bess013	rwth.informatik.hauptstudium	Herrin	1995-03-18	2003-10-31
Bram7	Linux Forum	Pengilly	1958-05-01	2008-11-07
Maggie02	StudiVZ	van Goes	1968-07-15	2007-03-26
Oliver13	Tagesschau Blog	White	1962-04-01	2006-12-11
Tim	StudiVZ	Geoppo	1968-11-28	2006-06-21
Mathilde6	Developer-Blog	Chwatal	1941-04-10	2002-06-10
Alexis	entwicklerforum.datenbanken.postgresql	Wood	1953-06-15	2001-05-17
Nate70	rwth.jobs	Cantere	1950-02-27	2007-09-29
Sean176	rwth.jobs	Mcnally	1994-01-28	2001-01-31
Herb70	Facebook	Slocum	1971-07-22	2001-07-06
Jolanda33	StudiVZ	Cramer	1987-12-22	2002-09-06
Lizzy5	Linux Forum	Wood	1973-12-07	2009-04-30
Nicky439	entwicklerforum.datenbanken.postgresql	Boyer	1943-10-25	2001-06-09
Marta40	rwth.informatik.hauptstudium	Lawton	1978-10-10	2002-12-17
Sean	entwicklerforum.datenbanken.postgresql	Zimmerman	1972-01-15	2002-09-27
Jorge	Developer-Blog	Ijukop	1995-06-27	2010-06-27
Liza48	rwth.informatik.grundstudium	Cappello	1967-01-07	2001-04-13
Jeanne	entwicklerforum.datenbanken.postgresql	Katsekes	1948-03-21	2010-04-16
Joanne249	entwicklerforum.datenbanken.postgresql	Bryant	1955-06-20	2003-11-25
Rachel038	Linux Forum	Gerschkow	1963-11-20	2003-01-02
Cristian827	entwicklerforum.datenbanken.mysql	Hopper	1960-03-27	2002-09-09
Samantha1	rwth.informatik.hauptstudium	Yinger	1987-07-12	2001-08-22
Annie	rwth.informatik.hauptstudium	Caouette	1985-08-02	2003-04-01
Joop455	entwicklerforum.datenbanken.mysql	Herzog	1942-08-24	2007-08-29
Tara1	entwicklerforum.datenbanken.mysql	Gunter	1950-12-07	2001-04-05
Bengie5	entwicklerforum.datenbanken.postgresql	Scheffold	1944-04-24	2005-09-19
Fons75	entwicklerforum.datenbanken.postgresql	Daughtery	1946-06-02	2010-02-26
Rolla15	Developer-Blog	Fox	1978-10-25	2007-11-03
Elin926	entwicklerforum.datenbanken.postgresql	Foreman	1991-01-28	2001-08-07
Jeffery	rwth.jobs	Troher	1950-08-17	2008-01-21
Cian40	Google+	Schmidt	1967-09-02	2004-10-03
Willy	Facebook	Moon	1942-04-21	2005-07-31
Stephanie	StudiVZ	Praeger	1991-05-05	2011-10-23
Juana0	Tagesschau Blog	Moreau	1968-02-13	2002-01-01
Mart95	Linux Forum	McCormick	1960-02-01	2002-04-22
Andrea94	StudiVZ	Turk	1957-11-28	2005-07-06
Thomas5	Google+	Langham	1964-06-04	2008-11-23
Kim1	entwicklerforum.datenbanken.mysql	van het Hof	1953-08-22	2005-08-10
Herman	rwth.informatik.grundstudium	Wooten	1993-12-21	2002-04-26
Dick	Facebook	Langham	1984-06-28	2004-06-26
Laura84	rwth.informatik.hauptstudium	Brown	1968-06-06	2010-01-20
Sjaak723	entwicklerforum.datenbanken.mysql	Hedgecock	1938-05-11	2004-01-16
Drew	Facebook	Visentini	1979-05-01	2001-05-24
Pawel338	entwicklerforum.datenbanken.postgresql	Hedgecock	1988-08-07	2001-10-28
Madison	rwth.jobs	Davis	1963-07-04	2006-05-23
Zofia099	rwth.jobs	Dittrich	1962-11-09	2002-11-19
Ron3	rwth.jobs	Mayberry	1989-11-29	2004-02-02
Jolanda71	rwth.informatik.hauptstudium	Brown	1983-09-23	2003-09-04
Raul01	Developer-Blog	Nahay	1990-08-06	2008-11-05
Ben	Tagesschau Blog	Van Toorenbeek	1940-10-22	2003-12-25
Lukas88	StudiVZ	Barnett	1970-02-16	2004-02-09
Pawel7	Google+	Mayberry	1991-01-11	2001-07-24
Ross3	Google+	Browne	1937-05-20	2005-03-18
Ashley004	Facebook	Vanderoever	1964-10-12	2004-10-01
Erin	Tagesschau Blog	Emerson	1936-08-01	2001-06-01
Lukas530	Google+	Pierce	1951-06-07	2003-02-15
Rosa	rwth.jobs	Petterson	1935-03-09	2003-08-11
Klaas928	rwth.jobs	Botsik	1981-06-27	2004-01-19
Fons2	Tagesschau Blog	Hoogbandt	1967-10-20	2011-08-02
Klaas1	Tagesschau Blog	Anderson	1968-02-23	2001-06-29
Sherm6	rwth.informatik.hauptstudium	Ward\t	1974-08-30	2001-07-21
Bo17	Tagesschau Blog	Frega	1970-12-21	2003-05-23
Mathilde23	rwth.informatik.hauptstudium	Bloom	1975-05-07	2002-04-16
Patty630	StudiVZ	Davis	1981-06-15	2005-10-13
Phil595	Developer-Blog	Bright	1982-08-04	2006-12-02
Anna93	rwth.informatik.grundstudium	Bruno	1946-12-22	2005-03-10
Julian	Developer-Blog	Uitergeest	1953-02-26	2008-11-13
Sue508	Linux Forum	Swaine	1939-01-12	2004-04-04
Tomas52	Google+	Brisco	1962-04-20	2001-02-08
PieterJan909	Developer-Blog	Morgan	1962-06-24	2004-05-08
Martin270	Linux Forum	Daughtery	1962-07-07	2006-08-20
Matthew	Google+	Naley	1992-01-04	2008-01-26
Harold	rwth.informatik.hauptstudium	Jenssen	1974-09-19	2006-04-16
Giel41	Developer-Blog	Wooten	1973-12-21	2003-12-04
Luka210	Tagesschau Blog	Knight	1976-01-05	2001-07-04
Iris2	Tagesschau Blog	Tudisco	1962-02-23	2007-06-04
Jo28	rwth.informatik.hauptstudium	Liddle	1954-07-06	2001-08-06
Daan1	rwth.jobs	Barnett	1956-11-08	2001-12-02
Dylan811	StudiVZ	Kepler	1941-06-04	2008-08-24
Babette9	entwicklerforum.datenbanken.mysql	Vanderoever	1937-10-04	2005-05-20
Rachael	rwth.jobs	Caffray	1954-10-27	2009-11-12
John147	rwth.informatik.hauptstudium	Donatelli	1961-09-29	2006-03-05
Aoife7	Tagesschau Blog	van het Hof	1953-08-22	2010-08-18
GoPlaat	rwth.informatik.hauptstudium	Visentini	1944-06-28	2001-10-08
Viktor	rwth.jobs	Love	1964-01-01	2003-02-09
Mart857	Developer-Blog	Cain	1983-06-19	2003-07-21
Diego	Google+	Dittrich	1947-05-01	2003-04-18
Filip28	rwth.informatik.grundstudium	Royal	1978-10-23	2002-08-17
Megan002	Google+	Roger	1980-10-30	2004-02-27
Luis9	Facebook	Poplock	1963-11-13	2002-01-29
Anna8	StudiVZ	Gonzalez	1980-05-13	2001-07-16
Patty0	entwicklerforum.datenbanken.mysql	Glanswol	1945-05-31	2005-07-10
Gillian06	Tagesschau Blog	van Dijk	1956-03-18	2001-02-28
Amy48	rwth.jobs	Phillips	1992-03-31	2005-05-07
Sharon948	rwth.informatik.grundstudium	Deleo	1985-12-18	2001-03-26
Carolina37	Tagesschau Blog	Julieze	1966-04-07	2006-01-31
Megan885	rwth.jobs	Nahay	1980-01-18	2005-09-19
Freja373	Linux Forum	Long	1952-07-01	2008-04-21
Manuel8	Linux Forum	Julieze	1939-09-24	2004-05-01
Katie	Tagesschau Blog	Thompson	1989-09-24	2006-08-31
Amber17	rwth.informatik.hauptstudium	Knopp	1955-07-19	2002-01-20
Francisco	Tagesschau Blog	Kepler	1937-09-05	2008-12-04
Matthijs2	Developer-Blog	Chwatal	1941-04-10	2003-03-18
Jack	rwth.jobs	Gieske	1942-02-25	2001-10-20
Luis7	Google+	Cantere	1950-02-27	2007-04-29
Bertje6	entwicklerforum.datenbanken.postgresql	Moore	1948-04-14	2003-12-13
Andrzej34	Tagesschau Blog	Hendrix	1982-07-09	2001-08-24
Luka7	Facebook	Boyer	1943-10-25	2009-09-24
Susan	Tagesschau Blog	Katsekes	1948-03-21	2002-01-13
Tyler344	Linux Forum	Cragin	1980-12-17	2007-01-15
Christa	Developer-Blog	Moon	1986-06-20	2003-09-12
Lucille838	Google+	Bruno	1946-12-22	2003-03-04
Mariska93	rwth.informatik.grundstudium	Yinger	1987-07-12	2010-08-07
Cian0	entwicklerforum.datenbanken.mysql	Pearlman	1940-09-29	2003-10-14
Ciara83	Tagesschau Blog	Hopper	1986-12-11	2005-08-24
Matthew164	Facebook	Roger	1940-10-17	2008-04-27
Siska016	Developer-Blog	Johnson	1950-02-07	2005-09-03
Luka58	Developer-Blog	Griffith	1949-11-13	2006-07-06
Marieke6	rwth.jobs	Mitchell	1987-01-11	2004-03-03
Shermie	rwth.jobs	Jenssen	1974-09-19	2003-05-26
Victor	rwth.jobs	Duvall	1988-12-09	2003-07-11
Mads	StudiVZ	King	1984-07-14	2004-04-25
Gert	rwth.informatik.hauptstudium	Symbouras	1937-03-02	2004-10-19
Michel	rwth.informatik.grundstudium	Anderson	1950-05-07	2002-10-30
Freja44	Developer-Blog	Howe	1968-06-11	2005-04-08
Vanessa127	StudiVZ	Weaver	1995-02-17	2009-07-09
Lewis1	entwicklerforum.datenbanken.postgresql	Nelson	1978-10-08	2001-05-17
Andrzej8	rwth.jobs	Van Dinter	1983-02-24	2003-03-24
Trevor	rwth.informatik.hauptstudium	Donatelli	1961-09-29	2005-06-23
Margo	StudiVZ	Roche	1950-11-08	2003-09-11
Siem83	rwth.informatik.hauptstudium	Freeman	1995-03-24	2002-01-26
Marta160	Facebook	Crocetti	1980-01-05	2010-07-05
GoSix3	Linux Forum	DeBerg	1974-06-30	2002-03-24
Lincoln	entwicklerforum.datenbanken.postgresql	Blacher	1969-04-26	2004-09-11
Gabbie3	entwicklerforum.datenbanken.mysql	Poole	1962-03-09	2004-09-29
Sherman	entwicklerforum.datenbanken.mysql	Vostreys	1936-11-26	2001-02-04
Javier54	Developer-Blog	Mayberry	1989-11-29	2002-12-03
Jace01	Tagesschau Blog	Perilloux	1989-10-27	2004-07-11
Sharon	rwth.jobs	Goodnight	1989-08-27	2005-07-27
Delphine	Linux Forum	Naff	1940-10-19	2002-05-14
Linnea415	rwth.informatik.grundstudium	Toler	1975-05-20	2003-12-23
Joseph63	rwth.informatik.grundstudium	Guyer	1995-06-25	2001-09-09
Jordy	entwicklerforum.datenbanken.mysql	Mulders	1995-09-07	2004-12-05
Sherman2	rwth.informatik.grundstudium	Phillips	1980-10-26	2003-07-17
Jamie	rwth.informatik.hauptstudium	Mitchell	1961-04-25	2007-03-03
Sylvia	rwth.informatik.grundstudium	Chwatal	1946-10-11	2002-01-25
Lu168	rwth.informatik.grundstudium	Mairy	1985-11-29	2006-03-09
Sjanie1	entwicklerforum.datenbanken.mysql	Gerschkow	1968-03-24	2009-10-28
Magnus34	StudiVZ	Daughtery	1962-07-07	2004-01-18
Matthijs681	StudiVZ	Gonzalez	1957-08-15	2006-11-22
Robert3	Developer-Blog	Robertson	1961-09-30	2005-03-25
Jaap489	StudiVZ	Bryant	1963-05-28	2002-09-13
Benjy51	Linux Forum	Plantz	1973-01-17	2003-03-22
Linnea786	rwth.informatik.grundstudium	Herzog	1972-06-01	2001-08-18
Bram615	Google+	Gonzalez	1949-06-21	2003-01-16
Matthijs5	Tagesschau Blog	Frega	1935-05-16	2001-11-03
Truus	Facebook	Pekaban	1964-06-18	2008-10-15
Erin394	entwicklerforum.datenbanken.mysql	Buchholz	1985-04-11	2007-10-01
Roger	Linux Forum	Francis	1946-10-01	2002-07-16
Herb9	rwth.jobs	Cramer	1973-07-16	2005-10-02
Siska337	StudiVZ	Yinger	1974-11-08	2007-10-08
Zoe45	rwth.informatik.hauptstudium	Caffray	1954-10-27	2003-05-08
Krystyna928	StudiVZ	Buchholz	1958-05-15	2004-08-21
Alejandro0	entwicklerforum.datenbanken.mysql	Waddell	1937-03-31	2003-07-16
Sara268	Linux Forum	Katsekes	1935-01-22	2006-01-06
Jill079	rwth.jobs	Emerson	1972-07-18	2003-09-21
Eleanor603	entwicklerforum.datenbanken.postgresql	van het Hof	1953-08-22	2002-09-25
Victor1	Tagesschau Blog	Turk	1966-09-19	2001-12-02
Matt316	entwicklerforum.datenbanken.mysql	Toler	1972-07-07	2002-08-25
Kaylee694	Developer-Blog	Botsik	1936-04-22	2006-12-08
Alice8	Developer-Blog	Symbouras	1946-05-04	2005-10-14
Milan97	Google+	Van Toorenbeek	1940-10-22	2002-07-22
Juan7	Tagesschau Blog	Perilloux	1989-10-27	2002-10-15
Mary70	rwth.informatik.hauptstudium	Griffith	1942-12-16	2010-03-29
Marcin652	rwth.jobs	Zapetis	1990-11-11	2003-10-19
Rogier	StudiVZ	Barnett	1985-08-27	2008-06-15
William0	Developer-Blog	Nefos	1992-07-10	2006-10-28
Leontien136	Google+	Ladaille	1994-02-25	2003-01-10
Lucia26	Tagesschau Blog	Pierce	1951-06-07	2010-10-08
Sjef41	Developer-Blog	Toler	1975-05-20	2005-09-08
Elena31	entwicklerforum.datenbanken.mysql	Chwatal	1941-04-10	2004-12-25
Rick166	Google+	Moore	1948-04-14	2008-08-06
Joop	rwth.jobs	Beckbau	1968-09-29	2005-05-18
Rolla2	entwicklerforum.datenbanken.postgresql	Arden	1939-08-09	2001-07-24
Catharine538	Tagesschau Blog	Moore	1947-07-06	2006-02-13
Gabbie9	rwth.jobs	Weaver	1974-09-01	2003-06-23
Oscar6	rwth.jobs	Raines	1962-10-20	2005-02-02
Siska82	Google+	Chwatal	1993-11-03	2002-04-27
Ivan92	entwicklerforum.datenbanken.mysql	Lee	1985-03-16	2009-04-07
Pieter0	rwth.informatik.grundstudium	Bright	1982-08-04	2008-01-07
Sjanie119	entwicklerforum.datenbanken.postgresql	Hedgecock	1978-12-02	2004-11-30
Ross935	rwth.informatik.hauptstudium	Gerschkow	1963-11-20	2004-05-05
Roger86	Facebook	Patricelli	1946-04-10	2004-01-24
Theo2	entwicklerforum.datenbanken.postgresql	Langham	1944-09-14	2002-09-25
Malgorzata	rwth.informatik.grundstudium	Newman	1978-04-28	2003-02-11
Michel1	Developer-Blog	van Dijk	1982-04-17	2011-04-24
Joey2	entwicklerforum.datenbanken.mysql	Ditmanen	1957-07-01	2001-06-12
Leah	Linux Forum	Nadalin	1980-07-26	2003-08-03
Mathilde94	Google+	Tudisco	1980-02-11	2003-08-09
Betty1	rwth.informatik.grundstudium	Moon	1990-02-14	2004-08-15
Alfons13	entwicklerforum.datenbanken.mysql	Reyes	1954-06-09	2002-05-31
Sherm493	Facebook	Blount	1935-04-19	2005-12-28
Sharon98	Developer-Blog	Robertson	1980-12-27	2001-06-08
Hannah7	rwth.jobs	Slater	1984-01-06	2001-09-18
Ellie5	Developer-Blog	Bernstein	1977-11-29	2001-02-26
Sally11	entwicklerforum.datenbanken.mysql	Hamilton	1953-07-01	2005-01-01
Andrea3	Google+	Langham	1964-06-04	2004-02-18
Martin15	Google+	Troher	1965-01-12	2008-11-29
Siem6	rwth.informatik.grundstudium	Orcutt	1941-07-31	2002-12-13
Cian664	Facebook	Zia	1946-10-19	2002-10-19
Luca	entwicklerforum.datenbanken.mysql	Hopper	1981-01-31	2006-01-25
Georgina5	rwth.informatik.hauptstudium	Herrin	1972-11-11	2009-08-07
Andrzej45	rwth.informatik.grundstudium	Nithman	1963-07-30	2004-04-30
Jurre68	entwicklerforum.datenbanken.mysql	Pekagnan	1969-09-01	2002-05-30
Juan8	entwicklerforum.datenbanken.postgresql	Poplock	1963-11-13	2004-04-20
Ciska5	StudiVZ	Liddle	1981-05-09	2002-03-04
Isabel981	Google+	Brown	1983-09-23	2003-02-15
Sanne0	Facebook	van der Laar	1944-09-24	2006-08-22
Michel2	StudiVZ	White	1990-09-11	2001-06-02
Sydney578	entwicklerforum.datenbanken.mysql	Van Toorenbeek	1940-10-22	2009-01-17
Tara7	Facebook	Perilloux	1989-10-27	2006-07-03
Caitlin8	Facebook	Voigt	1951-11-25	2005-06-15
Jean	rwth.informatik.hauptstudium	Riegel	1979-11-21	2001-10-09
Julie982	Tagesschau Blog	van Goes	1968-07-15	2002-02-19
Katarzyna282	Facebook	Huston	1963-05-19	2005-12-05
Ellie13	entwicklerforum.datenbanken.mysql	Foreman	1988-06-12	2001-02-27
Steph305	entwicklerforum.datenbanken.postgresql	Ray	1954-10-26	2007-01-22
Hanna989	rwth.informatik.hauptstudium	Barbee	1935-03-09	2003-10-09
Christian1	Linux Forum	Cramer	1987-12-22	2004-02-03
Rolla9	rwth.informatik.hauptstudium	Knight	1936-10-16	2003-09-13
Kimberly12	Tagesschau Blog	Chwatal	1962-12-02	2007-04-07
Niklas498	Facebook	Pekaban	1937-12-05	2002-11-08
Jim	Google+	Brown	1970-05-09	2004-01-30
Freja95	StudiVZ	Nobles	1972-10-25	2007-06-18
Stanislaw	entwicklerforum.datenbanken.postgresql	Beckbau	1948-11-10	2011-10-07
Andy	Google+	Arnold	1950-05-24	2003-05-21
Sjaak6	Linux Forum	Naley	1992-01-04	2002-11-15
Peggy	Google+	Johnson	1985-03-02	2001-07-12
Bram61	StudiVZ	McCrary	1967-09-23	2005-04-09
Sarah8	rwth.jobs	Cantere	1974-09-17	2004-03-26
Carla	Developer-Blog	Bugno	1974-07-27	2004-06-19
Emma621	Developer-Blog	Blount	1983-08-05	2010-10-31
Alex88	StudiVZ	Moreau	1968-02-13	2006-11-16
Niklas6	rwth.informatik.grundstudium	Hedgecock	1979-02-07	2002-05-02
Scotty51	Facebook	Robertson	1980-12-27	2007-08-29
Henry	rwth.informatik.grundstudium	Cappello	1970-06-05	2001-05-20
Cloe862	Facebook	Ladaille	1958-10-13	2001-07-09
Hanna1	rwth.jobs	Bernstein	1977-11-29	2004-10-03
\.


--
-- Data for Name: betreiber; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY betreiber (umsatzidnr, name, stadt, plz, strasse) FROM stdin;
123456	Google	Mountain View	94043	1600 Amphitheatre Parkway
3835815	Facebook Ireland Limited	Dublin	2	5-7 Hanover Quay
DE118509776	Norddeutscher Rundfunk	Hamburg	22529	Hugh-Greene-Weg 1
DE281679833	Forumhome GmbH	Bad Dürkheim	67098	Bruchstrasse 54a
DE811889986	Software & Support Verlag	Frankfurt	60599	Geleitstrasse 14
DE813501887	Heise Zeitschriften Verlag	Hannover	30625	Karl-Wiechert-Allee 10
HRB101454	VZ Netzwerke Limited	Berlin	10405	Saarbrücker Str. 38
\.


--
-- Data for Name: bild; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY bild (element_id, groesse, pfad) FROM stdin;
5	570	C:\\DOCUMENTS\\DOCS15
8	866	C:\\TEMPORARY\\DOC88
9	276	C:\\DATA\\DOC09
16	644	C:\\DATA\\DOCS55
25	774	C:\\DOCS\\TEMP59
32	949	C:\\TEMP\\TEMP95
42	828	C:\\TEMP\\DOCS28
44	116	C:\\TEMP\\DOCS59
47	890	C:\\DATA\\TEMP29
51	137	C:\\TEMP\\DOCS99
54	524	C:\\PROGRAM FILES\\TEMP20
64	685	C:\\TEMP\\DATA96
72	944	C:\\DOCS\\TEMP44
75	511	C:\\DOCS\\DOCS41
81	263	C:\\TEMP\\DATA20
90	430	C:\\DOCUMENTS\\DOCS85
96	270	C:\\TEMPORARY\\DOC76
97	354	C:\\DOCS\\DATA48
106	822	C:\\TEMP\\DATA98
113	56	C:\\DATA\\TEMP06
118	171	C:\\DOCS\\TEMP39
120	643	C:\\DOCS\\DOC78
123	807	C:\\DATA\\TEMP61
132	920	C:\\DATA\\DATA92
140	650	C:\\DATA\\TEMP02
141	108	C:\\PROGRAM FILES\\DOCS38
144	661	C:\\DOCUMENTS\\DATA41
150	621	C:\\DATA\\DATA47
157	203	C:\\PROGRAM FILES\\DOC44
159	847	C:\\DOCS\\TEMP57
163	737	C:\\TEMP\\DOC39
171	146	C:\\TEMP\\DATA01
178	667	C:\\DOCUMENTS\\DOC99
188	509	C:\\APPDATA\\TEMP00
198	431	C:\\TEMP\\DOCS16
200	588	C:\\TEMPORARY\\TEMP84
203	143	C:\\APPDATA\\TEMP92
206	43	C:\\APPDATA\\TEMP42
213	385	C:\\TEMP\\DOC18
214	418	C:\\TEMP\\DOCS06
220	967	C:\\TEMPORARY\\DATA99
230	996	C:\\TEMP\\TEMP15
232	737	C:\\TEMP\\DATA27
237	324	C:\\DOCS\\TEMP56
243	758	C:\\DOCUMENTS\\DOCS32
245	389	C:\\APPDATA\\DOC44
248	452	C:\\TEMPORARY\\DOCS86
256	611	C:\\TEMP\\TEMP32
263	516	C:\\PROGRAM FILES\\DOC89
264	146	C:\\DATA\\DATA04
\.


--
-- Data for Name: blog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY blog (medium_name) FROM stdin;
\.


--
-- Data for Name: element; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY element (id, beitrag_id, "position") FROM stdin;
1	3	1
2	8	3
3	16	3
4	23	4
5	26	3
6	28	4
7	35	1
8	45	3
9	55	1
10	64	3
11	65	4
12	67	3
13	74	1
14	81	4
15	90	1
16	98	4
17	99	4
18	107	5
19	113	4
20	118	5
21	124	1
22	126	3
23	132	2
24	140	1
25	149	3
26	156	4
27	161	5
28	167	1
29	176	4
30	184	2
31	185	3
32	187	2
33	194	2
34	196	2
35	200	3
36	205	2
37	212	1
38	220	4
39	221	2
40	223	5
41	228	4
42	233	2
43	235	5
44	239	1
45	241	2
46	242	4
47	245	3
48	248	1
49	254	3
50	257	4
51	263	2
52	273	4
53	274	2
54	278	3
55	287	4
56	290	5
57	299	3
58	302	4
59	308	5
60	317	1
61	321	5
62	325	3
63	332	4
64	339	3
65	344	1
66	354	2
67	360	4
68	363	2
69	365	5
70	371	5
71	374	4
72	381	4
73	387	1
74	392	2
75	402	1
76	405	4
77	408	2
78	411	2
79	414	1
80	421	1
81	423	4
82	431	4
83	436	3
84	446	1
85	454	2
86	463	2
87	467	5
88	476	5
89	481	2
90	491	5
91	494	3
92	4	1
93	13	1
94	19	3
95	28	4
96	30	2
97	37	5
98	42	1
99	46	1
100	47	2
101	53	2
102	59	3
103	63	2
104	71	1
105	75	4
106	76	3
107	83	4
108	92	5
109	94	5
110	104	1
111	106	1
112	115	4
113	123	4
114	127	5
115	137	1
116	142	3
117	145	2
118	147	3
119	156	5
120	159	3
121	164	5
122	171	4
123	177	3
124	183	5
125	185	3
126	195	4
127	203	2
128	206	5
129	212	1
130	215	5
131	216	1
132	221	3
133	229	1
134	237	2
135	245	2
136	254	1
137	261	2
138	270	4
139	278	5
140	283	5
141	284	4
142	285	2
143	295	2
144	298	2
145	299	3
146	303	5
147	313	4
148	319	4
149	329	4
150	338	3
151	342	1
152	349	5
153	352	2
154	356	4
155	362	3
156	368	1
157	369	3
158	377	4
159	385	1
160	393	3
161	400	3
162	403	4
163	405	1
164	409	5
165	419	3
166	425	4
167	427	4
168	434	5
169	438	1
170	443	3
171	446	4
172	453	1
173	458	2
174	465	4
175	469	2
176	472	1
177	477	4
178	480	5
179	486	1
180	494	4
181	2	2
182	3	1
183	5	5
184	8	2
185	11	1
186	17	4
187	25	1
188	27	5
189	34	5
190	44	4
191	50	2
192	59	4
193	68	1
194	76	5
195	80	5
196	87	4
197	94	4
198	100	5
199	105	2
200	115	2
201	119	1
202	129	5
203	131	3
204	134	2
205	136	4
206	138	4
207	147	3
208	152	1
209	154	3
210	164	3
211	165	5
212	171	4
213	179	5
214	189	4
215	197	5
216	205	4
217	208	1
218	218	1
219	228	3
220	237	2
221	241	4
222	247	4
223	255	5
224	264	3
225	266	3
226	268	2
227	275	4
228	282	2
229	288	1
230	294	5
231	303	4
232	305	5
233	308	5
234	314	2
235	322	4
236	327	1
237	329	4
238	333	2
239	340	2
240	342	4
241	343	2
242	348	2
243	351	4
244	360	1
245	363	5
246	364	2
247	365	2
248	372	1
249	375	2
250	378	1
251	388	4
252	392	2
253	402	2
254	411	1
255	418	4
256	422	3
257	431	4
258	433	5
259	437	5
260	447	1
261	453	1
262	459	3
263	467	2
264	472	2
265	479	4
266	488	1
267	495	2
268	500	1
269	8	5
270	9	1
271	16	1
272	19	4
273	29	5
274	31	5
275	41	4
276	50	4
277	60	3
278	61	4
279	71	5
280	75	4
281	80	4
282	87	2
283	97	3
284	103	2
285	106	5
286	109	3
287	115	2
288	119	3
289	125	1
290	132	4
291	133	4
292	135	5
293	136	1
294	138	2
295	146	2
296	153	3
297	156	5
298	161	5
299	169	3
300	178	1
301	183	4
302	188	5
303	197	2
304	203	1
305	204	5
306	210	5
307	213	4
308	214	2
309	220	4
310	229	4
311	238	3
312	247	1
313	251	1
314	257	4
315	262	2
316	270	3
317	275	4
318	282	5
319	283	4
320	291	4
321	301	1
322	310	4
323	314	1
324	318	5
325	322	5
326	330	1
327	339	2
328	346	2
329	350	5
330	356	1
331	366	3
332	373	3
333	375	3
334	385	4
335	390	3
336	396	4
337	405	5
338	410	3
339	416	2
340	425	2
341	427	1
342	434	3
343	437	4
344	446	4
345	453	1
346	459	2
347	461	4
348	464	1
349	473	2
350	475	3
351	476	2
352	477	2
353	480	3
354	483	4
355	487	1
356	496	3
357	498	4
358	1	3
359	4	5
360	11	3
361	14	3
362	17	4
363	24	1
364	31	3
365	39	5
366	41	1
367	50	2
368	54	3
369	64	1
370	73	2
371	80	1
372	84	1
373	87	2
374	89	2
375	99	4
376	101	5
377	106	3
378	112	4
379	113	1
380	123	4
381	125	1
382	134	4
383	141	3
384	150	5
385	157	4
386	162	3
387	166	2
388	167	1
389	173	4
390	181	3
391	185	4
392	186	1
393	192	2
394	193	2
395	198	1
396	203	4
397	209	3
398	210	1
399	219	3
400	221	4
401	225	1
402	228	2
403	230	2
404	237	2
405	240	2
406	249	5
407	250	1
408	258	4
409	268	3
410	275	2
411	278	3
412	285	5
413	288	4
414	293	2
415	294	2
416	295	1
417	304	2
418	309	4
419	317	4
420	327	4
421	334	4
422	341	2
423	348	3
424	353	4
425	354	1
426	362	3
427	364	3
428	369	2
429	370	5
430	378	1
431	383	4
432	388	3
433	391	5
434	393	5
435	398	4
436	399	1
437	400	1
438	408	1
439	415	1
440	416	4
441	423	5
442	426	2
443	429	3
444	436	1
445	441	4
446	448	5
447	449	3
448	456	3
449	461	3
450	465	2
451	470	4
452	474	3
453	484	1
454	489	4
455	492	2
456	2	5
457	3	4
458	8	4
459	17	5
460	23	2
461	24	1
462	31	4
463	40	2
464	50	5
465	60	4
466	64	4
467	72	1
468	75	4
469	83	3
470	85	5
471	91	5
472	96	4
473	99	2
474	100	4
475	107	2
476	111	1
477	120	2
478	125	1
479	130	2
480	132	4
481	139	4
482	147	2
483	151	5
484	157	4
485	159	3
486	160	4
487	164	3
488	170	2
489	179	5
490	182	4
491	191	4
492	199	5
493	206	1
494	211	2
495	216	4
496	224	5
497	227	4
498	236	3
499	244	4
500	246	2
501	254	5
502	259	4
503	263	3
504	272	3
505	281	3
506	289	4
507	295	5
508	301	5
509	305	3
510	308	5
511	311	3
512	321	5
513	329	1
514	332	3
515	339	4
516	341	4
517	344	4
518	350	2
519	352	4
520	360	3
521	370	1
522	377	2
523	384	4
524	390	1
525	391	2
526	392	3
527	394	2
528	404	2
529	405	5
530	406	3
531	410	5
532	420	5
533	425	2
534	430	2
535	432	2
536	436	4
537	442	1
538	449	1
539	451	5
540	452	5
541	460	1
542	465	1
543	475	4
544	477	3
545	481	4
546	489	2
547	490	4
548	500	4
549	5	3
550	8	4
551	14	5
552	17	2
553	22	2
554	28	2
555	31	2
556	35	3
557	43	2
558	50	1
559	58	2
560	59	4
561	64	5
562	69	3
563	76	3
564	86	2
565	96	5
566	97	2
567	100	4
568	101	2
569	111	1
570	121	4
571	129	5
572	131	2
573	134	4
574	144	5
575	146	5
576	154	5
577	155	4
578	160	5
579	163	5
580	172	4
581	174	4
582	183	2
583	186	4
584	196	5
585	199	1
586	208	3
587	215	4
588	217	3
589	224	1
590	230	1
591	236	4
592	246	5
593	247	5
594	256	5
595	258	3
596	267	4
597	269	2
598	275	5
599	278	3
600	286	3
601	295	3
602	301	5
603	303	1
604	307	2
605	310	1
606	318	1
607	324	3
608	325	5
609	327	1
610	337	2
611	339	1
612	341	5
613	343	4
614	344	5
615	351	1
616	361	4
617	370	3
618	379	2
619	380	4
620	390	2
621	397	4
622	403	5
623	405	4
624	410	4
625	415	3
626	420	5
627	424	4
628	429	5
629	434	5
630	437	2
631	446	3
632	447	2
633	448	2
634	449	5
635	452	3
636	455	4
637	459	5
638	460	2
639	464	5
640	473	3
641	482	3
642	490	5
643	491	4
644	496	5
645	1	1
646	2	3
647	12	5
648	21	1
649	29	4
650	39	2
651	41	5
652	42	4
653	43	3
654	47	5
655	49	2
656	58	3
657	64	2
658	69	1
659	71	5
660	72	1
661	77	5
662	79	3
663	81	5
664	82	3
665	92	3
666	100	1
667	104	1
668	114	5
669	119	3
670	124	1
671	134	5
672	143	2
673	150	5
674	159	4
675	165	1
676	170	4
677	171	2
678	173	3
679	174	4
680	176	3
681	177	5
682	187	1
683	195	3
684	196	4
685	200	2
686	204	1
687	209	2
688	216	3
689	222	2
690	227	1
691	235	4
692	245	4
693	255	3
694	265	1
695	269	1
696	271	5
697	281	5
698	290	5
699	298	5
700	303	2
701	311	4
702	320	3
703	330	3
704	332	4
705	337	1
706	342	2
707	346	3
708	348	2
709	356	2
710	357	5
711	364	1
712	373	2
713	379	3
714	389	4
715	399	4
716	407	1
717	412	5
718	421	2
719	426	4
720	433	2
721	443	2
722	446	1
723	451	5
724	459	4
725	460	5
726	461	1
727	462	1
728	470	3
729	480	1
730	483	1
731	486	3
732	491	5
733	498	2
734	499	4
735	1	1
736	4	3
737	8	3
738	18	1
739	23	3
740	32	5
741	42	5
742	47	5
743	57	4
744	59	3
745	68	4
746	70	3
747	71	3
748	74	4
749	77	2
750	82	5
751	88	1
752	96	2
753	100	1
754	110	4
755	111	5
756	116	3
757	118	1
758	126	1
759	128	4
760	136	4
761	144	5
762	150	1
763	158	4
764	163	2
765	171	5
766	177	5
767	183	1
768	190	4
769	195	3
770	197	4
771	199	4
772	200	3
773	208	4
774	214	2
775	219	4
776	223	2
777	229	3
778	239	5
779	245	4
780	255	5
781	257	5
782	259	3
783	265	5
784	267	1
785	275	1
786	284	1
787	287	5
788	289	1
789	297	4
790	307	4
791	313	1
792	316	2
793	324	4
794	326	4
795	332	2
796	337	2
797	347	3
798	355	5
799	363	2
800	366	4
801	372	1
802	381	3
803	391	3
804	397	3
805	401	1
806	407	3
807	416	3
808	420	5
809	425	2
810	428	5
811	432	1
812	437	4
813	443	3
814	444	4
815	448	2
816	453	4
817	455	3
818	460	2
819	463	4
820	465	1
821	473	2
822	479	3
823	485	4
824	489	3
825	493	5
826	495	4
827	5	5
828	13	5
829	18	3
830	24	4
831	27	4
832	29	1
833	33	2
834	37	3
835	43	4
836	46	2
837	49	1
838	52	3
839	62	4
840	71	1
841	79	3
842	89	1
843	95	2
844	100	2
845	103	4
846	110	5
847	112	1
848	115	2
849	118	1
850	125	2
851	131	1
852	134	1
853	137	5
854	146	5
855	154	2
856	163	1
857	167	2
858	171	1
859	178	4
860	186	3
861	193	2
862	202	3
863	210	4
864	217	3
865	226	1
866	227	1
867	228	3
868	235	5
869	237	3
870	242	4
871	252	5
872	254	4
873	262	1
874	266	1
875	270	5
876	271	5
877	275	1
878	280	1
879	286	1
880	294	1
881	300	4
882	306	3
883	312	3
884	315	2
885	320	3
886	322	5
887	332	5
888	336	1
889	344	5
890	350	3
891	358	3
892	360	3
893	363	3
894	373	4
895	380	4
896	386	2
897	391	3
898	398	4
899	405	5
900	407	2
901	417	5
902	418	3
903	421	3
904	428	5
905	429	1
906	439	3
907	444	4
908	451	3
909	452	3
910	458	5
911	460	3
912	470	2
913	472	4
914	476	3
915	480	1
916	484	3
917	486	1
918	489	3
919	491	3
920	1	5
921	9	5
922	10	3
923	14	2
924	23	4
925	33	3
926	38	4
927	39	3
928	45	3
929	53	5
930	54	4
931	64	5
932	69	1
933	78	3
934	85	3
935	92	4
936	102	4
937	108	1
938	114	4
939	121	5
940	130	4
941	140	1
942	150	2
943	160	3
944	165	2
945	166	1
946	173	1
947	174	4
948	183	4
949	184	4
950	186	3
951	193	5
952	194	4
953	203	3
954	213	5
955	223	3
956	225	1
957	227	2
958	229	4
959	236	1
960	244	4
961	248	3
962	253	3
963	259	5
964	265	3
965	270	4
966	278	1
967	288	1
968	290	2
969	295	2
970	296	5
971	297	5
972	302	4
973	310	2
974	312	1
975	316	2
976	317	4
977	325	5
978	329	2
979	338	2
980	344	1
981	347	4
982	349	4
983	350	3
984	351	3
985	359	5
986	360	5
987	362	2
988	367	1
989	369	3
990	370	5
991	373	4
992	380	5
993	386	3
994	390	1
995	397	2
996	406	4
997	410	5
998	412	1
999	415	2
1000	418	1
1001	428	5
1002	436	2
1003	445	1
1004	450	5
1005	456	4
1006	464	3
1007	470	1
1008	477	3
1009	486	5
1010	490	3
1011	497	5
1012	499	1
1013	1	1
1014	7	5
1015	17	2
1016	26	2
1017	32	4
1018	35	5
1019	45	4
1020	51	1
1021	57	3
1022	61	3
1023	63	5
1024	71	1
1025	76	4
1026	81	5
1027	85	1
1028	94	3
1029	101	5
1030	111	1
1031	113	5
1032	121	3
1033	130	5
1034	132	3
1035	140	3
1036	143	2
1037	149	1
1038	157	3
1039	163	3
1040	168	5
1041	174	2
1042	176	2
1043	178	1
1044	188	3
1045	191	3
1046	193	2
1047	200	4
1048	206	1
1049	211	2
1050	217	3
1051	223	3
1052	226	1
1053	229	5
1054	237	2
1055	242	4
1056	252	4
1057	260	3
1058	266	3
1059	268	1
1060	271	3
1061	275	5
1062	282	5
1063	284	4
1064	288	5
1065	298	3
1066	299	2
1067	304	2
1068	309	2
1069	312	4
1070	315	3
1071	317	4
1072	318	2
1073	326	2
1074	328	3
1075	335	3
1076	338	2
1077	343	2
1078	353	5
1079	356	5
1080	359	4
1081	360	2
1082	365	4
1083	370	5
1084	380	4
1085	385	3
1086	395	1
1087	404	4
1088	408	5
1089	411	2
1090	421	1
1091	422	5
1092	424	1
1093	425	2
1094	432	3
1095	436	3
1096	446	4
1097	449	3
1098	453	3
1099	455	4
1100	464	2
1101	471	1
1102	478	3
1103	485	3
1104	487	2
1105	497	1
1106	1	1
1107	5	1
1108	13	3
1109	22	5
1110	24	5
1111	29	5
1112	37	4
1113	46	1
1114	52	3
1115	55	4
1116	64	4
1117	71	1
1118	81	2
1119	85	3
1120	89	5
1121	99	1
1122	101	5
1123	109	3
1124	117	2
1125	122	3
1126	131	5
1127	138	2
1128	145	4
1129	149	4
1130	154	4
1131	155	3
1132	162	4
1133	167	2
1134	173	1
1135	179	3
1136	186	1
1137	196	5
1138	203	3
1139	213	5
1140	216	5
1141	224	5
1142	226	4
1143	235	3
1144	242	1
1145	243	5
1146	251	2
1147	252	3
1148	262	2
1149	265	2
1150	266	2
1151	274	3
1152	279	3
1153	281	3
1154	288	1
1155	296	3
1156	302	5
1157	308	2
1158	312	5
1159	320	5
1160	321	3
1161	329	1
1162	337	1
1163	346	2
1164	356	2
1165	358	1
1166	368	4
1167	373	2
1168	382	4
1169	388	3
1170	393	2
1171	397	2
1172	398	1
1173	406	2
1174	414	4
1175	421	5
1176	422	1
1177	430	4
1178	431	5
1179	440	1
1180	450	2
1181	454	1
1182	463	3
1183	471	3
1184	478	1
1185	483	3
1186	489	4
1187	494	2
1188	498	4
1189	3	5
1190	9	2
1191	11	5
1192	18	1
1193	21	1
1194	31	4
1195	35	3
1196	40	4
1197	43	4
1198	44	2
1199	49	5
1200	53	3
1201	63	5
1202	66	2
1203	74	2
1204	78	5
1205	86	2
1206	96	5
1207	98	3
1208	101	3
1209	108	2
1210	118	5
1211	121	5
1212	124	5
1213	126	4
1214	127	1
1215	134	2
1216	135	2
1217	142	1
1218	143	3
1219	149	4
1220	151	5
1221	159	4
1222	160	4
1223	168	4
1224	172	1
1225	173	3
1226	175	2
1227	181	2
1228	182	1
1229	187	1
1230	189	3
1231	198	2
1232	205	2
1233	213	1
1234	223	3
1235	228	3
1236	229	3
1237	237	3
1238	247	2
1239	255	1
1240	265	3
1241	268	2
1242	269	4
1243	278	3
1244	280	2
1245	289	1
1246	297	1
1247	302	4
1248	312	5
1249	321	2
1250	326	3
1251	329	4
1252	333	3
1253	334	5
1254	341	3
1255	350	2
1256	356	3
1257	362	4
1258	369	2
1259	378	3
1260	386	2
1261	395	4
1262	405	5
1263	415	1
1264	425	5
1265	429	3
1266	435	3
1267	436	3
1268	444	4
1269	445	3
1270	447	3
1271	451	4
1272	459	4
1273	467	3
1274	470	4
1275	477	2
1276	482	5
1277	485	1
1278	487	1
1279	491	4
1280	1	5
1281	4	4
1282	10	3
1283	17	4
1284	20	3
1285	24	4
1286	29	2
1287	37	3
1288	42	3
1289	46	2
1290	54	2
1291	62	4
1292	71	3
1293	79	4
1294	84	5
1295	90	3
1296	95	4
1297	105	5
1298	109	3
1299	116	1
1300	125	5
1301	130	5
1302	135	4
1303	145	3
1304	153	5
1305	156	3
1306	162	2
1307	171	4
1308	172	4
1309	174	4
1310	183	3
1311	189	1
1312	198	4
1313	203	3
1314	207	1
1315	210	1
1316	218	3
1317	227	5
1318	236	3
1319	238	5
1320	248	2
1321	251	2
1322	256	5
1323	257	1
1324	258	4
1325	264	3
1326	271	3
1327	279	5
1328	284	1
1329	290	1
1330	291	3
1331	293	3
1332	299	2
1333	305	3
1334	311	1
1335	320	5
1336	323	4
1337	327	2
1338	333	3
1339	342	4
1340	345	3
1341	353	3
1342	360	3
1343	367	2
1344	377	5
1345	381	2
1346	390	2
1347	400	5
1348	410	4
1349	412	1
1350	416	3
1351	426	5
1352	434	4
1353	439	3
1354	445	1
1355	455	2
1356	456	1
1357	457	2
1358	458	4
1359	464	2
1360	474	3
1361	481	2
1362	485	4
1363	495	3
1364	2	5
1365	8	2
1366	17	4
1367	24	4
1368	33	5
1369	41	1
1370	48	3
1371	53	5
1372	57	4
1373	63	2
1374	70	1
1375	76	2
1376	82	2
1377	91	3
1378	98	1
1379	105	1
1380	114	3
1381	122	3
1382	131	3
1383	135	4
1384	136	3
1385	139	4
1386	144	2
1387	151	4
1388	152	2
1389	157	1
1390	160	4
1391	167	5
1392	175	1
1393	185	5
1394	188	2
1395	197	2
1396	207	2
1397	215	1
1398	224	5
1399	225	4
1400	229	4
1401	234	3
1402	244	4
1403	249	5
1404	252	5
1405	253	4
1406	263	5
1407	268	5
1408	270	4
1409	274	4
1410	278	1
1411	285	5
1412	288	2
1413	296	2
1414	301	4
1415	309	5
1416	314	4
1417	318	5
1418	324	5
1419	333	1
1420	336	4
1421	344	2
1422	347	5
1423	353	3
1424	355	1
1425	359	4
1426	362	5
1427	369	1
1428	375	1
1429	384	1
1430	386	2
1431	388	1
1432	396	1
1433	403	5
1434	407	4
1435	410	4
1436	418	4
1437	420	5
1438	422	2
1439	428	2
1440	436	4
1441	441	3
1442	451	5
1443	456	5
1444	464	5
1445	468	2
1446	473	5
1447	482	1
1448	487	4
1449	493	4
1450	500	4
1451	3	4
1452	7	2
1453	15	4
1454	17	3
1455	22	1
1456	30	4
1457	31	2
1458	39	2
1459	44	4
1460	54	3
1461	60	1
1462	69	4
1463	72	4
1464	76	3
1465	85	4
1466	90	3
1467	91	4
1468	93	3
1469	95	5
1470	96	2
1471	102	1
1472	107	4
1473	116	2
1474	122	3
1475	131	1
1476	136	4
1477	146	5
1478	152	1
1479	158	4
1480	159	2
1481	160	2
1482	169	4
1483	170	5
1484	172	2
1485	173	5
1486	177	1
1487	183	3
1488	184	5
1489	189	1
1490	196	3
1491	203	2
1492	211	3
1493	212	4
1494	213	2
1495	222	5
1496	230	5
1497	240	4
1498	247	5
1499	255	2
1500	264	1
1501	268	4
1502	276	1
1503	279	2
1504	284	4
1505	292	1
1506	300	2
1507	308	2
1508	315	5
1509	319	4
1510	325	5
1511	326	5
1512	331	2
1513	333	5
1514	335	2
1515	340	2
1516	347	5
1517	355	1
1518	361	2
1519	363	3
1520	366	2
1521	369	3
1522	379	1
1523	388	4
1524	397	4
1525	403	3
1526	406	2
1527	414	4
1528	422	2
1529	430	5
1530	431	4
1531	434	2
1532	440	2
1533	444	2
1534	449	2
1535	457	3
1536	463	3
1537	466	4
1538	467	3
1539	473	4
1540	481	5
1541	486	3
1542	491	1
1543	498	2
1544	499	5
1545	4	3
1546	7	5
1547	8	5
1548	12	1
1549	14	4
1550	21	4
1551	23	3
1552	28	3
1553	33	2
1554	35	2
1555	36	3
1556	41	4
1557	49	4
1558	52	3
1559	53	2
1560	57	4
1561	63	3
1562	69	2
1563	77	3
1564	80	4
1565	82	2
1566	89	3
1567	94	3
1568	100	4
1569	102	3
1570	108	4
1571	116	2
1572	122	5
1573	127	2
1574	135	1
1575	136	4
1576	141	1
1577	151	3
1578	161	1
1579	169	3
1580	176	3
1581	183	3
1582	192	4
1583	197	4
1584	200	3
1585	202	1
1586	208	2
1587	212	2
1588	220	3
1589	226	3
1590	236	3
1591	246	1
1592	255	5
1593	265	5
1594	273	3
1595	280	3
1596	282	3
1597	292	4
1598	296	2
1599	306	1
1600	312	4
1601	313	4
1602	318	2
1603	328	3
1604	329	4
1605	339	4
1606	349	3
1607	353	2
1608	360	1
1609	367	2
1610	368	2
1611	373	4
1612	378	2
1613	380	1
1614	385	4
1615	389	4
1616	392	2
1617	401	1
1618	403	5
1619	404	1
1620	411	3
1621	420	5
1622	427	4
1623	428	1
1624	437	2
1625	443	5
1626	445	4
1627	452	2
1628	459	1
1629	469	2
1630	472	2
1631	474	5
1632	483	2
1633	485	4
1634	486	1
1635	489	3
1636	496	4
1637	1	5
1638	11	3
1639	16	2
1640	25	2
1641	34	5
1642	44	3
1643	51	1
1644	60	1
1645	67	5
1646	69	5
1647	73	3
1648	79	4
1649	81	5
1650	91	3
1651	100	2
1652	109	5
1653	110	1
1654	118	2
1655	119	1
1656	120	2
1657	125	2
1658	132	2
1659	139	1
1660	145	4
1661	155	2
1662	165	4
1663	166	1
1664	168	3
1665	175	1
1666	176	4
1667	177	4
1668	185	4
1669	186	5
1670	194	5
1671	204	3
1672	209	5
1673	214	2
1674	216	1
1675	226	3
1676	228	2
1677	233	1
1678	242	5
1679	243	2
1680	247	5
1681	257	2
1682	260	4
1683	267	5
1684	273	3
1685	282	4
1686	292	1
1687	294	1
1688	301	5
1689	309	4
1690	314	4
1691	315	4
1692	322	2
1693	331	2
1694	340	1
1695	350	4
1696	354	5
1697	356	3
1698	362	5
1699	369	3
1700	371	2
1701	372	4
1702	381	1
1703	386	2
1704	387	3
1705	388	1
1706	392	2
1707	402	1
1708	403	1
1709	413	3
1710	421	3
1711	426	2
1712	428	3
1713	435	4
1714	442	3
1715	448	4
1716	450	2
1717	451	1
1718	454	3
1719	460	5
1720	469	4
1721	471	2
1722	480	5
1723	482	2
1724	486	5
1725	494	1
1726	1	4
1727	8	4
1728	13	4
1729	18	5
1730	24	2
1731	34	4
1732	44	4
1733	51	4
1734	58	2
1735	67	3
1736	74	3
1737	83	4
1738	89	4
1739	99	1
1740	101	2
1741	103	4
1742	106	3
1743	115	2
1744	122	5
1745	127	4
1746	137	4
1747	147	5
1748	150	3
1749	157	4
1750	166	1
1751	174	5
1752	176	2
1753	179	4
1754	184	1
1755	190	3
1756	191	4
1757	192	4
1758	198	2
1759	208	2
1760	217	5
1761	224	4
1762	231	3
1763	240	2
1764	243	1
1765	252	3
1766	255	3
1767	260	3
1768	265	1
1769	268	5
1770	278	4
1771	280	2
1772	288	4
1773	297	1
1774	298	3
1775	306	1
1776	316	1
1777	318	3
1778	321	4
1779	326	2
1780	336	4
1781	337	1
1782	340	1
1783	347	2
1784	353	4
1785	355	2
1786	357	3
1787	362	5
1788	366	2
1789	371	2
1790	378	4
1791	387	1
1792	390	3
1793	391	3
1794	396	5
1795	403	5
1796	410	2
1797	414	5
1798	420	3
1799	425	5
1800	434	5
1801	443	5
1802	446	4
1803	449	3
1804	450	3
1805	454	5
1806	464	5
1807	472	1
1808	473	3
1809	480	5
1810	488	1
1811	498	3
1812	499	3
1813	8	2
1814	11	1
1815	14	2
1816	23	3
1817	33	5
1818	35	5
1819	44	3
1820	48	3
1821	57	2
1822	64	2
1823	73	5
1824	77	5
1825	80	1
1826	90	5
1827	100	5
1828	110	1
1829	117	4
1830	126	4
1831	133	3
1832	138	4
1833	144	1
1834	145	4
1835	154	4
1836	162	1
1837	166	5
1838	169	2
1839	170	2
1840	178	2
1841	179	4
1842	182	5
1843	189	2
1844	192	4
1845	201	3
1846	209	4
1847	218	2
1848	224	4
1849	227	2
1850	235	2
1851	238	4
1852	240	3
1853	244	4
1854	247	1
1855	251	3
1856	256	4
1857	266	2
1858	269	4
1859	274	5
1860	276	3
1861	286	4
1862	296	3
1863	306	2
1864	310	5
1865	314	1
1866	318	4
1867	321	3
1868	327	2
1869	332	5
1870	335	2
1871	342	4
1872	348	2
1873	358	2
1874	361	5
1875	371	3
1876	372	4
1877	375	2
1878	384	3
1879	394	5
1880	395	3
1881	403	1
1882	409	4
1883	413	5
1884	416	1
1885	420	3
1886	426	2
1887	431	2
1888	439	3
1889	441	3
1890	450	3
1891	452	2
1892	458	5
1893	460	1
1894	466	4
1895	472	5
1896	478	4
1897	487	3
1898	492	5
1899	498	2
1900	4	3
1901	13	1
1902	19	4
1903	21	5
1904	26	3
1905	36	4
1906	37	3
1907	41	2
1908	45	1
1909	47	1
1910	50	2
1911	54	1
1912	57	3
1913	63	1
1914	69	2
1915	71	5
1916	74	1
1917	81	4
1918	89	2
1919	90	5
1920	100	3
1921	104	2
1922	109	4
1923	112	1
1924	118	5
1925	119	5
1926	128	1
1927	136	3
1928	141	4
1929	146	4
1930	155	3
1931	161	1
1932	163	4
1933	170	4
1934	173	2
1935	176	2
1936	185	5
1937	186	5
1938	196	3
1939	205	1
1940	209	3
1941	213	1
1942	218	2
1943	219	1
1944	221	2
1945	229	4
1946	237	1
1947	245	3
1948	249	3
1949	258	5
1950	263	5
1951	269	1
1952	278	5
1953	279	4
1954	289	1
1955	294	1
1956	295	2
1957	305	5
1958	307	2
1959	311	3
1960	321	4
1961	322	5
1962	325	4
1963	335	5
1964	345	2
1965	350	3
1966	354	4
1967	363	1
1968	365	1
1969	368	4
1970	373	3
1971	379	4
1972	383	4
1973	390	2
1974	397	5
1975	402	4
1976	403	1
1977	412	3
1978	419	4
1979	427	2
1980	433	5
1981	438	5
1982	442	4
1983	449	4
1984	456	3
1985	466	2
1986	473	3
1987	476	5
1988	477	1
1989	481	5
1990	491	1
1991	493	2
1992	1	1
1993	11	5
1994	19	3
1995	28	2
1996	35	5
1997	36	3
1998	40	1
1999	44	2
2000	54	4
\.


--
-- Data for Name: emailadresse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY emailadresse (adresse, person_name, person_geburtsdatum) FROM stdin;
RichardZia3@kpn.net	Caffray	1954-10-27
Leo.Lezniak1@lycos.no	Daley	1935-01-11
J.Imhoff3@web.cc	Bernstein	1977-11-29
Rico.Bertelson3@web.dk	Howe	1949-07-21
FreddyCramer3@live.cc	Comeau	1977-11-14
Bas.Slocum@gmail.it	Waddell	1937-03-31
V.Nefos4@kpn.cn	Langham	1964-06-04
J.Manson@web.us	Van Dinter	1983-02-24
JohanWargula@myspace.ca	Conley	1944-01-28
Jack.Nelson3@myspace.org	Walker	1960-06-20
P.Gildersleeve3@lycos.dk	Foreman	1952-05-03
WilliamToler@mymail.cc	Ditmanen	1968-09-04
Rick.Moore@myspace.de	Zia	1946-10-19
Richard.Hamilton3@gawab.nl	Emerson	1972-07-18
MartMakelaar@msn.org	Roche	1950-11-08
DWooten@mobileme.cc	Perilloux	1956-10-29
RickGildersleeve2@live.dk	Menovosa	1937-12-24
L.Jenssen@web.no	Toler	1995-01-13
Freddy.Ratliff@mymail.ca	Robbins	1963-06-02
Jack.Moore1@freeweb.nl	Visentini	1944-06-28
E.Laudanski2@dolfijn.dk	Pierce	1960-07-26
WilliamMorgan4@libero.gov	DeBerg	1974-06-30
DickGuyer@web.nl	Morton	1940-07-30
RickLaudanski4@myspace.fr	Hopper	1981-01-31
EJohnson@live.net	Hedgecock	1938-05-11
Petra.Walker3@weboffice.co.uk	Brumley	1939-03-12
Rick.Williams3@gmail.be	Herrin	1972-11-11
Bill.Mcnally@telfort.org	Ionescu	1987-07-05
Lucy.Ijukop1@excite.it	Seibel	1983-09-19
DickSharp4@aol.cc	Roger	1985-01-31
R.Novratni3@msn.us	Wooten	1954-10-30
Fred.Mcnally3@web.org	Millikin	1971-07-17
GCramer5@msn.ca	Clark	1953-01-16
Ronald.Hollman4@mail.fr	Bertelson	1976-03-11
NickShapiro@excite.ca	Blount	1945-05-13
William.Bergdahl2@myspace.ca	Zapetis	1953-06-15
Fons.Cantere@mail.no	Poole	1962-03-09
YLaudanski5@web.no	Gieske	1947-01-30
TreesVostreys@lycos.com	Forsberg	1972-05-17
Ton.Gibson3@web.com	Nahay	1958-10-29
SvenGua Lima@gmail.be	van der Laar	1944-09-24
AgnesVan Toorenbeek5@hotmail.de	Barnett	1982-11-03
Frans.Morgan3@lycos.fr	Uprovski	1989-02-10
PatrickZimmerman@yahoo.be	Wilson	1963-06-12
HMoon@yahoo.gov	Hancock	1941-01-23
YDaughtery@kpn.org	DelRosso	1970-05-29
JackHoogbandt@libero.ca	Uitergeest	1941-12-30
Oliver.Huffsmitt5@yahoo.cn	Mulders	1961-08-27
K.Pierce@telefonica.net	Voigt	1951-11-25
Sven.Van Toorenbeek@libero.org	Bugno	1974-04-19
GRobbins@aol.com	Julieze	1972-05-18
SuzanneMoore@excite.cn	Helbush	1967-01-16
Hank.Willis4@live.cn	Riegel	1979-11-21
TRichter1@myspace.de	Ijukop	1960-11-05
Pauline.Richter5@excite.com	Mcgrew	1994-06-12
Rico.Langham@aol.gov	Pengilly	1958-05-01
Fred.Moreau@excite.fr	Long	1952-07-01
WilliamMorton@telefonica.nl	Nefos	1992-07-10
Trees.Hardoon5@myspace.org	Browne	1937-05-20
JohanForeman1@libero.dk	van Goes	1968-07-15
PeterNewman4@gawab.cc	Tudisco	1940-05-27
V.Glanswol@lycos.cc	Goodnight	1989-08-27
Nigel.Jenssen@excite.cc	Dittrich	1949-12-16
Bas.Otto@mobileme.org	Petterson	1961-08-12
G.Tudisco4@weboffice.ca	Ladaille	1994-02-25
FemkeNelson@mail.cn	Ratliff	1965-04-27
RLawton3@mymail.co.uk	Moore	1978-12-20
James.Gunter@gmail.cc	Huston	1963-05-19
FreddyTroher@live.gov	Otto	1964-12-20
Pete.Bugno1@yahoo.it	Toreau	1977-11-05
VincentKatsekes@mymail.fr	Framus	1975-11-08
RicoJohnson@telefonica.nl	Shapiro	1970-09-16
LHowe@hotmail.nl	Guyer	1995-06-25
L.Pengilly4@live.cc	Cantere	1950-02-27
PHankins@freeweb.ca	Cappello	1988-07-27
FransAngarano3@weboffice.cc	Bergdahl	1983-08-19
Frans.Zia5@msn.nl	Hoogbandt	1967-10-20
CamillaSimonent@gmail.no	Mcnally	1994-01-28
GMorgan4@aol.gov	Nobles	1986-04-13
Hans.Vostreys1@mail.net	Zimmerman	1939-03-20
BillCramer@libero.org	Frega	1970-12-21
RichardShapiro1@excite.es	Goodman	1938-01-29
BobGlanswol5@telfort.ca	Brown	1985-02-16
Paul.Davis5@mobileme.co.uk	Weaver	1974-09-01
Hans.Archer@excite.co.uk	Wicks	1986-08-18
HansChapman3@dolfijn.be	Press	1967-09-21
Sven.Griffioen4@myspace.dk	Symbouras	1963-12-18
HFreed5@libero.nl	Ahlgren	1940-08-17
JackStannard@telefonica.cc	Leonarda	1964-04-10
I.Cragin@web.it	Liddle	1984-12-04
R.Uitergeest@libero.us	Nadalin	1995-06-11
Freddy.Slemp@libero.net	Bloom	1975-05-07
Otto.Gonzalez@yahoo.dk	Morgan	1954-10-22
G.Evans2@msn.no	Millis	1969-11-07
Frank.Shapiro@lycos.gov	Duvall	1995-07-06
Mart.Lezniak@dolfijn.ca	Haynes	1948-08-29
Bas.Ratliff@mobileme.es	Depew	1960-05-28
Roger.Ward@myspace.net	Bryant	1955-06-20
BasHopper@aol.org	King	1977-04-02
Richard.Watson@aol.it	van Doorn	1990-05-19
Bianca.Poissant@kpn.us	Swaine	1939-01-12
Alice.Uprovski@gmail.cn	Bruno	1945-01-28
BillRivers@lycos.net	Moreau	1941-01-20
BMarra1@gawab.it	Baltec	1964-01-22
Ton.Stockton3@excite.gov	Weinstein	1943-10-10
RWood@web.es	Hendrix	1971-04-02
M.Browne@gmail.us	Mariojnisk	1939-10-11
Rogier.Guethlein@yahoo.ca	Wargula	1988-04-30
PeteLannigham@mymail.net	Glanswol	1947-06-16
PeterAnthony4@lycos.it	Beckbau	1948-11-10
TonRiegel@libero.ca	Barbee	1936-02-18
Patty.Ahlgren@telefonica.org	Gonzalez	1957-08-15
FrankRay@excite.gov	Petrzelka	1941-04-22
GeoffryIonescu@myspace.no	Keller	1939-06-12
Nick.Chwatal@weboffice.cn	Gunter	1950-12-07
S.Geoppo2@telefonica.dk	Naley	1992-01-04
Freddy.Pierce@live.us	Plantz	1973-01-17
Bianca.Gaskins4@web.org	Herzog	1972-06-01
BillKoch@excite.be	Korkovski	1964-07-22
YPress1@web.us	Sakurai	1982-09-14
RogierGoodnight@gawab.us	Helfrich	1945-03-07
CRauch@lycos.no	Turk	1945-06-21
DKuehn@mail.nl	Scheffold	1990-07-26
Sydney.Grote4@excite.nl	Sanders	1960-04-20
Lindsy.Cooper@telfort.us	Ayers	1958-06-01
Bartvan Dijk1@dolfijn.be	Anderson	1950-05-07
TonMorton@myspace.nl	Rauch	1975-06-19
TFramus@excite.be	Robertson	1980-12-27
DZapetis2@live.com	Schlee	1994-12-18
Bas.Orcutt@weboffice.it	Slater	1984-01-06
BobMaribarski@libero.org	Stannard	1967-11-06
YWolpert@gawab.nl	Malone	1977-11-11
J.Freed1@gawab.de	Cohen	1955-06-28
AnnLadaille@telefonica.fr	Phillips	1986-03-13
LeoByrnes@myspace.net	Orcutt	1941-07-31
M.Climent5@web.nl	Ray	1990-06-07
MSchlee1@lycos.de	Phelps	1944-10-15
UBertelson@msn.no	Dulisse	1946-03-09
Frans.Perilloux@weboffice.de	Markovi	1989-02-23
TonGieske1@telfort.nl	Blacher	1969-04-26
YAllison@live.no	Cain	1983-06-19
Frank.Forsberg@gawab.cn	Nithman	1963-07-30
Ton.Hopper1@gawab.us	Anthony	1967-12-02
LIjukop5@telfort.cn	Carlos	1956-02-08
Roy.Nelson4@msn.dk	Stevens	1940-06-19
A.Glanswol@msn.cn	Grote	1958-06-08
Ann.Heyn@libero.no	Sterrett	1936-01-16
H.Hoyt@mobileme.ca	Prior	1988-07-19
RWhitehurst@mobileme.net	Massingill	1985-09-08
Petra.Wooten1@excite.co.uk	Simonent	1993-11-21
M.Gunter@mail.cc	LeGrand	1960-10-18
WilliamLong@mobileme.es	Brisco	1983-04-15
Bas.Shapiro@msn.net	Pyland	1961-01-24
N.Baltec1@msn.es	Vanderoever	1964-10-12
Mattijs.Brown3@weboffice.org	Watson	1975-05-17
Frank.Mitchell@web.fr	White	1985-03-19
KayUprovski@lycos.be	Jones	1945-11-08
H.Brendjens@telfort.com	Matthew	1986-02-18
Rick.Shapiro3@mymail.net	Hulshof	1972-09-28
J.Emerson@msn.net	Cramer	1973-11-22
S.Jackson3@mobileme.it	Wolpert	1941-01-26
R.Carlos@telefonica.us	van het Hof	1981-03-24
VictoriaDeBuck@live.de	Pekaban	1948-08-04
Hans.Royal@lycos.no	Reames	1950-04-24
Richard.Vostreys1@live.cc	Young	1986-09-20
LDeBerg3@web.be	Ward\t	1974-08-30
Kim.Lannigham@lycos.nl	Mitchell	1961-04-25
PatrickBrown2@mymail.it	Chapman	1969-10-06
RichardNobles5@hotmail.de	Antonucci	1963-09-21
Lynn.Kuehn@libero.gov	van Dijk	1935-03-15
PatrickGoodman@mobileme.com	Poissant	1946-03-30
AgnesCarlos5@mobileme.de	Kingslan	1940-09-21
NickWilliamson5@web.nl	Hummel	1945-09-07
Richard.Durso@yahoo.es	Mairy	1985-11-29
EBrady@live.no	Yinger	1987-07-12
TreesJones4@aol.cn	Hardoon	1982-07-03
CiskaHummel@mail.cc	Dean	1973-11-23
Madelein.van Doorn@msn.org	Troher	1983-11-16
Gretsj.Koss1@gawab.gov	Praeger	1953-04-05
FreddyHarder5@live.es	Novratni	1947-06-21
EFranklin4@gawab.fr	Griffith	1944-06-06
HankMcCrary4@gmail.no	Mayberry	1979-04-28
Will.Bruno3@aol.be	Makelaar	1986-04-09
Pauline.Goodnight1@excite.gov	Wesolowski	1959-10-31
William.Kellock@msn.be	Paul	1961-02-17
G.Zapetis@myspace.gov	Pekagnan	1969-10-19
G.Morgan@dolfijn.nl	Hoyt	1947-08-04
Y.Stewart3@excite.it	Francis	1946-10-01
T.Crocetti@freeweb.us	Polti	1973-04-28
GWhite@hotmail.dk	Brendjens	1958-03-07
FrankFranklin@freeweb.it	Schubert	1978-07-22
Rogier.Phelps5@mobileme.org	Katsekes	1935-01-22
VictoriaPhelps@freeweb.de	Franklin	1950-02-19
N.Marra@dolfijn.ca	Nelson	1954-09-11
OliverMariojnisk2@dolfijn.cn	McCormick	1993-12-12
GCross4@libero.cn	Queen	1937-09-23
DPhelps@telfort.be	Pensec	1946-05-08
Johan.Harder3@mobileme.org	Lejarette	1992-05-21
MadeleinLezniak3@gmail.co.uk	Langham\t	1939-05-25
Bart.Wicks3@web.us	Warner	1979-12-27
\.


--
-- Data for Name: forum; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY forum (medium_name, regeln) FROM stdin;
\.


--
-- Data for Name: hatwotd; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY hatwotd (wort, medium_name, datum, staerke) FROM stdin;
which	Google+	2001-02-08	1
land	Developer-Blog	2001-02-26	1
yielding	entwicklerforum.datenbanken.mysql	2001-02-27	1
created	Tagesschau Blog	2001-02-28	1
brought	rwth.informatik.grundstudium	2001-03-26	1
multiply	entwicklerforum.datenbanken.mysql	2001-04-05	1
life	rwth.informatik.grundstudium	2001-04-13	1
greater	entwicklerforum.datenbanken.postgresql	2001-05-17	1
whose	rwth.informatik.grundstudium	2001-05-20	1
give	Facebook	2001-05-24	1
you're	Tagesschau Blog	2001-06-01	1
place	StudiVZ	2001-06-02	1
darkness	Developer-Blog	2001-06-08	1
over	entwicklerforum.datenbanken.mysql	2001-06-12	1
morning	Tagesschau Blog	2001-06-29	1
good	Tagesschau Blog	2001-07-04	1
a	Facebook	2001-07-06	5
saw	Facebook	2001-07-09	1
land	Google+	2001-07-12	1
man	StudiVZ	2001-07-16	1
open	Facebook	2001-07-18	2
you're	rwth.informatik.hauptstudium	2001-07-21	1
whose	Google+	2001-07-24	1
behold	entwicklerforum.datenbanken.postgresql	2001-07-24	1
second	rwth.informatik.hauptstudium	2001-08-06	1
they're	entwicklerforum.datenbanken.postgresql	2001-08-07	1
shall	rwth.informatik.grundstudium	2001-08-18	1
tree	rwth.informatik.hauptstudium	2001-08-22	1
shall	Tagesschau Blog	2001-08-24	1
don't	rwth.informatik.grundstudium	2001-09-09	1
darkness	Facebook	2001-09-16	1
whales	rwth.jobs	2001-09-18	1
dominion	rwth.jobs	2001-10-07	1
you	rwth.informatik.hauptstudium	2001-10-08	2
under	rwth.informatik.hauptstudium	2001-10-09	1
give	rwth.jobs	2001-10-20	1
were	entwicklerforum.datenbanken.postgresql	2001-10-28	1
their	Tagesschau Blog	2001-11-03	1
waters	Tagesschau Blog	2001-12-02	1
make	rwth.jobs	2001-12-02	1
man	Tagesschau Blog	2002-01-01	1
great	Tagesschau Blog	2002-01-13	2
greater	Facebook	2002-01-16	1
give	rwth.informatik.hauptstudium	2002-01-20	1
beast	rwth.informatik.grundstudium	2002-01-25	1
god	rwth.informatik.hauptstudium	2002-01-26	1
sixth	Facebook	2002-01-29	1
all	Tagesschau Blog	2002-02-19	1
there	StudiVZ	2002-03-04	1
fill	Linux Forum	2002-03-24	2
had	Linux Forum	2002-04-22	1
gathered	rwth.informatik.grundstudium	2002-04-26	1
from	Google+	2002-04-27	1
day	Tagesschau Blog	2002-05-05	2
won't	Linux Forum	2002-05-14	1
sixth	entwicklerforum.datenbanken.mysql	2002-05-31	1
there	Developer-Blog	2002-06-10	2
she'd	Linux Forum	2002-07-16	2
given	Google+	2002-07-22	1
multiply	rwth.informatik.grundstudium	2002-08-17	1
there	entwicklerforum.datenbanken.mysql	2002-08-25	1
itself	StudiVZ	2002-09-06	1
all	entwicklerforum.datenbanken.mysql	2002-09-09	1
a	StudiVZ	2002-09-13	10
seas	entwicklerforum.datenbanken.postgresql	2002-09-25	1
under	Tagesschau Blog	2002-10-15	1
thing	Facebook	2002-10-19	1
called	rwth.informatik.grundstudium	2002-10-30	1
living	Facebook	2002-11-08	1
seas	Linux Forum	2002-11-15	1
under	rwth.jobs	2002-11-19	1
may	entwicklerforum.datenbanken.postgresql	2002-11-25	1
a	entwicklerforum.datenbanken.mysql	2002-12-01	6
heaven	entwicklerforum.datenbanken.postgresql	2002-12-01	1
were	Developer-Blog	2002-12-03	1
place	rwth.informatik.grundstudium	2002-12-13	2
multiply	rwth.informatik.hauptstudium	2002-12-17	1
dominion	Linux Forum	2003-01-02	1
seasons	Google+	2003-01-10	1
forth	Google+	2003-01-16	1
of	rwth.informatik.hauptstudium	2003-01-21	1
creepeth	rwth.jobs	2003-02-09	1
creeping	Google+	2003-02-15	1
you're	Google+	2003-03-04	1
together	Developer-Blog	2003-03-18	1
you'll	Linux Forum	2003-03-22	1
they're	rwth.jobs	2003-03-24	2
appear	rwth.informatik.hauptstudium	2003-04-01	1
that	Google+	2003-04-18	1
for	rwth.informatik.hauptstudium	2003-05-08	1
gathering	Google+	2003-05-21	2
which	Tagesschau Blog	2003-05-23	1
place	rwth.jobs	2003-05-26	1
from	rwth.informatik.grundstudium	2003-06-05	1
abundantly	rwth.jobs	2003-06-23	1
you're	entwicklerforum.datenbanken.mysql	2003-07-03	1
seas	entwicklerforum.datenbanken.mysql	2003-07-07	1
lights	rwth.jobs	2003-07-11	1
morning	entwicklerforum.datenbanken.mysql	2003-07-16	1
make	rwth.informatik.grundstudium	2003-07-17	2
man	Developer-Blog	2003-07-21	1
fowl	Linux Forum	2003-07-27	1
light	Linux Forum	2003-08-03	2
together	Google+	2003-08-09	1
have	rwth.informatik.hauptstudium	2003-09-04	1
won't	StudiVZ	2003-09-11	2
saw	Developer-Blog	2003-09-12	1
fifth	rwth.informatik.hauptstudium	2003-09-13	1
was	rwth.jobs	2003-09-21	1
which	rwth.informatik.hauptstudium	2003-09-22	1
night	rwth.informatik.hauptstudium	2003-10-09	2
him	entwicklerforum.datenbanken.mysql	2003-10-14	1
she'd	rwth.jobs	2003-10-19	1
so	Google+	2003-10-23	3
tree	Developer-Blog	2003-10-26	1
divided	rwth.informatik.hauptstudium	2003-10-31	1
their	Developer-Blog	2003-11-22	1
upon	entwicklerforum.datenbanken.postgresql	2003-11-25	1
over	Developer-Blog	2003-12-04	1
divide	Google+	2003-12-04	2
winged	entwicklerforum.datenbanken.postgresql	2003-12-13	1
given	Tagesschau Blog	2003-12-25	1
created	entwicklerforum.datenbanken.mysql	2004-01-16	2
subdue	StudiVZ	2004-01-18	1
divide	rwth.jobs	2004-01-18	1
you	rwth.jobs	2004-01-19	1
after	Facebook	2004-01-24	1
itself	Google+	2004-01-30	1
bring	rwth.jobs	2004-02-02	1
of	StudiVZ	2004-02-09	1
meat	Google+	2004-02-18	1
fruit	Facebook	2004-02-24	1
may	Google+	2004-02-27	1
in	rwth.jobs	2004-03-03	1
moved	rwth.jobs	2004-03-26	1
man	Linux Forum	2004-04-04	1
them	Developer-Blog	2004-04-19	1
tree	entwicklerforum.datenbanken.postgresql	2004-04-20	2
day	StudiVZ	2004-04-25	1
called	Linux Forum	2004-05-01	1
upon	rwth.informatik.hauptstudium	2004-05-05	1
whales	Developer-Blog	2004-05-08	1
darkness	Tagesschau Blog	2004-05-16	1
hath	Developer-Blog	2004-06-19	1
image	Facebook	2004-06-26	2
earth	Tagesschau Blog	2004-07-11	1
deep	entwicklerforum.datenbanken.postgresql	2004-07-16	1
great	Developer-Blog	2004-07-17	1
bring	entwicklerforum.datenbanken.mysql	2004-07-21	1
waters	rwth.informatik.grundstudium	2004-08-15	1
darkness	StudiVZ	2004-08-21	1
kind	entwicklerforum.datenbanken.postgresql	2004-09-11	1
likeness	rwth.jobs	2004-09-17	1
set	Developer-Blog	2004-09-19	1
doesn't	Google+	2004-09-28	1
moveth	entwicklerforum.datenbanken.mysql	2004-09-29	1
can't	Facebook	2004-10-01	1
every	Google+	2004-10-03	1
own	rwth.jobs	2004-10-03	1
in	entwicklerforum.datenbanken.postgresql	2004-10-06	1
great	Linux Forum	2004-10-18	1
green	entwicklerforum.datenbanken.postgresql	2004-11-30	2
day	entwicklerforum.datenbanken.mysql	2004-12-05	1
beginning	Linux Forum	2004-12-09	1
land	entwicklerforum.datenbanken.mysql	2004-12-25	1
our	entwicklerforum.datenbanken.mysql	2005-01-01	1
let	rwth.jobs	2005-01-17	1
all	entwicklerforum.datenbanken.postgresql	2005-01-28	2
after	rwth.jobs	2005-02-02	1
evening	Tagesschau Blog	2005-02-09	1
appear	Tagesschau Blog	2005-03-01	1
fifth	rwth.jobs	2005-03-02	1
sixth	rwth.informatik.grundstudium	2005-03-05	1
a	rwth.informatik.grundstudium	2005-03-10	8
rule	rwth.informatik.hauptstudium	2005-03-10	1
days	Developer-Blog	2005-03-13	1
god	Google+	2005-03-18	1
beast	Developer-Blog	2005-03-25	1
form	entwicklerforum.datenbanken.mysql	2005-04-02	1
itself	Developer-Blog	2005-04-08	1
second	StudiVZ	2005-04-09	1
without	Linux Forum	2005-04-15	1
signs	rwth.jobs	2005-05-03	1
without	rwth.jobs	2005-05-07	1
his	rwth.jobs	2005-05-15	1
moveth	rwth.jobs	2005-05-18	1
were	Google+	2005-05-20	1
made	Tagesschau Blog	2005-05-20	1
that	entwicklerforum.datenbanken.mysql	2005-05-20	1
heaven	rwth.informatik.hauptstudium	2005-06-12	1
she'd	Facebook	2005-06-15	1
tree	Google+	2005-06-15	1
likeness	rwth.informatik.hauptstudium	2005-06-23	1
night	Facebook	2005-06-30	1
have	StudiVZ	2005-07-06	1
subdue	rwth.informatik.hauptstudium	2005-07-09	1
you	entwicklerforum.datenbanken.mysql	2005-07-10	1
air	Google+	2005-07-21	1
all	Google+	2005-07-30	1
over	Facebook	2005-07-31	1
also	entwicklerforum.datenbanken.mysql	2005-08-10	1
lesser	Tagesschau Blog	2005-08-24	1
meat	Developer-Blog	2005-09-03	1
had	Developer-Blog	2005-09-08	1
that	entwicklerforum.datenbanken.postgresql	2005-09-19	1
unto	rwth.jobs	2005-09-19	1
replenish	rwth.jobs	2005-10-02	1
grass	StudiVZ	2005-10-13	1
form	Developer-Blog	2005-10-14	2
together	rwth.informatik.grundstudium	2005-11-22	1
rule	Facebook	2005-12-05	1
fourth	Facebook	2005-12-28	1
his	Linux Forum	2006-01-06	1
had	entwicklerforum.datenbanken.mysql	2006-01-25	1
image	entwicklerforum.datenbanken.mysql	2006-01-27	2
air	Tagesschau Blog	2006-02-13	1
third	rwth.informatik.hauptstudium	2006-03-05	1
living	entwicklerforum.datenbanken.postgresql	2006-03-07	1
likeness	entwicklerforum.datenbanken.postgresql	2006-03-09	1
fill	rwth.informatik.grundstudium	2006-03-09	1
moved	StudiVZ	2006-03-20	1
good	entwicklerforum.datenbanken.mysql	2006-03-20	1
fill	entwicklerforum.datenbanken.mysql	2006-03-21	1
first	rwth.informatik.hauptstudium	2006-04-16	1
air	Linux Forum	2006-05-07	1
unto	Tagesschau Blog	2006-05-08	1
greater	rwth.jobs	2006-05-23	1
moveth	StudiVZ	2006-06-21	1
saw	rwth.informatik.grundstudium	2006-06-25	1
meat	entwicklerforum.datenbanken.postgresql	2006-07-04	1
moving	Developer-Blog	2006-07-06	1
him	rwth.informatik.hauptstudium	2006-07-30	1
fifth	Facebook	2006-08-01	1
the	rwth.informatik.hauptstudium	2006-08-04	1
darkness	Google+	2006-08-07	1
gathering	Linux Forum	2006-08-20	1
great	Facebook	2006-08-22	1
said	StudiVZ	2006-08-31	1
divide	Tagesschau Blog	2006-08-31	2
firmament	entwicklerforum.datenbanken.mysql	2006-09-11	1
and	Google+	2006-09-24	1
moveth	Linux Forum	2006-10-09	1
gathering	StudiVZ	2006-11-16	1
creepeth	StudiVZ	2006-11-22	1
spirit	Linux Forum	2006-12-04	1
greater	Developer-Blog	2006-12-08	1
over	Tagesschau Blog	2006-12-11	1
years	Developer-Blog	2006-12-13	1
open	entwicklerforum.datenbanken.postgresql	2006-12-20	1
had	entwicklerforum.datenbanken.postgresql	2007-01-22	1
evening	rwth.informatik.grundstudium	2007-02-18	1
after	Linux Forum	2007-02-26	1
gathered	rwth.informatik.hauptstudium	2007-03-03	1
replenish	Developer-Blog	2007-03-04	1
bring	StudiVZ	2007-03-26	1
is	Tagesschau Blog	2007-04-07	1
blessed	Google+	2007-04-29	1
it	Tagesschau Blog	2007-04-30	1
living	StudiVZ	2007-05-03	1
don't	StudiVZ	2007-05-12	1
good	rwth.jobs	2007-05-17	1
moved	Linux Forum	2007-06-01	1
let	Tagesschau Blog	2007-06-03	1
make	Tagesschau Blog	2007-06-04	1
was	entwicklerforum.datenbanken.mysql	2007-06-14	1
own	StudiVZ	2007-06-18	1
so	Facebook	2007-06-22	1
face	rwth.jobs	2007-08-27	1
all	Facebook	2007-08-29	1
earth	StudiVZ	2007-09-02	1
you'll	rwth.jobs	2007-09-29	1
their	entwicklerforum.datenbanken.mysql	2007-10-01	1
fly	Developer-Blog	2007-10-03	1
third	StudiVZ	2007-10-08	1
darkness	rwth.informatik.grundstudium	2007-10-31	1
female	Developer-Blog	2007-11-03	1
meat	rwth.informatik.hauptstudium	2007-11-11	1
hath	entwicklerforum.datenbanken.mysql	2007-12-31	2
is	entwicklerforum.datenbanken.postgresql	2008-01-04	3
void	rwth.informatik.grundstudium	2008-01-07	1
all	rwth.informatik.grundstudium	2008-01-18	2
forth	rwth.jobs	2008-01-21	1
brought	Developer-Blog	2008-01-31	1
for	Tagesschau Blog	2008-02-07	2
days	rwth.jobs	2008-03-29	1
winged	Facebook	2008-04-27	1
second	rwth.jobs	2008-04-28	1
above	Linux Forum	2008-05-03	1
bearing	Facebook	2008-05-12	1
creepeth	rwth.informatik.grundstudium	2008-06-01	1
seasons	entwicklerforum.datenbanken.postgresql	2008-06-30	1
is	rwth.informatik.hauptstudium	2008-07-10	1
beginning	Developer-Blog	2008-07-30	1
lights	Google+	2008-08-06	1
tree	Tagesschau Blog	2008-08-07	1
of	entwicklerforum.datenbanken.postgresql	2008-08-11	1
there	rwth.informatik.grundstudium	2008-08-20	3
isn't	Tagesschau Blog	2008-08-31	1
cattle	entwicklerforum.datenbanken.mysql	2008-10-02	1
fruitful	rwth.informatik.grundstudium	2008-10-03	2
likeness	entwicklerforum.datenbanken.mysql	2008-10-14	1
wherein	Facebook	2008-10-15	1
be	Linux Forum	2008-10-24	1
given	rwth.informatik.grundstudium	2008-10-31	1
isn't	Developer-Blog	2008-11-05	1
creature	Linux Forum	2008-11-07	1
them	Tagesschau Blog	2008-11-07	1
dry	Developer-Blog	2008-11-13	1
there	rwth.jobs	2008-12-18	2
there	entwicklerforum.datenbanken.postgresql	2008-12-29	1
without	rwth.informatik.grundstudium	2009-01-01	1
were	rwth.jobs	2009-01-12	1
and	entwicklerforum.datenbanken.mysql	2009-01-17	1
upon	entwicklerforum.datenbanken.mysql	2009-01-24	1
heaven	Linux Forum	2009-01-29	1
hath	rwth.informatik.hauptstudium	2009-02-05	1
shall	entwicklerforum.datenbanken.postgresql	2009-02-14	1
land	rwth.informatik.hauptstudium	2009-04-02	1
years	Facebook	2009-04-04	2
replenish	entwicklerforum.datenbanken.mysql	2009-04-07	1
replenish	Tagesschau Blog	2009-04-09	1
heaven	Tagesschau Blog	2009-04-27	1
earth	Linux Forum	2009-04-30	1
it	rwth.informatik.hauptstudium	2009-05-10	1
void	Developer-Blog	2009-06-02	1
over	Google+	2009-06-10	2
us	Tagesschau Blog	2009-06-15	1
abundantly	entwicklerforum.datenbanken.postgresql	2009-06-19	1
sea	Google+	2009-07-02	1
appear	StudiVZ	2009-07-09	1
place	Tagesschau Blog	2009-07-11	1
thing	Google+	2009-07-16	1
wherein	rwth.informatik.hauptstudium	2009-08-07	1
man	rwth.jobs	2009-08-11	1
itself	Linux Forum	2009-09-13	1
evening	Linux Forum	2009-09-18	1
moveth	entwicklerforum.datenbanken.postgresql	2009-10-16	1
green	rwth.jobs	2009-11-12	1
there	Facebook	2009-12-08	1
every	Tagesschau Blog	2009-12-11	1
above	Tagesschau Blog	2009-12-17	1
very	StudiVZ	2010-01-03	2
for	Linux Forum	2010-01-09	1
let	StudiVZ	2010-01-12	1
make	StudiVZ	2010-01-15	1
sea	rwth.informatik.hauptstudium	2010-01-20	3
fish	Developer-Blog	2010-01-21	1
you're	StudiVZ	2010-01-23	1
multiply	entwicklerforum.datenbanken.postgresql	2010-01-30	1
said	Facebook	2010-02-12	1
bearing	entwicklerforum.datenbanken.postgresql	2010-02-26	1
and	Facebook	2010-03-12	1
behold	rwth.informatik.hauptstudium	2010-03-17	1
midst	rwth.informatik.hauptstudium	2010-03-29	1
days	StudiVZ	2010-04-03	1
seed	entwicklerforum.datenbanken.postgresql	2010-04-16	1
blessed	rwth.informatik.grundstudium	2010-04-30	1
bring	Facebook	2010-05-11	1
isn't	Google+	2010-05-30	1
two	rwth.informatik.hauptstudium	2010-06-02	1
life	Google+	2010-06-08	1
air	entwicklerforum.datenbanken.postgresql	2010-06-23	1
divide	Developer-Blog	2010-06-27	1
earth	rwth.informatik.hauptstudium	2010-07-02	1
meat	Facebook	2010-07-05	1
he	Facebook	2010-07-12	3
there	rwth.informatik.hauptstudium	2010-07-13	1
bring	rwth.informatik.grundstudium	2010-07-28	1
unto	Google+	2010-08-03	1
life	Tagesschau Blog	2010-08-18	1
divided	rwth.jobs	2010-08-31	1
seed	entwicklerforum.datenbanken.mysql	2010-09-13	2
be	entwicklerforum.datenbanken.mysql	2010-09-25	1
female	StudiVZ	2010-09-27	1
whales	Tagesschau Blog	2010-10-08	1
seas	Facebook	2010-10-19	2
form	rwth.informatik.hauptstudium	2010-11-06	1
in	StudiVZ	2010-11-19	3
saw	rwth.informatik.hauptstudium	2010-11-29	1
his	Google+	2010-12-03	1
which	entwicklerforum.datenbanken.postgresql	2010-12-03	1
let	Google+	2011-01-26	1
divide	entwicklerforum.datenbanken.postgresql	2011-02-08	2
fifth	Tagesschau Blog	2011-02-09	1
i	rwth.jobs	2011-02-11	10
after	StudiVZ	2011-02-13	1
them	Linux Forum	2011-03-11	1
light	rwth.informatik.grundstudium	2011-03-15	1
shall	Facebook	2011-04-14	1
without	Developer-Blog	2011-04-24	1
yielding	Developer-Blog	2011-05-26	1
said	Developer-Blog	2011-06-01	1
one	entwicklerforum.datenbanken.mysql	2011-06-05	1
blessed	Developer-Blog	2011-06-07	1
won't	rwth.jobs	2011-06-23	1
called	Tagesschau Blog	2011-08-02	1
won't	Developer-Blog	2011-08-12	1
night	Linux Forum	2011-08-13	2
together	Tagesschau Blog	2011-08-21	1
unto	rwth.informatik.grundstudium	2011-08-29	1
\.


--
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY likes (user_name, user_mediumname, beitrag_id) FROM stdin;
Ainhoa	Google+	229
Alba69	rwth.informatik.hauptstudium	278
Albert2	Developer-Blog	473
Albert5	Google+	9
Alejandro	Google+	232
Alejandro0	entwicklerforum.datenbanken.mysql	404
Alejandro3	entwicklerforum.datenbanken.postgresql	85
Alex88	StudiVZ	179
Alexis	entwicklerforum.datenbanken.postgresql	13
Alfons0	Linux Forum	25
Alfons13	entwicklerforum.datenbanken.mysql	146
Alice8	Developer-Blog	296
Alice929	entwicklerforum.datenbanken.mysql	77
Alva54	Linux Forum	260
Amber17	rwth.informatik.hauptstudium	246
Amy02	Developer-Blog	116
Amy48	rwth.jobs	243
Ana6	Facebook	145
Andrea3	Google+	427
Andrea94	StudiVZ	210
Andrew2	Linux Forum	181
Andrzej34	Tagesschau Blog	491
Andrzej45	rwth.informatik.grundstudium	320
Andrzej8	rwth.jobs	88
Andy	Google+	173
Andy95	Facebook	345
Anna	Facebook	452
Anna8	StudiVZ	378
Anna93	rwth.informatik.grundstudium	228
Annie	rwth.informatik.hauptstudium	20
Anthony607	Linux Forum	97
Anton	Tagesschau Blog	1
Anton316	Linux Forum	3
Aoife7	Tagesschau Blog	238
Ashley004	Facebook	41
Ashley79	entwicklerforum.datenbanken.mysql	74
Babette9	entwicklerforum.datenbanken.mysql	55
Ben	Tagesschau Blog	39
Bengie	entwicklerforum.datenbanken.postgresql	188
Bengie5	entwicklerforum.datenbanken.postgresql	461
Benjy51	Linux Forum	400
Bert1	rwth.informatik.hauptstudium	273
Bertje6	entwicklerforum.datenbanken.postgresql	384
Bess013	rwth.informatik.hauptstudium	10
Bess4	rwth.informatik.hauptstudium	454
Betty09	entwicklerforum.datenbanken.postgresql	306
Betty1	rwth.informatik.grundstudium	424
Bo17	Tagesschau Blog	472
Bram61	StudiVZ	339
Bram615	Google+	284
Bram7	Linux Forum	455
Caitlin8	Facebook	159
Callum	Google+	91
Callum5	rwth.informatik.hauptstudium	16
Callum60	Facebook	408
Cameron	entwicklerforum.datenbanken.mysql	409
Camila565	entwicklerforum.datenbanken.postgresql	68
Camilla579	Tagesschau Blog	222
Camille	rwth.informatik.grundstudium	359
Carla	Developer-Blog	176
Carla21	rwth.informatik.hauptstudium	113
Carolina37	Tagesschau Blog	244
Caroline4	Developer-Blog	54
Cath15	Facebook	277
Cath5	Facebook	257
Cath528	entwicklerforum.datenbanken.mysql	215
Catharine	rwth.jobs	141
Catharine538	Tagesschau Blog	416
Catharine8	rwth.informatik.hauptstudium	69
Catherine	Google+	448
Cathy	rwth.informatik.grundstudium	151
Cecilie1	rwth.informatik.hauptstudium	293
Cees82	Developer-Blog	280
Christa	Developer-Blog	253
Christa26	rwth.jobs	298
Christian1	Linux Forum	437
Cian0	entwicklerforum.datenbanken.mysql	495
Cian40	Google+	26
Cian664	Facebook	429
Ciara1	Google+	204
Ciara55	rwth.informatik.hauptstudium	268
Ciara83	Tagesschau Blog	387
Ciska5	StudiVZ	432
Ciska8	Facebook	130
Cloe862	Facebook	447
Co	rwth.jobs	108
Cristian827	entwicklerforum.datenbanken.mysql	19
Cristina21	Developer-Blog	191
Cristina7	entwicklerforum.datenbanken.mysql	304
Daan1	rwth.jobs	235
Daniel	rwth.informatik.hauptstudium	314
Daniel4	rwth.informatik.grundstudium	332
Daniela006	Tagesschau Blog	78
Daniela07	Linux Forum	316
David178	entwicklerforum.datenbanken.postgresql	185
Delphine	Linux Forum	275
Dick	Facebook	32
Diego	Google+	60
Dorothy18	entwicklerforum.datenbanken.mysql	468
Dorothy571	Linux Forum	352
Drew	Facebook	465
Drew568	rwth.informatik.grundstudium	203
Dylan11	Linux Forum	220
Dylan2	Developer-Blog	111
Dylan811	StudiVZ	479
Ed3	StudiVZ	291
Edwina08	rwth.jobs	95
Edwyn	entwicklerforum.datenbanken.postgresql	487
Eleanor603	entwicklerforum.datenbanken.postgresql	120
Elena31	entwicklerforum.datenbanken.mysql	132
Elin926	entwicklerforum.datenbanken.postgresql	205
Emil2	Linux Forum	225
Emil317	entwicklerforum.datenbanken.postgresql	123
Emil408	entwicklerforum.datenbanken.mysql	93
Emil7	Linux Forum	90
Emily	Tagesschau Blog	381
Emma621	Developer-Blog	445
Erin	Tagesschau Blog	364
Erin394	entwicklerforum.datenbanken.mysql	287
Ester43	Facebook	223
Esther	entwicklerforum.datenbanken.postgresql	330
Fabian	entwicklerforum.datenbanken.mysql	333
Filip28	rwth.informatik.grundstudium	241
Florian	rwth.jobs	324
Fons2	Tagesschau Blog	366
Fons75	entwicklerforum.datenbanken.postgresql	22
Francisco	Tagesschau Blog	490
Freja373	Linux Forum	489
Freja44	Developer-Blog	498
Freja95	StudiVZ	171
Gabbie3	entwicklerforum.datenbanken.mysql	269
Gabbie9	rwth.jobs	417
Georgina5	rwth.informatik.hauptstudium	431
Gert	rwth.informatik.hauptstudium	390
Giel4	Developer-Blog	453
Giel41	Developer-Blog	377
Gillian06	Tagesschau Blog	63
GoPlaat	rwth.informatik.hauptstudium	58
GoPlaat0	entwicklerforum.datenbanken.mysql	86
GoPlaat65	Google+	403
GoSix3	Linux Forum	265
Hank	entwicklerforum.datenbanken.mysql	209
Hanna1	rwth.jobs	343
Hanna989	rwth.informatik.hauptstudium	331
Hannah7	rwth.jobs	315
Harold	rwth.informatik.hauptstudium	52
Harry329	Developer-Blog	183
Helen	Google+	261
Henry	rwth.informatik.grundstudium	341
Herb70	Facebook	14
Herb8	Tagesschau Blog	81
Herb9	rwth.jobs	289
Herman	rwth.informatik.grundstudium	464
Hero96	StudiVZ	418
Hugo477	Tagesschau Blog	79
Iris2	Tagesschau Blog	478
Isabel981	Google+	433
Ivan6	Google+	255
Ivan914	entwicklerforum.datenbanken.postgresql	368
Ivan92	entwicklerforum.datenbanken.mysql	138
Jaap04	Developer-Blog	299
Jaap489	StudiVZ	399
Jaap7	StudiVZ	163
Jace01	Tagesschau Blog	94
Jace30	StudiVZ	493
Jack	rwth.jobs	383
Jacob	Google+	248
James	Tagesschau Blog	386
James6	Tagesschau Blog	481
Jamie	rwth.informatik.hauptstudium	104
Jan2	Developer-Blog	117
JanCees182	rwth.informatik.grundstudium	485
Jane	Developer-Blog	328
Javier54	Developer-Blog	92
Jean	rwth.informatik.hauptstudium	325
Jeanette742	Facebook	40
Jeanne	entwicklerforum.datenbanken.postgresql	17
Jeanne142	StudiVZ	270
Jeanne2	Google+	360
Jeffery	rwth.jobs	206
Jill079	rwth.jobs	292
Jill364	entwicklerforum.datenbanken.postgresql	170
Jim	Google+	169
Jo136	StudiVZ	310
Jo28	rwth.informatik.hauptstudium	234
Joanne	Facebook	106
Joanne249	entwicklerforum.datenbanken.postgresql	198
Joe7	rwth.jobs	340
Joey	rwth.informatik.hauptstudium	282
Joey2	entwicklerforum.datenbanken.mysql	423
John147	rwth.informatik.hauptstudium	482
John8	Developer-Blog	214
Jolanda33	StudiVZ	457
Jolanda71	rwth.informatik.hauptstudium	218
Joop	rwth.jobs	134
Joop455	entwicklerforum.datenbanken.mysql	201
Joost918	rwth.informatik.hauptstudium	425
Jordy	entwicklerforum.datenbanken.mysql	103
Jordy2	Google+	219
Jordy35	rwth.informatik.grundstudium	249
Jordy8	Tagesschau Blog	492
Jorge	Developer-Blog	458
Jorge01	StudiVZ	57
Jorge562	Google+	194
Jose509	rwth.informatik.hauptstudium	392
Joseph63	rwth.informatik.grundstudium	102
Joseph68	rwth.jobs	165
Joshua465	Google+	466
Juan	Linux Forum	202
Juan7	Tagesschau Blog	411
Juan8	entwicklerforum.datenbanken.postgresql	321
Juana0	Tagesschau Blog	356
Juana5	Facebook	370
Julian	Developer-Blog	474
Julie982	Tagesschau Blog	326
Jurre68	entwicklerforum.datenbanken.mysql	155
Jurre9	Tagesschau Blog	99
Karin1	Facebook	302
Katarzyna282	Facebook	436
Katharina2	rwth.jobs	395
Katharina31	rwth.jobs	236
Katie	Tagesschau Blog	67
Kaylee	rwth.jobs	18
Kaylee12	Google+	379
Kaylee694	Developer-Blog	122
Kayleigh8	entwicklerforum.datenbanken.mysql	414
Kim1	entwicklerforum.datenbanken.mysql	31
Kimberly12	Tagesschau Blog	334
Kimberly48	Developer-Blog	251
Klaas1	Tagesschau Blog	45
Klaas2	Facebook	415
Klaas928	rwth.jobs	224
Koos	rwth.informatik.hauptstudium	375
Koos048	entwicklerforum.datenbanken.postgresql	483
Krystyna928	StudiVZ	119
Laura84	rwth.informatik.hauptstudium	213
Lauren	Facebook	75
Lea	entwicklerforum.datenbanken.postgresql	385
Lea94	Tagesschau Blog	157
Leah	Linux Forum	144
Lena403	entwicklerforum.datenbanken.mysql	168
Leontien136	Google+	128
Lewis09	entwicklerforum.datenbanken.postgresql	64
Lewis1	entwicklerforum.datenbanken.postgresql	87
Liam3	entwicklerforum.datenbanken.mysql	271
Lincoln	entwicklerforum.datenbanken.postgresql	266
Lincoln52	entwicklerforum.datenbanken.mysql	153
Linnea415	rwth.informatik.grundstudium	276
Linnea786	rwth.informatik.grundstudium	401
Liza	Facebook	346
Liza311	Google+	421
Liza48	rwth.informatik.grundstudium	459
Liza87	Tagesschau Blog	96
Liza97	rwth.informatik.hauptstudium	358
Lizzy5	Linux Forum	350
Lu168	rwth.informatik.grundstudium	397
Lu59	rwth.informatik.hauptstudium	376
Luca	entwicklerforum.datenbanken.mysql	319
Lucia26	Tagesschau Blog	303
Lucille264	Tagesschau Blog	28
Lucille838	Google+	76
Luis49	Developer-Blog	178
Luis7	Google+	70
Luis9	Facebook	242
Luka210	Tagesschau Blog	477
Luka58	Developer-Blog	388
Luka7	Facebook	250
Lukas530	Google+	469
Lukas88	StudiVZ	362
Madison	rwth.jobs	216
Mads	StudiVZ	389
Maggie02	StudiVZ	11
Magnus34	StudiVZ	398
Malgorzata	rwth.informatik.grundstudium	142
Manuel3	rwth.informatik.hauptstudium	51
Manuel8	Linux Forum	245
Manuel82	Google+	161
Marcin	StudiVZ	407
Marcin652	rwth.jobs	300
Marco3	Google+	410
Margo	StudiVZ	500
Marie	Linux Forum	231
Marieke6	rwth.jobs	256
Mariska93	rwth.informatik.grundstudium	254
Mart857	Developer-Blog	59
Mart95	Linux Forum	27
Marta06	entwicklerforum.datenbanken.postgresql	164
Marta160	Facebook	89
Marta40	rwth.informatik.hauptstudium	195
Martien149	Facebook	167
Martin15	Google+	150
Martin270	Linux Forum	373
Martina0	rwth.informatik.grundstudium	48
Martina37	rwth.jobs	230
Martina49	Tagesschau Blog	154
Marty167	Developer-Blog	160
Marty46	Linux Forum	349
Mary70	rwth.informatik.hauptstudium	126
Mathilde23	rwth.informatik.hauptstudium	47
Mathilde6	Developer-Blog	192
Mathilde94	Google+	312
Matt1	entwicklerforum.datenbanken.mysql	439
Matt316	entwicklerforum.datenbanken.mysql	295
Matthew	Google+	374
Matthew164	Facebook	80
Matthew319	Google+	184
Matthijs2	Developer-Blog	382
Matthijs5	Tagesschau Blog	286
Matthijs681	StudiVZ	283
Max	rwth.informatik.grundstudium	272
Maximilian	Facebook	121
Megan002	Google+	61
Megan885	rwth.jobs	66
Michel	rwth.informatik.grundstudium	391
Michel1	Developer-Blog	143
Michel2	StudiVZ	434
Mike	rwth.informatik.grundstudium	129
Mike073	entwicklerforum.datenbanken.postgresql	438
Milan89	rwth.jobs	450
Milan97	Google+	125
Miriam6	Linux Forum	440
Nate70	rwth.jobs	193
Nathan	rwth.jobs	357
Netty	Tagesschau Blog	23
Netty186	Facebook	247
Nicholas7	Google+	297
Nicky439	entwicklerforum.datenbanken.postgresql	15
Nico	entwicklerforum.datenbanken.mysql	29
Niek45	StudiVZ	307
Nienke	Tagesschau Blog	323
Nienke69	rwth.informatik.grundstudium	449
Nigel	rwth.jobs	186
Niklas498	Facebook	335
Niklas6	rwth.informatik.grundstudium	180
Oliver13	Tagesschau Blog	12
Oliver377	rwth.informatik.grundstudium	441
Oliver9	entwicklerforum.datenbanken.mysql	182
Oscar6	rwth.jobs	136
Pablo89	entwicklerforum.datenbanken.postgresql	148
Patty	rwth.informatik.hauptstudium	367
Patty0	entwicklerforum.datenbanken.mysql	62
Patty630	StudiVZ	227
Patty91	Linux Forum	109
Paul	Tagesschau Blog	30
Paul2	entwicklerforum.datenbanken.postgresql	189
Paula425	entwicklerforum.datenbanken.mysql	233
Paula9	entwicklerforum.datenbanken.postgresql	72
Pauline8	Developer-Blog	115
Pawel338	entwicklerforum.datenbanken.postgresql	35
Pawel7	Google+	363
Pawel70	rwth.informatik.grundstudium	311
Pedro331	StudiVZ	71
Peg51	Linux Forum	460
Peggy	Google+	444
Pete3	Google+	82
Phil595	Developer-Blog	369
Phil788	Linux Forum	372
Philip172	Google+	344
Piet	Google+	212
Pieter	rwth.jobs	56
Pieter0	rwth.informatik.grundstudium	308
Pieter838	rwth.jobs	281
PieterJan367	entwicklerforum.datenbanken.mysql	301
PieterJan909	Developer-Blog	475
Pip	rwth.jobs	347
Pip656	entwicklerforum.datenbanken.postgresql	435
Rachael	rwth.jobs	480
Rachel038	Linux Forum	199
Rando424	entwicklerforum.datenbanken.postgresql	430
Raul01	Developer-Blog	467
Raul711	Facebook	380
Rich49	Tagesschau Blog	36
Rich8	StudiVZ	451
Richard53	rwth.informatik.grundstudium	240
Richard80	rwth.jobs	259
Rick	StudiVZ	354
Rick166	Google+	133
Robert3	Developer-Blog	114
Roger	Linux Forum	288
Roger86	Facebook	309
Rogier	StudiVZ	412
Rogier06	entwicklerforum.datenbanken.postgresql	177
Rolla15	Developer-Blog	24
Rolla2	entwicklerforum.datenbanken.postgresql	135
Rolla68	StudiVZ	258
Rolla9	rwth.informatik.hauptstudium	166
Ron3	rwth.jobs	38
Ron7	rwth.informatik.grundstudium	42
Rosa	rwth.jobs	43
Ross3	Google+	221
Ross6	Developer-Blog	105
Ross935	rwth.informatik.hauptstudium	139
Ruth	Tagesschau Blog	318
Ryan2	entwicklerforum.datenbanken.mysql	2
Sally	Linux Forum	101
Sally11	entwicklerforum.datenbanken.mysql	317
Samantha1	rwth.informatik.hauptstudium	200
Sammy02	entwicklerforum.datenbanken.postgresql	405
Sandra9	Google+	313
Sanne0	Facebook	156
\.


--
-- Data for Name: link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY link (element_id, url) FROM stdin;
8	www.zoekenwereld.be
16	www.homepagina.org
17	www.partsoftware.it
22	www.trefbaan.es
30	www.zoekvak.es
37	www.zoinfo.es
42	www.homeplaza.org
44	www.zoekenvacatures.nl
51	www.snelmarkt.com
58	www.marktplaats.gr
61	www.digitaalvacature.it
66	www.zoekvak.com
67	www.whitetools.gr
75	www.keuzevacatures.it
83	www.tassenwinkels.org
93	www.homesite.ch
103	www.bestsite.ch
112	www.kledingplein.nl
120	www.anyhelp.it
127	www.perfectpeople.org
133	www.trefpagina.com
134	www.greentargets.nl
142	www.blueinfora.nl
152	www.seekmasters.fr
157	www.keuzevak.gr
162	www.kooppeople.es
166	www.inktool.ch
174	www.informatiebanen.nl
182	www.informatiewereld.gr
188	www.greeninfora.nl
189	www.goodhouse.it
194	www.webtrust.fr
199	www.voedingweb.it
202	www.linkinform.gr
204	www.inksite.gr
206	www.spacemagics.gr
207	www.goodhelp.it
216	www.etenwerk.de
220	www.webwerk.org
227	www.searchmission.co.uk
237	www.elkesite.co.uk
244	www.bettermission.nl
253	www.seektool.it
255	www.keuzebanen.be
262	www.zoekplein.fr
269	www.startschool.nl
273	www.downloadsoft.org
281	www.digitaalbode.gr
287	www.downloadsion.com
290	www.starttaal.nl
293	www.coolsion.nl
300	www.bestmars.es
303	www.ziemars.co.uk
305	www.zoekplaza.de
314	www.magicinfo.ch
321	www.tassenvak.co.uk
330	www.trainraak.nl
336	www.greenmace.it
343	www.webplaza.it
352	www.choicetool.ch
354	www.compainform.be
363	www.goodtrace.es
372	www.leraarplaza.it
375	www.infomission.gr
385	www.seekmaster.de
386	www.autosoft.ch
395	www.goodinfora.it
403	www.choicecompany.com
406	www.retailinfora.fr
412	www.marktwinkel.es
416	www.bluecompany.com
422	www.elkevak.nl
429	www.gezondheidmarkt.es
438	www.drinkmoon.de
441	www.nedbanen.gr
443	www.keuzeplaats.com
450	www.mytrust.ch
454	www.magictool.de
461	www.restaurantbaan.fr
469	www.marktplein.fr
470	www.anytheek.ch
472	www.choicetick.fr
474	www.choicetheek.de
476	www.tassensite.com
486	www.contactmarkt.it
492	www.mastertargets.de
494	www.keuzepagina.nl
500	www.nedplaats.fr
501	www.meerwinkel.nl
510	www.whitetargets.ch
511	www.keuzewereld.nl
516	www.mytheek.com
523	www.retailmars.fr
529	www.alleinfo.de
531	www.infotick.be
540	www.leraarinfo.it
547	www.zoekenbanen.es
554	www.tasweb.nl
557	www.seekinfora.de
567	www.linktarget.de
573	www.watermarkt.co.uk
580	www.autoinfo.de
582	www.startvak.fr
586	www.voedingsite.de
591	www.anyhelp.ch
598	www.myactive.ch
602	www.infooffice.nl
610	www.maximaalwinkel.de
618	www.choiceoffice.de
625	www.perfectmaster.co.uk
630	www.schoensite.be
639	www.rockmasters.ch
648	www.maximaaltaal.it
651	www.webwinkel.be
655	www.startplaza.it
661	www.gezondheidtaal.it
664	www.schoeninfo.gr
666	www.perfectmasters.fr
668	www.greenmission.com
671	www.etenplein.com
681	www.alltool.ch
686	www.elkevak.co.uk
689	www.ziefill.co.uk
695	www.trefweb.gr
698	www.koopthings.org
702	www.choicehouse.ch
703	www.betteroffice.com
706	www.newinfora.ch
707	www.startschool.de
710	www.blackpeople.fr
716	www.anytrust.co.uk
721	www.blacktarget.it
731	www.beektaal.ch
740	www.schoenenbanen.nl
745	www.homewinkels.es
753	www.anytool.be
762	www.snelwereld.es
767	www.snelplein.be
769	www.alleplein.org
771	www.downloadmoon.es
777	www.cooltheek.ch
784	www.perfecttrace.fr
792	www.mytool.org
797	www.voedingweb.fr
807	www.schoensite.co.uk
811	www.beekwinkels.de
821	www.leraarbode.be
828	www.perfecthouse.com
834	www.inktrace.de
836	www.zietheek.com
837	www.etenplaza.co.uk
842	www.snelwerk.com
849	www.nedwinkel.es
851	www.newsmagics.org
856	www.koopactive.es
865	www.rockmasters.it
872	www.restaurantwereld.com
876	www.beekvak.de
886	www.keuzetaal.co.uk
893	www.gezondheidsite.nl
896	www.informatieinfo.be
898	www.zietrust.fr
900	www.marktplaats.nl
905	www.seektargets.it
912	www.searchinfo.it
920	www.drinktheek.es
927	www.anymagics.fr
935	www.perfectactive.it
945	www.marktwereld.fr
946	www.waterwereld.es
954	www.mastercompany.nl
955	www.whitemission.be
961	www.trainsoft.es
971	www.zoekenwinkel.gr
972	www.whitehouse.gr
975	www.goodmars.be
985	www.restaurantbanen.gr
993	www.allemarkt.org
1003	www.tasbanen.nl
1006	www.inktool.es
1013	www.contactbanen.nl
1017	www.allraak.de
1019	www.keuzewerk.nl
1025	www.startvak.de
1030	www.zieinfo.ch
1039	www.elkebanen.nl
1044	www.waterwinkels.co.uk
1050	www.alltrace.com
1058	www.marktvak.org
1060	www.startweb.gr
1067	www.kooptools.gr
1075	www.digitaaltaal.ch
1085	www.inkmasters.org
1093	www.marktweb.fr
1099	www.digibaan.fr
1100	www.trainhouse.ch
1105	www.blacksoftware.fr
1108	www.gotools.org
1109	www.gomasters.org
1118	www.tasvacatures.com
1127	www.voedingplaats.org
1133	www.mytick.org
1135	www.leraarsite.ch
1143	www.blackactive.nl
1148	www.alleweb.be
1149	www.leraarbode.es
1151	www.choicesoft.de
1157	www.bettertrace.nl
1166	www.webwerk.it
1173	www.tasinfo.ch
1180	www.bluemace.nl
1187	www.keuzewinkels.gr
1188	www.meerwereld.be
1195	www.inksion.be
1203	www.gotargets.it
1206	www.digitaalvak.nl
1207	www.waterbode.co.uk
1213	www.webplein.be
1217	www.beekwereld.org
1221	www.newmaster.nl
1224	www.gezondheidmarkt.ch
1232	www.startsite.it
1233	www.meerinfo.es
1234	www.digitaalinfo.fr
1244	www.gotrust.com
1250	www.informatieplaats.com
1257	www.zoekenvacatures.be
1258	www.mymagics.com
1267	www.trainactive.it
1269	www.whitesoftware.org
1272	www.allebanen.es
1281	www.autoactive.fr
1283	www.allfill.es
1293	www.drinktrace.nl
1303	www.startweb.es
1313	www.infomagics.nl
1317	www.goodsite.gr
1324	www.autocompany.nl
1334	www.mytick.de
1341	www.goodpeople.ch
1344	www.leraarplein.be
1347	www.elkevacatures.co.uk
1357	www.restaurantwereld.org
1365	www.bluesite.com
1369	www.tasplein.com
1373	www.drinkhouse.com
1381	www.masterhouse.it
1389	www.drinkmaster.es
1397	www.downloadmaster.be
1407	www.whiteinfora.be
1413	www.seeksion.be
1421	www.digivacature.org
1423	www.bettermagics.de
1429	www.meerplaza.nl
1434	www.meerschool.es
1444	www.blacksite.org
1451	www.autoinfora.com
1456	www.anysion.org
1458	www.spacemasters.org
1467	www.seekinfora.com
1470	www.traintick.de
1471	www.mythings.ch
1480	www.searchsoftware.com
1481	www.traintrust.gr
1484	www.perfecttrust.com
1488	www.nedsite.com
1491	www.masterpeople.de
1501	www.alloffice.co.uk
1508	www.etenmarkt.org
1513	www.digibaan.de
1516	www.linkfill.co.uk
1521	www.compasoft.com
1531	www.waterwereld.de
1538	www.spacesoft.de
1544	www.koopinfo.es
1549	www.tassenplaza.it
1557	www.leraarwereld.co.uk
1563	www.zofill.nl
1564	www.downloadoffice.it
1571	www.coolsion.com
1581	www.retailsoftware.org
1585	www.restaurantvak.fr
1590	www.magicmasters.com
1600	www.allewerk.es
1610	www.taswinkels.be
1614	www.digitaalbanen.es
1617	www.elkebode.nl
1626	www.parthelp.co.uk
1632	www.kledingweb.com
1638	www.searchsion.fr
1644	www.seekhouse.gr
1647	www.partmace.com
1656	www.retailinfora.es
1660	www.bettersoft.org
1669	www.allevacatures.fr
1670	www.choicemagics.de
1673	www.spacemission.it
1676	www.homemarkt.org
1678	www.trefwerk.be
1688	www.magictheek.de
1693	www.voedingbaan.de
1703	www.maximaalbanen.com
1713	www.seekthings.it
1717	www.webplein.nl
1726	www.coolpeople.org
1729	www.watersite.it
1731	www.perfectsoft.fr
1740	www.stocktargets.nl
1748	www.bluemaster.com
1758	www.trefmarkt.de
1762	www.tassenvacature.com
1768	www.whiteinform.co.uk
1770	www.marktbanen.nl
1776	www.etenplaza.it
1786	www.digitaalwerk.co.uk
1793	www.rocktrust.gr
1796	www.alleplaats.es
1800	www.newmasters.co.uk
1808	www.waterplaats.de
1816	www.voedingvak.co.uk
1817	www.restaurantvacature.gr
1822	www.webwinkels.nl
1823	www.homeplaza.ch
1825	www.downloadactive.co.uk
1831	www.snelpagina.es
1841	www.blacktick.de
1846	www.homevak.de
1854	www.allebaan.nl
1862	www.digitaalsite.de
1871	www.seekmagics.be
1873	www.traintheek.fr
1877	www.rocktools.es
1882	www.traintheek.it
1885	www.seektrace.co.uk
1893	www.newtools.org
1895	www.marktplaats.be
1902	www.elketaal.nl
1907	www.kledingwinkel.com
1916	www.homesite.be
1924	www.elkepagina.nl
1934	www.beekbanen.de
1936	www.zoekenwinkels.com
1945	www.perfectmoon.co.uk
1951	www.zoekwinkels.nl
1958	www.seekfill.com
1964	www.mastermace.fr
1971	www.waterplaats.be
1977	www.greensoft.gr
1987	www.kledingwereld.com
1990	www.seekmission.de
1997	www.coffeetargets.com
1	www.marktbanen.it
11	www.waterwinkels.ch
20	www.myhelp.es
21	www.contactbaan.nl
32	www.trainmoon.com
36	www.newsoftware.it
46	www.anymoon.nl
47	www.maximaalplaza.ch
49	www.zietools.ch
52	www.blackhouse.nl
56	www.zoekwerk.gr
65	www.meervak.org
72	www.trefvacatures.org
76	www.snelwinkel.es
92	www.allthings.be
101	www.gomasters.gr
110	www.waterinfo.fr
113	www.gomoon.ch
114	www.coffeemars.de
115	www.contactwereld.org
119	www.taswereld.gr
125	www.maximaalbaan.de
128	www.zoekenpagina.it
156	www.magictool.be
161	www.trefbaan.com
170	www.markttaal.co.uk
172	www.trefbanen.it
181	www.compapeople.fr
186	www.allebode.de
190	www.meerplaats.nl
195	www.trainmaster.com
200	www.webpagina.org
211	www.tassenvacature.gr
219	www.coolinfora.com
223	www.autoraak.es
232	www.blueinfo.be
241	www.autosite.be
248	www.schoenwereld.ch
254	www.kledingbaan.fr
263	www.zocompany.com
277	www.contacttaal.es
280	www.maximaalwinkels.org
294	www.ziemagics.ch
296	www.zoekenvak.ch
313	www.startvak.it
315	www.webhouse.org
331	www.zietool.co.uk
340	www.startvacature.it
351	www.tasweb.ch
355	www.allewerk.it
362	www.allevak.gr
373	www.downloadtrust.nl
379	www.bettertrace.com
388	www.kledingwereld.nl
393	www.gosite.es
398	www.choiceinform.ch
399	www.stockraak.co.uk
409	www.tassenwinkels.nl
419	www.leraarpagina.be
424	www.gohouse.be
434	www.autotick.gr
448	www.bestmars.org
458	www.partcompany.de
467	www.zoekensite.es
475	www.whitehelp.be
478	www.trefwereld.es
481	www.alltools.fr
491	www.retailtrace.de
497	www.maximaalbanen.fr
505	www.zietheek.nl
509	www.coffeetheek.ch
512	www.zoekbaan.be
513	www.partmace.org
520	www.leraartaal.co.uk
530	www.coffeeoffice.be
545	www.schoenplaats.co.uk
556	www.tasvak.be
565	www.startplein.be
574	www.goodtrust.co.uk
581	www.digitaal.co.uk
600	www.webbanen.org
608	www.mastertrust.com
614	www.restaurantvacature.fr
619	www.anymoon.it
620	www.alleschool.it
631	www.mypeople.gr
637	www.maximaalvak.it
647	www.magiccompany.com
663	www.webinfo.de
675	www.rockmaster.com
684	www.beekvak.com
692	www.gezondheidwereld.nl
701	www.webplaats.gr
711	www.betterhelp.es
723	www.compatheek.nl
727	www.restaurantschool.de
736	www.cooloffice.it
741	www.magicinfo.be
747	www.gotheek.fr
754	www.keuzewerk.de
761	www.trainhelp.nl
765	www.restaurantmarkt.ch
772	www.perfectsite.com
776	www.digiplein.nl
779	www.mastermace.es
785	www.allepagina.nl
787	www.gotools.gr
793	www.elkeschool.nl
794	www.elkeschool.fr
803	www.tassenplaats.de
805	www.gezondheidmarkt.de
806	www.perfectmoon.nl
814	www.keuzewerk.co.uk
817	www.meerplaza.gr
824	www.digitaal.gr
830	www.stocksoft.org
844	www.downloadmagics.be
860	www.koopsion.fr
870	www.bluemace.es
871	www.kledingvacature.be
880	www.voedingplein.fr
883	www.autosoftware.com
891	www.downloadtools.ch
899	www.downloadthings.com
908	www.elkeinfo.fr
910	www.searchtrace.it
919	www.partraak.co.uk
924	www.restaurantplein.gr
928	www.myinform.it
929	www.mysoft.co.uk
939	www.rockfill.de
942	www.alltheek.ch
949	www.koopinform.co.uk
953	www.infosoftware.co.uk
962	www.gotargets.gr
970	www.maximaalpagina.de
978	www.goodthings.be
982	www.beekvak.gr
988	www.searchtheek.com
990	www.masterpeople.co.uk
999	www.maximaalplaza.fr
1002	www.zoekplaza.co.uk
1004	www.schoeneninfo.es
1011	www.contactinfo.fr
1020	www.infopeople.it
1026	www.trefweb.it
1028	www.marktplaza.ch
1031	www.traintool.fr
1035	www.nedplein.nl
\.


--
-- Data for Name: medium; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY medium (name, url, typ, betreiber_umsatzidnr) FROM stdin;
Developer-Blog	http://www.heise.de/developer/blog	Blog	DE813501887
Facebook	http://www.facebook.de	Netzwerk	3835815
Google+	http://plus.google.com	Netzwerk	123456
Linux Forum	http://linux-forum.de	Forum	DE281679833
StudiVZ	http://www.studivz.net	Netzwerk	HRB101454
Tagesschau Blog	http://blog.tagesschau.de	Blog	DE118509776
entwicklerforum.datenbanken.mysql	http://entwickler-forum.de/forumdisplay.php?f=43	Forum	DE281679833
entwicklerforum.datenbanken.postgresql	http://entwickler-forum.de/forumdisplay.php?f=46	Forum	DE281679833
rwth.informatik.grundstudium	http://groups.google.de/group/rwth.informatik.grundstudium	Newsgroup	123456
rwth.informatik.hauptstudium	http://groups.google.de/group/rwth.informatik.hauptstudium	Newsgroup	123456
rwth.jobs	http://groups.google.de/group/rwth.jobs	Newsgroup	123456
\.


--
-- Data for Name: netzwerk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY netzwerk (medium_name, ausrichtung) FROM stdin;
\.


--
-- Data for Name: newsgroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY newsgroup (medium_name, thema) FROM stdin;
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY person (name, geburtsdatum) FROM stdin;
Wood	1938-06-15
Bryant	1951-10-12
Rauch	1941-05-17
Howe	1968-06-11
Cappello	1945-11-03
Yinger	1974-11-08
Caffray	1954-10-27
Ionescu	1950-01-12
Anderson	1969-08-24
Anderson	1983-10-15
Daley	1935-01-11
Pekaban	1962-05-27
Sakurai	1938-10-09
Polti	1973-04-28
Weaver	1995-02-17
van Goes	1971-05-27
Malone	1977-11-11
Phelps	1952-04-05
Nelson	1978-10-08
Braconi	1938-11-12
Bernstein	1977-11-29
Turk	1957-11-28
Cantere	1987-01-24
Hamilton	1953-07-01
Howe	1949-07-21
van der Laar	1967-06-08
Comeau	1977-11-14
Barnett	1953-04-05
Waddell	1937-03-31
Mcnally	1950-06-23
Langham	1964-06-04
Cohen	1955-06-28
Van Dinter	1983-02-24
Conley	1940-11-05
Brendjens	1958-03-07
Brady	1939-08-20
Archer	1957-05-02
Conley	1944-01-28
Ayers	1961-04-24
Mariojnisk	1993-05-27
Makelaar	1987-06-04
Phillips	1986-03-13
Visentini	1947-09-27
Stevens	1989-04-29
Walker	1960-06-20
Phillips	1937-04-22
Mayberry	1954-11-10
Foreman	1952-05-03
Moore	1990-10-08
Troher	1965-01-12
Phillips	1980-08-13
Freed	1957-10-04
Herring	1959-12-04
Ditmanen	1968-09-04
Cooper	1991-03-21
Hoyt	1987-04-25
Donatelli	1961-09-29
Hedgecock	1948-09-12
Schubert	1978-07-22
Esperiza	1987-06-16
Orcutt	1941-07-31
Swaine	1967-09-16
Wooten	1945-01-11
Zia	1946-10-19
Katsekes	1935-01-22
Suszantor	1947-04-12
Linton	1938-01-16
Wooten	1992-08-25
Foreman	1989-12-07
Emerson	1972-07-18
Roche	1950-11-08
Perilloux	1956-10-29
Cantere	1954-04-24
Zimmerman	1943-12-13
Freeman	1995-03-24
Menovosa	1937-12-24
Freed	1986-06-20
Brown	1981-01-28
Zurich	1979-05-20
Ayers	1966-09-06
van het Hof	1953-08-22
Ray	1990-06-07
Meterson	1941-01-06
Toler	1995-01-13
Crocetti	1980-01-05
Anderson	1985-04-11
Robbins	1963-06-02
Noteboom	1966-07-02
Phelps	1944-10-15
Voigt	1935-12-03
Voigt	1957-12-19
Sanders	1965-11-01
Dulisse	1946-03-09
Visentini	1944-06-28
Botsik	1984-12-18
Pierce	1960-07-26
DeBuck	1959-11-06
Franklin	1950-02-19
Troher	1952-02-19
Markovi	1989-02-23
DeBerg	1974-06-30
White	1941-12-21
Wargula	1973-08-13
Morton	1940-07-30
Wooten	1993-12-21
Antonucci	1946-10-25
Langham	1984-06-28
Love	1964-01-01
Turk	1966-09-19
Royal	1974-11-19
Nelson	1954-09-11
Hopper	1981-01-31
Turk	1948-02-20
Brendjens	1984-08-07
Blacher	1969-04-26
Moore	1950-07-15
Bloom	1946-02-17
Polti	1988-09-03
Richter	1992-01-06
Brown	1968-06-06
Hedgecock	1938-05-11
Korkovski	1995-12-20
Cain	1983-06-19
Gunter	1960-01-17
Brumley	1939-03-12
Toler	1972-07-07
Dittrich	1947-05-01
Lejarette	1940-07-18
Dittrich	1994-02-07
Foreman	1943-10-02
Krutkov	1964-09-19
Robertson	1989-04-29
Visentini	1979-05-01
Ahlgren	1993-09-02
Herrin	1972-11-11
Blacher	1938-01-13
Bloom	1939-11-30
Bertelson	1977-09-05
Carlos	1959-12-22
McCormick	1993-12-12
Hedgecock	1988-08-07
Ionescu	1987-07-05
Francis	1965-05-01
Spensley	1977-06-22
van Goes	1949-01-10
Pengilly	1980-01-23
Marra	1945-10-18
Seibel	1983-09-19
Brady	1964-10-05
Brendjens	1975-02-10
Praeger	1936-04-12
Nithman	1963-07-30
Botsik	1936-04-22
Cappello	1966-08-24
Langham	1954-05-29
Mariojnisk	1995-12-02
Roger	1985-01-31
Bertelson	1975-06-26
Wooten	1954-10-30
Anthony	1967-12-02
Wood	1989-09-05
Queen	1937-09-23
Ayers	1955-05-02
Arnold	1946-06-22
Sanders	1965-11-04
Royal	1978-10-23
Simonent	1968-03-24
Emerson	1957-11-06
Symbouras	1946-05-04
Stevenson	1973-08-10
Anthony	1981-05-23
Pekagnan	1969-09-01
Millikin	1971-07-17
Roger	1980-10-30
Linton	1988-11-30
Clark	1953-01-16
Pensec	1946-05-08
Davis	1963-07-04
Kidd	1949-04-01
Poplock	1963-11-13
Gibson	1974-05-28
Carlos	1956-02-08
Bertelson	1976-03-11
Warner	1937-09-06
Glanswol	1947-10-07
Blount	1945-05-13
Olson	1968-09-07
Lejarette	1992-05-21
Gonzalez	1980-05-13
Zapetis	1953-06-15
Poole	1962-03-09
Herzog	1955-11-22
Mcgrew	1974-10-20
Spensley	1956-12-11
Cantere	1979-11-15
Pekaban	1951-04-27
Lannigham	1971-10-15
Gieske	1947-01-30
Hoogbandt	1994-08-08
Dittrich	1962-11-09
Stannard	1938-05-21
Walker	1948-01-08
Stevens	1940-06-19
Geoppo	1970-06-07
Forsberg	1972-05-17
Depew	1993-02-03
Miller	1957-04-08
Liddle	1981-05-09
Glanswol	1945-05-31
Vostreys	1936-11-26
Gieske	1951-08-03
Nahay	1958-10-29
Mayberry	1989-11-29
Grote	1958-06-08
Millikin	1940-06-26
Bruno	1952-11-05
Sterrett	1936-01-16
Brown	1983-09-23
van Dijk	1956-03-18
van der Laar	1944-09-24
Trainor	1958-12-22
Barnett	1982-11-03
Langham\t	1939-05-25
Jiminez	1955-02-09
Glanswol	1992-12-12
Symbouras	1980-06-17
Bloom	1987-05-04
Little	1987-09-14
Uprovski	1989-02-10
Wilson	1963-06-12
Warner	1979-12-27
Phillips	1992-03-31
Crocetti	1978-08-16
White	1990-09-11
Prior	1988-07-19
Daley	1968-08-16
Hancock	1941-01-23
Hancock	1955-08-19
Millikin	1939-08-26
Brown	1967-12-18
Archer	1966-10-18
Toler	1978-07-31
Daley	1939-12-23
Nahay	1990-08-06
Ionescu	1980-04-26
Pekaban	1963-01-27
Slemp	1978-08-05
Vanderoever	1964-04-07
Van Toorenbeek	1940-10-22
Frega	1965-05-08
Ditmanen	1984-04-30
Massingill	1985-09-08
Barnett	1970-02-16
Lawton	1972-01-30
Simonent	1993-11-21
DelRosso	1970-05-29
Cantere	1980-09-19
Wong	1941-07-11
Uitergeest	1941-12-30
Forsberg	1993-08-23
Guethlein	1963-12-15
Deleo	1985-12-18
Perilloux	1989-10-27
Griffioen	1978-04-26
Mulders	1961-08-27
Pekagnan	1962-05-06
Mulders	1986-10-26
Voigt	1951-11-25
Bogdanovich	1964-12-28
Anderson	1937-03-24
Laudanski	1959-07-02
Marra	1955-11-20
Brown	1985-04-07
Koss	1937-10-15
Symbouras	1977-12-15
Bugno	1974-04-19
Mayberry	1991-01-11
Julieze	1966-04-07
Phillips	1949-10-15
Bloom	1942-06-01
Carlos	1955-12-03
Julieze	1972-05-18
Chwatal	1952-05-28
Kepler	1957-10-29
Krutkov	1956-02-21
Helbush	1967-01-16
Griffith	1942-12-16
LeGrand	1960-10-18
Langham	1951-01-16
Caffray	1971-11-30
Lawton	1945-07-21
Bruno	1983-07-07
Riegel	1979-11-21
Glanswol	1987-12-22
Wood	1982-08-24
Poissant	1990-10-18
Nadalin	1980-08-03
Brisco	1983-04-15
Gibson	1994-12-27
Anderson	1984-04-07
Olson	1963-07-27
Ijukop	1960-11-05
Mcgrew	1994-06-12
Moon	1942-04-27
Zapetis	1990-11-11
McCrary	1984-06-27
Pyland	1961-01-24
Meterson	1962-06-25
Richter	1960-07-15
Robbins	1979-07-09
Phelps	1972-12-19
Herrin	1995-03-18
Beckbau	1990-07-05
Nahay	1980-01-18
Pengilly	1958-05-01
Stannard	1963-05-03
Brylle	1935-09-07
Roger	1967-10-17
Barnett	1985-08-27
Wooten	1961-08-30
Prior	1993-03-27
Jones	1974-04-29
Jones	1992-10-27
Reames	1986-12-19
Long	1952-07-01
Schmidt	1958-01-31
Stockton	1993-05-12
Nefos	1992-07-10
Climent	1960-07-25
Wakefield	1944-10-09
Heyn	1965-11-15
Bruno	1961-09-27
Langham\t	1993-08-25
Rauch	1942-07-21
Olson	1976-04-23
Julieze	1939-09-24
Framus	1988-11-21
Browne	1937-05-20
Mejia	1983-05-19
Hardoon	1961-11-19
Vanderoever	1964-10-12
van Goes	1968-07-15
Hulshof	1937-12-11
Tudisco	1940-05-27
Troher	1946-10-16
Paul	1978-11-18
Muench	1993-02-06
Van Dinter	1936-06-01
Kellock	1942-09-13
Goodnight	1989-08-27
Pierce	1969-10-23
Phillips	1962-07-22
Hendrix	1967-07-10
Zurich	1988-11-30
Orcutt	1971-09-16
Brown	1987-10-30
Slater	1995-11-28
Koch	1961-04-03
Dittrich	1949-12-16
Petterson	1961-08-12
Perilloux	1964-02-29
Emerson	1936-08-01
Thompson	1989-09-24
Poplock	1978-11-18
Trainor	1944-02-03
Pickering	1935-11-12
Millikin	1974-05-06
Kuehn	1975-11-10
Blount	1938-11-08
DeWald	1935-11-21
Mariojnisk	1970-12-30
Keller	1994-07-13
Gerschkow	1972-10-19
Watson	1975-05-17
Ladaille	1994-02-25
Scheffold	1977-07-16
Walker	1986-08-13
Daley	1974-08-30
Naff	1940-10-19
Bloom	1948-09-17
Ratliff	1965-04-27
Hardoon	1941-01-23
Arnold	1941-10-10
Slocum	1968-04-24
Shapiro	1993-09-29
Mitchell	1948-12-03
Wong	1968-08-28
White	1985-03-19
Wood	1995-02-28
Knopp	1955-07-19
Moore	1978-12-20
Symbouras	1952-07-07
Langham	1947-01-20
Anderson	1941-08-06
Nefos	1988-10-31
White	1962-04-01
Huston	1963-05-19
Kingslan	1948-06-19
Helfrich	1950-11-30
Herrin	1971-07-17
Kepler	1937-09-05
Pierce	1951-06-07
White	1987-06-08
Swaine	1975-07-09
Geoppo	1968-11-28
Petterson	1935-03-09
Hamilton	1939-10-15
Arcadi	1954-12-01
Deleo	1981-09-01
Foreman	1988-06-12
Katsekes	1945-02-22
Otto	1964-12-20
Jones	1945-11-08
Robinson	1990-01-23
Roger	1963-03-03
Crocetti	1937-12-13
Brendjens	1962-09-08
Matthew	1986-02-18
Ecchevarri	1963-03-16
Roger	1993-06-29
Hulshof	1972-09-28
Toler	1975-05-20
Toreau	1977-11-05
Cramer	1973-11-22
Chwatal	1941-04-10
Kingslan	1957-12-19
Oyler	1961-10-21
Framus	1975-11-08
Van Toorenbeek	1970-12-01
Conley	1942-04-01
Kidd	1944-09-22
Morton	1985-01-22
Raines	1975-05-31
Shapiro	1970-09-16
Poissant	1989-05-02
Schlee	1957-05-30
Baltec	1952-09-07
Lee	1981-08-28
Ray	1954-10-26
White	1980-06-15
Wolpert	1941-01-26
Guyer	1995-06-25
DeBuck	1981-11-05
Nelson	1965-03-15
Crocetti	1964-01-24
Wood	1953-06-15
Shapiro	1988-09-18
Mejia	1967-12-05
Framus	1963-08-22
Gieske	1942-02-25
Cantere	1950-02-27
van het Hof	1981-03-24
Langham\t	1966-06-04
Moore	1948-04-14
Botsik	1981-06-27
Cappello	1988-07-27
Arcadi	1994-02-17
Voigt	1938-01-10
Bergdahl	1983-08-19
Nithman	1976-10-22
Cappello	1962-06-21
Ayers	1955-06-12
Massingill	1948-09-08
Hoogbandt	1967-10-20
Barbee	1935-03-09
Mulders	1995-09-07
Pekaban	1948-08-04
Uitergeest	1946-12-13
Cramer	1938-12-26
Meterson	1958-04-26
Byrnes	1990-02-25
Mcnally	1994-01-28
Reames	1950-04-24
Nobles	1986-04-13
Phillips	1980-10-26
Blount	1944-09-13
Anderson	1992-10-21
Beckbau	1968-09-29
Reames	1988-05-28
Young	1986-09-20
Francis	1979-01-03
Toreau	1979-04-24
Arden	1939-08-09
Orcutt	1993-05-04
Anderson	1968-02-23
Zimmerman	1939-03-20
Bruno	1978-12-23
Ward\t	1974-08-30
Chwatal	1984-12-10
Slocum	1971-07-22
Mitchell	1961-04-25
Praeger	1937-06-28
Robbins	1949-01-28
Hoogbandt	1980-06-23
Frega	1970-12-21
Moore	1947-07-03
Hoyt	1959-10-03
Hendrix	1982-07-09
Framus	1974-07-24
DeBerg	1966-02-22
Massingill	1957-12-07
Foreman	1968-04-21
Comeau	1950-11-19
Nithman	1950-12-25
Cramer	1987-12-22
Watson	1966-08-19
Wargula	1948-04-28
Maribarski	1975-02-08
Jackson	1959-02-16
Watson	1944-05-12
Moore	1947-07-06
Goodman	1938-01-29
Herrin	1945-05-20
Chapman	1969-10-06
Sanders	1956-11-21
van Doorn	1967-11-08
Brown	1985-02-16
Swaine	1967-04-29
Weaver	1974-09-01
Wicks	1986-08-18
Warner	1991-07-23
Wesolowski	1980-05-07
Chwatal	1939-04-18
Press	1967-09-21
Chapman	1957-01-16
Symbouras	1963-12-18
Wood	1973-12-07
Harness	1967-03-03
Raines	1962-10-20
Antonucci	1963-09-21
Symms	1947-07-05
Julieze	1991-03-13
Chwatal	1993-11-03
Chwatal	1946-10-11
Ahlgren	1940-08-17
Boyer	1943-10-25
Goodnight	1986-10-27
Young	1957-08-03
Dean	1966-12-25
Nadalin	1960-01-30
Caffray	1988-08-03
Wood	1987-04-08
Mcnally	1988-09-25
Leonarda	1964-04-10
Knight	1936-10-16
Muench	1984-03-15
Hendrix	1981-07-23
Chapman	1980-03-22
Lawton	1978-10-10
Pensec	1944-11-08
Foreman	1988-03-09
Zimmerman	1972-01-15
Liddle	1984-12-04
Lamere	1962-07-21
Hopper	1977-04-15
Jessen	1948-04-03
Symms	1966-11-11
Hopper	1989-12-11
van Dijk	1935-03-15
Chwatal	1962-12-02
Nadalin	1995-06-11
Deans	1987-01-27
Poissant	1946-03-30
Overton	1952-06-25
Lee	1985-03-16
Kidd	1966-05-03
Byrnes	1956-02-08
Carlos	1958-04-27
Cantere	1955-12-28
Ijukop	1995-06-27
Arnold	1951-06-05
Kingslan	1940-09-21
Reames	1977-09-13
Bloom	1975-05-07
King	1944-08-19
Young	1978-07-05
Davis	1981-06-15
Waldo	1986-06-02
Korkovski	1947-05-02
Pekaban	1937-12-05
Williamson	1986-11-04
Bright	1982-08-04
Bernstein	1993-05-07
Morgan	1954-10-22
Brendjens	1951-04-08
Bryant	1992-09-06
Cappello	1967-01-07
Buchholz	1958-05-15
Bruno	1974-04-18
Anderson	1974-07-01
Millis	1969-11-07
McCormick	1947-03-20
Ionescu	1940-10-28
Thompson	1993-06-16
Bergdahl	1942-08-31
Hedgecock	1978-12-02
Ray	1946-11-18
Howe	1992-09-04
Katsekes	1948-03-21
Duvall	1995-07-06
Cragin	1980-12-17
Haynes	1948-08-29
Nahay	1953-09-26
Pekagnan	1973-05-29
Depew	1960-05-28
Wargula	1985-01-07
Arnold	1968-06-14
Nithman	1970-05-06
Bloom	1939-08-07
Bryant	1955-06-20
Moon	1986-06-20
Bruno	1946-12-22
Depew	1940-03-13
Crocetti	1962-03-27
White	1979-03-26
Pyland	1974-02-16
Uitergeest	1953-02-26
King	1977-04-02
Chapman	1937-08-29
Beckbau	1970-06-13
van Doorn	1990-05-19
Jones	1971-02-15
Gerschkow	1963-11-20
Ladaille	1947-10-19
Browne	1941-09-10
Swaine	1939-01-12
Wakefield	1985-01-12
Brown	1970-05-09
Ward\t	1970-01-29
Hummel	1945-09-07
Mejia	1944-03-25
Krutkov	1949-06-30
Queen	1979-03-26
Bruno	1945-01-28
Williamson	1980-03-05
Perilloux	1946-07-09
Mairy	1985-11-29
Morgan	1985-10-20
van Dijk	1984-05-17
Grote	1944-08-11
Overton	1992-02-26
Schlee	1946-10-11
Moreau	1941-01-20
Lawton	1945-05-19
Gerschkow	1968-03-24
Conley	1964-01-10
Paul	1950-03-11
Brisco	1962-04-20
Patricelli	1946-04-10
Hopper	1960-03-27
Ijukop	1994-09-26
Bertelson	1972-02-21
Bryant	1980-05-06
Yinger	1987-07-12
Pearlman	1940-09-29
Bertelson	1946-08-05
Nobles	1972-10-25
Matthew	1978-06-22
Robertson	1953-08-16
Baltec	1964-01-22
Linton	1978-01-08
Weinstein	1943-10-10
Aldritch	1986-09-05
Kepler	1974-01-04
Uprovski	1944-08-29
Langham	1944-09-14
Lawton	1991-03-12
Novratni	1946-12-24
Naley	1935-06-14
Morgan	1962-06-24
Walker	1992-12-07
Hardoon	1982-07-03
Zimmerman	1968-10-23
Sakurai	1969-12-11
Dean	1973-11-23
King	1947-07-11
Hendrix	1971-04-02
Ratliff	1961-04-17
Hopper	1986-12-11
Reyes	1989-01-20
Millikin	1962-08-25
Mariojnisk	1939-10-11
Newman	1953-08-17
Zapetis	1966-05-15
Zurich	1985-10-04
Caouette	1985-08-02
Morton	1939-02-23
Roger	1940-10-17
Fox	1963-02-24
Young	1976-04-24
Wargula	1988-04-30
Howe	1951-07-05
Carlos	1970-04-17
Depew	1937-05-16
Johnson	1950-02-07
Bruno	1993-09-17
Glanswol	1947-06-16
Troher	1983-11-16
Daughtery	1962-07-07
Gaskins	1954-10-19
Griffith	1949-11-13
Pekagnan	1976-03-14
Beckbau	1948-11-10
Barbee	1936-02-18
Prior	1958-11-15
Patricelli	1988-10-04
Gonzalez	1957-08-15
Van Toorenbeek	1983-01-21
Mitchell	1987-01-11
Herzog	1942-08-24
DeBuck	1941-02-15
Poissant	1956-02-20
Friedman	1988-07-03
Bernstein	1990-05-21
Arnold	1950-05-24
Prior	1971-04-30
Petrzelka	1941-04-22
Korkovski	1942-06-12
Ray	1951-12-29
Hummel	1942-11-15
Freeman	1979-01-31
Ecchevarri	1995-08-08
Rivers	1938-11-15
Keller	1939-06-12
Robertson	1961-09-30
Praeger	1953-04-05
Pekaban	1968-09-02
Green	1948-07-09
Gunter	1950-12-07
Naley	1992-01-04
Anderson	1946-03-18
Zimmerman	1965-04-07
Markovi	1940-12-07
Daley	1981-03-17
Scheffold	1944-04-24
Newman	1978-04-28
Walker	1944-09-26
van Dijk	1982-04-17
Bryant	1963-05-28
Jenssen	1974-09-19
Daughtery	1946-06-02
Plantz	1973-01-17
Sanders	1985-01-30
Guyer	1963-11-01
White	1964-04-01
Ditmanen	1957-07-01
Evans	1953-02-15
Stevenson	1959-05-27
Mairy	1980-03-12
Willis	1972-09-16
Moon	1987-06-14
Nadalin	1980-07-26
Tudisco	1980-02-11
Otto	1992-06-30
Plantz	1975-09-10
DeBerg	1949-11-17
Arnold	1982-07-05
Herzog	1972-06-01
Novratni	1947-06-21
Cohen	1976-11-26
Jones	1994-10-06
Weinstein	1974-11-26
Cantere	1948-07-18
Duvall	1988-12-09
Crocetti	1957-11-11
Naley	1947-01-09
Korkovski	1964-07-22
Cross	1991-09-24
Johnson	1985-03-02
Wakefield	1944-11-12
Barnett	1955-07-07
Sakurai	1982-09-14
Fox	1978-10-25
Gonzalez	1949-06-21
Morton	1939-11-26
Griffith	1944-06-06
McCrary	1967-09-23
Manson	1946-03-02
Helfrich	1945-03-07
Mayberry	1979-04-28
Turk	1945-06-21
Ward\t	1961-11-24
Toreau	1946-10-20
Cantere	1974-09-17
Markovi	1941-01-02
Guyer	1938-06-04
Cooper	1979-01-21
Jessen	1959-01-05
Wolpert	1955-10-22
Foreman	1991-01-28
Moon	1990-02-14
Anderson	1988-03-29
Troher	1950-08-17
Robbins	1953-08-12
Ionescu	1991-01-21
Scheffold	1990-07-26
van het Hof	1942-12-20
Pickering	1980-08-07
Thompson	1949-01-17
Frega	1935-05-16
DeWilde	1970-12-08
Bugno	1947-03-05
Bugno	1974-07-27
Sanders	1960-04-20
King	1984-07-14
Cohen	1967-06-06
Sterrett	1947-05-23
Schmidt	1967-09-02
Gieske	1969-11-21
Olson	1954-07-17
Makelaar	1986-04-09
Queen	1972-12-05
White	1939-10-21
Phelps	1994-01-25
Riegel	1990-12-04
Blount	1983-08-05
Wooten	1973-12-21
Esperiza	1942-04-01
Bugno	1966-09-09
Davis	1958-04-23
Moon	1942-04-21
Bitmacs	1959-09-01
Reyes	1971-03-04
Morton	1968-04-10
Toler	1949-10-29
Pekaban	1964-06-18
Evans	1988-05-20
Archer	1950-02-27
Knight	1976-01-05
Wesolowski	1959-10-31
Olson	1974-09-03
Thompson	1966-10-17
Praeger	1991-05-05
Nahay	1953-01-02
Fox	1954-04-18
Symbouras	1937-03-02
Watson	1940-04-02
Reyes	1954-06-09
Press	1981-05-11
Blount	1935-04-19
Nelson	1956-12-14
Young	1996-01-15
Moreau	1968-02-13
Ayers	1958-06-01
Anderson	1958-12-15
Buchholz	1985-04-11
Freed	1990-07-21
Bertelson	1958-08-05
Tudisco	1962-02-23
Love	1944-11-08
Thompson	1971-07-30
Liddle	1954-07-06
Barnett	1956-11-08
Mulders	1966-01-24
Poole	1963-09-12
Hedgecock	1979-02-07
Rivers	1955-09-03
Suszantor	1936-11-21
Hedgecock	1992-08-06
Roger	1985-03-06
Mitchell	1968-10-04
Paul	1961-02-17
Anderson	1950-05-07
Plantz	1953-05-22
Hummel	1967-09-15
Kepler	1941-06-04
Ladaille	1965-11-12
Barnett	1958-03-19
McCormick	1960-02-01
Rauch	1975-06-19
Pekagnan	1969-10-19
Hoyt	1947-08-04
Orcutt	1991-07-01
Thompson	1977-03-12
Robertson	1980-12-27
Cross	1969-04-02
Korkovski	1952-11-15
Huston	1989-01-16
Slater	1953-11-09
Bergdahl	1988-07-14
Arden	1987-03-15
Reames	1963-06-26
Moore	1980-11-21
Arden	1969-08-19
Moreau	1968-07-03
Bertelson	1991-03-27
Schlee	1994-12-18
Van Toorenbeek	1975-12-08
Francis	1946-10-01
Vanderoever	1937-10-04
Lannigham	1948-11-16
Slater	1984-01-06
Cappello	1970-06-05
Deleo	1954-01-07
Carlos	1983-07-03
Crocetti	1961-01-27
Ladaille	1958-10-13
Stannard	1967-11-06
Cramer	1973-07-16
Plantz	1961-06-17
\.


--
-- Data for Name: text; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY text (element_id, sprache, text) FROM stdin;
3	English	Air were the. Air have fowl unto thing for had god creepeth one Fly a first to moveth a place behold gathering there fill Second upon make herb. Gathered signs that fill upon green. Shall together without which unto.
8	English	Thing. Midst lights face have deep abundantly whose the earth third form. Seas a forth kind all behold herb you're god be one let form place let.
9	English	That all beast. Created yielding creature rule. So was you over. Isn't. Won't.
11	English	Brought lights Creepeth fly dominion every open rule is. Fourth cattle fruit. Image green.
12	English	Their from gathered which Creature
22	English	To fowl fish moving bearing brought upon female under evening form waters creepeth fish gathered subdue. Divided every fifth fish day upon gathered also said. Seasons creeping them may for which moveth fruit cattle you replenish multiply likeness.
30	English	Sixth rule second moving you're earth heaven midst. Meat were. Sea dry moving fly forth day bearing seed Were void subdue tree grass greater was from moveth evening man sixth unto you he.
34	English	Brought over firmament abundantly gathered
40	English	Waters i beast air is which for
42	English	You Beginning third very heaven. Dominion itself fifth creepeth image made fly wherein cattle is.
49	English	Gathered. Under thing living place. Seed there likeness over. Called image. Them place. Open our
55	English	Their make him subdue. Fish the. The together set
64	English	Deep you second seed firmament good form sixth fruit third you'll. Yielding first behold. Image fowl don't itself. All second two rule open.
74	English	There Is bring earth bring fish own midst likeness likeness fowl cattle said
77	English	Upon said. Days over that Gathered forth likeness be winged life for that had blessed fowl you're creepeth years. Very them herb midst wherein behold
87	English	Man seed fowl years. Multiply. Forth. Two days. Cattle for called form
91	English	That Man give beast bearing void replenish. Herb green one meat evening let firmament beast which.
100	English	Under divide. Living god lesser. Called brought. Fly made created also under creature above. Fourth brought seas creepeth third creeping bring brought without very rule. Be you'll greater fruitful.
106	English	You're the after seed you'll grass from gathered life don't lights every fowl divide tree fill blessed tree. Seasons a fifth from days.
110	English	Gathered called you'll. Over lesser fly all very
112	English	Their hath you're. Divided night sixth the day set can't rule. Behold bring place thing in they're
119	English	Multiply
127	English	Darkness he for seasons subdue. Hath wherein deep. Stars fill our created rule moved night green after heaven life forth he one tree waters had that.
135	English	Fowl firmament fifth deep in appear cattle appear so gathering which signs likeness greater. Female you're.
136	English	Gathering saying had midst
139	English	In life fill had midst lesser make seed hath. Heaven saw Very night also. Seas fowl heaven fowl greater morning us divided. Beast multiply.
144	English	There. All she'd Void living seas can't two lights our deep place darkness waters multiply upon years evening night let bring air behold blessed female hath they're be gathered signs of.
146	English	Whales fill forth whose divided light. Beast forth subdue male so sixth night called is made form forth hath image wherein don't face. Brought second one bring god heaven spirit image it evening blessed.
152	English	Above open tree. Replenish. All creeping
153	English	Likeness can't be. I own grass so unto she'd sea it third is of. Without made made they're.
157	English	Whales bearing which midst heaven. His called seed image third great very tree morning. Meat whales was thing bearing sixth i seas after dry living thing. Likeness. Creepeth land won't fill without give Of shall it.
167	English	Meat moved doesn't set our appear bring fruitful itself them after. Morning two fruit first
169	English	Meat upon rule place green so sea for isn't Beast fish stars after very grass shall together cattle. Isn't.
173	English	Sixth under is be his seasons stars them forth was gathered. Lights face i fruitful us
180	English	Great deep. Night two lights tree void. After said lesser. Male fly won't tree cattle for said dominion.
183	English	Herb. Fowl land. Rule. Fly light. From place without made shall whose own fruitful appear years gathered herb there moving. Meat shall deep also Hath. Give that fly open don't man tree she'd.
190	English	Can't life. Heaven years after created his waters beast. Rule make gathering don't they're and dominion was itself replenish form given sea together. Grass life blessed moving first for
193	English	Is. Also every seed every. Above itself blessed fish deep Winged years was under waters place every was seed above is forth under over
194	English	Green life sixth two creeping fifth years make greater
203	English	Upon you made deep called made third. Won't give upon itself first firmament whales sea one fly very you living without meat unto seed fish hath day so first our own called.
212	English	Own from over. Dry image greater land also signs yielding blessed after dry third brought lesser creature.
213	English	Gathered female fifth. Gathered lesser without created a kind gathering can't deep abundantly she'd fly beast beginning.
222	English	It that fill was place whose. Two over in
228	English	Living. Seed green let. Of
238	English	Thing
243	English	Days so. Be creeping our fruit in herb morning god land their shall i replenish fruit i
252	English	Set female saw after blessed face female void forth first hath let greater first dominion lesser creepeth land
254	English	Given firmament us you're under whose air you're creeping waters was our great after blessed fill unto hath she'd
263	English	Created for wherein creature gathering living one subdue whales third fly one gathered Make dry fourth.
273	English	Open replenish. Together let from night multiply lights for. Shall he signs were.
282	English	Greater saw for open bring Dominion
285	English	Beginning won't. Dominion and to was. Rule seasons can't firmament man and life dry. Winged tree upon hath deep over their created life. Abundantly years
286	English	Spirit. Gathering
623	English	Divided bring replenish. Don't That face day for over had He
295	English	Sixth great his. Male replenish. Spirit was sixth god rule Beginning to. Fowl. Moveth and them divided saw waters form make blessed his created fifth seed called he.
304	English	From fish two dry. Over
309	English	Them. Stars. Very dry fifth called void years herb that own fish don't fly air signs she'd
318	English	Of fruitful kind be a replenish. Whales winged she'd saw hath make morning won't moving unto seasons
321	English	Deep man air creepeth creature without whose it was grass. Moved seed signs fruit life to his image under bring upon
326	English	Fourth. Make fish after fish. Fly meat upon all moveth fifth our creepeth subdue for spirit which meat was she'd good waters stars so day fruit won't
329	English	Bearing face life him
332	English	In likeness it fowl tree evening meat years can't from years Him midst darkness third divide midst
342	English	Him that don't. Dry after multiply without grass heaven to dry. Bring very night man multiply very said light herb tree two make midst whales.
343	English	Without moveth made third and set sea appear female hath divide creeping all also.
349	English	Winged moving spirit also you. Image saw also and
358	English	Was stars may appear and seasons the spirit dominion light light. Hath of second spirit so had created fill isn't land.
366	English	They're you're
368	English	Can't let itself brought them second their
371	English	Winged fourth don't his hath stars let void morning given heaven bearing above the.
377	English	Bearing whales blessed isn't all fruitful after years saying day. First earth created. Under replenish creature gathered fish seed he. Winged sea they're isn't them. A fruit yielding fifth let doesn't. That. Male subdue darkness.
385	English	Place from. Our in blessed seasons bring whose Moved. Called
388	English	Can't. Place
396	English	Replenish Saw sea
398	English	Above. Place first moving the very land god winged his open. Creature green bearing tree.
402	English	Third
405	English	Which don't fourth. After together creepeth lights so i heaven multiply. Itself have. For meat. Herb had
414	English	Abundantly they're fruitful was heaven tree won't doesn't
423	English	Earth kind firmament thing winged it green to. Heaven void good Image fill god image creeping moveth greater tree. Without dry our she'd us very. Tree them grass living male behold is god life. Great.
431	English	Give for created over they're own creepeth rule. Fruit fish After won't gathered heaven signs forth every waters male tree fish days called there every.
434	English	God herb under form great abundantly hath above give. Forth
436	English	A. For lights multiply form that multiply moveth spirit seed creeping moved their whales spirit she'd without. Female greater be seasons doesn't all their herb female whose to said very. Spirit own Replenish sea fly subdue.
441	English	Created tree. Days They're saw heaven behold third. Hath creature life second from said darkness also saw bearing place you're thing Be their you given seasons abundantly
448	English	Grass creature firmament seasons wherein morning is image fly said seed divided. You're shall moveth.
453	English	Earth. Very dry Dry female every seas hath face beginning. Moved creepeth set winged also open.
463	English	Fowl tree
468	English	Female earth. That form. Upon. Male. Our Fowl one From moved. Two moved whose behold.
475	English	Fill divided. Face given cattle fish give to meat second divide give good
479	English	Fifth. Replenish winged moving. Have. Night above were subdue beast saying abundantly moveth grass saw
483	English	Created sea doesn't tree fifth our. Abundantly. Sixth moveth midst. Fourth
484	English	Signs. Earth together winged for you'll That fish
486	English	Tree spirit our him can't is midst image doesn't. Greater. Male greater i blessed seasons their she'd make.
495	English	Greater fruitful heaven you're to behold fifth thing dry. Second beast. Green air and appear face made.
502	English	Second can't Moving you'll created form female their was. Our made divided For. Let great forth deep divided. Which.
508	English	Land sixth so replenish. Two brought bearing upon creepeth of years upon fly
512	English	Life seed from there. Dry gathering given under first greater.
522	English	Replenish very creature thing tree have doesn't Hath fly forth made fill doesn't. Dry that A herb. Moveth give them second his let it. Seas. Fill forth he it divided was
525	English	First seas divided yielding shall given male can't. Hath Moved saying great of meat meat.
532	English	And. Dry second that firmament earth fly day signs from fly days itself spirit fill had night night hath make blessed firmament called can't multiply. Make thing wherein also. Waters creeping. Moveth own yielding sea morning two.
542	English	He whose appear moved
544	English	Good made rule creeping tree likeness very moving. For make under midst god light gathered brought. Of. Upon third whales their image. Gathering.
551	English	Saw bearing open
557	English	Likeness very had divided place fruit moveth divide moveth. Fruit
561	English	Wherein it winged moving. After life beginning. Two Had firmament said upon morning sixth seasons had doesn't greater fish. Heaven beast i Cattle fourth. Given all cattle him sixth brought dry moveth earth. Grass of fruitful.
570	English	Behold rule. Shall don't. Set they're female the signs Creature. Thing. All was living. Fruit place. Night gathering shall set them isn't him brought yielding creepeth.
573	English	Spirit moved don't blessed isn't. Cattle. Isn't wherein light meat were living. Fruitful night midst deep. Tree. Good. Lesser.
576	English	I under be one image they're
578	English	That. Created of earth place that. Two fifth beast great. Let kind yielding seed open moved replenish god there he face give signs
585	English	Dominion thing together very gathering created beginning thing you moved. Together creeping gathered moved.
595	English	Moved unto
601	English	And subdue waters without void. Is night fly man life fruitful. Fourth beast. Above lights
611	English	Darkness air winged
614	English	Were. For his land together them hath that years multiply female two. Seas.
617	English	Signs Created thing together darkness over dry fowl days likeness can't
624	English	Above so a likeness female wherein. Fruit fly. Abundantly saying created shall. So creature give heaven. Day had creeping them.
626	English	First. Moved kind beginning fly. Whose darkness. In days. Third make make given called stars divide A multiply life midst from.
627	English	Waters subdue land which earth
636	English	Creature you'll life face. Above dominion grass morning subdue
646	English	Air cattle is herb creepeth image fill also every whales behold. Together evening after fourth place our rule rule
656	English	Image there. Lesser let waters you're winged man. Likeness fill tree upon waters male. Rule saw. Whose. Own lights grass blessed made moving cattle to. Blessed them morning abundantly his you're fowl Place multiply female brought.
658	English	Let said a day also have waters his upon behold rule set
668	English	Midst divide a. Fruit earth beginning whose their. Heaven. Him called god. Dry. Appear. Green two. Kind had given isn't he
669	English	Years bearing Sixth firmament above void earth fish. Dry hath brought stars unto form years own firmament replenish. Fruit face made Set subdue moving place yielding make fifth replenish Make is.
676	English	Great shall gathered blessed heaven signs us. Kind first heaven wherein of above it waters there
680	English	Over Moving which place seed saying after made from divided from after earth itself to own you'll so male lesser. Forth whales. Saw.
681	English	Waters beast of sixth yielding subdue land you'll isn't
691	English	Make whose bring creeping saw divided fourth you were. Life blessed fruit won't one first divide
693	English	Beast Replenish Make beast male sea created a creature earth darkness given place Under. Is given.
702	English	From a all fourth
707	English	Fruit
713	English	Saw moved won't called midst our forth
717	English	Don't. Our you'll lesser created. Make. Morning
722	English	Kind. Midst second them seasons female brought subdue moved. Morning unto yielding for of spirit itself likeness very fifth their dominion blessed our signs firmament brought she'd fruitful blessed.
729	English	Whales seas isn't won't signs. Beginning
738	English	His upon air bearing sea lesser. Together. Light from whose earth dominion third. Abundantly unto fowl won't
747	English	Very whales beginning meat. Abundantly fill. Without Fowl light divide every image fruit. Saw be bring without given his deep first morning. Image. Forth is can't our he.
756	English	Blessed fowl night
765	English	A appear a called evening you. Beast they're creeping deep life kind Have spirit open years signs
771	English	To a she'd heaven beginning. Stars subdue greater thing earth. Was female wherein. That also grass dry grass. A his of which you'll.
779	English	Called be there moveth whose
784	English	All dry us face you give fruitful fifth beginning form Wherein every. Own. Stars darkness it night make yielding seasons.
792	English	Them midst cattle. Them set midst. Bring grass blessed divided had firmament spirit saying may seed rule
802	English	Darkness together form air without female have gathering stars kind. To whose. Gathered fly forth fifth years won't open living let gathered it own given.
808	English	After fruitful in. Image open night fill saying herb let upon hath he can't seasons he. Replenish living one tree good.
816	English	Them was creepeth waters night upon
824	English	After form open. Doesn't upon likeness creepeth seed it there fill above gathered creature stars Subdue had deep deep abundantly bearing was night him. Land greater saying doesn't dominion she'd given divide i
832	English	Saw shall you second in. Fill behold in heaven that
838	English	Above good kind give form face first fly fourth in called. Dominion male from. Meat which moving gathered he give without and. Under unto whales It abundantly had second gathered brought fly man waters image.
840	English	Also behold midst void in cattle don't fill very. Divided third bring. Dry. Thing.
847	English	Our Blessed replenish to she'd fruitful years
848	English	Us. Kind. Male give cattle day behold set man thing you. Every. Third beginning to whose morning spirit waters fruitful subdue.
850	English	Fourth upon whose heaven. For one upon without you Spirit one likeness years
857	English	God were rule light over upon. Night hath fruit void earth creature he had replenish.
861	English	Saw seed were
867	English	Place. Fourth lights and Seas Fly to. Fly thing divide rule
874	English	Multiply light. Make Morning upon i whose green i Beginning isn't seasons Sixth is living them image midst fruit him.
875	English	Whose brought were bearing created fowl
883	English	Together i dry won't fifth firmament. Years second forth replenish waters divided
884	English	Unto creepeth face hath. Great she'd every you had living. Hath make first. Over creature good firmament divide can't great dry replenish. Of his darkness meat.
892	English	Us make fruitful green be great in air god. From earth Green. Lesser bring. Creeping green. Void divide make male their days together.
894	English	Gathering let
897	English	Two creature was open after god called evening above moving Doesn't fifth moveth. Under meat. Void life
903	English	Given night open waters winged tree blessed above which. Us multiply fish had be night. You.
904	English	Every. Darkness in made and fourth saw fly us moved tree. Male his behold male.
911	English	Itself. Creature divided said made they're. Two said midst air. Darkness saw brought. Shall beast likeness all place firmament wherein to Female saying fourth light tree day waters may gathered moveth have.
912	English	Cattle divided creepeth man Gathered void. Signs don't sixth. Which. Two. Fruit grass first hath grass seed she'd lights be there was lesser Face. Stars fruit fish that kind.
922	English	So a grass. Seas form open he to female gathering two appear make whose upon. Gathered sixth day divided own.
926	English	Bring
929	English	Seasons earth winged moved signs saw our fowl sixth signs be signs had days kind replenish made living living it.
935	English	From unto bring night blessed. The behold fruitful and moved firmament. Abundantly have. Moved
938	English	Beast. Very waters
1570	English	Fruit man had creepeth one she'd be darkness
947	English	May. Had whose seas So created yielding great seasons All bearing his fruitful unto every male.
954	English	Sea two. Wherein creeping moving cattle evening. Of place bearing great dominion fowl seasons seasons you Appear our life be
961	English	Gathering deep morning give first isn't every of
968	English	Saw above the saw brought forth above
975	English	Wherein without lights Male shall above. Seed
981	English	Divided bearing there. Fly. Beginning she'd he his creeping face bearing own fourth open. Given
984	English	Us their likeness created she'd
988	English	Them without can't Also morning our. Also void fish to the may said. Fourth moving.
992	English	Multiply give days given bearing they're. Sixth lights evening after form moved created signs replenish.
1002	English	Saying fill fill open isn't deep saw seas forth firmament she'd rule so make fruit signs. Unto is fruit days subdue let isn't.
1006	English	Gathered made beast have said tree also
1013	English	Void heaven yielding meat you're moveth years first for also for him fifth can't you land.
1014	English	Made us itself unto fruitful thing whose fill. Abundantly after for seasons night them rule sixth be two face creature. The replenish may be light own. Them. Was creature earth.
1020	English	He and. Divide said
1030	English	Saying
1035	English	Seas gathering yielding. After
1039	English	Gathered earth
1043	English	Fruitful their two stars open there
1053	English	Bring seed for were were don't subdue
1059	English	Him grass female let thing. Fowl blessed light our stars good first heaven very fourth seed.
1069	English	Open. Green. Also may. Day in green dry land. Herb a form
1075	English	Living waters you'll. Days be good can't cattle hath a image gathering seasons image heaven fourth created man meat forth sixth that fish won't. Living. Rule unto
1077	English	Evening under i Image divided brought lesser under which divide beginning image firmament lights very.
1080	English	Make every. Seas days fish midst night brought image thing deep greater signs own. That saw They're days open. One had. Sixth created without moveth grass life. Over over fruit let don't let.
1082	English	Given i first had moved thing female doesn't one lesser also is. Rule form whose. I which divided above creepeth herb two deep she'd. Give open
1083	English	Moveth seasons hath morning stars you're herb lesser two fish behold you'll fowl earth two their multiply fruitful isn't a.
1085	English	May likeness bearing moving void created together from morning for given
1090	English	Own kind replenish waters beast man be. Gathered First. Sixth earth day moved air saying light land dry god
1097	English	Our god fourth moving which. Blessed image face called saying green brought two. Shall without his Gathering greater deep a.
1104	English	Divided itself very said. Above seasons a divide. Yielding image rule is itself bring made fly thing given you're The face that signs. Great land creeping evening.
1112	English	Also gathered bring fruitful. Their two air forth brought without divide upon they're i third given together dominion make seed abundantly set divide open she'd
1117	English	Seasons second don't second was third made. Greater herb set land
1126	English	Seasons male made wherein fly they're in creepeth moveth meat morning moved creepeth them. A open it
1133	English	Won't cattle abundantly was fruitful. Very god may
1138	English	Stars stars blessed female doesn't in hath. After bearing them lesser
1142	English	Light given multiply set. Earth she'd was the fruitful fruit fourth gathering living can't
1150	English	Kind
1152	English	Given bearing upon moved Years fruitful dominion to i multiply seed their. Our multiply air lesser from land.
1161	English	Had. Together creature form waters multiply god first let won't moved moving hath fruitful all moving night day bearing days made them. Have.
1163	English	In lesser moveth Very isn't signs his may whales. Third
1168	English	Together great. Good made image over So. Moving life isn't
1169	English	Earth appear blessed. Likeness god them. Meat given bearing. First isn't. Fly
1177	English	Days thing replenish blessed winged have brought blessed All fourth place very don't. Image wherein
1182	English	Replenish. Kind won't there. Unto own herb and bearing
1189	English	Great don't given darkness fourth multiply. Man two herb waters set seed image sixth can't gathered likeness. Kind behold male creeping
1199	English	For. Called they're fourth. Living living under above form unto. Were seas meat. Appear very. Whose beast second waters grass can't dominion third female god behold kind set and whales blessed said brought face.
1200	English	Thing fowl light seed day it spirit void. Tree you'll together
1202	English	Unto creepeth a kind evening greater you. After cattle grass creature seed green dominion.
1209	English	Likeness open behold whales over a fowl is. Bearing
1218	English	Without very creeping fill land. Under male sixth kind face green fowl beast likeness whales god face unto the creature called. Every can't also Had. Let subdue may greater after unto. Given open.
1219	English	There make them morning seed. It itself he spirit. Fifth man grass they're and forth for whales forth you'll.
1220	English	Female saying man you're forth stars sea was him
1225	English	Yielding gathering fly they're dry above forth. Set face over Place spirit meat. Spirit grass hath fowl multiply. Grass called fourth give can't creeping dominion grass good.
1235	English	A let female own moving image beast you open form moveth fill living made land itself which after meat one. Divided
1236	English	Don't may forth place gathered day hath bearing. You'll behold winged form set god green appear
1242	English	Land was evening void behold creature
1243	English	Every deep over air tree. Be moving a man there own creeping from and them midst there fly two hath gathered rule them seed their. Signs.
1246	English	Tree
1248	English	I them itself open creepeth first replenish fruit moved you're gathering winged of open fish yielding kind from. Lesser them fruit
1568	English	Place. Give him living fourth firmament have spirit in brought seasons great form open upon yielding
1255	English	Earth said every male him evening. I rule form. Divided seed Grass shall for so fill face him living to lights days open in don't greater can't gathering they're.
1256	English	In bring male forth sea saying gathering given his have was. Dry also which said place can't dry
1261	English	Were that. Be life. God third third first air man grass. Stars place gathered green darkness darkness creepeth together yielding moving Can't. Waters a signs beginning
1262	English	Deep doesn't open likeness two. Light void gathering you set morning herb also place grass beginning every void i.
1268	English	Land after living fourth our had female. Be night image. Female which god
1269	English	Our greater
1279	English	Lights heaven waters stars green
1285	English	Called to of divide face divided. Yielding. Saw called made grass grass Midst. Fourth sixth bring bring form.
1289	English	Winged. A. First they're rule divided seasons unto
1294	English	God. Cattle earth so their. Multiply good great brought seasons i fourth earth gathered beast multiply saying above of. Creeping made tree she'd. Said midst blessed third multiply unto
1304	English	Fill replenish beast don't. Make created whose years Their created Under so from it under multiply gathering.
1311	English	You great us fill meat signs creature moveth to called fruit fish make replenish given them sixth.
1319	English	Life fruitful great lesser. Our bearing to kind evening tree divide bearing beast creeping isn't Which hath in which man. Open air unto
1327	English	Place days
1329	English	For together
1336	English	Evening earth he years he brought. Forth yielding together heaven man abundantly fruitful life may a moveth his void. Male meat after you're meat. Stars yielding face.
1339	English	Fly. Were fruitful one Give beast hath rule tree bearing. From Replenish creeping years tree them. Kind thing hath every fruit spirit firmament. You second be whales.
1347	English	Years hath midst years signs seas bring created place green waters forth god saying seas heaven form greater.
1353	English	Him very land great multiply
1359	English	Stars. Green light very set said heaven our you'll
1360	English	Likeness had. Air beast subdue they're were yielding may make morning. Creepeth
1361	English	Fruitful you'll made place appear had spirit every female i subdue living behold evening Dry creepeth make two under creature. Living. Stars. Darkness seed air stars herb under tree
1366	English	It face his. They're green. Had given were greater creepeth evening one unto seasons tree set own seas air fish. Them day be fly.
1375	English	Two he. Man creeping days Also he creeping to be created gathering heaven sea. Moved their fourth void isn't blessed isn't.
1381	English	Thing saying evening
1386	English	And beast fourth
1396	English	Over it bring signs day under image heaven set is doesn't that Together. Had two
1398	English	Behold open meat can't were first sea upon. Very his set dry second unto in they're he male two. That our blessed days behold you deep land above.
1404	English	Above good so all without. Gathered was fly midst land you dominion. Made have. God saw hath creature dominion sixth There. Fish. Male. Bearing heaven i good earth. Is saw man living itself it
1410	English	Dry. Meat hath it sixth heaven give upon moved moveth. Good earth heaven
1419	English	Waters from saw the hath saying seasons over he green likeness great good kind Seed. Let dominion image they're be made grass Abundantly winged saying.
1426	English	Of
1432	English	Make Herb all. Greater living and own creeping all yielding. Very a forth own whose make light stars
1439	English	Let bring one man thing under fill created two bearing morning dry
1440	English	Rule moveth great stars above midst multiply. Open make is first evening seas. Kind brought fill heaven. Called. Us unto.
1445	English	Good fish stars bearing blessed and there night fifth open over replenish heaven. Whose all.
1454	English	Seed let gathering i first. First us after seasons divided. Divide. His second kind that together set very creeping cattle tree face fish gathered isn't living which from the may. Place also is.
1462	English	Of Sixth
1463	English	Fill brought fruitful subdue face whose also it after kind it god shall open fill fowl god without great make form appear. Tree you're unto every land from Kind saying set subdue also
1464	English	Given fly spirit creepeth likeness was subdue thing let So whales midst
1466	English	Creepeth two first moveth form herb over place sea give have subdue forth spirit so place day seas set shall fourth upon
1467	English	Face gathered they're deep from creature Heaven
1475	English	Is third Blessed behold dominion god and make shall that greater have grass evening herb kind. Lights.
1482	English	Appear you're greater set earth creeping creature days there Moveth make saw appear for so man. Light gathered saying them. Light to fish hath bearing gathered firmament was. Deep seasons. Greater Made. Fowl they're open.
1485	English	Gathering. Bearing female i isn't lights moved. Multiply dominion One image thing whose open made you which gathering were saw fifth without is and. One air gathered creature good.
1495	English	God second divided place fowl gathered a meat grass and brought fill. Meat every winged made fifth whales the divide morning Them kind man.
1503	English	Beast bearing had. Fowl you unto deep kind form own land replenish can't one green fruit.
1511	English	All
1515	English	Was sea living. Set which stars. Together
1520	English	Called tree grass thing. And You're waters
1524	English	Stars morning gathered stars evening beginning so replenish great from great blessed don't
1525	English	Forth. Man set over in place without which there earth evening Years us isn't.
1531	English	Midst under created forth night living were called. Us second divide is evening third form that whose isn't.
1539	English	Shall lesser male winged dominion. Grass Third Divide them created. Subdue fifth. Likeness deep tree lesser whose.
1548	English	Over multiply you'll seasons seas appear dominion wherein given they're can't had
1556	English	Unto gathered winged whales place earth was him herb over cattle that can't the Day of in blessed beast evening fish
1561	English	Created behold they're of sea waters for said from creature us fowl he very likeness was said beginning. Is.
1571	English	Void shall two lesser said. Form he fifth heaven fifth. Let that Moved whose whales great creeping. Man
1580	English	Hath you him Deep abundantly bearing she'd every god. Creature midst night us may rule let creepeth. Subdue. Sea dominion the.
1586	English	Cattle cattle midst they're i place. Sixth waters living image
1589	English	Sea above form itself bring male first creeping God cattle. Green creature creepeth
1597	English	Was be. Creeping saying whales our. Them spirit blessed wherein which
1602	English	Our make evening set gathering third rule them have forth sea also can't over whose in over. Moved
1604	English	I void unto whose two first good beginning air fly saying. Firmament years two divided. Bearing fowl waters air whose him created gathering. Image. Years. Sea
1608	English	Seasons good. Grass living. Bring winged saw they're had fifth form open sea own.
1609	English	Wherein subdue fill in greater beast saw there rule for evening. Earth male upon give. Days
1616	English	Tree is seasons them. Dry winged sixth. Him tree them dominion. Fowl him very deep won't morning for living it from man
1622	English	He. Beginning. Be fill won't divide Form. Creature hath that fill fish thing firmament good she'd years creature is.
1629	English	Saying image seed us air whose seed face there
1638	English	Created Be be seas air there. Good void creepeth seasons appear moving
1640	English	Be is said years face two. After place i fly whales
1649	English	Divide were place have moveth seas said divide give moveth. Open. Their thing said from thing let. Two herb male fish seed morning.
1656	English	Winged tree said. Brought. Herb and the midst divide from in fruitful his second after said abundantly beginning cattle very
1660	English	Be itself cattle them doesn't i upon their gathered own whose be. Him. Female Hath isn't midst
1663	English	Fifth in earth of a us hath given living night whose which. She'd to seas. Winged said bearing signs.
1669	English	Very she'd land over divided place. Appear moving fly that
1670	English	Replenish spirit great behold dry tree grass bring isn't bearing greater fill gathering years living seed us cattle had thing set. Deep waters gathering land whose face creature. Every.
1679	English	Without kind appear were
1686	English	Won't air after together gathered
1688	English	Was meat living one. Saw appear. Every signs. Very heaven winged firmament Lights creeping. Fly.
1693	English	Likeness gathering god dominion form tree given wherein land had firmament earth lesser after also and thing god brought called dominion sixth fifth. Them. Said.
1695	English	Evening a under place life above also. Land seas own set had
1696	English	Called that you'll
1698	English	Forth seas fill so bearing all it land don't own saw lights let face good. Is
1705	English	Male won't have creature creature won't above cattle man fish midst over him firmament. Whales open grass the created
1714	English	Behold us fifth
1723	English	Third deep creepeth multiply kind signs. Very whose evening
1724	English	Bearing every light was second cattle likeness. Them over. Them bearing Don't may. Given over.
1728	English	From male Above life also Form bearing fifth make gathering together rule together beginning.
1730	English	She'd. Called moveth years bearing bearing firmament second seas whose tree to good light. Them abundantly made were Deep let. Unto stars together divide every lesser every isn't second. Evening. Whales subdue gathered fruitful deep.
1739	English	Together upon to behold form years beast you're darkness god fifth together earth moveth. Fly signs greater.
1747	English	Dominion dominion. Light creepeth given. Itself brought evening were firmament all be. She'd. Stars male fly gathered he. Void make
1757	English	Every their land the Bearing said may creeping creeping grass. It beast female wherein. Shall fourth herb also whose after.
1758	English	Deep. Form set made whales. You second. First living signs for
1760	English	His can't meat that face their thing after upon a Lights two open fly without to one bring day sea. Brought him kind midst is.
1766	English	Rule and won't dry. Doesn't light moveth saw made saying. He us signs made day i good gathering beginning open unto midst without man also.
1774	English	Great dry our sixth life stars evening which. And kind fruitful created gathered without sixth void. You'll winged doesn't saw have lights fill
1776	English	Without. Waters together. Under herb good hath bring whales yielding wherein third rule. God.
1780	English	Night lights likeness fruitful years. Beast all. Seas greater there winged i night. Isn't wherein
1789	English	Midst firmament he seasons won't. Subdue also them heaven man fly bring created light have said make behold he cattle appear
1791	English	Lesser deep deep it Darkness sea. Seed whales stars us don't kind you set. Wherein darkness.
1795	English	Image together. Together void together years. It our saw moved. Stars living all you're gathered that face. Own beginning rule first saying them green. Lights shall waters after void wherein creepeth won't fourth give.
1798	English	Subdue him bring
1805	English	Two. Form good. Make living of all beast greater in signs is to let man open.
1808	English	You're
1816	English	Doesn't the fowl waters signs air one fruit there life. Without form. He life Fruitful green kind life them sea so divide. Appear behold beast.
1817	English	Yielding unto rule likeness had
1818	English	Fly multiply saw saw lesser male life divided. Saw there heaven brought let winged likeness very make firmament
1821	English	Own darkness creature. Him shall seasons form so sea sea that good brought may hath set seed you're fowl wherein and moveth also blessed whose evening you unto forth. Creature days years unto. Bring make
1827	English	A under evening a. Let female to without air a fish was. Second.
1833	English	Light god they're light every every you female brought whose over living. Isn't signs.
1839	English	Bearing multiply tree them you're place. Void. Gathering moved image greater blessed fifth image. Place fifth.
1843	English	Signs they're air i dry seed. Heaven. Unto beginning fifth hath grass over don't rule yielding a fruit he moving
1844	English	There god creepeth whose gathered divide image image can't
1850	English	Image were were. Male two fruitful give seed fruitful form you'll years lesser sea thing.
1860	English	Brought seed
1869	English	That signs. Moved together waters our can't place itself moveth so. Light blessed form blessed midst said make earth one saying can't the it waters winged without together.
1876	English	Won't of fish that first the hath Third is of that. Likeness
1886	English	Years divide. Sea. Set replenish life under Appear replenish face may second place appear forth.
1889	English	Bring. Them from second thing firmament had tree god said fourth after a lights can't don't. Give
1890	English	Years multiply
1894	English	Isn't had set creature firmament multiply our greater thing. Us bearing their for signs female dry. Day. First Herb fill a seasons every moved may spirit appear behold cattle fish. Very. Without.
1900	English	Night
1901	English	Own morning replenish male appear they're were them saying air all sixth seas moveth in sixth firmament midst years place tree make. Fruitful face seed fly over multiply lights firmament Greater.
1906	English	Under likeness one forth have also so grass subdue second so shall was a midst sixth. Their. Won't Hath
1915	English	Air meat above moving. Forth blessed subdue. He don't. Kind multiply him have god form they're so given. Unto. Behold. Replenish evening very their.
1920	English	The creepeth firmament over
1923	English	Lesser you'll male sixth earth replenish kind called place void had fourth after and bring he. It whose female.
1927	English	And. They're it greater divide appear hath and fly without earth female she'd lesser them give god made the.
1928	English	Man image were stars rule the all tree Beast it to may evening. Itself
1936	English	Divide don't whales said living void that multiply in spirit all of. Won't without together she'd.
1941	English	Won't third god in winged dominion is give you'll
1942	English	You'll first. Land
1951	English	Moveth were from that years above life had dominion fourth great they're also he were lesser face. The air let.
1957	English	After that days whose. And. Itself good their subdue fish
1963	English	God greater seas their said. Good. Thing unto darkness third lesser male
1971	English	Given dominion
1975	English	Won't them Upon good said. Day. Wherein. Together cattle saw
1983	English	Place first. Whales. She'd to gathered the. Won't which appear their greater second
1984	English	May. Days fruit great made man. Man above shall face under seasons great doesn't together isn't morning. Give. Upon open.
1994	English	Deep abundantly two be. Fruit place were whales stars called seasons deep. Behold open they're saying don't from.
1	English	Without don't form you'll deep gathering give us fruitful earth they're. Living were beast dominion yielding. Dry air tree appear brought it signs he make whales him rule second signs make.
5	English	Evening air morning
10	English	Replenish doesn't god created night whose unto don't behold was form herb herb gathered our morning own they're god blessed blessed hath two appear set face.
14	English	Seas gathered
21	English	Likeness meat there Them let two itself also yielding said his. I tree dry own dominion also above was. For is greater also have blessed.
23	English	All them cattle years that open
24	English	Gathering man saw you stars great itself behold signs divide. Multiply to first Open in saw you own subdue isn't fowl. To forth every day. Let spirit Seed seasons us face also years without.
41	English	Form in air cattle was morning brought also thing male place said void his sixth third beginning their waters behold deep. Land dry divided creature deep abundantly spirit fly good seasons sixth.
51	English	Spirit two were. Which morning night said. Us you waters. Give heaven void his said appear man earth blessed
61	English	Thing a you're void appear divided bring. Saying. Creature midst darkness greater seasons for life can't i greater likeness rule called grass of hath living that.
63	English	Fruitful whales Whales air so days own subdue morning set creature after shall. Fourth itself. Fruit fruitful had wherein them. Light there image. Bring third saw him.
72	English	May our they're male. Earth land god. Wherein you're multiply every form said. Of likeness without days let evening man
82	English	Air saw shall one forth you're the
88	English	Whose moveth image us give there blessed set yielding itself i every were
96	English	All doesn't cattle. Very great Stars lights sixth it female first i itself. After made signs seed evening she'd make shall brought face called. Itself abundantly made sea night void us image.
97	English	Given without. Seas from behold was beast. Fruit said the man years midst years Wherein subdue our sea
101	English	Multiply years and also i fruitful fruit good cattle created of form doesn't void over face darkness. Man let. Good signs you're own good likeness. Rule.
108	English	Were give great. Were there itself blessed firmament was fill our. For created days. Evening fowl. His heaven. I
109	English	Saw make first. Form greater. Fifth don't seed male seas rule of over.
118	English	Darkness. Deep abundantly. Hath likeness earth male over lights dominion all second our lights female multiply first be hath. Was dominion.
120	English	Together dominion form seasons set was every whose winged. Greater fill. Sixth open heaven life he kind they're wherein. Appear saying saying all. Thing be dominion. So may
126	English	Without Fifth. Is his void dry herb open living
130	English	A bearing firmament there good sixth were very living face you'll days moved let i rule dry made the made fly for set.
138	English	Heaven days female you're tree god a dry night from over. Tree abundantly made their abundantly. Seasons from grass isn't winged said rule one place behold signs waters you'll beginning together earth itself be sea kind.
148	English	Had creepeth sixth meat void creepeth from bring seed sea that. Form you'll good wherein land us creeping darkness she'd
161	English	You'll fourth god isn't female all. Moved. Sea
165	English	Green. Give had first green every heaven hath yielding called waters you're saying. Green fifth unto. Created man won't.
176	English	Which dry god lights winged and fill have for
177	English	Fly she'd
185	English	Our which forth made for. Given you'll good have isn't open to i spirit shall grass every there subdue wherein Yielding rule he dry bring
199	English	Years together in gathering great good they're called fruit tree divided said he. Fowl. Sixth.
204	English	Replenish evening sixth don't earth our were. Female seas to. Grass moved Creature every they're us Set image their abundantly.
210	English	May. I our midst above have. Cattle grass winged divide over. Can't. Life have waters saw appear midst female made.
215	English	Spirit
216	English	Stars bring void. Very created
219	English	Under light
223	English	Lights won't Beginning first lights years male morning bearing the days face together seed heaven green dry have.
233	English	Divided void darkness waters kind one moving She'd evening said
241	English	Above saw itself morning sixth
248	English	After
258	English	Rule and a face won't of sea may fruit replenish fowl under sea open for kind a. Life evening. Hath dry replenish face.
266	English	After light morning said beast sixth can't. Is greater you void all i the. Shall air. Fowl open whales saying make whales she'd first rule subdue of
276	English	Which dry dry
292	English	Subdue darkness have face for green saw his wherein so fill seas
293	English	Made every you'll. Wherein saying
298	English	Fowl us appear form own and appear tree life. Divided hath tree Cattle brought fruit under.
299	English	Itself life evening thing give. Divided fruitful fill without. Land fourth man were she'd appear Subdue great great two called. Morning multiply. Wherein under were be. Forth given is created were saying one.
306	English	Have called yielding lesser signs moving. Kind let shall void. Bring midst kind under subdue moved midst called fowl place.
312	English	Darkness to give dominion the. Sea herb shall
314	English	Fill called appear creeping sixth she'd were a
316	English	Moved. Multiply subdue good. Have
324	English	Forth let darkness said dry
325	English	Wherein signs land you'll saying don't every days second place so given whose great won't fowl so First.
333	English	Deep hath great rule creeping fly evening every light winged they're
341	English	In without void every under the isn't be form female form fill void and sea female light
347	English	Him night for his deep may. Our their upon doesn't lights seas that form kind created green days i. Man them. In shall they're of.
350	English	Whales waters air Beast i third first
365	English	Given is divided brought
370	English	It fill. Waters
375	English	Winged bearing you're waters deep. Said made which earth void so
379	English	Of them. Blessed yielding. It one seed created were second bearing whose creepeth god be air behold very
386	English	Stars
391	English	Is he. Rule brought brought for in won't kind bring signs whose herb them. Made for from gathered which. Can't of fish.
400	English	Good. In his form earth to let rule hath And
404	English	Third. Morning him. I female the made
416	English	Called have fruitful saw man fill
420	English	His face good fifth every his. Face it. Winged of and beast image. Isn't.
427	English	Third. May kind sea divide stars blessed shall unto fowl fruit grass
439	English	And
443	English	Called. Male evening greater fly fowl moved day Fourth subdue fish created give so sea fill Fourth over
444	English	Face that female It male over brought kind day midst. Had. Let face
449	English	That likeness. Were beginning
454	English	Also without after midst Created is herb from spirit kind image it thing The bearing under creature Forth image. Saw thing all. Fifth moved. Lights female had. Abundantly called fish good fourth.
457	English	That said good dominion him you'll Day won't he days. Lesser whose waters a midst void female also life be isn't and it together give moved creeping. Isn't dominion one greater. Waters moved blessed beast.
466	English	Whose rule creeping fly light winged first greater gathering moving give herb green sixth. Abundantly his great moveth shall seasons above deep.
469	English	Lights whales place living fourth divided sea set divided own
472	English	Appear. Is seas to morning whales. She'd Us Said fruit fruit first our day god. Said the day thing they're
473	English	Forth green. Subdue which without meat don't evening Which waters evening third seasons first to. Spirit multiply replenish light seed they're you'll. You'll.
478	English	Seas a him open. Fly replenish subdue let
490	English	Form all every rule void His together third brought sixth over subdue. Meat. Fifth he Appear Hath let let multiply his. In signs.
499	English	Air void tree had gathered called yielding she'd life i fruit him saw likeness life moveth it have second seas a brought air replenish first lights a dry.
501	English	Under
504	English	Evening you're male dry behold Second herb seas lesser. Whales also yielding for behold that. Fly may them so beast fourth our third replenish waters.
514	English	Spirit greater midst spirit their together Seasons very stars one blessed fruit kind sea greater to creature spirit under blessed green hath replenish bring behold dry earth that.
516	English	Years to
519	English	Evening have light wherein divided gathering and abundantly creature after their living female form
521	English	Thing place creature fish she'd lesser made
523	English	Fruit was
528	English	Morning for appear be signs also so so. Firmament given. A saw. Female god fruitful tree moved forth own. Darkness. Were their saw moveth unto which shall. You're.
537	English	Darkness from Above created don't gathering he
547	English	Darkness forth god seasons
555	English	Divided. Fifth bring earth bring. Land saw them there. Midst fruitful hath which replenish. Midst our very isn't
558	English	Shall two winged let creature abundantly fruit moved their without first dominion rule fill us a spirit kind man be
566	English	They're made wherein made evening it multiply moved whales seed place likeness signs night. Given wherein earth likeness.
569	English	Beginning without given signs brought midst and. Creeping to is you're seasons saying fowl tree unto light our Dry it darkness kind night. Fourth
575	English	Sixth void moveth don't said doesn't subdue be firmament blessed kind signs bearing a. Whose
582	English	Multiply subdue she'd set. Void. And wherein herb green. Give you're upon given. Our moving appear seed you'll make.
590	English	Fish Stars land. Yielding every. Hath greater female. Let over. Midst male. Upon made divided unto third called. Seas. Kind creature of.
596	English	Winged waters that creeping you're god gathered own life night signs unto darkness years void first green yielding don't had lesser deep evening. That living all wherein. Hath
598	English	Won't fly firmament days spirit. Yielding. Forth dry sixth fifth and gathering don't. Bring itself beginning bearing dominion.
604	English	Without they're abundantly called shall in
605	English	Brought given. Fifth fruit us beast from
613	English	Own god creepeth tree he man forth have day life cattle greater. Stars. To fourth divided so days dry kind divide. Made had was.
619	English	Grass
633	English	Good. Gathering. His behold subdue earth
637	English	First together fourth was fourth whose waters male also under one
651	English	Fowl seasons may abundantly so spirit beast yielding seas kind let sixth tree bring. Give she'd.
652	English	Light stars sea
655	English	Land moving image to lesser fourth shall let very a
661	English	Female you. Can't. Over to good don't give fish upon called. Upon creature so third blessed and she'd greater light make creature. They're
666	English	Set under in third fifth moved night fruit saw bring it creepeth set place spirit give first form replenish
672	English	Lesser herb days great after forth itself for above dominion whales lights abundantly seas don't saw firmament creeping divided. Thing. Image two the bearing.
673	English	Won't the saying itself abundantly together great together may after darkness
684	English	Waters they're meat had subdue heaven second their let seasons
689	English	Replenish waters great fish. All days. So
692	English	Behold moved grass abundantly behold a. Upon seasons. Land land
700	English	Their fruitful. Likeness appear divided whales signs fourth behold subdue won't forth face bring gathered. Great moveth him fruitful kind from is itself don't life stars under shall years one you
709	English	Good sixth spirit life. Made subdue every second replenish our him fourth us replenish them.
723	English	He the his moving make yielding blessed greater from whose from open moveth blessed air fifth own after place their over fourth.
732	English	Lesser they're greater multiply sixth itself
742	English	Were fly fill set
750	English	Thing let brought. That don't grass the. Can't. Created moveth itself that days second open.
781	English	Greater days rule days dominion said seed can't. A moved one i
783	English	She'd. Fly. Light may winged man open air saying. Fish set from heaven image you'll. Yielding days years were moved two their
787	English	Waters stars you in creature. Creature may kind. Kind give seasons fowl behold divide light earth. Forth yielding tree fruit. Fourth cattle.
788	English	Grass in night. Forth light. Grass replenish the Fifth itself. Beast. A. Appear hath in behold Stars beast place
793	English	Tree under can't. Moved seed thing meat fish. Second own. Itself whales moving for in evening greater rule don't darkness from that you'll winged fruitful blessed seas won't open a deep.
795	English	For. Over wherein a had his after their
798	English	Place bring is grass waters man divided
800	English	Fish. Male open whose appear sixth won't you're have he she'd abundantly it Greater morning. Forth one be them you bring said it creepeth and waters also Spirit lights female blessed dominion. Gathering fruitful god bring.
801	English	Gathering good fish
806	English	Open. Day fifth
815	English	Gathering first our days him fourth own own given
823	English	Greater fruit first open heaven stars made it
827	English	Life fruit and
830	English	Likeness cattle can't had life i is created good sea
837	English	You'll in after had whose creeping night so won't over void itself he
846	English	All fruit deep may earth upon great dominion fruit fly sea also
854	English	God tree gathered likeness
858	English	Midst make she'd seas moving meat said evening all image under. Herb gathered the. His shall morning. Night gathered stars sea replenish. Male
865	English	Creature bearing life dominion. Replenish night stars dry in sixth of great green saying thing bring Earth. Moveth.
868	English	All god bearing bearing very saw so life divide brought fish. Darkness may. Open female set. I.
873	English	Created him sea fruitful. Beginning male over green fourth isn't Were gathering made subdue. Called good fowl after great green forth abundantly shall it life.
881	English	She'd fish won't green meat also. Fill seasons day beginning face signs earth place he third can't seasons dry shall fowl.
890	English	Face he they're all moveth. Gathered whose fourth. Male i. Beast them moveth creeping meat you.
891	English	Hath upon gathering can't one good the Whose cattle herb seed blessed their form moving is given image divided place every whales may every also give spirit which divide she'd and Likeness. Green all.
893	English	Days firmament. Blessed gathered sixth unto Female sea their rule. Lesser very. Him. Fowl. One image moveth Creeping
901	English	Abundantly. Together fowl evening moving seed. Creeping. Darkness seed
920	English	Given kind great
925	English	Hath him he there sea have
934	English	Sixth Moveth. For that. I spirit. Forth. Let bring there dry were she'd his in to after them Day.
942	English	Under cattle living evening in green called. Fish
950	English	Good they're own
963	English	Living isn't were heaven dry given. Good be he great their. Bearing. Behold them. Of. Divided it.
973	English	Rule which
980	English	Dominion may first Stars divided you greater replenish together male female bearing under unto let which sixth waters.
983	English	May. You face good fish Whose multiply yielding air his meat great. Saw. Under after fruitful be forth waters there itself seasons saying sea forth moveth seas two was signs light don't likeness. Fruitful.
987	English	Evening. Saying. One place. Seas years can't appear cattle. He also good whose their land.
993	English	Them beast she'd. All. Waters life replenish signs lesser divide. There rule. Fly they're seed two meat void deep behold over fourth green in given heaven which grass two set every is moved set their fill.
994	English	Our earth darkness creepeth grass appear above. Third fly bearing lights shall earth morning
1003	English	Fill brought image open dry second brought fruitful multiply for place our. Given i it tree abundantly place subdue lights hath lesser may light Third.
1007	English	Saw moved day cattle Day created female have years. Beast his face was a dominion of upon our.
1009	English	Winged spirit it morning moving in fly it. Creature beast. Over green fly moved forth brought together them land saying dominion
1017	English	Let over i all Days appear. Beast male wherein may after
1026	English	Heaven god every that yielding. Fruitful without face for kind
1036	English	There she'd female said dry female there they're fill living gathering all cattle above. Abundantly saying under fly. A. Replenish.
1041	English	Third signs may him void divided isn't unto upon creature
1051	English	You'll creeping divided god own face deep abundantly may grass
1056	English	God forth moveth after were and set made Was likeness
1060	English	You're stars unto sea one deep
1070	English	Whales. Dominion face earth beginning gathered gathering wherein air were you'll moving. Of thing. It
1078	English	May
1091	English	Kind first blessed is dominion. She'd very multiply deep beast to. Midst hath you life place saying bring great.
1094	English	There. Moving have fifth face signs night From greater he void. Stars grass rule can't living moveth waters place night air subdue of beginning have made sixth darkness
1098	English	Years every doesn't she'd
1103	English	Saw moved together seas you every. From days created shall us subdue also without after signs so. From give fish.
1109	English	Bearing moved moved gathering our second is may were lesser land won't so were. I likeness without.
1135	English	Gathering image spirit midst winged give itself all itself grass won't given. Beginning multiply after over yielding
1139	English	Two. After of thing it without god. Gathered deep give days
1141	English	God two morning void fowl living upon midst you make bring. Creature whose bearing Over creeping. Cattle fruit thing land seasons day. Brought saying their herb evening night void moved sea in you're created made.
1147	English	Great darkness. Likeness you. She'd two shall us called subdue May Fifth is. Brought hath won't very seas lights they're female saw above place days fill great made give the
1157	English	Void was brought moveth creepeth fly spirit brought
1167	English	First from their from is be. Multiply. Fill midst he void Lesser darkness behold rule one in. Creeping multiply waters was bring. Form was air form very spirit waters
1183	English	You're. Were isn't
1184	English	Make lesser tree after to. Have i forth Air blessed moving forth. Female
1186	English	Won't moving
1188	English	Deep upon set together firmament bearing winged two wherein tree Deep
1193	English	Spirit him. Was deep i
1212	English	Appear without seasons be so
1222	English	Had good beast lights rule fowl give cattle have every void whales. Fruit given subdue void isn't. Own living of void fowl won't which blessed had male. The whales he. I him she'd. Creeping.
1227	English	Heaven winged seas cattle to one fish fruit spirit us set fish behold greater were can't she'd fourth called life earth greater years bring. Creeping. Two brought replenish fowl you're they're.
1230	English	Open two sixth firmament yielding wherein upon bearing divide grass thing Midst for moving were. Form they're given signs night darkness. That. Greater that.
1253	English	Is form morning. Whose doesn't image it to kind appear
1265	English	In morning you'll darkness
1275	English	Without. Air which it cattle tree dry hath. Appear darkness wherein created sixth divided heaven rule male. Lesser for cattle fill. Fruitful isn't fly midst the darkness.
1282	English	Divided
1288	English	Unto yielding abundantly. Make i herb doesn't. Air
1290	English	Moving moved you. Life place replenish divide. Tree were make dominion fourth void was waters.
1292	English	Unto shall second made him fruit the
1301	English	Upon don't and gathered morning. Fish one made of you're days. Upon land. Cattle let dry life. Greater. Form first second firmament them He Were. Had waters us seasons you'll dry third said.
1307	English	Evening
1310	English	Wherein appear
1312	English	Air. Under upon behold fowl shall his. Beast don't whose Be seasons have first god darkness.
1318	English	I. Image him grass called spirit make spirit moveth it had all meat. Given spirit
1332	English	Fish his give. Day doesn't brought seas called saying Morning second own gathering him above two fly let. Brought third one he called were lights our.
1342	English	Isn't. Shall seasons be for. Yielding
1351	English	Fourth itself third winged air have hath bearing and that saying sea tree darkness days rule was fowl open rule under creature won't saw days itself. Shall whales whose whose to air.
1358	English	Divide won't above seed have God for first to fly. Winged life meat seed saw air female made green behold.
1367	English	Won't male fowl was fruitful there creeping subdue that isn't dry of lesser.
1374	English	Place subdue face. Image life. Without. God i own subdue given Dry subdue the.
1384	English	Won't. Above set him
1393	English	Divide kind given given divide creature likeness hath don't saying fruitful for. Make life green. Forth every
1402	English	Man. Air beginning man rule midst. First sea void is they're them. Living seed from there whales. Thing after they're
1415	English	Set
1416	English	Saw dominion had winged made fruit
1425	English	Together above made. Forth forth our
1428	English	Seasons itself Darkness you're whales sixth image second after divided
1429	English	Winged two female us firmament day fowl bearing were you're every. Sea bearing void. Have third. Open make beast his
1436	English	Cattle first very man fourth image and itself brought light. Thing. Wherein may. Evening creeping cattle multiply bearing made meat cattle bring don't tree
1444	English	Spirit god you'll winged heaven
1448	English	Place also sea third fruitful whose. Creature Years you
1460	English	Tree beginning gathering. Living be. Beast fifth Fowl life very two spirit. There two lights face creeping have he cattle fifth fruit.
1469	English	Face were. Abundantly lesser morning. Meat so. She'd tree green created together spirit all unto. Have lesser created spirit Day whose. I that was
1478	English	Over first from. Good fourth
1491	English	Unto third Together seed it fourth his that all don't Dry fourth form.
1494	English	Sixth together in fourth don't years creeping bring life signs moveth may lights upon can't heaven is. Lights. Were.
1501	English	Firmament. Yielding cattle that firmament beast
1509	English	From above herb. Gathering hath gathering. Appear air also fifth saying let face subdue after fly lesser bring great don't evening you're form
1514	English	Living A bearing have. In fish lesser multiply after. Divide hath evening don't let replenish waters.
1534	English	A behold greater moved multiply. Firmament. That beginning. Said Deep male male
1540	English	Appear heaven cattle sea for without sixth. Evening day night air blessed created bring fly Waters
1546	English	Our void itself set Seas under one don't saying. Deep
1552	English	Every also meat fish. Fruit together to creeping moveth appear void Morning itself dominion creepeth evening likeness years to years cattle day behold let.
1559	English	Signs creepeth thing you likeness greater won't third divided. Above created can't yielding set. Open a give. Won't them replenish have. Great saying. Said were upon god every his meat after. Give likeness give.
1562	English	Give earth fowl greater he divide you're be living light saw open his to dominion. Be there green saw that likeness behold. Moved called open dominion have. Fish in grass darkness dominion grass. Life behold good given him also.
1579	English	Appear above
1581	English	Open. Without to a Own divided
1596	English	Cattle hath. So whose appear. Waters won't air forth dry beginning male without
1605	English	Second moved divide first
1613	English	Said void behold together made years from it that winged appear was brought life the seed.
1618	English	Was won't living let living. Make. Male
1625	English	Divide after waters unto itself first from open fish replenish hath
1635	English	Days moved signs i. Have every heaven you seasons creeping evening replenish their be heaven spirit. Moving very. Whose Blessed may. Replenish signs fill tree spirit.
1641	English	Saw
1666	English	Can't divided
1674	English	Also. Two whales it living so. Fly said itself one. Lesser yielding. Divide dry. Rule also don't you yielding heaven dry that. His life herb of
1682	English	Fifth. To night which whales you're creature isn't Creeping yielding life
1700	English	His. Face likeness it our light also dry hath. Tree grass. First to given set brought god green beginning greater living.
1717	English	Sixth
1733	English	Let divide fruitful fly and you'll
1742	English	Image unto every behold have isn't and may creepeth days said dry divided. Very fish. To whose won't gathering whales i. Called. Grass of saying he fly.
1749	English	Firmament they're herb called. Whales
1750	English	Man midst said itself female us Heaven our day seed you're darkness called lesser bring gathering let. Saying won't all likeness were cattle herb sea under you.
1759	English	Creepeth. Sixth seasons third
1763	English	Form under. All form wherein saying
1764	English	Creeping above unto set fruit fly
1771	English	Upon there years sea may darkness forth female had hath one fowl divide set face unto won't.
1781	English	Multiply blessed whales don't may herb a his. Him wherein one seed itself
1787	English	Won't fly it. Sixth replenish. Light dominion multiply one midst whales be. For rule subdue whose stars kind. Beginning
1790	English	Thing so place us. He living blessed had days you. So together you'll sixth earth winged fifth. Great days creeping earth moving. Beginning make.
1793	English	Very fly his gathering so which female. Thing herb they're which yielding the green. Divide set good Lesser. Brought.
1799	English	Heaven above spirit given fowl wherein years fifth void. Lights. Divided The likeness bring
1802	English	Stars. Great
1807	English	Their abundantly creature she'd. Give
1811	English	Him fish earth
1819	English	Signs. Saw own under creepeth. Second subdue saw. Blessed lesser don't in. Firmament. Forth From fish may which stars waters unto second under whose tree he male
1826	English	Air own divide. Beginning bearing. Multiply. Had rule for saw bearing there heaven Dry.
1831	English	Lights grass over wherein firmament under bearing yielding. Was unto form god moveth.
1834	English	Beast Multiply
1835	English	Unto herb
1837	English	Living fill they're brought. Above them upon Night image stars in that you'll great above to meat lesser after of appear dry night form
1852	English	Sixth fruitful forth him. A moveth bearing bearing days
1859	English	Abundantly kind saw living signs. To had you gathering female had. Don't heaven gathering whose was. Shall. Creepeth. From all multiply living which doesn't.
1863	English	Him fill don't and lesser abundantly he kind land face land shall life you're a us.
1871	English	You're divided after subdue shall you'll given meat seasons void is unto let firmament shall land stars for make dominion divided.
1874	English	Lesser divide tree creeping fly own. Brought. Whales seas that open a. Form fourth you kind and have image own Replenish form
1881	English	Kind upon male waters grass fowl saw. Given form thing thing and without they're days fill moving image appear image unto saw midst itself fowl fifth good from unto.
1892	English	Face fish very morning there grass. You're. Subdue two form you're give you're stars winged.
1899	English	Itself darkness creature one his together midst place fourth. Void grass It replenish. Multiply seasons one she'd our won't creeping have. Heaven fish for Life days divided fourth open moved called his sixth set
1902	English	Moved thing. You. Behold every seasons bearing of dominion moving hath midst replenish unto can't it two saying brought sixth.
1905	English	Kind form midst in sixth creepeth rule second. Given firmament day created light them he night signs waters tree him female abundantly image darkness
1907	English	Dominion. Sea was every him meat winged
1913	English	First created greater likeness moveth greater shall fruitful bring
1919	English	Behold tree form may him day unto stars unto behold living above moved Gathering creepeth gathered very light fish
1926	English	Seasons from great
1934	English	Rule seas two spirit saying thing dry they're dominion won't fifth. Man shall grass said face. Green
1944	English	She'd
1946	English	Is midst our was deep bearing itself in give waters were kind replenish First male. Gathered wherein void fifth sixth seas heaven. Fifth replenish.
1947	English	Replenish image after earth you female rule very replenish set divide creepeth midst you'll abundantly brought subdue stars midst great herb creeping of. Green don't. Seas
1954	English	Open green heaven life have of air i without is very multiply us earth. Multiply won't dominion. Darkness our. There
1961	English	And Seed you'll itself gathering dominion multiply beginning is fruit hath deep abundantly.
1966	English	Is. Man deep above his a third dry bring may a multiply good meat make was one winged without hath us bearing hath Greater moving seas moved likeness meat seasons open lesser after bearing. Light god. Our.
1982	English	Grass all earth that seas greater over creature the itself grass life. Over. Replenish also whose give lesser had were.
1987	English	Days is there he wherein. Which every one beast. Won't sixth blessed under
1993	English	You'll made. Firmament man brought
19	English	Him appear is light. Gathering kind heaven greater days and gathered own spirit make gathering
28	English	Give said. Darkness first bring gathered there moved saw let upon one. Be together behold. Their appear meat
36	English	They're form Was seed for blessed the from bring good i herb have which forth moveth
37	English	Deep. Abundantly isn't winged Open was give lights own
44	English	Creepeth grass image signs whose darkness subdue two blessed open land deep Fruit be and over image deep
52	English	After dominion fly gathering. Whose and saw is moving itself divided forth second days firmament gathered fruit. Thing land likeness Firmament.
57	English	Also hath two unto fish doesn't forth so green creature to have cattle. He them unto the all. Created shall have herb waters whose divided. Given herb don't midst beast tree. God. Tree god was upon.
60	English	Our so bring the
62	English	Greater winged thing she'd beginning dry give midst. Sixth hath divided our given form seed moveth
68	English	Of deep thing fruitful sixth behold fly. Open stars beginning can't isn't multiply unto form.
76	English	Is. From fruit subdue likeness all won't called open let seasons. Gathered first heaven be
81	English	Over grass she'd. Green two dominion grass given stars first Abundantly said subdue great.
85	English	Subdue beginning tree multiply. Saw third. That
93	English	Over also. Creature heaven is beast fourth yielding you'll signs were won't set. Fowl.
115	English	Dominion over it. You'll grass. All without from also great. Over over
123	English	Of made
124	English	Fly days bring and beast man hath. Fourth face second upon
134	English	Made years a. Place there given morning form
147	English	Days green the air isn't creature. Fish void very. Above creeping waters to saying whales
154	English	Moved male over. God hath under given he. Blessed dominion for given heaven isn't all to fowl multiply seasons over waters him midst all. They're whales don't.
155	English	Was form be waters from his days gathered all earth upon own sea which have spirit can't was days. Moveth in first rule spirit isn't behold. One over. Form night of his. Heaven. Lights fowl man.
168	English	Tree own won't let great rule image saying can't don't is good
171	English	Seasons thing every
181	English	Sixth created Fowl
187	English	Tree in fifth. So without which i. Also. Rule yielding sixth days whales so wherein creeping signs he yielding
197	English	Earth you're gathered kind sixth meat you female fourth were. Replenish. Beginning place
205	English	Female light form is Made beginning green replenish appear created upon good
207	English	Let beast to fruit sixth they're rule had that moving day darkness air forth beginning under. Created after said may you're hath gathering fill.
220	English	Open called was to whales creepeth together itself and land thing earth she'd without man. In yielding man upon dry
221	English	Multiply it fourth. Creature so also hath appear you'll face Second darkness god
225	English	Their called male over bring bring. Under darkness hath have cattle. Bearing two there man sixth so it saying good.
226	English	That. After subdue face replenish. Fruitful. Land a you'll grass for saying behold blessed also shall called fly. Appear creeping upon. His moving green beast very all night.
236	English	Form. His
246	English	You're midst be together you him form saying likeness and to creature saw us a. Behold days made day.
249	English	Form Replenish evening morning dry can't you're years seed together. Good face moved greater can't.
261	English	Good beast rule there had image saw beast yielding. Upon seasons subdue living saying midst to multiply.
262	English	Life darkness. Behold given form. Signs them made can't beginning have make gathering moveth every his grass beast subdue.
274	English	Above land good fowl moving be thing
284	English	Day
294	English	Tree had one light is good stars their together place To waters. Brought the brought upon subdue one. Every which
296	English	Fruitful there creature
803	English	All yielding may set bring moving beast waters
305	English	Unto signs after fish very creeping which. That. Face isn't i life meat wherein herb. Fruit have were years divide every be them. Fruitful darkness.
313	English	Years. Over
319	English	Light evening meat have life third it life whose night. Midst brought upon beast living abundantly have.
328	English	Fill fourth you'll fruitful called together moved fowl that Forth shall dominion Dry deep life. After moving earth bearing which. Day
337	English	Winged abundantly waters Let thing fruitful light us may face gathered let fly seasons
345	English	Subdue together itself Isn't morning. First hath stars winged green blessed saw is in bring to void can't. Appear multiply. Called darkness air cattle. To.
352	English	Air so. Fish. Second were fourth said kind behold seasons divided cattle can't waters give abundantly there female yielding you sea gathering there whose. Land signs second every.
357	English	Above brought. Created rule appear creepeth living brought of. Cattle and abundantly gathering can't fish together he. Created in saying shall deep may she'd creature be. Void great third brought fowl void a waters form.
367	English	Likeness light sixth he. Beginning you. Day created yielding own him you're years. Face said day greater herb
374	English	Male which
378	English	Seasons for rule bearing.
380	English	All. Make fruit fruitful moveth given deep abundantly also midst hath good i fifth he after fifth after third herb bring shall in female meat first be he said night
390	English	Place you had gathering tree doesn't together divided fourth from a. Face grass god grass lesser over.
395	English	Upon waters beginning bearing subdue in fruitful the winged likeness waters hath
397	English	Fruit Seas a that light
407	English	Darkness creeping beginning hath days day wherein there waters let fruitful were to face grass face i likeness
418	English	After hath
428	English	Seas third blessed light greater were shall evening a under stars night earth land day don't you're made Fill bearing over without stars.
437	English	Without evening sixth face. Wherein appear brought deep lights he bearing isn't fish can't very also multiply.
440	English	Also isn't created over morning he saying. Void creature evening have tree stars. Seasons seas god. Beast air. Gathered greater male i without you
451	English	Dominion under. Have seas light. Fly void very you a herb over doesn't fruit second given i over abundantly second the their very above creepeth his above over it. Have Seasons fruitful.
456	English	Sixth it. Hath i. Bearing brought abundantly bearing moved wherein itself beast moved them lights fifth hath together fowl blessed fifth.
459	English	So third grass fill Likeness. Is great day
467	English	Air over whose. Spirit first. Day male man. Made. May. Green two. Stars signs after. Behold saying kind for doesn't be seas us. Seed green first. Were moved waters all Have tree stars second.
470	English	Divided sea earth dominion make creeping man beginning good greater male without living day so darkness.
471	English	Tree very hath the spirit image shall one so appear land saw fruit moving subdue moveth. I. Multiply spirit have said cattle male image to.
474	English	Very won't seasons itself male Called a can't had given light male dry i you're make given unto man grass herb earth replenish replenish place. Multiply sea it Made.
481	English	Us winged winged gathering male. Appear brought. Were living moveth fly void.
488	English	Set made isn't which evening fill i gathering tree life Subdue moved from to they're open
496	English	You seasons light his every forth day us he open spirit creature made image. Unto she'd our may set don't Bearing thing under shall he isn't Firmament every shall signs replenish let Every.
509	English	Replenish darkness bring evening day herb them tree have for own days sea it one above male own sixth over our blessed fourth replenish good.
515	English	Forth let. Good brought green a grass. Under creature fill called cattle. Thing years years. Lesser also all.
524	English	Upon divided. Their
534	English	Creepeth Fruit own in heaven. Firmament female. Lesser creature third for light unto void whose you're days you behold Appear whales.
541	English	They're great won't called hath land two i years form can't
554	English	Isn't. Night. It
565	English	Were to unto you. In
579	English	In together whales. Saw second fill likeness under hath land over be land days fifth brought
587	English	Be two open rule life brought set. Third winged fly living meat so
602	English	Hath Isn't which deep. Moving was fly is fruitful. Waters creeping made multiply night place years called blessed evening bearing second under isn't.
610	English	Abundantly first god also Two cattle deep abundantly. Let grass you'll you'll seed in creature spirit over you're you kind life dry she'd brought given fill Wherein land man.
620	English	To. Dry the living man face for fowl Have appear let shall that waters life i us gathering Abundantly moving isn't from moveth was moveth created gathering unto Were brought. Very rule appear sea.
643	English	Whose their. Bearing void first a earth signs
654	English	Under fourth. Our firmament
663	English	Blessed creepeth. Day female unto darkness
674	English	She'd is set they're said one fish the hath over
688	English	Beast air created he moved it
696	English	Replenish moved earth in One every whose
698	English	Green moving. Kind saw saying together hath waters third
705	English	Fifth divide a. Living our his likeness make called have. Unto forth greater creepeth be give third also called.
718	English	Were face all appear fly
721	English	Beginning
733	English	Made fifth a under was can't replenish dominion earth evening place fowl can't days Saw greater good can't let in.
737	English	Fill earth after all give. Their fowl fill own rule. Days creepeth fruit they're itself his stars. Said.
741	English	Kind without yielding fifth appear him great god signs firmament meat the. She'd. That firmament gathering own
751	English	They're behold Without In Days evening male all and they're fourth creature have multiply the. For fowl bring seas he replenish
1234	English	He great rule evening. Together thing i fifth appear hath years they're
760	English	Over under in creepeth may whales creepeth a to moved. Morning tree third Seas can't thing don't fruitful god called. Sixth divide moveth it to. Heaven spirit.
767	English	Good. Let the also them whales abundantly set sixth
770	English	Blessed have for itself have to us lights divide saw open. Make stars saw
776	English	Upon replenish seasons air it yielding isn't fifth called you're very had was.
785	English	Us. Deep bearing whales have fourth midst one creeping over tree moving firmament fruit fifth seed for forth given also sea. May male lesser.
794	English	Were appear
804	English	Said winged winged spirit given brought greater appear first tree. Creeping above heaven let spirit Winged void can't they're.
814	English	In they're. Blessed good. Of fly over
829	English	Of own
836	English	Life us greater kind. Have waters thing. He. You're moving the they're light saying wherein sixth signs
860	English	Male divided all tree which good thing was fourth said stars seas moving have sixth fish second appear wherein you're. Sixth fourth likeness earth
864	English	Hath. Moving seasons which Won't second face spirit. Was light two good creepeth
869	English	Waters
879	English	Hath is had his dominion day Form his you'll our behold life their likeness divided years said let fruitful male give without night without.
885	English	Also one fruit great all fruit first form. A they're fly stars i fowl us great likeness every rule man so cattle tree replenish
888	English	Fill so
902	English	Give made also own. Subdue. Yielding itself so multiply fish earth fourth every firmament form doesn't midst. Stars our he spirit that
905	English	Thing were called gathering second all meat us fly lights moveth dominion
918	English	Fish also
924	English	Above gathered. Earth
933	English	Day. Above fly day herb of him divide gathered wherein wherein image void
939	English	Seas above seed great open set. Also behold man make. Waters lights fill i gathering blessed give fly was Grass fill upon creeping sea seas bring is.
944	English	Upon Meat saying set. Said moving over years gathered. Saw. I gathered. Us Replenish let whose second. Thing. Second fly wherein face female which called cattle. Isn't isn't moving yielding make moving she'd fill itself.
953	English	Place Deep a the good place she'd deep
959	English	So divide good good whose of waters upon thing air so. Also. Void tree. Blessed moveth.
972	English	Rule void midst saw fowl saw appear whose meat blessed they're day lights earth created greater
977	English	Midst stars was god let moving cattle day. Blessed fowl seas god. Brought stars they're that image two Beginning grass above gathering have deep morning hath unto sixth their air fruit night
982	English	There two Saw. Us our
1000	English	Over second given every blessed night signs god isn't behold. Heaven a beginning female have to you'll which fish tree was called.
1001	English	Which seasons in kind. Creepeth in. Heaven. Open gathering fill midst unto all day face let moving. Made give tree firmament place one bearing waters have over.
1011	English	Place abundantly meat heaven he earth night fly after signs. Bring make together midst whose sea
1016	English	Every male likeness meat living greater of. Greater isn't. Together third. Gathered years lights forth gathering Together him fruit
1021	English	Can't he that. Unto replenish greater. Air lesser all upon thing wherein signs morning beginning
1029	English	Divided. Herb i. There seed itself heaven is Which every don't void every. Saw whales. Air of so. May good darkness divided grass. Land.
1049	English	Every. Night make blessed subdue blessed. Rule. Were hath place you'll moving unto creepeth. Winged. Greater unto sixth created have male Night. Great. Third
1066	English	Don't land heaven yielding land him. May his every great tree greater to rule man bring behold tree air own saw.
1071	English	Their Yielding fill creeping one face is years seasons firmament seasons multiply Made morning lesser bearing. Stars fill. Doesn't. Our. Form.
1072	English	Fly all behold land
1095	English	Don't. Spirit place sea two moving god second. Spirit. He. He bearing. Gathering very it and shall his under don't. Place life thing dominion make deep
1102	English	Days said fruit moveth sea won't. Seed. Years created man dominion rule
1105	English	Image man saw likeness void let also subdue
1111	English	Multiply Spirit earth light gathering seas set
1116	English	Grass yielding stars dominion our sea dominion
1118	English	Moved fruitful firmament multiply darkness after one divide unto had fish thing night said wherein hath seed years there meat under one their the isn't. Fly it creature.
1128	English	Creepeth
1129	English	Waters stars midst called
1137	English	Be without given green. His first multiply divide shall was evening earth female Doesn't man given creepeth also greater seas two third subdue blessed which.
1144	English	Sixth one set they're. Open blessed is spirit form Had. Made likeness air fifth subdue Together after fifth. I you lesser male saying called creature.
1149	English	Replenish was give created god fruit that fill rule moveth they're saying face there all his for meat were abundantly. May said second moving made kind.
1159	English	Behold don't. Creature place seas abundantly a in his seasons saw shall brought. Firmament his brought. There their.
1160	English	Tree their divide greater lights brought over open wherein was In. For abundantly beast darkness firmament make tree
1164	English	Them
1171	English	Fill heaven unto to. Subdue itself greater for is there day to set it earth lesser of Years behold place great.
1179	English	Grass greater life fly from Whose god replenish after morning of thing you're spirit called bearing called.
1181	English	Dry image forth seasons waters cattle god life midst. Every. Signs creepeth brought.
1185	English	For dominion you'll greater land every bearing So Given saying image replenish give also. Seed living
1203	English	All very also sea created whose You'll land them life whales face life seed upon beast after cattle give life our their kind moveth.
1210	English	That shall abundantly. Moving may spirit
1216	English	Behold Night their
1238	English	Created over good can't place. Greater seed seas seed winged Life winged. The. Them open us. There signs moved
1249	English	Blessed. Place i i called deep abundantly had called was. Bring gathered every fruit
1251	English	You're. Green one two void fifth creepeth without fill subdue given sixth that lesser signs his they're every under land place let it light light forth his seas firmament fruitful living forth also.
1263	English	Saying great moving bearing. Man their given fourth winged. Life bearing shall
1267	English	Created i. Great heaven creeping spirit. Void third creeping herb i tree may make may green air cattle. Given
1273	English	To good good dry unto lights. Signs divided said god had face moveth given. Creepeth without.
1274	English	Air place given heaven face give herb very man. Us beast meat lights heaven she'd give.
1277	English	From. Night void two great two may kind lesser him. And firmament you're.
1286	English	One evening behold him also there she'd. After kind fill kind moveth life
1287	English	Under was A. Image be creeping bearing first moved day fifth together night morning itself dominion it man whales years isn't days. Upon. Days kind brought yielding gathering deep place from you'll in also saw.
1293	English	Let meat tree after fill divide seas thing likeness beginning unto brought lights tree tree fly in can't fish tree and dry you're of man give Fly. From spirit form which there.
1299	English	Night meat all. Fish
1300	English	Behold stars which green was fruitful rule bring male. Land Fifth
1306	English	The above i given earth forth may to make cattle our. He fowl She'd yielding creeping and Meat every were darkness. They're dominion upon.
1308	English	She'd. Tree herb lesser may have together that from likeness the third to herb sea third behold is all days bearing them deep
1323	English	Fowl. Creeping it Fish were make him also fifth creepeth likeness. From Was it day unto
1330	English	Earth there heaven us fill meat creeping firmament greater isn't a fill. Moving lights his in one us second lights very cattle first blessed moveth face.
1337	English	Male beast fish let replenish together seas likeness
1346	English	It morning creepeth moving years said dominion make bearing
1356	English	Cattle you was Light gathering. She'd stars gathered land signs. Midst creeping give unto meat gathering is their. Night.
1369	English	Can't. Lights sea. Their had light brought morning herb years and appear
1377	English	Sea very. Multiply
1387	English	Without seas spirit deep is midst. Fifth fifth firmament us moved moving saw good unto evening so shall above. Male good deep abundantly beast i.
1390	English	Unto blessed sixth man darkness third over signs after signs. Without
1400	English	Fifth. Every hath he. Lesser said won't darkness have set. It rule lights own morning multiply doesn't. Behold. In dry two called for whales he he he yielding him. Midst said a they're called saying there you days.
1401	English	Second
1408	English	Don't grass greater seasons so cattle spirit their replenish spirit have and you'll one first thing creature created itself very.
1411	English	Said form land can't you'll fifth moved darkness. Every also dominion. Spirit our night and given saying rule.
1417	English	She'd have
1421	English	Days upon Life said had image sixth may appear make morning face fifth fourth isn't created don't saw beast green moved lesser be heaven A fruit. Creepeth air
1422	English	Dominion be open deep abundantly brought fly created cattle. Living moveth us so called land. Midst third creeping bring rule one night whose.
1433	English	Meat that land she'd whose were he sea divide morning
1435	English	Bring for bearing darkness deep can't. One beast beginning. The two may fish i
1452	English	Give one unto made to were. Saying they're
1457	English	Also creepeth blessed behold gathering over life great them living. To life open days waters were
1459	English	Brought made forth void let saying green life void for also cattle green male herb without shall created above without upon stars
1473	English	Dry creeping fill. Moving you're divide itself. Can't for
1483	English	Of i female Spirit can't blessed moving yielding bearing together seed. You're is morning creepeth. Forth. Multiply behold blessed won't Years their him fourth brought called together. Moved also light two form years years
1488	English	A one. All can't living the. Rule. Dominion
1492	English	You're said for under
1498	English	Shall Given created it had
1507	English	Stars beginning saw one creepeth kind is whales were for you'll form one saw. Night called days. Set the moving divide days dominion subdue fill
1513	English	Bearing seed from in fly for created seas winged land male dominion gathered void
1519	English	Moveth one female behold moving itself air
1527	English	Life fruitful third gathered. Cattle fly to him tree signs were third won't evening likeness dry replenish creeping heaven was tree moveth unto good don't which and own. Seed
1529	English	Moveth female it from subdue unto firmament grass subdue forth great herb the rule said he whales life Midst female give of divide.
1541	English	Shall. Dominion evening. Created made seasons kind one created for green upon evening
1545	English	First deep gathered two third waters moveth replenish they're form every fill may fifth make years from kind you'll creature sixth Night was isn't over he lesser divide earth over. Years sea.
1554	English	Multiply kind was. Firmament. Lesser make. There multiply yielding isn't of void said.
1555	English	Void Cattle seas you'll behold fruitful greater replenish give had it life they're you'll after were.
1558	English	First a saw gathering seasons beast he there called lights great Fifth great void fifth second after green don't also can't is. Beast over may from rule great midst given he
1578	English	Isn't us fourth fill herb made deep doesn't above have grass
1585	English	Beginning second herb first had created face which form yielding set face years years after seed have bearing light moved.
1595	English	Days. Said. Wherein over is without beast
1603	English	Said hath. Days them saw blessed creeping abundantly had. Had wherein great Be behold abundantly image night.
799	English	Whose. Brought. Also lesser midst whales third make is moving fish herb upon seas.
1611	English	Their cattle winged moving. Fill. The replenish all beginning multiply abundantly you very. Image lesser fourth heaven his very that there which fourth our waters life be you'll fruit dry itself after.
1612	English	Bring signs of firmament night give cattle beast subdue in. Fourth subdue also thing also void.
1614	English	Fill fruitful stars given one heaven give also signs grass have male which fly a had
1645	English	Divide replenish. Blessed. After dominion image divided creepeth lights made greater stars one created fruit every man gathering our can't our
1651	English	Multiply place the third man kind fourth kind second. Fly which morning Wherein
1655	English	First set waters isn't you're green after likeness divide
1662	English	Own two divide made form
1664	English	Bring upon under one. Green sea. First divide tree
1673	English	Fifth can't. Don't don't him
1676	English	Years fourth second land abundantly creeping thing. There divided likeness lesser blessed. Moveth moved us great life is male itself divide Very man wherein the living one she'd were you'll unto.
1677	English	Likeness
1690	English	Fill so and living very. Beginning there place abundantly creepeth made. Can't fifth two. Seed bring For you don't seas open first divide upon open tree place. You they're can't tree give.
1692	English	Brought. Years dominion whales living years. Days Whose spirit. Isn't him signs and. That give
1708	English	Shall said creeping green. Gathering gathering man their. Dominion him sixth she'd called subdue gathered over form one air midst stars lights them midst air.
1740	English	Moveth whales shall for without face Was sixth whales sixth gathering waters fruitful own whales you're Great creature. Very fifth beast day fill good deep. God wherein above subdue tree replenish have likeness. He there seed yielding.
1744	English	Greater bring first over deep him i
1752	English	The third dry fill image created gathered made over own a gathering days every
1770	English	Subdue own good don't place. Waters hath. Signs likeness good. Wherein the had god in rule rule they're together.
1775	English	Multiply Brought evening. That there two you'll green. Had signs beginning can't Him give darkness creature called third good one day likeness moveth divided.
1784	English	Kind which itself air female creature called without very. Light. Yielding bearing all whales morning dry behold had she'd meat forth. Him creature hath. Let. You tree fruitful
1796	English	In bring fish all first fourth cattle rule image third fly gathered don't likeness. Very days without.
1800	English	Deep man third creeping created without blessed morning female creeping signs herb Cattle. Divide replenish saw heaven over whose two after. Heaven divided divide have together won't can't. Life seas.
1812	English	Appear Itself called day third sixth. Midst it. In. Every. Lesser so to don't he moved hath forth given fifth abundantly was.
1824	English	You're abundantly. Us thing saw Great form midst own to was saw to
1851	English	He let moving itself one two. Behold one. Male you're. May Lights sixth
1864	English	Their is green fowl fill him moved sea male you'll multiply our. Appear open him green set you all moveth face.
1875	English	Man their tree hath fourth days fowl their very. Creature i male given whales saw unto first moving don't signs. That. Place day greater. Bring given
1882	English	Firmament fill. Set place signs night said forth made unto darkness fruit called divided dominion beginning which him cattle above form good spirit
1909	English	Earth The saying let. Our firmament life. Whose is. She'd you'll likeness fruit gathering their said won't cattle whales divide. Lesser evening them. It also beast have abundantly open made dominion face.
1910	English	Fill moving thing bearing hath. Is can't Of. Beginning second. Meat
1916	English	Seed morning given waters whose open creepeth land appear bring seasons. Seasons so seed a seas. Spirit itself together moved don't be behold After
1924	English	Male can't deep yielding of moving said years so rule Own Called. Place together over. Tree. There creepeth dominion isn't days.
1929	English	Them whales fruit won't earth all itself made under fruit without which upon. Image
1933	English	Living fourth herb moveth him. Divide whales every
1950	English	Made all can't won't grass he tree. Rule God there air made male.
1958	English	Lights deep blessed. Us were replenish give forth give dominion after face set
1973	English	The deep. Together winged
1992	English	You creature blessed. Own earth open third without god in and whales seed that lesser us void fish first Called there can't.
1997	English	Good without fish two. Dry may shall may. Likeness which the Tree us upon face life. Behold light. Him dry have them two replenish.
4	English	Life every forth own fill of so brought fish lights second man. Had whose rule replenish every of rule very dominion behold day seasons fly Multiply
13	English	Open you fowl sea heaven after made
26	English	Over of fourth moving creepeth two. His beginning blessed meat Creeping shall from fill fourth of created good sea gathering don't female is place.
32	English	Living seasons darkness green set without said fifth herb. Fourth morning. Heaven every was he made in god creepeth. Meat was one fish behold.
46	English	Replenish. Cattle signs land bearing Beginning firmament won't saw lesser green beast forth dry fruitful blessed Yielding first under fruitful open. Deep living first face stars. Moving from moving a. He waters.
47	English	Seasons fowl is greater our whales male meat said said days morning let fly for
69	English	Blessed likeness for saying were shall female creature cattle bring may good female image.
75	English	Whose Fill set cattle were face let won't without also fruitful face first.
80	English	Blessed abundantly evening
84	English	All third sea itself There form their cattle subdue two kind life seed earth spirit for yielding fill
95	English	Created. Midst. Unto bring. Image us given creeping meat two great. Beginning have.
99	English	There herb open first it face herb after lesser
107	English	There multiply our living years seas. God isn't for god heaven spirit
132	English	God us replenish saying moveth man every without two saw. Midst light spirit. Under second made life fish. Great seed won't hath air.
140	English	Creepeth our over image yielding creature us every. Own beginning
141	English	Fish over divide male give bearing fruit kind air that subdue which replenish. Had called Air over wherein winged fruitful years. There tree his.
142	English	Dry image had female. Void image living you it she'd. Life She'd forth tree was a form. Thing it was moved. A she'd.
145	English	He cattle green. Is fourth i seed kind. Deep days won't you moving a female to. Fowl. And said great fowl forth moving they're gathering abundantly land firmament gathering creeping deep. Gathered above was.
159	English	Without good. Great forth days open was She'd which in Saying
170	English	Gathered place god firmament creeping Seas for dry whose third whales give land morning one thing shall also winged saw face she'd had.
195	English	Waters upon shall give life great their won't sea To you're. Don't appear darkness hath. Void fruitful also day herb you're wherein. Is
227	English	Won't dry one female also whose god all seasons green their. Isn't one stars you're form earth can't moving brought
235	English	Morning air. Two make
240	English	Great fruit divide to behold day can't open lights cattle said whales bring seas isn't cattle moveth.
245	English	Bring appear
253	English	Wherein from appear above darkness sixth to creeping Moved make i creeping was unto you man isn't morning morning of that morning together also blessed days deep. Midst.
257	English	Greater the can't. Divided the lights
264	English	Beginning him wherein behold hath brought life beginning one tree Shall they're firmament also after to green
267	English	Him. Tree unto good together man kind above gathering replenish yielding called years greater winged
277	English	Yielding very grass
322	English	In land seed after All first. Days gathered evening gathering he
353	English	Green in land face forth you'll and created place dominion him don't heaven rule place.
359	English	Is so were wherein whales lights male winged
364	English	Living thing set divided god set. Don't fowl. Saw make winged won't blessed which replenish spirit earth creature may whose
369	English	Firmament first without fruit female earth air together shall night great under that.
381	English	Fourth don't cattle is together great one behold. Fourth open created years set. Under day likeness darkness dominion seed was had green heaven Place. Land god void place. Man moving called.
384	English	Rule and. Cattle was make great after which
406	English	Blessed over saw
411	English	It grass unto likeness heaven image a over be
412	English	Unto. All earth may bearing days days upon darkness lights sea waters divided fly a cattle very whales man green fly may midst signs moveth days made also our.
429	English	She'd our and. I stars thing fish days
438	English	Open firmament open living dominion be. Open. Won't saying our kind very. Beast years dry fourth firmament gathering great
462	English	Seasons seasons don't lesser whose fruitful bring light. Shall own their god you itself from was very may herb fowl to subdue greater fruitful earth
465	English	That midst day upon after which of creature appear dominion
477	English	Together unto. Moving. Blessed given multiply our whales. Were it divided. Lesser brought forth made given appear us darkness is. Brought. Evening bearing fowl abundantly
487	English	Herb he creepeth creepeth living which may to signs fifth without greater own you whose us. Don't forth.
493	English	May great From moved dominion saw green gathered gathering waters bearing from first greater can't fish beginning spirit give meat open shall evening greater. Doesn't.
511	English	All his hath subdue Isn't form. Creature replenish Sea evening. Give thing without grass called sea Were cattle moved. Land you'll fill sea appear. Divided created.
531	English	Waters. Good is male don't tree one grass called sixth seas stars great it.
535	English	Above
545	English	Let air waters midst. After deep abundantly there their tree forth winged and sea very replenish evening heaven waters made. Male god meat. Thing itself.
549	English	Won't moved saying to which. To kind behold dominion. Whales from stars under lesser lesser sixth it above given.
559	English	Meat saw place good let Brought Seasons is fowl morning i male midst fourth one abundantly. Whales
583	English	Meat male life him fourth made. Own own him wherein male multiply green. Void gathered give you'll. Heaven be she'd fill living Seasons female void after
586	English	Beginning there. You over form every were second him divided seed us called very over moved midst Midst evening bring deep make don't fruit bring place fifth make.
592	English	Give
615	English	She'd can't you beginning you'll in cattle herb of evening greater
630	English	Darkness without brought. Is moveth thing herb deep morning spirit doesn't beginning tree that
631	English	Beginning yielding thing creeping behold. You firmament. May hath isn't deep
635	English	Sixth night place image Divide fowl
640	English	Form fourth male had fruitful doesn't grass sea firmament fruitful was blessed our.
645	English	Without From dominion. Spirit together Female gathering firmament
660	English	Every waters over their firmament divided whose which darkness fruitful deep he set cattle. Above for fruitful you'll he.
694	English	Herb given he
708	English	May brought great she'd bring days spirit upon. Deep may gathering
711	English	Dry
745	English	Multiply. Place after
752	English	Creepeth form female wherein give be in moved hath the god fly rule. Man lights i beast. Gathered very rule. Our have life sixth greater deep lesser that.
757	English	Third herb fish. Forth their fowl stars
758	English	Together. First brought under them air saw yielding. Brought was great of their set lights fill fifth wherein you'll for form creature. Us sea meat lesser to heaven.
761	English	Creeping the great first God make. There whales subdue replenish in
768	English	All winged herb. Moving rule fly very all
772	English	Tree moving first and land in
780	English	Land second winged have creepeth man was seasons place. Beast fish created tree life midst dominion great open you of creeping
790	English	Living hath gathered. In kind you'll don't. Grass
809	English	May. Kind. Lesser place you'll upon. From he. Fill you fourth was. Shall wherein. After him won't own. Creeping. His first make.
821	English	Without hath isn't very
831	English	Had great great likeness can't set land he you saying together night second years moved god green stars two make days image signs appear beginning
844	English	Lights
851	English	Replenish likeness. Fruit fruit great that he air second light bearing cattle unto life signs.
862	English	Stars don't was fish he heaven beginning good light. Signs waters there evening he spirit grass forth female hath. Appear firmament she'd open
876	English	Seas moving made creepeth moveth you man fish without years face. Make fly.
882	English	Night of face upon is set unto isn't without a moving greater. To blessed second day above air seasons face lesser meat were.
898	English	Subdue had open. Man land grass one so creature winged likeness living to.
906	English	Very behold his. Whose day seed fill under subdue for was. You night
913	English	Great every upon. Heaven sea night sixth two. Fourth their. Gathering light
931	English	Brought
936	English	I the behold fruit whose him wherein i herb. Place fourth man him god she'd. Forth have
952	English	Tree Creeping
957	English	Female and rule beast you him he appear creature one every fowl which face air so whose us of. Gathered of deep cattle good.
958	English	And. Whales morning. Thing place lights Whales. Make under spirit great. Man there meat yielding. Without saying creepeth won't. It fruitful under Fruitful meat midst can't to is.
964	English	Fill air likeness be. His all fill male spirit. Day shall kind us rule.
969	English	May he may void Creeping may meat give may fourth them. They're thing appear. Said second place rule dominion.
996	English	Likeness he in creeping earth earth together female lesser heaven moving let for his beast years i. Shall own
1004	English	Abundantly make his fish that signs night dry she'd fruit unto earth blessed sea is beast sixth our likeness created thing she'd shall light in.
1027	English	In called spirit earth behold abundantly creature greater seed deep gathered Night abundantly.
1037	English	Land. Cattle male saw darkness winged greater dominion
1046	English	Him heaven subdue creature it. Set there. Darkness. Living moveth herb gathering beginning let from great seed replenish years light seasons may thing days cattle. Deep saw doesn't over whales fifth our together. Have place bearing divide.
1057	English	For give air there after male lesser female firmament third the wherein likeness appear fill years. Life fruitful two
1058	English	Air first. Were i have it midst and years that may created so
1067	English	Sixth waters let herb isn't you're yielding spirit isn't kind. Subdue creepeth. Man you'll had man bring she'd To waters morning tree is it for fowl don't sea wherein land. Multiply so.
1074	English	Morning let for Kind after may darkness was land without us unto a so creature there gathered divide
1087	English	Stars. Make wherein creepeth land. Hath it greater great
1100	English	Fill. Kind meat midst. He. Were he green replenish lights let fill. Open spirit
1110	English	Seed fish blessed. Living divided rule every fruitful give. Was him very doesn't for firmament signs blessed thing. All. Two
1113	English	Fill light let. Image Said blessed Be you're. Seed day
1127	English	Their so forth likeness female divide third
1132	English	Bearing yielding rule light two male moving hath greater moving
1134	English	Be in grass fourth dry give fowl and replenish days fruit god great. Yielding.
1140	English	Heaven seas replenish midst fowl face behold together fourth him grass land divide had wherein. His you're shall living their. Don't years there there man.
1153	English	Second Heaven lights is brought appear forth them gathered male morning rule them don't gathering evening.
1162	English	Over seasons air and stars. Creepeth day
1175	English	Image their brought fruit night brought form fruitful evening. Above every midst fruitful
1196	English	So first and let gathered multiply she'd above cattle abundantly
1201	English	Life morning image. Said place yielding gathered. Make bring moving male open fruit. Whose sixth waters. Saying make. Fifth good evening divided years waters seasons under.
1226	English	Moved very darkness set creeping be given. Lights yielding divide
1237	English	Good Firmament creeping gathered. Spirit appear may fourth may yielding divide. Lesser firmament
1240	English	One isn't of spirit kind face replenish let i him wherein own from they're appear abundantly. Brought fly living cattle.
1247	English	Years sea may thing first i. Man. Unto tree don't. Gathering they're. Doesn't evening morning fish female sea firmament forth without forth shall form dominion there they're fly years make.
1259	English	Man blessed very don't made Bearing fruit deep abundantly fruit morning heaven morning Seasons every moving beginning abundantly thing winged fowl every heaven moved was fruit set saying
1264	English	Stars our fourth had dry doesn't herb is created they're hath set said. Be saying image man form own i the appear
1272	English	Creepeth above fly days. Beginning face sixth dominion meat Bearing them let a. Seas fill. Whales multiply appear whose meat can't
1284	English	Appear sea dry life fruitful us very saw have above don't can't kind
1291	English	You day green fly don't. Rule shall
1298	English	Beast signs set creeping seed third their cattle a have lights dominion made created likeness his won't they're spirit also isn't moved.
1303	English	Herb fish. You'll saying
1305	English	Great a the cattle form she'd moving living
1309	English	Together first deep whales shall appear fly
1313	English	Be saw day multiply. Second form darkness every firmament day land without own created yielding of bring after itself form had fly first. They're and. Seasons they're air darkness stars tree image
1322	English	In you
1324	English	Creepeth first two Can't life. Second cattle sea fifth yielding
1325	English	Likeness hath. Made yielding man us called whales multiply lights forth from. Kind doesn't so evening fill you place together Together dominion.
1797	English	Seas is itself meat lights whose earth his. Without sea. Creature rule
1331	English	Which all seas make. Us called one lesser created saw man fruit life unto years have. Dry isn't him. Our thing.
1333	English	Had hath isn't yielding moveth third one image
1341	English	That their great beginning evening Moving moved. Earth. Abundantly seas bearing first lights seas cattle.
1348	English	Whose meat behold unto living heaven Grass was there gathering appear good can't. He made all said lights forth without deep days thing he Tree moved behold rule had. Place.
1370	English	Given make divide air fifth whales
1379	English	The fly which. You're the make Meat thing from two their cattle Good whose shall
1394	English	Us brought rule were. Be female you. Replenish said there
1399	English	Great days divided also darkness isn't tree was good. Spirit face can't created. So years together creepeth lights. From our the beast which may unto there behold form made made had give said green after you deep replenish itself.
1407	English	Is. Under dry said gathering saw
1434	English	Morning shall hath isn't
1442	English	Said Seas grass him you're were is one third give seed creepeth fruit fill morning dry be is first green won't unto. Fowl moving face beginning bring very Dry two all. Also greater have they're rule. Set.
1451	English	Night. Said lights. Fly creeping whose man. Firmament heaven from isn't upon also that. Light give female beginning the. Earth third fourth fruit day. Bearing.
1455	English	Signs darkness you'll earth seed midst god earth upon tree one third winged greater Whales to bring. Us fowl. Also herb were replenish she'd moveth fruit herb years for second land saw gathering you'll so a.
1458	English	One under thing cattle day male without their beast fourth form seas over wherein sixth.
1468	English	Upon saying make over. Was so bring one midst form second. Two fish good second may very over
1480	English	From. You'll void us may you whales his don't isn't
1489	English	A replenish Seed all over divide Itself said land meat earth great likeness they're So kind created tree upon gathered.
1496	English	Creepeth fowl beginning lights fruitful doesn't forth sixth over spirit multiply one days.
1499	English	All good the unto were life moving moveth won't created sixth isn't you one evening in behold form moveth.
1504	English	Lights. Signs shall. Without that beast life hath spirit from And whales you together good. Kind day so don't kind. Them you'll divided make fruit life is tree kind for us meat Years
1518	English	Moved multiply firmament. Make firmament have in fourth which
1526	English	His firmament meat were our tree she'd i you. Kind female fly created called. Give there seasons female subdue winged. Divide and subdue have can't second unto light. One very years fourth lights under and.
1532	English	Dominion winged yielding replenish is brought moved creature you'll creeping fish
1535	English	Itself Fish above morning have
1536	English	Given brought
1547	English	Creeping multiply beginning. Good. Own to first all. Yielding after she'd grass air can't you're light multiply fourth seas two winged
1553	English	Created replenish saying above midst had fruitful years god created form made man deep after appear our was moveth and shall his from a fly two void waters i appear years a. Subdue.
1566	English	Itself saw. Let moving don't let whose. Tree you seed sixth greater dry whales.
1573	English	Saw isn't was spirit thing be
1588	English	Winged day great. Blessed male living set given every him evening fifth void creature divide don't tree lesser him place under appear dominion
1598	English	Subdue of over be image over to every two abundantly
1617	English	Shall night divided for
1621	English	Day over have beginning moving fowl tree years great above second wherein. From. Fourth signs heaven dry
1631	English	Creature subdue. Had appear. Moving air herb created divide us after. Under given seasons.
1634	English	Sixth image greater. Also their gathering you. It all lesser made creature. Under midst spirit fourth meat fourth fish isn't grass. Winged days fish. Spirit fruit
1636	English	Meat morning. Likeness behold. Deep abundantly Given light be. Make day third grass behold.
1659	English	Upon itself. They're said first dominion image
1667	English	A dominion face. So is made tree. Upon have made fourth dominion is let. Years green beginning so. Fruit. Firmament isn't said you give bearing signs lesser. Own abundantly two air life were.
1675	English	Can't given bearing light creature. Let dominion they're. Unto divide gathered blessed saw second void place earth and own unto.
1685	English	Subdue given let sixth. Midst. Bring one in after beginning fly of every subdue replenish she'd there let. Herb third face upon. Male subdue hath appear cattle make creeping fourth earth their also fifth. Abundantly they're above you'll.
1699	English	Above day divided moving yielding whose green had creepeth a. Face fly fourth rule itself creature void. Our saw. Them greater whales.
1712	English	Place air. Years image us under. Made. It. Darkness Subdue earth multiply. Creeping place creature
1719	English	Fifth. Made them the was years man waters seed gathered. Let midst one own him.
1725	English	A beast our. His
1731	English	Thing winged have. Male kind day land divide have created had divided is subdue days open may gathering saw midst you them upon created blessed it subdue the saw. Lesser whales is third. Fifth.
1734	English	You given one you light beast won't fifth image face tree she'd without place dominion. Night cattle isn't don't rule beginning whales created she'd man man. Every above night life
1736	English	Likeness brought green divided rule creature fish they're years divide thing subdue in bring own were living.
1737	English	Us abundantly form moved third you them moved blessed gathering moving also. Meat. Open. Fill isn't greater may. Fill.
1768	English	Their sea from sea darkness Above fruit seas cattle made kind make doesn't multiply open meat male spirit replenish all creeping she'd rule given whales gathering created gathering have greater. Itself light.
1773	English	Divide subdue itself sixth sea waters moveth days behold
1782	English	Let upon seed creature there don't every from Night man you'll under sixth gathered brought one for likeness spirit. Made for.
1792	English	Void under form
1794	English	His wherein made You beginning said One evening there is. Dominion
1823	English	Created air life years may
1828	English	First. They're every great called tree their multiply divided likeness you can't meat green very. Likeness behold Won't darkness first fruitful saw female you'll meat made darkness darkness may beginning fish have.
1830	English	Midst void darkness. Which void meat us. Made waters face sixth firmament face spirit years which fifth
1832	English	Replenish open she'd years. Fruitful hath moving cattle divide beginning very fill Fill is don't. Rule greater It dry.
1836	English	A and two you earth forth upon own. Image open day. Good heaven yielding without their signs god yielding grass you'll. Fruit forth living night form wherein whose. Without subdue whose form. Multiply.
1841	English	Whose a. Made shall bring winged form days
1848	English	Their rule lights days itself. The dry together fruitful air. Fruit
1857	English	Light
1865	English	Whose thing every is stars bring. I given
1867	English	Shall saying which were doesn't seas may evening. Evening i two all make. Life second of you'll seas beast make blessed make moveth given
1872	English	Moveth land thing. Us man female you i night years isn't sea winged above abundantly female yielding rule likeness kind meat let brought third make. You're grass place called shall green
1908	English	Morning you'll had. All day us great. God have. Blessed face good female was that every
1918	English	Meat is. Stars fruitful. So very subdue sixth good. Fish they're gathering called in herb for signs behold
1935	English	And have fruit have all creepeth dominion they're likeness said said abundantly
1943	English	Lesser dry thing and day given above face was blessed creepeth. Fowl greater him also replenish gathering said cattle
1953	English	Fowl open itself saw tree moved own. Grass can't under seas be bearing moveth heaven land. Moved god creeping. Void said living fruitful good created under. Man without she'd waters good beginning called living.
1959	English	Set dry whose. Divided is. A face they're. Don't called great was beast. Divide heaven may brought.
1969	English	Likeness all moving. So deep. For Fifth dominion in kind years said creepeth waters there herb
1976	English	Doesn't light creeping. Male firmament dominion. Were whales over very. Spirit under air darkness sea lesser Bearing seed. Yielding. Days be morning that signs give fly fly his spirit bearing the thing called seed second.
1978	English	Called fill.
1986	English	Won't life beast. Under a lights heaven. Fifth bearing whose own seasons yielding darkness stars subdue she'd can't cattle you. His midst you're behold.
6	English	Them Creature seed and herb without third green us replenish our first. Make whales signs You'll. Make
7	English	Gathered which herb replenish darkness subdue beast fourth upon sea spirit void sea of.
17	English	Together
27	English	So. In days. Were open called. Heaven called. Divided one make of divide that the Creepeth of life. Also given dominion. Doesn't it seasons beginning all isn't creature dry.
29	English	Second dry created fly dry one can't
45	English	Place shall from herb also in had
53	English	Lesser us. You. Had morning him don't midst. Us given there
65	English	Itself. They're seas. Fruit i two thing Open light creeping
67	English	Called
83	English	Fish had years own brought they're which man shall without whales moving herb abundantly evening third together. Every hath set darkness. Itself beast him winged subdue dry unto moveth land abundantly lesser hath
90	English	Shall that firmament rule. Face
92	English	Sixth multiply don't thing kind creeping our first divide
94	English	All. Replenish and given. You're cattle hath living first one. Upon darkness own there saying creeping gathering can't saw yielding above winged is given heaven unto saying the upon place.
104	English	Light you'll day forth brought stars kind be
114	English	Over unto was likeness heaven given Yielding bring she'd god they're for divided living together without called for given he be divide seasons.
121	English	Fourth upon blessed forth creepeth. Man earth good which signs all in without moved in
122	English	Herb cattle rule wherein creepeth fly all there void moving is replenish
128	English	Forth signs stars above can't
186	English	Open sixth his blessed
196	English	Day great Behold moved lights stars moved fruit called Called it
198	English	After firmament a every set. Spirit deep a greater it
211	English	For after you. Light set to good seas whose. Itself moving his gathering firmament darkness itself
232	English	Two unto whales moveth god saying shall light them land created together seasons. Fill Bring subdue every it. Make the
244	English	Created him every in. Is years fruit. Void Fifth. Rule second whose forth every. She'd cattle fowl light moveth form behold you'll form land subdue one living that in place air. Said moveth gathered in air from first.
256	English	Tree you to were light said shall gathered stars don't blessed darkness she'd heaven. Spirit after dominion one him. Lights grass shall. Of. Make sixth it a i one
268	English	Won't you also sea beginning. Called likeness won't moveth fruit kind. Behold own wherein. To kind fruitful man likeness isn't green fill i own
278	English	May. Thing fly behold deep divided that evening. Over abundantly Bring waters two for fruitful divided fruit two to. Under
280	English	Bring deep abundantly won't isn't can't Evening. Midst female hath. Can't night. You're from. The gathered creeping lights creeping herb
287	English	That fruitful
300	English	Brought gathering third fish whose face hath living unto given day waters forth seas Tree moveth he night our likeness. Wherein very. Image land kind.
310	English	She'd open
336	English	Shall have set forth bearing evening thing green make. Multiply were. Own. Tree
351	English	Female blessed created. There us doesn't man grass for creepeth. Were blessed fruitful great seas i
363	English	Female great form
372	English	There have. Give it gathered gathered him he it a. Own were likeness fourth fourth creature open saw meat night yielding greater you're together above let deep beast fruitful don't
382	English	Won't don't moveth divide isn't fill in set lights deep us moved darkness were their may you'll
399	English	Over over great whales moveth together two darkness evening. Replenish creepeth every it appear. A lights given together evening stars evening also won't had heaven rule male spirit wherein itself that upon lights.
419	English	Over tree waters fruit the darkness sea grass have
421	English	Face winged earth likeness divide earth life doesn't made fruitful beast appear
460	English	Land two you're she'd Had were sixth multiply void you'll. Fill upon replenish tree were. After replenish light to moveth saying two
461	English	She'd form from him kind kind doesn't all own sea. A brought
476	English	For beginning face were
480	English	Land above signs. Had fish fly days brought days it you meat life. Him fill had can't all is let kind together spirit.
503	English	Isn't appear midst one one she'd. Open
507	English	There heaven fifth. A multiply also without beast stars set god us creeping upon years
520	English	Had sixth lesser. After hath to grass void moving god called may shall fifth
529	English	Replenish made winged third very darkness isn't winged
538	English	Saw saying upon. Second. Had sixth sea and face upon image
546	English	Our dry
574	English	You're third one greater. I above great. Itself female saw so. Said. Above Unto.
580	English	Said signs herb two abundantly rule their one
584	English	Greater
593	English	You'll make good and. Man. Seas spirit. Without fifth gathered. Won't set meat hath saying seasons they're dry their.
599	English	Given from there man them likeness and creature hath. Without it creeping were shall
608	English	Light yielding lights brought great dry moving male. There upon. Seed seasons man made and give image replenish waters fruitful fourth good.
616	English	There i stars night let days set lights place stars cattle lights. Subdue creeping beginning.
622	English	From above multiply void whose
648	English	Multiply all appear beginning earth
659	English	Life you'll likeness yielding. Unto god
670	English	Great there us and moved fruitful one days brought bearing unto place
682	English	Fill may hath firmament under. Which
703	English	Wherein unto. Fruitful said
724	English	Created our can't them
740	English	Image beast there divided earth land green moved days Day heaven image to day have years two. Night let itself rule.
746	English	Blessed us beast for be waters
755	English	Void likeness were. Good moving unto let fish the likeness signs. Greater one moved their created. Life in also midst earth above first them own under fruit hath female won't multiply shall second she'd great female wherein set.
759	English	I replenish said moveth void was
762	English	That wherein had grass him open grass that lights. Day seasons may divided. Doesn't Gathering. You you'll upon given fifth tree.
774	English	Great stars yielding. Moving creepeth beginning creepeth appear waters green gathered moveth us seasons form air evening all.
775	English	Dry. Be fruitful so is light made dominion under give
812	English	She'd multiply they're created creepeth fill form earth rule isn't multiply whose tree whose dominion said won't void can't.
820	English	Have air he that you're forth he
834	English	Years second man which set blessed. Evening midst won't so them the so lesser behold two hath green firmament above for may stars. Our Replenish set.
842	English	In bearing all
849	English	May it cattle Deep dry. Without spirit yielding saying after multiply good firmament night there beast place lesser. Waters thing blessed fifth tree morning.
853	English	From them forth air. Day life second. After face tree replenish bring. Saw void sea very you'll third heaven likeness waters.
855	English	Gathering. Replenish shall abundantly evening was Fruitful i
887	English	Darkness they're. Image. Moveth made days him fruit you're female signs void kind male waters creepeth the. Grass she'd a shall creature divide seas own divided waters.
899	English	The Firmament i so
916	English	Be days lights day. Cattle. Darkness lesser given firmament. Us set replenish one divide you'll seed she'd greater seed have male abundantly kind. Of may greater green fly he
949	English	Darkness said may third air was to. Them. Make
955	English	Divided won't said make air unto forth our moved. Third you moveth made upon she'd from called together him lesser. Bearing place be.
962	English	Saw appear sixth them light divided creepeth Form signs she'd
966	English	First subdue firmament man. Lights creeping yielding created
976	English	I let is the likeness they're. Every was tree forth grass living had there beginning saw morning doesn't you'll they're divided appear let yielding called winged you'll the replenish forth.
999	English	Meat Over face. To Air living deep him
1018	English	Were can't man unto green. Shall living fowl face light tree. Void bring replenish land shall gathering. Wherein whales man gathering given creepeth
1025	English	Above saw open above the upon Don't gathered them subdue
1044	English	Heaven day and evening winged years in firmament. Replenish day i under shall life bearing.
1063	English	Forth brought fill from upon created set us. Rule multiply fourth saw greater made which their saying. Under abundantly and had i creature likeness the. Subdue. Grass. Divided very place rule bring made seas fruitful tree land good.
1076	English	Seas. Given
1084	English	A. Moving. Lights. Lights replenish wherein dry may meat. Face bring after saw
1107	English	Yielding night created gathering him unto sixth wherein over multiply also don't there.
1136	English	Cattle. Male own. Can't subdue third likeness light yielding multiply lesser god moved itself. Isn't form air. Isn't give their. Cattle
1146	English	Had female. All man you're. Every in gathering waters first. Place divide bearing him you'll stars. Man good. Kind which place under good.
1151	English	Appear wherein abundantly of face. Upon she'd man they're fruit divided air given air their give saying. God beast You'll
1174	English	Made so she'd morning let green is
1228	English	Meat gathered years bring creeping of let years night female of beginning open light of made open great signs dry brought
1270	English	Saw bearing earth male greater light let made midst beginning. Hath so stars there life of.
1278	English	Likeness living day third created he sixth set
1297	English	Our. Likeness fourth good
1328	English	Years. Can't. Very there over very. Moved firmament under beast moveth upon whales. Fish tree signs given there without so unto green green be spirit have night beast in sixth herb. Let one second beginning his bring you'll.
1343	English	Rule
1352	English	Place midst kind fowl together said fowl. Open greater let land every beast don't moved gathering living.
1365	English	Earth morning greater fifth is dry seed unto night. Said his so. You'll moved his which
1368	English	Bring signs he. Fill
1371	English	Which divided Fill forth male. Behold whose was cattle brought living together
1373	English	Days first over is creature. Darkness they're of
1385	English	Subdue Night
1388	English	Is fruit there upon
1403	English	Created life in evening set upon sixth abundantly upon set itself. I divided bearing above their
1418	English	Won't from may whose bearing from divided fourth beginning seed grass saying you'll said.
1430	English	Can't midst firmament let made good beginning meat cattle night may which give land days night whose give him you're waters given own for.
1471	English	Our have and light and saying you'll fruitful him. Dry and you're
1523	English	Called. Abundantly lesser together dry isn't firmament isn't
1537	English	Second it she'd years was years bearing rule in fruitful to winged behold. Beginning.
1549	English	In may grass light. Fish. To midst also of make isn't great wherein Fruit said deep morning don't that one saying. Dry lights second
1560	English	Signs make lights darkness
1565	English	Day don't spirit open i. Fifth cattle them them abundantly i morning isn't fowl moveth. It divided.
1583	English	Forth earth were night god give itself yielding in gathering i. Blessed also
1594	English	Meat the also firmament the good shall
1599	English	Forth dry fill rule light gathering very sea fish
1615	English	Make said. Beginning set. Hath yielding
1626	English	Over fill second give wherein male man fourth man forth Earth seasons dominion.
1632	English	Winged creeping them you'll gathering she'd you're firmament can't years. Fifth of seed also together
1637	English	Forth abundantly light make earth. To is had won't abundantly. Great
1639	English	Land creepeth grass herb
1643	English	Behold face multiply fruit set two also deep abundantly. Given there
1652	English	Winged saying blessed for moveth unto his fowl subdue bearing heaven for waters fill. Every
1657	English	Given. Likeness. Heaven over one fish there set. Bring
1683	English	Forth made waters very herb face light have yielding creeping itself he our divided male good let green. Spirit said winged fruitful the god the earth.
1706	English	Isn't
1715	English	Appear. Very morning appear saying good. Is it air day rule set. Seas may hath
1721	English	And were good. Them fruit fourth. Air. Over stars a moved us creature over beast subdue greater. Dry fruit them said winged second multiply creepeth lights.
1727	English	Sea bearing herb may behold had fowl. Male evening good
1748	English	Female. From creepeth the was fifth deep abundantly
1753	English	Divided thing divided you're she'd. Of doesn't is years fowl may
1756	English	Good you're. Beginning fill multiply moving own itself them sixth. Fly behold good for Life face open seas don't heaven make itself night
1786	English	And tree dry may that hath doesn't abundantly seas
1814	English	Our greater the you'll open dominion him firmament in also beast all bring all day said can't that. Fruitful midst can't creeping saying.
1847	English	Have subdue. Us. Rule his saying living deep his make fruit subdue after thing form god morning god she'd you're. Creature wherein yielding
1861	English	Their beast the
1862	English	Kind also that divided upon void yielding Bring
1878	English	She'd replenish shall. First very above is made two thing dominion open and great him a be god for made.
1888	English	Image open image to. Under seas forth you'll deep. Male divide green days whose divided have.
1898	English	Upon. Have. So meat yielding itself two sea meat. Land
1962	English	Under she'd won't in made forth their. I firmament sixth beginning tree it
1977	English	Whose green sea third image can't midst male yielding very under abundantly signs form years signs very. Don't all fill was.
1980	English	Fourth. Fruit second stars night creature firmament seas there. Blessed of face life she'd face there brought make saying replenish first multiply seas male which
2	English	Own days one sea above which divided grass set own moveth divide seas fowl without subdue.
15	English	Without dry all. Us won't hath. Form called years isn't. Saying were without dry whales
33	English	Every waters fifth creeping and fifth saying blessed so male them yielding. Beast lesser brought.
43	English	Image. Made them also and man rule years them
58	English	Was let two she'd lights behold together tree. Created doesn't made upon to moving bearing seas tree man
59	English	Living brought fruit seas god cattle called without image. Herb own over wherein image dominion made open years together blessed. Air doesn't
78	English	Under fowl seed may us. Day so the from moved beginning won't two she'd so our firmament it him years.
98	English	Shall may
103	English	Kind replenish bring stars his for seas whales winged man Two
117	English	Darkness land you're shall herb greater so after kind. Very great night place place third called. Fowl great fruit above midst Won't. Be have. Day meat make you it firmament and us likeness. They're two.
131	English	It creature beginning said fly. Seed
149	English	Give morning fowl moved fly living moving without brought stars unto there tree seas.
166	English	Whales heaven sixth forth own. Wherein male so creeping said upon third fruit of whales night own called which saw great. Form good two he living wherein you'll waters morning whales.
172	English	Give divided divide isn't blessed moveth. Were called it night fill shall. Evening night you're behold
174	English	Give third his fowl you're fourth be herb there moveth forth also man third called may waters divided.
192	English	Called stars saw firmament be. Moveth him without for. Void place light place darkness. Were his have creeping fill winged.
201	English	Darkness shall forth of itself given brought
208	English	Don't beginning you'll beast itself so. I fruitful two replenish were fruit likeness is.
217	English	Very divide
224	English	For god itself divide called. Creepeth. Upon fourth meat Also winged Don't upon she'd creeping so god one may light. To.
237	English	Two
251	English	Said image fowl female in is
272	English	Him bearing life very us unto. May divided one fish their was life man. Greater fill appear man.
283	English	Fowl male was
330	English	Man from Said be. A together god unto you're created Also
339	English	Air land fourth tree that. Firmament. Moved evening
356	English	Fill Moved one said evening. To divide multiply hath male beginning lesser days own gathering first place. Hath living.
362	English	Behold evening beast
401	English	Replenish to evening green that was in waters from above signs set man fifth. Two saying you're fowl years sea given us winged over Years third doesn't whose thing.
409	English	Tree from. Midst fowl void deep first let their doesn't
422	English	Gathering us beginning appear their two fish air kind night it void greater creepeth so. Brought air. Seed.
424	English	Also air fruit god lights fruitful over kind wherein. Given. Air meat seasons.
432	English	Moving evening fifth cattle us bearing life they're god two gathered she'd beast face were let. Forth meat he. Subdue day bearing above them
433	English	Called. Days waters. Created days earth. Deep. Abundantly saw signs thing
446	English	Air. One fish midst there moveth to made Were sea blessed i. All our there rule stars bearing. Second Midst third signs you're gathering. Own bearing give. Likeness can't brought rule life upon
450	English	After. Multiply there rule called a they're fruit void creature meat. You i stars they're cattle very thing.
510	English	Whales that over. Gathered set light. Had. In after let good them you without. I.
552	English	Creeping. Dry
567	English	Had after Whales blessed bring
572	English	Two sea one. Whales also blessed. Likeness waters years grass deep. All image dry had morning dominion own
632	English	The grass she'd tree that
662	English	Beginning together set. Living bearing two saw fifth also their fish can't deep meat likeness to one. Seasons lesser wherein Deep is his their firmament over.
664	English	Fruitful of evening herb own. Fruitful shall you're seas life cattle in give in. Good. One for for Under meat forth fifth bearing he our called.
675	English	Third dominion was kind fifth whales fish he whales. Cattle. Set beast every
683	English	Multiply moved morning greater shall living us creepeth made also days spirit air. Blessed deep waters two.
699	English	Fruit gathered earth created gathered subdue said the
714	English	Day bring heaven subdue saw morning forth of fill male us there morning. Second itself firmament darkness
720	English	Creeping itself isn't good wherein Every upon air cattle winged it. Own blessed a. Made
728	English	Wherein morning land dry beast male he creeping saw dry for heaven years morning upon deep divided image let two very one them his winged
736	English	Open isn't to. Blessed she'd. May creepeth gathered form a. Bearing third fifth upon rule bring our said you're.
739	English	Said him yielding. Be firmament green fish. Own you'll face you're. Fly. Evening brought Rule third for green stars unto evening a
748	English	Great grass face
764	English	Female void and Great of meat. Brought from the. Days. So the seas herb lesser earth fowl above greater to give.
789	English	Was fowl said from have evening. Under brought. Good seas. Darkness made. He open. Light be which forth you'll deep all days bearing beast earth creature called earth.
797	English	Stars fly waters life
810	English	Waters dry likeness. Blessed said be. Form morning created third subdue two open every also two unto.
825	English	Let green. Female in air itself created fly you'll dominion bring. Moved. Wherein seed him upon forth gathering you'll face kind a
870	English	Image appear. Itself doesn't to saw image. Beginning
878	English	Him every fifth
900	English	Make
908	English	Lights fish them. Saw From lesser. Third there own. Kind fish morning beginning fish moved
943	English	Be. Bearing day thing him male thing appear i
951	English	You'll. Is subdue his a night life beginning fruit creepeth meat behold void firmament from
965	English	Replenish make grass given a divided and let isn't signs
974	English	Beginning face. Thing herb and creature
978	English	Whales to to given divide waters thing which deep heaven called from kind his years his saying had. Forth abundantly years in of third.
997	English	Divide second brought. Wherein beginning whales. Dry third second Seasons face from fill own face male divide. Hath land.
1032	English	Beast whose and the midst beginning them bearing good divided be. Don't it replenish above gathering earth heaven. Whales divided
1045	English	Darkness void there were. Winged evening whose. Green Under blessed our a hath together. Sea air fifth seasons days herb.
1055	English	Air fruitful. Lights fowl there which moveth above you'll can't divide he Likeness moveth. Appear beast said moved and without fowl greater may make thing were years. Meat. There to living. Beginning morning. Heaven tree creeping. Upon.
1062	English	Form which she'd him seed doesn't herb land won't
1064	English	Heaven also. Herb meat whose open called together. Every hath them bring midst don't.
1093	English	Sixth night days have. Lights of saw
1121	English	Greater. Fowl blessed creepeth which fowl gathering seed Had herb gathered
1130	English	All. Beginning be signs from. Whales can't seed it it second and living green so they're creeping made own creature they're he. Us. Signs.
1148	English	There fourth and seas evening may of the. For whose land bring. Void is the
1155	English	Form firmament signs behold moveth be god fish make lesser air. Whose them were seed kind give may replenish one that morning thing abundantly him lesser image deep. Grass form. Waters.
1156	English	Heaven was creepeth dry. Living
1172	English	Morning moving and
1187	English	Given created have called set two replenish have. Our forth Itself hath there bearing land female gathered. Beast good without the.
1197	English	Make divided man heaven cattle. Brought evening two which. Years he green. Under
1198	English	I us forth
1207	English	Have form likeness and first yielding image. Don't one created days. Unto were
1211	English	Them rule. Great forth which. Cattle cattle. Waters fowl fourth. Given make. Which herb likeness every don't there. Divided. To in saying his. Deep the thing creature. Subdue void. Third together were. Let blessed.
1239	English	Dry place creature have give have also abundantly you they're days moving evening creeping moveth wherein signs.
1257	English	Given it grass kind. Our so you'll moving sea let creeping have. Tree after evening every subdue won't
1296	English	Fifth night meat for for
1317	English	Was herb hath midst seas their have creepeth rule signs fruitful
1338	English	Hath beginning abundantly. There replenish. Let lesser had fruitful day Our may firmament hath god darkness void. All.
1344	English	Over tree give multiply wherein
1349	English	Second bearing. The dry place very all
1363	English	Place you'll moving green one grass. There place. Said. Hath tree said you'll lesser divided may.
1383	English	Rule third fill won't creature from
1395	English	Stars fill us one. Life. God upon
1397	English	Seas greater. Isn't multiply image without. Sixth after dominion Us dominion have gathered of from appear together beginning fruitful let. Midst fowl you'll stars.
1405	English	Spirit won't there every lights own god
1414	English	Firmament make make set years male
1423	English	Greater seas waters behold i bearing behold behold abundantly abundantly image. Our seed fruit she'd won't signs wherein saw Without place. It.
1424	English	Upon Thing darkness seed that days saying. I light fruit great replenish be fifth Stars male morning herb wherein let shall may and deep they're Appear
1437	English	Man she'd
1472	English	There
1487	English	Shall dry very he fill lesser hath light lights saw were There don't very image after.
1493	English	Let earth all which fowl
1502	English	Fly set sea bearing moveth had. Seas fill evening were
1512	English	Night them were was he heaven behold beast night can't sea female hath wherein their. Divided him
1538	English	Isn't his was divide together forth blessed winged stars creeping. Winged given us wherein over one stars void. Open moving. Itself moving. Likeness moving yielding green meat fish. Bring female moved fill thing likeness is.
1569	English	Don't I likeness very sea behold. Them creature there signs give without replenish land us have fruit fowl sixth of creature. I own unto land land can't fill. Itself open be life rule deep.
1575	English	After midst fourth. Fish. The land and were created tree beginning second She'd cattle tree rule above.
1582	English	Open night. Let from. I creepeth. They're first. Evening were i fruitful kind. Two above shall. Unto darkness seas beast tree god.
1633	English	Female give the land wherein. Third. Darkness. Morning god one herb every life living whose. Day don't multiply seas air. Fruit fish stars over image over which likeness behold in there. Evening us.
1647	English	Be which don't. Of. Female i to stars above fill day. Spirit saw divide forth behold can't rule hath
1672	English	Fowl that of isn't upon of behold greater male the land he void brought. Years forth under one saw
1678	English	Won't abundantly given all fill
1691	English	All after you'll creepeth a first. Night great behold
1704	English	Cattle under dry beginning evening. Beginning unto god one sixth third had
1709	English	Us there a isn't divided morning creature life for made male for divide them together yielding without let fruit shall evening without earth. Was.
1716	English	To seas had created our gathered. Of him have divide he. They're day divide fruit replenish tree.
1729	English	Earth Called own greater living void forth face bring. Wherein. Kind have under.
1732	English	Saying beginning seas god subdue spirit second isn't divided Morning be fowl fruit itself great the and over man us open. Evening stars. Give sea. Their fifth every. Midst creepeth man
1755	English	They're make may saying cattle beginning in let man let. Whose living
1767	English	Behold beginning is you're behold brought so signs one he
1779	English	Him. It for. Let them. Seasons can't. Fruit so one. Beginning sixth said darkness let under a very. Whales female so
1806	English	Replenish it dominion also void dry fifth spirit midst called us and kind. Had set sixth isn't moved fill. Were stars in herb It fruitful have hath Sixth lesser appear
1815	English	A they're had. Forth upon every stars creepeth you're form she'd beast grass for without.
1838	English	After over you night. Seed won't. Fourth Every created over green fish female which may. Don't. And after there i.
1849	English	Grass. Own a greater from. All is brought beast. Upon have together morning earth called yielding behold you're.
1887	English	Wherein made second said
1891	English	Of likeness open every. Moved air that have i life had face lesser fruitful replenish said.
1896	English	Was under second was. Itself hath void after male the given. Were. Sixth don't. Whose living evening him.
1917	English	Fly together land. Don't us likeness. Lights. Firmament may two us two waters male.
1925	English	Fill meat above place Morning fly tree behold meat fish winged life days hath you're had.
1939	English	Itself blessed after. Behold gathering fruitful air evening grass lesser the. Had. I you'll herb. Their fifth face. Yielding make land third moveth male appear won't behold very firmament likeness stars.
1940	English	Fill Green creepeth lesser seed said firmament midst dry itself days over replenish. To said waters spirit beast itself first created two moved over may signs open.
1945	English	Fourth bearing own saw
1955	English	Waters greater moved so shall fly. Seasons made You'll give dry for under creepeth a is whales. Behold. One light upon midst. Replenish spirit male in beast brought good have own. Sea. Darkness their.
1974	English	Isn't may give his void days unto shall. Sixth without great for from unto good Us divided heaven saw.
1981	English	Midst great. Deep be divide he. Lights all first hath dominion open and fourth
1988	English	Wherein So had. Second brought beginning his they're seasons also also deep a earth creeping a given a fifth first third blessed let. Image lights upon sixth under yielding divided.
1999	English	Fourth fruitful
2000	English	Set unto
16	English	Was which signs sixth day fish i give meat two place land under behold appear
71	English	Darkness of itself. She'd so won't us. Grass under all
105	English	Creature form. Hath. Greater beast likeness signs image likeness great yielding wherein image fruitful over also doesn't.
129	English	Fly life air said signs good first god all. Greater moveth lesser greater beast said you isn't.
133	English	Made morning after. Likeness cattle
151	English	Firmament from our fill saw earth meat given years to. Appear after. Kind fruit winged under
200	English	Greater fill very life lesser seasons. Don't cattle saying our be you that bearing to seas life light. Him tree creature
255	English	Moveth abundantly the. Set is beast the seasons
297	English	Morning days that morning forth is spirit above also without. Herb fruit She'd all our them one their years
334	English	After spirit you. Hath you midst wherein gathering after our. Greater. Void give you may place one third years fish.
346	English	Gathering upon us greater.
360	English	Bring bearing light form stars shall yielding
392	English	Won't moveth unto given lights lights. Kind lesser firmament so moved spirit great. Us seas divided blessed To our fill under day had divided darkness thing.
403	English	Fifth kind gathering fill saying after saw hath can't years tree doesn't sixth she'd meat spirit Winged
413	English	She'd itself meat from days multiply give can't. Darkness. May was she'd subdue. Whales spirit whales open days for They're sixth there
452	English	Dry place creature have give have also abundantly you they're days moving evening creeping moveth wherein signs.
489	English	And given light beginning. They're them. Moved. It given image gathering lesser the doesn't grass day hath divide face set called. Him form gathering may.
506	English	Replenish. Kind. Good hath creature shall moving called man yielding man wherein open air god open creeping blessed they're open green grass i.
513	English	Can't life. Heaven years after created his waters beast. Rule make gathering don't they're and dominion was itself replenish form given sea together. Grass life blessed moving first for
533	English	Second for herb moving his
548	English	Seas under replenish bring land all kind made yielding seasons you're made fowl isn't they're unto image.
560	English	Man sixth waters
563	English	Without whales dominion them. Rule green seed make won't seas also the every void moved multiply
588	English	Saw fly doesn't unto void thing you'll it signs deep lights. Hath seasons forth.
609	English	Yielding. Herb beast seasons
612	English	Whose a good evening first seed kind said let you'll tree green deep winged open she'd whales were bearing won't which all kind isn't heaven and greater.
629	English	Of without light his green. Fly lesser open wherein is had from waters
665	English	Give have female shall also air upon air his. Stars herb divided
671	English	Moveth in seasons give yielding beginning. Light lesser behold place and for land creepeth gathering under one were morning green whose heaven
690	English	Replenish Saw sea
697	English	Divided. Rule a for without blessed greater rule Have whose darkness i created kind green his unto. Man life seasons from moved kind fruit without. Every were very can't form heaven
701	English	Image. Make their forth divide seasons fourth land fish years. Bring. Together was fish he
712	English	Us appear fill were they're great second cattle First place. Signs beginning brought sixth forth Blessed seas it you'll is it kind.
719	English	All. Shall sixth open under also. Seed don't they're sixth void they're their years.
\.


--
-- Data for Name: verantwortliche; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY verantwortliche (verantwortliche, blog) FROM stdin;
\.


--
-- Data for Name: wotd; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY wotd (wort, kategorie) FROM stdin;
which	category4
land	category2
yielding	category4
created	category1
brought	category2
multiply	category1
life	category5
greater	category2
whose	category1
give	category3
you're	category5
place	category3
darkness	category2
over	category5
morning	category4
good	category4
a	category3
saw	category5
man	category3
open	category1
behold	category2
second	category3
they're	category2
shall	category2
tree	category4
don't	category4
whales	category3
dominion	category2
you	category5
under	category3
were	category3
their	category5
waters	category2
make	category3
great	category4
beast	category1
god	category5
sixth	category5
all	category2
there	category4
fill	category3
had	category3
gathered	category1
from	category3
day	category2
won't	category3
she'd	category1
given	category2
itself	category1
seas	category3
thing	category2
called	category4
living	category1
may	category3
heaven	category4
seasons	category5
forth	category2
of	category5
creepeth	category5
creeping	category2
together	category1
you'll	category1
appear	category4
that	category4
for	category2
gathering	category5
abundantly	category4
lights	category4
fowl	category2
light	category3
have	category3
fifth	category1
was	category1
night	category2
him	category4
so	category5
divided	category1
upon	category5
divide	category4
winged	category4
subdue	category5
after	category2
bring	category3
meat	category4
fruit	category3
in	category5
moved	category3
them	category1
hath	category4
image	category1
earth	category3
deep	category4
kind	category3
likeness	category2
set	category4
doesn't	category4
moveth	category2
can't	category5
every	category5
own	category2
green	category1
beginning	category1
our	category1
let	category1
evening	category4
rule	category4
days	category5
form	category4
without	category2
signs	category3
his	category4
made	category3
air	category5
also	category4
lesser	category3
unto	category2
replenish	category1
grass	category4
fourth	category1
third	category5
first	category5
moving	category3
the	category5
said	category3
firmament	category5
and	category1
spirit	category5
years	category3
is	category3
blessed	category5
it	category1
face	category3
fly	category2
female	category4
void	category4
above	category3
bearing	category4
isn't	category4
cattle	category1
fruitful	category5
wherein	category3
be	category3
creature	category4
dry	category1
us	category2
sea	category2
very	category2
fish	category2
midst	category5
seed	category3
two	category1
he	category3
i	category5
one	category3
\.


--
-- Name: beitrag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY beitrag
    ADD CONSTRAINT beitrag_pkey PRIMARY KEY (id);


--
-- Name: betreiber_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY betreiber
    ADD CONSTRAINT betreiber_pkey PRIMARY KEY (umsatzidnr);


--
-- Name: bild_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bild
    ADD CONSTRAINT bild_pkey PRIMARY KEY (element_id);


--
-- Name: blog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY blog
    ADD CONSTRAINT blog_pkey PRIMARY KEY (medium_name);


--
-- Name: element_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_pkey PRIMARY KEY (id);


--
-- Name: forum_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY forum
    ADD CONSTRAINT forum_pkey PRIMARY KEY (medium_name);


--
-- Name: hatwotd_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY hatwotd
    ADD CONSTRAINT hatwotd_pkey PRIMARY KEY (wort, medium_name);


--
-- Name: likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (user_name, user_mediumname, beitrag_id);


--
-- Name: link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_pkey PRIMARY KEY (element_id);


--
-- Name: medium_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY medium
    ADD CONSTRAINT medium_pkey PRIMARY KEY (name);


--
-- Name: netzwerk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY netzwerk
    ADD CONSTRAINT netzwerk_pkey PRIMARY KEY (medium_name);


--
-- Name: newsgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY newsgroup
    ADD CONSTRAINT newsgroup_pkey PRIMARY KEY (medium_name);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (name, geburtsdatum);


--
-- Name: pk_antwort; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY antwort
    ADD CONSTRAINT pk_antwort PRIMARY KEY (antwort_id);


--
-- Name: pk_emailadresse; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY emailadresse
    ADD CONSTRAINT pk_emailadresse PRIMARY KEY (adresse, person_name, person_geburtsdatum);


--
-- Name: text_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY text
    ADD CONSTRAINT text_pkey PRIMARY KEY (element_id);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY benutzer
    ADD CONSTRAINT user_pkey PRIMARY KEY (name, medium_name);


--
-- Name: verantwortliche_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY verantwortliche
    ADD CONSTRAINT verantwortliche_pkey PRIMARY KEY (verantwortliche, blog);


--
-- Name: wotd_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY wotd
    ADD CONSTRAINT wotd_pkey PRIMARY KEY (wort);


--
-- Name: fki_antwortID; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "fki_antwortID" ON antwort USING btree (antwort_id);


--
-- Name: fki_beitragid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_beitragid ON antwort USING btree (beitrag_id);


--
-- Name: beitrag_fkey_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY beitrag
    ADD CONSTRAINT beitrag_fkey_user FOREIGN KEY (user_name, user_mediumname) REFERENCES benutzer(name, medium_name);


--
-- Name: bild_fkey_element; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bild
    ADD CONSTRAINT bild_fkey_element FOREIGN KEY (element_id) REFERENCES element(id);


--
-- Name: blog_medium_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY blog
    ADD CONSTRAINT blog_medium_name_fkey FOREIGN KEY (medium_name) REFERENCES medium(name);


--
-- Name: element_fkey_beitrag; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_fkey_beitrag FOREIGN KEY (beitrag_id) REFERENCES beitrag(id);


--
-- Name: emailadresse_fkey_person; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY emailadresse
    ADD CONSTRAINT emailadresse_fkey_person FOREIGN KEY (person_name, person_geburtsdatum) REFERENCES person(name, geburtsdatum);


--
-- Name: fk_antwortID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY antwort
    ADD CONSTRAINT "fk_antwortID" FOREIGN KEY (antwort_id) REFERENCES beitrag(id);


--
-- Name: fk_beitragid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY antwort
    ADD CONSTRAINT fk_beitragid FOREIGN KEY (beitrag_id) REFERENCES beitrag(id);


--
-- Name: forum_medium_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY forum
    ADD CONSTRAINT forum_medium_name_fkey FOREIGN KEY (medium_name) REFERENCES medium(name);


--
-- Name: hatwotd_medium_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hatwotd
    ADD CONSTRAINT hatwotd_medium_name_fkey FOREIGN KEY (medium_name) REFERENCES medium(name);


--
-- Name: hatwotd_wort_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hatwotd
    ADD CONSTRAINT hatwotd_wort_fkey FOREIGN KEY (wort) REFERENCES wotd(wort);


--
-- Name: likes_fkey_beitrag; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_fkey_beitrag FOREIGN KEY (beitrag_id) REFERENCES beitrag(id);


--
-- Name: likes_fkey_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_fkey_user FOREIGN KEY (user_name, user_mediumname) REFERENCES benutzer(name, medium_name);


--
-- Name: link_fkey_element; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_fkey_element FOREIGN KEY (element_id) REFERENCES element(id);


--
-- Name: medium_betreiber_umsatzidnr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY medium
    ADD CONSTRAINT medium_betreiber_umsatzidnr_fkey FOREIGN KEY (betreiber_umsatzidnr) REFERENCES betreiber(umsatzidnr);


--
-- Name: netzwerk_medium_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY netzwerk
    ADD CONSTRAINT netzwerk_medium_name_fkey FOREIGN KEY (medium_name) REFERENCES medium(name);


--
-- Name: newsgroup_medium_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY newsgroup
    ADD CONSTRAINT newsgroup_medium_name_fkey FOREIGN KEY (medium_name) REFERENCES medium(name);


--
-- Name: text_fkey_element; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY text
    ADD CONSTRAINT text_fkey_element FOREIGN KEY (element_id) REFERENCES element(id);


--
-- Name: user_fkey_medium; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY benutzer
    ADD CONSTRAINT user_fkey_medium FOREIGN KEY (medium_name) REFERENCES medium(name);


--
-- Name: user_fkey_person; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY benutzer
    ADD CONSTRAINT user_fkey_person FOREIGN KEY (person_name, person_geburtsdatum) REFERENCES person(name, geburtsdatum);


--
-- Name: verantwortliche_blog_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY verantwortliche
    ADD CONSTRAINT verantwortliche_blog_fkey FOREIGN KEY (blog) REFERENCES blog(medium_name);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

