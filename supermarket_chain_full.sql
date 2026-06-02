--
-- PostgreSQL database dump
--

\restrict Prvssis2sWtvSqg4vRZvWQ3j1r88uinSa2K51XQ0aIdPIGqxftR1He7QiB7vYc8

-- Dumped from database version 17.10 (6a49db4)
-- Dumped by pg_dump version 18.3 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: supermarket_chain; Type: SCHEMA; Schema: -; Owner: neondb_owner
--

CREATE SCHEMA supermarket_chain;


ALTER SCHEMA supermarket_chain OWNER TO neondb_owner;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: playing_with_neon; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.playing_with_neon (
    id integer NOT NULL,
    name text NOT NULL,
    value real
);


ALTER TABLE public.playing_with_neon OWNER TO neondb_owner;

--
-- Name: playing_with_neon_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.playing_with_neon_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.playing_with_neon_id_seq OWNER TO neondb_owner;

--
-- Name: playing_with_neon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.playing_with_neon_id_seq OWNED BY public.playing_with_neon.id;


--
-- Name: availability; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.availability (
    branch_code integer NOT NULL,
    product_code integer NOT NULL,
    quantity integer NOT NULL,
    local_price numeric(6,2) NOT NULL,
    CONSTRAINT availability_local_price_check CHECK ((local_price > (0)::numeric)),
    CONSTRAINT availability_quantity_check CHECK ((quantity >= 0))
);


ALTER TABLE supermarket_chain.availability OWNER TO neondb_owner;

--
-- Name: branches; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.branches (
    branch_code integer NOT NULL,
    phone character varying(20) NOT NULL,
    city character varying(100) NOT NULL,
    street character varying(150) NOT NULL,
    postal_code character varying(10) NOT NULL,
    number character varying(10) NOT NULL
);


ALTER TABLE supermarket_chain.branches OWNER TO neondb_owner;

--
-- Name: customer_phones; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.customer_phones (
    loyalty_card_id integer NOT NULL,
    phone_number character varying(20) NOT NULL
);


ALTER TABLE supermarket_chain.customer_phones OWNER TO neondb_owner;

--
-- Name: customers; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.customers (
    loyalty_card_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    accumulated_points integer DEFAULT 0,
    CONSTRAINT customers_accumulated_points_check CHECK ((accumulated_points >= 0))
);


ALTER TABLE supermarket_chain.customers OWNER TO neondb_owner;

--
-- Name: departments; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.departments (
    department_code character(3) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE supermarket_chain.departments OWNER TO neondb_owner;

--
-- Name: employees; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.employees (
    employee_code integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    ssn character(16) NOT NULL,
    role character varying(50) NOT NULL,
    gender character(1),
    contract_type character varying(50),
    branch_code integer NOT NULL,
    department_code character(3) NOT NULL,
    CONSTRAINT employees_gender_check CHECK ((gender = ANY (ARRAY['M'::bpchar, 'F'::bpchar, 'X'::bpchar])))
);


ALTER TABLE supermarket_chain.employees OWNER TO neondb_owner;

--
-- Name: procurements; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.procurements (
    supplier_code integer NOT NULL,
    product_code integer NOT NULL,
    branch_code integer NOT NULL,
    quantity integer NOT NULL,
    local_price numeric(6,2) NOT NULL,
    CONSTRAINT procurements_local_price_check CHECK ((local_price > (0)::numeric)),
    CONSTRAINT procurements_quantity_check CHECK ((quantity >= 0))
);


ALTER TABLE supermarket_chain.procurements OWNER TO neondb_owner;

--
-- Name: products; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.products (
    product_code integer NOT NULL,
    category character varying(100) NOT NULL,
    detail character varying(150),
    brand character varying(100),
    standard_price numeric(6,2) NOT NULL,
    department_code character(3) NOT NULL,
    CONSTRAINT products_standard_price_check CHECK ((standard_price > (0)::numeric))
);


ALTER TABLE supermarket_chain.products OWNER TO neondb_owner;

--
-- Name: purchases; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.purchases (
    loyalty_card_id integer NOT NULL,
    receipt_number integer NOT NULL
);


ALTER TABLE supermarket_chain.purchases OWNER TO neondb_owner;

--
-- Name: receipt_details; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.receipt_details (
    receipt_number integer NOT NULL,
    product_code integer NOT NULL,
    quantity integer NOT NULL,
    price numeric(6,2) NOT NULL,
    CONSTRAINT receipt_details_price_check CHECK ((price >= (0)::numeric)),
    CONSTRAINT receipt_details_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE supermarket_chain.receipt_details OWNER TO neondb_owner;

--
-- Name: receipts; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.receipts (
    receipt_number integer NOT NULL,
    receipt_date date DEFAULT CURRENT_DATE NOT NULL,
    receipt_hour integer NOT NULL,
    receipt_minute integer NOT NULL,
    receipt_second integer NOT NULL,
    total_amount numeric(8,2) DEFAULT 0.00,
    employee_code integer NOT NULL,
    CONSTRAINT receipts_receipt_hour_check CHECK (((receipt_hour >= 0) AND (receipt_hour <= 23))),
    CONSTRAINT receipts_receipt_minute_check CHECK (((receipt_minute >= 0) AND (receipt_minute <= 59))),
    CONSTRAINT receipts_receipt_second_check CHECK (((receipt_second >= 0) AND (receipt_second <= 59))),
    CONSTRAINT receipts_total_amount_check CHECK ((total_amount >= (0)::numeric))
);


ALTER TABLE supermarket_chain.receipts OWNER TO neondb_owner;

--
-- Name: suppliers; Type: TABLE; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE TABLE supermarket_chain.suppliers (
    supplier_code integer NOT NULL,
    vat_number character(13) NOT NULL,
    company_name character varying(150) NOT NULL,
    headquarter_city character varying(100) NOT NULL
);


ALTER TABLE supermarket_chain.suppliers OWNER TO neondb_owner;

--
-- Name: v_procurements; Type: VIEW; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE VIEW supermarket_chain.v_procurements AS
 SELECT supplier_code,
    product_code,
    branch_code,
    quantity,
    local_price
   FROM supermarket_chain.procurements;


ALTER VIEW supermarket_chain.v_procurements OWNER TO neondb_owner;

--
-- Name: v_products; Type: VIEW; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE VIEW supermarket_chain.v_products AS
 SELECT product_code,
    category,
    detail,
    brand,
    standard_price,
    department_code
   FROM supermarket_chain.products;


ALTER VIEW supermarket_chain.v_products OWNER TO neondb_owner;

--
-- Name: v_purchases; Type: VIEW; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE VIEW supermarket_chain.v_purchases AS
 SELECT loyalty_card_id,
    receipt_number
   FROM supermarket_chain.purchases;


ALTER VIEW supermarket_chain.v_purchases OWNER TO neondb_owner;

--
-- Name: v_receipt_details; Type: VIEW; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE VIEW supermarket_chain.v_receipt_details AS
 SELECT receipt_number,
    product_code,
    quantity,
    price
   FROM supermarket_chain.receipt_details;


ALTER VIEW supermarket_chain.v_receipt_details OWNER TO neondb_owner;

--
-- Name: v_receipts; Type: VIEW; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE VIEW supermarket_chain.v_receipts AS
 SELECT receipt_number,
    receipt_date,
    receipt_hour,
    receipt_minute,
    receipt_second,
    total_amount,
    employee_code
   FROM supermarket_chain.receipts;


ALTER VIEW supermarket_chain.v_receipts OWNER TO neondb_owner;

--
-- Name: v_suppliers; Type: VIEW; Schema: supermarket_chain; Owner: neondb_owner
--

CREATE VIEW supermarket_chain.v_suppliers AS
 SELECT supplier_code,
    vat_number,
    company_name,
    headquarter_city
   FROM supermarket_chain.suppliers;


ALTER VIEW supermarket_chain.v_suppliers OWNER TO neondb_owner;

--
-- Name: playing_with_neon id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.playing_with_neon ALTER COLUMN id SET DEFAULT nextval('public.playing_with_neon_id_seq'::regclass);


--
-- Data for Name: playing_with_neon; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.playing_with_neon (id, name, value) FROM stdin;
1	c4ca4238a0	0.112537846
2	c81e728d9d	0.9356275
3	eccbc87e4b	0.68509924
4	a87ff679a2	0.58829844
5	e4da3b7fbb	0.5107853
6	1679091c5a	0.05327852
7	8f14e45fce	0.48036873
8	c9f0f895fb	0.48132446
9	45c48cce2e	0.34162664
10	d3d9446802	0.054595176
11	c4ca4238a0	0.33334407
12	c81e728d9d	0.5243739
13	eccbc87e4b	0.9721803
14	a87ff679a2	0.9350534
15	e4da3b7fbb	0.73857564
16	1679091c5a	0.27817386
17	8f14e45fce	0.31214133
18	c9f0f895fb	0.23365447
19	45c48cce2e	0.13029276
20	d3d9446802	0.60841465
\.


--
-- Data for Name: availability; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.availability (branch_code, product_code, quantity, local_price) FROM stdin;
\.


--
-- Data for Name: branches; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.branches (branch_code, phone, city, street, postal_code, number) FROM stdin;
1	020-7946-0101	London	Oxford Street	W1D 1BS	45
2	0161-496-0102	Manchester	Deansgate	M3 2AW	12A
3	0121-496-0103	Birmingham	Broad Street	B1 2EA	9
4	0131-496-0104	Edinburgh	Princes Street	EH2 2EQ	100
5	0141-496-0105	Glasgow	Buchanan Street	G1 3HL	250
6	0113-496-0106	Leeds	Briggate	LS1 6NP	8B
7	0117-496-0107	Bristol	Park Street	BS1 5HX	1500
8	0151-496-0108	Liverpool	Bold Street	L1 4DS	45
9	0191-496-0109	Newcastle	Grey Street	NE1 6AE	23
10	0114-496-0110	Sheffield	Fargate	S1 2HE	88
11	028-9018-0111	Belfast	Donegall Place	BT1 5AW	12
12	029-2018-0112	Cardiff	Queen Street	CF10 2HQ	5A
13	0115-496-0113	Nottingham	Clumber Street	NG1 3ED	300
14	023-8018-0114	Southampton	Above Bar St	SO14 7DQ	40
15	0116-496-0115	Leicester	High Street	LE1 5YN	100
16	01273-496016	Brighton	North Laine	BN1 1YA	12
17	01202-496017	Bournemouth	Old Christchurch Rd	BH1 1EZ	5
18	01223-496018	Cambridge	Sidney Street	CB2 3HX	14
19	01865-496019	Oxford	Cornmarket St	OX1 3EX	21
20	01904-496020	York	The Shambles	YO1 7LZ	150
21	01225-496021	Bath	Milsom Street	BA1 1DN	88
22	01244-496022	Chester	Eastgate Street	CH1 1LE	56
23	01392-496023	Exeter	High Street	EX4 3LN	12
24	01752-496024	Plymouth	Armada Way	PL1 1HH	100
25	01603-496025	Norwich	Gentleman's Walk	NR2 1NA	45
26	01482-496026	Hull	Jameson Street	HU1 3JX	30
27	01792-496027	Swansea	Wind Street	SA1 1DP	200
28	01908-496028	Milton Keynes	Midsummer Blvd	MK9 3GB	80
29	01782-496029	Stoke-on-Trent	Hanley Road	ST1 1QN	15
30	01332-496030	Derby	St Peters Street	DE1 1SH	350
31	01224-496031	Aberdeen	Union Street	AB10 1BD	142
32	024-7655-0132	Coventry	Broadgate	CV1 1FS	24
33	0118-496-0133	Reading	Broad Street	RG1 2BH	55B
34	023-9282-0134	Portsmouth	Commercial Road	PO1 1BU	8
35	01772-496035	Preston	Fishergate	PR1 2NJ	210
36	0117-496-0136	Sunderland	High Street West	SR1 1BN	93
37	01902-496037	Wolverhampton	Dudley Street	WV1 3EY	17A
38	01702-496038	Southend-on-Sea	High Street	SS1 1JE	305
39	01582-496039	Luton	George Street	LU1 2AL	44
40	01793-496040	Swindon	Regent Street	SN1 1JQ	12
\.


--
-- Data for Name: customer_phones; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.customer_phones (loyalty_card_id, phone_number) FROM stdin;
1001	07700-900111
1001	020-7946-0222
1002	07700-900333
1004	07700-900444
1006	07700-900555
1007	07700-900666
1009	07700-900777
1009	020-7946-0888
1010	07700-900999
1011	07700-900101
1013	07700-900202
1015	07700-900303
1015	020-7946-0404
1019	07700-900505
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.customers (loyalty_card_id, first_name, last_name, email, accumulated_points) FROM stdin;
1001	John	Smith	john.smith@email.com	450
1002	Emily	Johnson	emily.j@gmail.com	120
1003	Michael	Williams	michaelw@outlook.com	0
1004	Sophia	Brown	sophia.brown@yahoo.com	3500
1005	William	Jones	w.jones99@email.com	15
1006	Olivia	Garcia	olivia.g@company.com	0
1007	James	Miller	james.m@yahoo.com	850
1008	Isabella	Davis	i.davis@gmail.com	40
1009	Benjamin	Rodriguez	ben.rod@outlook.com	1200
1010	Mia	Martinez	mia.martinez@email.com	5
1011	Lucas	Hernandez	lucas.h@gmail.com	670
1012	Charlotte	Lopez	charlotte.l@outlook.com	0
1013	Alexander	Gonzalez	alex.g@email.com	250
1014	Amelia	Wilson	amelia.w@outlook.com	80
1015	Henry	Anderson	henry.anderson@gmail.com	4100
1016	Harper	Thomas	harper.t@yahoo.com	20
1017	Sebastian	Taylor	seb.taylor@email.com	150
1018	Evelyn	Moore	evelyn.m@company.com	0
1019	Jack	Jackson	jack.jackson@yahoo.com	900
1020	Abigail	Martin	abigail.m@gmail.com	30
1021	Owen	Lee	owen.lee@mail.com	110
1022	Ella	Perez	ella.perez@gmail.com	80
1023	Samuel	Thompson	sam.thompson@yahoo.com	500
1024	Avery	White	avery.w@outlook.com	12
1025	Matthew	Harris	matt.harris@gmail.com	350
1026	Scarlett	Sanchez	scarlett.s@yahoo.com	0
1027	Joseph	Clark	joseph.clark@email.com	4000
1028	Grace	Ramirez	grace.r@yahoo.com	120
1029	David	Lewis	david.lewis@gmail.com	5
1030	Chloe	Robinson	chloe.robinson@outlook.com	65
1031	Wyatt	Walker	wyatt.w@mail.com	780
1032	Victoria	Young	victoria.y@gmail.com	0
1033	John	Allen	john.allen@yahoo.com	140
1034	Riley	King	riley.king@yahoo.com	300
1035	Luke	Wright	luke.wright@outlook.com	40
1036	Aria	Scott	aria.scott@gmail.com	2100
1037	Dylan	Torres	dylan.torres@email.com	0
1038	Lily	Nguyen	lily.nguyen@yahoo.com	50
1039	Grayson	Hill	grayson.hill@yahoo.com	890
1040	Aubrey	Flores	aubrey.f@gmail.com	15
1041	Isaac	Green	isaac.green@outlook.com	300
1042	Zoey	Adams	zoey.adams@email.com	0
1043	Gabriel	Nelson	gabriel.nelson@yahoo.com	1250
1044	Penelope	Baker	penelope.b@gmail.com	60
1045	Anthony	Hall	anthony.hall@yahoo.com	15
1046	Lillian	Rivera	lillian.r@outlook.com	430
1047	Lincoln	Campbell	lincoln.c@gmail.com	0
1048	Addison	Mitchell	addison.m@email.com	70
1049	Joshua	Carter	joshua.carter@yahoo.com	3000
1050	Layla	Roberts	layla.roberts@yahoo.com	10
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.departments (department_code, name) FROM stdin;
BTC	Butchery & Meat
FRP	Fresh Produce
DEL	Deli & Ready Meals
CHK	Checkout & Customer Service
FSH	Fishmonger & Seafood
BKE	Bakery & Pastry
DRY	Dairy & Chilled
HBA	Health & Beauty
BEV	Beverages & Spirits
FRZ	Frozen Foods & Ice Cream
HOM	Home & Cleaning
PET	Pet Care
WNE	Wine, Beer & Spirits
BGO	Baby & Toddler
CNF	Confectionery & Snacks
NWS	Newsagent & Magazines
CHM	Pharmacy & Healthcare
ELC	Electrical & Entertainment
CLO	Clothing & Apparel
TOY	Toys & Games
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.employees (employee_code, first_name, last_name, ssn, role, gender, contract_type, branch_code, department_code) FROM stdin;
201	James	Smith	QQ123451A       	Manager	M	Permanent	1	CHK
202	Michael	Johnson	QQ123452B       	Shop Assistant	M	Part-Time	1	FRP
203	Robert	Williams	QQ123453C       	Butcher	M	Permanent	1	BTC
204	Mary	Brown	QQ123454D       	Cashier	F	Permanent	2	CHK
205	Patricia	Jones	QQ123455E       	Counter Clerk	F	Fixed-Term	2	DEL
206	David	Garcia	QQ123456F       	Shop Assistant	M	Part-Time	3	BKE
207	Linda	Miller	QQ123457G       	Cashier	F	Apprenticeship	3	CHK
208	Richard	Davis	QQ123458H       	Fishmonger	M	Fixed-Term	4	FSH
209	Taylor	Rodriguez	QQ123459I       	Shop Assistant	X	Permanent	4	DRY
210	Barbara	Martinez	QQ123460J       	Cashier	F	Permanent	4	CHK
211	William	Hernandez	QQ123461K       	Store Manager	M	Permanent	5	CHK
212	Susan	Lopez	QQ123462L       	Shop Assistant	F	Permanent	5	HBA
213	Joseph	Gonzalez	QQ123463M       	Warehouse Operative	M	Part-Time	5	BEV
214	Thomas	Wilson	QQ123464N       	Cashier	M	Fixed-Term	5	CHK
215	Charles	Anderson	QQ123465O       	Shop Assistant	M	Permanent	6	FRZ
216	Jessica	Thomas	QQ123466P       	Shop Assistant	F	Apprenticeship	6	HBA
217	Christopher	Taylor	QQ123467Q       	Counter Clerk	M	Permanent	6	DEL
218	Sarah	Moore	QQ123468R       	Cashier	F	Part-Time	6	CHK
219	Daniel	Jackson	QQ123469S       	Shop Assistant	M	Permanent	7	WNE
220	Karen	Martin	QQ123470T       	Shop Assistant	F	Part-Time	7	HBA
221	Matthew	Lee	QQ123471U       	Manager	M	Permanent	7	CHK
222	Nancy	Perez	QQ123472V       	Cashier	F	Permanent	7	CHK
223	Anthony	Thompson	QQ123473W       	Butcher	M	Fixed-Term	8	BTC
224	Mark	White	QQ123474X       	Shop Assistant	M	Apprenticeship	8	FRP
225	Lisa	Harris	QQ123475Y       	Counter Clerk	F	Permanent	8	DEL
226	Donald	Sanchez	QQ123476Z       	Store Manager	M	Permanent	8	CHK
227	Steven	Clark	QQ123477A       	Fishmonger	M	Part-Time	9	FSH
228	Betty	Ramirez	QQ123478B       	Shop Assistant	F	Fixed-Term	9	HBA
229	Paul	Lewis	QQ123479C       	Shop Assistant	M	Permanent	9	BKE
230	Margaret	Robinson	QQ123480D       	Cashier	F	Part-Time	9	CHK
231	Andrew	Walker	QQ123481E       	Counter Clerk	M	Permanent	10	DEL
232	Joshua	Young	QQ123482F       	Shop Assistant	M	Permanent	10	FRP
233	Kenneth	Allen	QQ123483G       	Butcher	M	Part-Time	10	BTC
234	Kevin	King	QQ123484H       	Cashier	M	Apprenticeship	10	CHK
235	Sandra	Wright	QQ123485I       	Shop Assistant	F	Permanent	11	BKE
236	Ashley	Scott	QQ123486J       	Store Manager	F	Permanent	11	CHK
237	Kimberly	Torres	QQ123487K       	Shop Assistant	F	Part-Time	11	HOM
238	Brian	Nguyen	QQ123488L       	Cashier	M	Fixed-Term	12	CHK
239	Emily	Hill	QQ123489M       	Shop Assistant	F	Permanent	12	PET
240	George	Flores	QQ123490N       	Shop Assistant	M	Apprenticeship	12	BEV
241	Edward	Green	QQ123491O       	Shop Assistant	M	Part-Time	13	FRP
242	Ronald	Adams	QQ123492P       	Store Manager	M	Permanent	13	CHK
243	Timothy	Nelson	QQ123493Q       	Butcher	M	Fixed-Term	13	BTC
244	Jason	Baker	QQ123494R       	Cashier	M	Permanent	14	CHK
245	Jeffrey	Hall	QQ123495S       	Shop Assistant	M	Part-Time	14	FRZ
246	Donna	Rivera	QQ123496T       	Counter Clerk	F	Permanent	14	DEL
247	Carol	Campbell	QQ123497U       	Shop Assistant	F	Fixed-Term	15	HBA
248	Ryan	Mitchell	QQ123498V       	Cashier	M	Permanent	15	CHK
249	Jacob	Carter	QQ123499W       	Store Manager	M	Permanent	15	CHK
250	Gary	Roberts	QQ123500X       	Shop Assistant	M	Part-Time	15	BEV
251	Nicholas	Gomez	QQ123501Y       	Manager	M	Permanent	16	CHK
252	Eric	Phillips	QQ123502Z       	Cashier	M	Fixed-Term	16	CHK
253	Michelle	Evans	QQ123503A       	Counter Clerk	F	Permanent	16	DEL
254	Amanda	Turner	QQ123504B       	Shop Assistant	F	Part-Time	17	FRP
255	Stephen	Diaz	QQ123505C       	Store Manager	M	Permanent	17	CHK
256	Larry	Parker	QQ123506D       	Shop Assistant	M	Fixed-Term	17	BKE
257	Justin	Cruz	QQ123507E       	Cashier	M	Permanent	18	CHK
258	Scott	Edwards	QQ123508F       	Warehouse Operative	M	Part-Time	18	WNE
259	Brandon	Collins	QQ123509G       	Shop Assistant	M	Apprenticeship	18	FRZ
260	Benjamin	Reyes	QQ123510H       	Butcher	M	Permanent	19	BTC
261	Samuel	Stewart	QQ123511I       	Fishmonger	M	Permanent	19	FSH
262	Gregory	Morris	QQ123512J       	Shop Assistant	M	Fixed-Term	19	DRY
263	Melissa	Morales	QQ123513K       	Cashier	F	Part-Time	20	CHK
264	Frank	Murphy	QQ123514L       	Manager	M	Permanent	20	CHK
265	Alexander	Cook	QQ123515M       	Counter Clerk	M	Fixed-Term	20	DEL
266	Raymond	Rogers	QQ123516N       	Shop Assistant	M	Permanent	21	FRP
267	Patrick	Gutierrez	QQ123517O       	Cashier	M	Apprenticeship	21	CHK
268	Deborah	Ortiz	QQ123518P       	Shop Assistant	F	Part-Time	21	HBA
269	Stephanie	Morgan	QQ123519Q       	Store Manager	F	Permanent	22	CHK
270	Jack	Cooper	QQ123520R       	Butcher	M	Fixed-Term	22	BTC
271	Dennis	Peterson	QQ123521S       	Shop Assistant	M	Permanent	22	BKE
272	Jerry	Bailey	QQ123522T       	Cashier	M	Part-Time	23	CHK
273	Rebecca	Reed	QQ123523U       	Shop Assistant	F	Permanent	23	HOM
274	Tyler	Kelly	QQ123524V       	Shop Assistant	M	Fixed-Term	23	PET
275	Aaron	Howard	QQ123525W       	Counter Clerk	M	Permanent	24	DEL
276	Jose	Ramos	QQ123526X       	Cashier	M	Part-Time	24	CHK
277	Adam	Kim	QQ123527Y       	Manager	M	Permanent	24	CHK
278	Henry	Cox	QQ123528Z       	Shop Assistant	M	Fixed-Term	25	FRZ
279	Nathan	Ward	QQ123529A       	Butcher	M	Permanent	25	BTC
280	Laura	Richardson	QQ123530B       	Shop Assistant	F	Part-Time	25	HBA
281	Sharon	Watson	QQ123531C       	Store Manager	F	Permanent	26	CHK
282	Douglas	Brooks	QQ123532D       	Shop Assistant	M	Fixed-Term	26	DEL
283	Cynthia	Chavez	QQ123533E       	Cashier	F	Part-Time	26	CHK
284	Peter	Wood	QQ123534F       	Shop Assistant	M	Permanent	27	FRP
285	Kyle	James	QQ123535G       	Counter Clerk	M	Fixed-Term	27	BKE
286	Walter	Bennett	QQ123536H       	Shop Assistant	M	Apprenticeship	27	HBA
287	Kathleen	Gray	QQ123537I       	Cashier	F	Permanent	28	CHK
288	Amy	Mendoza	QQ123538J       	Manager	F	Permanent	28	CHK
289	Ethan	Ruiz	QQ123539K       	Shop Assistant	M	Part-Time	28	DRY
290	Jeremy	Hughes	QQ123540L       	Fishmonger	M	Fixed-Term	29	FSH
291	Christian	Price	QQ123541M       	Cashier	M	Permanent	29	CHK
292	Keith	Alvarez	QQ123542N       	Shop Assistant	M	Part-Time	29	FRZ
293	Shirley	Castillo	QQ123543O       	Counter Clerk	F	Permanent	30	DEL
294	Angela	Sanders	QQ123544P       	Cashier	F	Fixed-Term	30	CHK
295	Anna	Patel	QQ123545Q       	Store Manager	F	Permanent	30	CHK
296	Roger	Myers	QQ123546R       	Butcher	M	Part-Time	16	BTC
297	Terry	Long	QQ123547S       	Shop Assistant	M	Permanent	17	WNE
298	Sean	Ross	QQ123548T       	Warehouse Operative	M	Fixed-Term	18	HOM
299	Gerald	Foster	QQ123549U       	Manager	M	Permanent	19	CHK
300	Carl	Jimenez	QQ123550V       	Shop Assistant	M	Part-Time	20	BKE
301	Arthur	Powell	QQ123551W       	Cashier	M	Permanent	21	CHK
302	Lawrence	Jenkins	QQ123552X       	Counter Clerk	M	Fixed-Term	22	DEL
303	Joe	Perry	QQ123553Y       	Shop Assistant	M	Permanent	23	HBA
304	Albert	Russell	QQ123554Z       	Cashier	M	Part-Time	24	CHK
305	Willie	Sullivan	QQ123555A       	Shop Assistant	M	Permanent	25	FRP
306	Billy	Bell	QQ123556B       	Store Manager	M	Permanent	26	CHK
307	Bryan	Coleman	QQ123557C       	Butcher	M	Fixed-Term	27	BTC
308	Bruce	Washington	QQ123558D       	Fishmonger	M	Permanent	28	FSH
309	Louis	Butler	QQ123559E       	Shop Assistant	M	Part-Time	29	FRZ
310	Eugene	Simmons	QQ123560F       	Cashier	M	Permanent	30	CHK
311	Ralph	Gonzales	QQ123561G       	Manager	M	Permanent	1	CHK
312	Roy	Patterson	QQ123562H       	Shop Assistant	M	Fixed-Term	2	DRY
313	Wayne	Jordan	QQ123563I       	Counter Clerk	M	Permanent	3	DEL
314	Harry	Reynolds	QQ123564J       	Cashier	M	Part-Time	4	CHK
315	Vincent	Hamilton	QQ123565K       	Butcher	M	Permanent	5	BTC
316	Eugene	Graham	QQ123566L       	Shop Assistant	M	Fixed-Term	6	WNE
317	Russell	Wallace	QQ123567M       	Shop Assistant	M	Permanent	7	BKE
318	Johnny	West	QQ123568N       	Cashier	M	Apprenticeship	8	CHK
319	Philip	Cole	QQ123569O       	Fishmonger	M	Part-Time	9	FSH
320	Bobby	Hayes	QQ123570P       	Shop Assistant	M	Fixed-Term	10	FRZ
321	Brenda	Woods	QQ123571Q       	Store Manager	F	Permanent	11	CHK
322	Pamela	Corrales	QQ123572R       	Cashier	F	Part-Time	12	CHK
323	Nicole	Gibson	QQ123573S       	Shop Assistant	F	Permanent	13	HBA
324	Emma	Harrison	QQ123574T       	Counter Clerk	F	Fixed-Term	14	DEL
325	Ian	Ford	QQ123575U       	Shop Assistant	M	Permanent	15	FRP
326	Gabriel	Brooks	QQ123576V       	Cashier	M	Apprenticeship	16	CHK
327	Alan	Marshall	QQ123577W       	Shop Assistant	M	Part-Time	17	HOM
328	Juan	Owens	QQ123578X       	Shop Assistant	M	Permanent	18	PET
329	Bradley	Tucker	QQ123579Y       	Manager	M	Permanent	19	CHK
330	Victor	Simpson	QQ123580Z       	Butcher	M	Fixed-Term	20	BTC
331	Martin	Shaw	QQ123581A       	Shop Assistant	M	Permanent	21	BEV
332	Ernest	Mason	QQ123582B       	Cashier	M	Part-Time	22	CHK
333	David	Ferguson	QQ123583C       	Store Manager	M	Permanent	23	CHK
334	Shawn	Knight	QQ123584D       	Shop Assistant	M	Fixed-Term	24	FRZ
335	Clarence	Palmer	QQ123585E       	Counter Clerk	M	Permanent	25	DEL
336	Craig	Willis	QQ123586F       	Fishmonger	M	Part-Time	26	FSH
337	Sean	Berry	QQ123587G       	Cashier	M	Apprenticeship	27	CHK
338	Todd	Matthews	QQ123588H       	Shop Assistant	M	Permanent	28	BKE
339	Victor	Grant	QQ123589I       	Butcher	M	Fixed-Term	29	BTC
340	Joel	Weaver	QQ123590J       	Shop Assistant	M	Permanent	30	DRY
341	Julian	Bishop	QQ123591K       	Cashier	M	Part-Time	1	CHK
342	Antonio	Black	QQ123592L       	Manager	M	Permanent	2	CHK
343	Richard	Stephens	QQ123593M       	Shop Assistant	M	Fixed-Term	3	FRP
344	Chris	Daniels	QQ123594N       	Counter Clerk	M	Permanent	4	DEL
345	Luis	Howell	QQ123595O       	Shop Assistant	M	Part-Time	5	HBA
346	Marco	Duncan	QQ123596P       	Cashier	M	Permanent	6	CHK
347	Colin	Spencer	QQ123597Q       	Store Manager	M	Permanent	7	CHK
348	Derek	Hudson	QQ123598R       	Shop Assistant	M	Fixed-Term	8	HOM
349	Oscar	Bradley	QQ123599S       	Butcher	M	Permanent	9	BTC
350	Miguel	Carroll	QQ123600T       	Fishmonger	M	Part-Time	10	FSH
\.


--
-- Data for Name: procurements; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.procurements (supplier_code, product_code, branch_code, quantity, local_price) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.products (product_code, category, detail, brand, standard_price, department_code) FROM stdin;
301	Shampoo	Purple Shampoo 250ml	L'Oréal	4.50	HBA
302	Shampoo	Anti-Brass 250ml	Kerastase	18.90	HBA
303	Shampoo	Blonde Care 200ml	Garnier	3.80	HBA
304	Shampoo	Salon Professional	Toni&Guy	8.50	HBA
305	Shampoo	Curly Hair 250ml	Pantene	3.50	HBA
306	Shampoo	Curls Definer 250ml	Garnier Fructis	3.20	HBA
307	Shampoo	Argan Oil Curls	Sunsilk	2.99	HBA
308	Shampoo	Frizz Control	L'Oréal Elvive	3.90	HBA
309	Shampoo	Daily Care 250ml	Dove	3.00	HBA
310	Shampoo	Natural Repair	Herbal Essences	4.20	HBA
311	Shampoo	Intensive Repair	Pantene Pro-V	3.80	HBA
312	Shampoo	Anti-Dandruff Classic 250ml	Head & Shoulders	3.50	HBA
313	Shampoo	Anti-Dandruff Menthol	Head & Shoulders	3.60	HBA
314	Shampoo	Anti-Dandruff Ice	Clear	3.20	HBA
315	Shampoo	Gentle Care	Nivea	2.80	HBA
316	Body Wash	Relaxing Lavender 500ml	Radox	2.90	HBA
317	Body Wash	Deep Nourishing 500ml	Dove	2.99	HBA
318	Body Wash	Original Pine	Original Source	2.50	HBA
401	Skincare	Daily Moisturising Lotion	Aveeno	5.50	HBA
402	Deodorant	Africa Body Spray 150ml	Lynx	2.50	HBA
319	Dry Pasta	Spaghetti 16oz	Barilla	0.99	DEL
320	Dry Pasta	Thick Spaghetti 16oz	De Cecco	1.35	DEL
321	Dry Pasta	Bronze Die Spaghetti 16oz	Rummo	1.49	DEL
324	Dry Pasta	Penne Rigate 16oz	Barilla	0.99	DEL
326	Dry Pasta	Premium Penne Rigate 16oz	Rummo	1.49	DEL
403	Ready Meals	Chicken Tikka Masala 400g	Store Brand	3.50	DEL
404	Deli Meat	Roast Beef Slices 120g	Richmond	2.80	DEL
405	Deli Snack	Classic Pork Pie	Melton Mowbray	1.50	DEL
406	Deli Snack	Sausage Roll 4pk	Greggs	2.00	DEL
407	Dips	Classic Houmous 200g	Store Brand	1.20	DEL
329	Beef & Pork	T-Bone Steak 1kg	Highland Meats	25.90	BTC
330	Beef & Pork	Angus Beef Burgers 200g	Highland Meats	4.50	BTC
332	Poultry	Chicken Breast Fillets 400g	Moy Park	6.50	BTC
408	Sausages	Cumberland Sausages 6pk	Richmond	3.00	BTC
409	Bacon	Unsmoked Back Bacon	Danepak	2.50	BTC
410	Lamb	Welsh Lamb Chops	Highland Meats	6.50	BTC
335	Seafood	Salmon Fillet 250g	Mowi	12.50	FSH
336	Seafood	Fresh Sea Bream 500g	Atlantic Seafoods	9.90	FSH
411	Seafood	Cold Smoked Salmon 100g	Young's	4.50	FSH
412	Seafood	Raw King Prawns 200g	Atlantic Seafoods	5.00	FSH
338	Cheese	Mature Cheddar 200g	Cathedral City	4.50	DRY
340	Cheese	Fresh Mozzarella 250g	Galbani	3.90	DRY
342	Dairy	Whole Milk 1L	Arla	1.30	DRY
413	Butter	Spreadable Butter 500g	Lurpak	4.20	DRY
414	Eggs	Large Free Range Eggs 6pk	Happy Egg Co	2.20	DRY
415	Yogurt	Greek Style Yogurt 500g	Yeo Valley	2.00	DRY
348	Biscuits	Chocolate Chip Cookies 350g	Maryland	2.80	CNF
350	Biscuits	Digestives Dark Choc 400g	McVitie's	3.30	CNF
353	Spreads	Nutella Hazelnut Spread 400g	Ferrero	3.99	CNF
416	Chocolate	Dairy Milk Bar 200g	Cadbury	2.50	CNF
417	Crisps	Cheese & Onion Crisps 6pk	Walkers	1.90	CNF
418	Crisps	Salt & Vinegar Crisps 150g	Kettle Chips	2.25	CNF
419	Sweets	Starmix Share Bag 190g	Haribo	1.50	CNF
356	Water	Still Spring Water 1.5L	Evian	0.40	BEV
359	Soft Drinks	Coca-Cola Original 1.5L	Coca Cola	1.90	BEV
420	Tea	Everyday Tea Bags 80pk	Yorkshire Tea	3.50	BEV
421	Coffee	Gold Blend Instant 200g	Nescafe	5.50	BEV
422	Juice	Pure Orange Juice 1L	Tropicana	2.50	BEV
423	Mixers	Indian Tonic Water 1L	Schweppes	1.80	BEV
362	Beer	Lager Beer 660ml	Stella Artois	1.20	WNE
366	Red Wine	Cabernet Sauvignon	Hardys	14.50	WNE
369	White Wine	Sauvignon Blanc	Oyster Bay	8.90	WNE
424	Spirits	London Dry Gin 70cl	Gordon's	16.50	WNE
425	Spirits	Blended Scotch Whisky 70cl	Famous Grouse	15.00	WNE
426	Cider	Gold Premium Cider 500ml	Thatchers	2.20	WNE
371	Frozen Food	Garden Peas 750g	Birds Eye	3.80	FRZ
373	Frozen Food	Margherita Pizza	Dr. Oetker	2.99	FRZ
377	Frozen Food	Vanilla Ice Cream 500ml	Ben & Jerry's	4.50	FRZ
427	Frozen Food	Oven Chips 1.5kg	McCain	3.50	FRZ
428	Frozen Food	Fish Fingers 10pk	Birds Eye	3.00	FRZ
429	Frozen Food	Yorkshire Puddings 12pk	Aunt Bessie's	2.20	FRZ
380	Laundry Detergent	Bio Liquid 50 Washes	Persil	9.90	HOM
385	Dish Soap	Lemon Washing Up Liquid 1L	Fairy	1.50	HOM
430	Paper Products	Toilet Tissue 9 Rolls	Andrex	5.50	HOM
431	Paper Products	Kitchen Towel 2 Rolls	Plenty	3.00	HOM
432	Cleaning	Thick Bleach 750ml	Domestos	1.50	HOM
389	Cat Food	Chicken Dry Food 1.5kg	Purina One	6.90	PET
393	Dog Food	Beef Kibble 3kg	Pedigree	8.50	PET
433	Cat Food	Wet Cat Food Pouches 12pk	Felix	5.50	PET
434	Dog Treats	Dentastix Daily Chews	Pedigree	2.50	PET
435	Cat Litter	Hygiene Non-Clumping 5L	Catsan	6.00	PET
436	Nappies	Baby-Dry Nappies Size 4	Pampers	8.00	BGO
437	Baby Wipes	Sensitive Baby Wipes 4pk	WaterWipes	9.00	BGO
438	Baby Food	Organic Apple Purée	Ella's Kitchen	1.20	BGO
439	Baby Milk	First Infant Milk 800g	Cow & Gate	10.50	BGO
440	Newspaper	The Times Daily Edition	The Times	2.20	NWS
441	Newspaper	The Guardian Daily Edition	The Guardian	2.50	NWS
442	Magazine	Vogue UK	Condé Nast	4.99	NWS
443	Stationery	Ballpoint Pens Black 10pk	Bic	2.00	NWS
444	Pain Relief	Paracetamol 500mg 16 Caplets	Panadol	1.20	CHM
445	Pain Relief	Ibuprofen 200mg 16 Tablets	Nurofen	2.00	CHM
446	First Aid	Fabric Plasters 40pk	Elastoplast	2.50	CHM
447	Cold & Flu	Cough Syrup 150ml	Benylin	4.50	CHM
448	Vitamins	Vitamin C Effervescent	Berocca	5.00	CHM
449	Batteries	AA Alkaline Batteries 8pk	Duracell	6.50	ELC
450	Cables	USB-C Charging Cable 1m	Store Brand	4.00	ELC
451	Appliances	2-Slice Toaster Black	Russell Hobbs	24.99	ELC
452	Appliances	Electric Kettle 1.7L	Breville	29.99	ELC
453	Lightbulbs	LED Bayonet Bulbs 2pk	Philips	5.00	ELC
454	Menswear	Cotton Ankle Socks 5pk	F&F	6.00	CLO
455	Menswear	Basic White T-Shirt	F&F	4.50	CLO
456	Womenswear	Black Opaque Tights 60 Denier	F&F	3.50	CLO
457	Childrenswear	School Shirts 2pk	George	7.00	CLO
458	Toys	City Police Car Set	LEGO	12.99	TOY
459	Games	Monopoly Classic	Hasbro	22.00	TOY
460	Toys	Barbie Fashion Doll	Mattel	15.00	TOY
461	Games	Uno Card Game	Mattel	7.50	TOY
462	Fruit	Fairtrade Bananas 5pk	Fyffes	1.20	FRP
463	Fruit	Pink Lady Apples 6pk	Pink Lady	2.80	FRP
464	Vegetables	Maris Piper Potatoes 2kg	Store Brand	2.00	FRP
465	Vegetables	Closed Cup Mushrooms 300g	Store Brand	1.20	FRP
466	Vegetables	Cherry Tomatoes 250g	Store Brand	1.50	FRP
467	Bread	Thick Sliced White Bread 800g	Warburtons	1.40	BKE
468	Bread	Seeded Batch Loaf 800g	Hovis	1.80	BKE
469	Pastry	Crumpets 6pk	Warburtons	1.20	BKE
470	Pastry	All Butter Croissants 4pk	Store Brand	2.50	BKE
471	Till Snacks	Peppermint Chewing Gum	Wrigley's Extra	0.80	CHK
472	Till Snacks	Spearmint Mints	Trebor	0.65	CHK
473	Bags	Heavy Duty Bag for Life	Store Brand	0.30	CHK
474	Bags	Cotton Tote Bag	Store Brand	1.50	CHK
\.


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.purchases (loyalty_card_id, receipt_number) FROM stdin;
1001	5001
1002	5002
1004	5003
1004	5004
1004	5005
1005	5006
1001	5008
1007	5009
1008	5010
1009	5011
1010	5012
1011	5013
1001	5015
1007	5016
1009	5017
1010	5018
1011	5019
1013	5021
1014	5022
1015	5023
1016	5024
1017	5025
1018	5026
1019	5027
1020	5028
1021	5029
1022	5030
1023	5031
1024	5032
1025	5033
1025	5034
1025	5035
1026	5036
1027	5037
1028	5038
1029	5039
1031	5040
1032	5041
1033	5042
1034	5043
1035	5044
1036	5045
1037	5046
1038	5047
1039	5048
1001	5049
1004	5050
1015	5051
1022	5052
1045	5053
\.


--
-- Data for Name: receipt_details; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.receipt_details (receipt_number, product_code, quantity, price) FROM stdin;
5001	329	1	25.90
5001	366	1	14.50
5001	464	1	2.00
5001	413	1	4.20
5002	440	1	2.20
5002	443	1	2.00
5002	471	1	0.80
5003	301	1	4.50
5003	316	2	2.90
5003	401	1	5.50
5003	430	1	5.50
5004	319	5	0.99
5004	324	2	0.99
5004	342	3	1.30
5005	451	1	24.99
5005	452	1	29.99
5005	380	2	9.90
5005	432	2	1.50
5006	423	1	1.80
5006	472	1	0.65
5007	326	3	1.49
5007	338	2	4.50
5007	369	1	8.90
5008	356	6	0.40
5008	462	1	1.20
5009	335	2	12.50
5009	412	1	5.00
5009	369	2	8.90
5009	466	1	1.50
5010	436	1	8.00
5010	437	2	9.00
5010	438	6	1.20
5011	348	2	2.80
5011	420	1	3.50
5011	342	2	1.30
5012	408	2	3.00
5012	362	6	1.20
5012	427	1	3.50
5013	373	4	2.99
5013	359	2	1.90
5013	417	2	1.90
5014	377	1	4.50
5014	416	2	2.50
5015	380	1	9.90
5015	385	2	1.50
5015	431	1	3.00
5016	389	1	6.90
5016	433	2	5.50
5016	435	1	6.00
5017	393	1	8.50
5017	434	3	2.50
5018	444	2	1.20
5018	447	1	4.50
5018	448	1	5.00
5019	458	1	12.99
5019	461	1	7.50
5019	419	2	1.50
5020	467	1	1.40
5020	413	1	4.20
5020	353	1	3.99
5021	403	2	3.50
5021	407	1	1.20
5022	329	3	25.90
5022	366	2	14.50
5022	464	2	2.00
5022	418	3	2.25
5023	454	2	6.00
5023	455	1	4.50
5024	452	1	29.99
5024	449	2	6.50
5024	453	2	5.00
5025	462	2	1.20
5025	463	1	2.80
5025	465	1	1.20
5025	466	1	1.50
5026	469	2	1.20
5026	420	1	3.50
5026	342	1	1.30
5027	424	1	16.50
5027	423	4	1.80
5027	418	2	2.25
5028	404	2	2.80
5028	468	1	1.80
5028	414	1	2.20
5029	332	2	6.50
5029	465	1	1.20
5029	422	2	2.50
5030	471	1	0.80
5030	472	1	0.65
5031	425	1	15.00
5031	359	2	1.90
5031	417	3	1.90
5032	338	1	4.50
5032	340	2	3.90
5032	415	3	2.00
5033	440	1	2.20
5034	303	1	3.80
5034	306	1	3.20
5034	309	1	3.00
5034	317	2	2.99
5035	319	4	0.99
5035	321	2	1.49
5035	403	2	3.50
5036	474	1	1.50
5036	473	2	0.30
5037	439	2	10.50
5037	436	1	8.00
5037	438	5	1.20
5038	380	1	9.90
5038	385	1	1.50
5039	445	1	2.00
5039	448	1	5.00
5040	451	1	24.99
5040	452	1	29.99
5040	453	4	5.00
5041	335	2	12.50
5041	411	1	4.50
5041	369	1	8.90
5042	373	2	2.99
5042	377	1	4.50
5043	389	2	6.90
5043	435	1	6.00
5044	362	6	1.20
5044	426	4	2.20
5044	418	2	2.25
5045	458	1	12.99
5045	460	1	15.00
5045	416	2	2.50
5046	329	2	25.90
5046	410	1	6.50
5046	366	1	14.50
5047	467	1	1.40
5047	342	2	1.30
5048	444	1	1.20
5048	447	1	4.50
5049	456	2	3.50
5049	457	1	7.00
5050	404	1	2.80
5050	405	2	1.50
5050	406	1	2.00
5051	356	6	0.40
5051	359	2	1.90
5052	420	1	3.50
5052	421	1	5.50
5052	348	2	2.80
5053	462	1	1.20
5053	463	1	2.80
5054	301	1	4.50
5054	312	1	3.50
5055	319	3	0.99
5055	320	2	1.35
5056	332	2	6.50
5056	465	1	1.20
5057	436	1	8.00
5057	437	1	9.00
5058	451	1	24.99
5058	452	1	29.99
5059	380	1	9.90
5059	430	1	5.50
5060	424	1	16.50
5060	423	2	1.80
5061	335	1	12.50
5061	369	1	8.90
5062	371	2	3.80
5062	428	1	3.00
5063	389	1	6.90
5063	433	1	5.50
5064	440	1	2.20
5064	442	1	4.99
5065	454	1	6.00
5065	455	1	4.50
5066	467	1	1.40
5066	413	1	4.20
5066	353	1	3.99
5067	408	2	3.00
5067	362	4	1.20
5068	425	1	15.00
5068	417	2	1.90
5069	338	1	4.50
5069	340	1	3.90
5070	304	1	8.50
5070	401	1	5.50
5071	319	5	0.99
5071	324	2	0.99
5072	356	6	0.40
5072	422	1	2.50
5073	436	2	8.00
5073	438	5	1.20
5074	380	2	9.90
5074	432	1	1.50
5075	444	1	1.20
5075	445	1	2.00
5076	458	1	12.99
5076	461	1	7.50
5077	462	1	1.20
5077	463	1	2.80
5078	329	1	25.90
5078	366	1	14.50
5079	469	1	1.20
5079	420	1	3.50
5080	471	2	0.80
5080	472	1	0.65
5081	439	1	10.50
5081	437	1	9.00
5082	385	1	1.50
5082	431	1	3.00
5083	335	1	12.50
5083	412	1	5.00
5084	373	2	2.99
5084	377	1	4.50
5085	393	1	8.50
5085	434	1	2.50
5086	362	6	1.20
5086	426	2	2.20
5087	456	1	3.50
5087	457	1	7.00
5088	404	1	2.80
5088	406	1	2.00
5089	356	6	0.40
5089	359	1	1.90
5090	420	1	3.50
5090	421	1	5.50
5091	462	2	1.20
5091	465	1	1.20
5092	301	1	4.50
5092	316	1	2.90
5093	319	2	0.99
5093	321	2	1.49
5094	332	1	6.50
5094	464	1	2.00
5095	436	1	8.00
5095	438	2	1.20
5096	451	1	24.99
5096	449	1	6.50
5097	380	1	9.90
5097	430	1	5.50
5098	424	1	16.50
5098	423	1	1.80
5099	335	1	12.50
5099	369	1	8.90
5100	371	1	3.80
5100	427	1	3.50
5101	389	1	6.90
5101	435	1	6.00
5102	440	1	2.20
5102	443	1	2.00
5103	454	1	6.00
5103	455	1	4.50
5104	467	1	1.40
5104	414	1	2.20
5105	408	1	3.00
5105	362	2	1.20
5106	425	1	15.00
5106	418	1	2.25
5107	338	1	4.50
5107	342	1	1.30
5108	302	1	18.90
5108	401	1	5.50
5109	319	3	0.99
5109	326	1	1.49
5110	356	6	0.40
5110	422	1	2.50
5111	439	1	10.50
5111	437	1	9.00
5112	380	1	9.90
5112	432	1	1.50
5113	444	1	1.20
5113	446	1	2.50
5114	460	1	15.00
5114	461	1	7.50
5115	462	1	1.20
5115	463	1	2.80
5116	329	1	25.90
5116	366	1	14.50
5117	469	1	1.20
5117	420	1	3.50
5118	471	1	0.80
5118	474	1	1.50
5119	436	1	8.00
5119	438	2	1.20
5120	385	1	1.50
5120	431	1	3.00
5121	335	1	12.50
5121	411	1	4.50
5122	373	2	2.99
5122	377	1	4.50
5123	393	1	8.50
5123	434	1	2.50
5124	362	6	1.20
5124	426	2	2.20
5125	456	1	3.50
5125	457	1	7.00
5126	404	1	2.80
5126	405	1	1.50
5127	356	6	0.40
5127	359	1	1.90
5128	420	1	3.50
5128	421	1	5.50
5129	462	1	1.20
5129	466	1	1.50
5130	307	1	2.99
5130	316	1	2.90
5131	319	2	0.99
5131	321	1	1.49
5132	332	1	6.50
5132	464	1	2.00
5133	436	1	8.00
5133	438	3	1.20
5134	452	1	29.99
5134	449	1	6.50
5135	380	1	9.90
5135	430	1	5.50
5136	424	1	16.50
5136	423	1	1.80
5137	335	1	12.50
5137	369	1	8.90
5138	371	1	3.80
5138	427	1	3.50
5139	389	1	6.90
5139	435	1	6.00
5140	440	1	2.20
5140	443	1	2.00
5141	454	1	6.00
5141	455	1	4.50
5142	467	1	1.40
5142	414	1	2.20
5143	408	1	3.00
5143	362	2	1.20
5144	425	1	15.00
5144	418	1	2.25
5145	338	1	4.50
5145	342	1	1.30
5146	305	1	3.50
5146	401	1	5.50
5147	319	3	0.99
5147	326	1	1.49
5148	356	6	0.40
5148	422	1	2.50
5149	439	1	10.50
5149	437	1	9.00
5150	451	1	24.99
5150	452	1	29.99
5150	380	2	9.90
5150	430	2	5.50
\.


--
-- Data for Name: receipts; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.receipts (receipt_number, receipt_date, receipt_hour, receipt_minute, receipt_second, total_amount, employee_code) FROM stdin;
5001	2024-01-10	8	30	15	46.60	201
5002	2024-01-10	9	15	0	5.00	204
5003	2024-01-12	12	45	30	21.30	207
5004	2024-01-15	14	10	5	10.83	207
5005	2024-01-20	18	55	59	77.78	210
5006	2024-01-22	19	20	10	2.45	210
5007	2024-01-25	10	5	22	22.37	251
5008	2024-01-28	11	33	44	3.60	252
5009	2024-02-02	9	0	12	49.30	257
5010	2024-02-05	10	15	30	33.20	263
5011	2024-02-08	12	30	0	11.70	267
5012	2024-02-10	16	40	45	16.70	272
5013	2024-02-14	17	22	10	19.56	276
5014	2024-02-15	18	5	5	9.50	281
5015	2024-02-20	8	10	0	15.90	283
5016	2024-02-22	9	45	15	23.90	287
5017	2024-02-25	11	20	30	16.00	291
5018	2024-02-28	15	15	15	11.90	294
5019	2024-03-01	19	50	50	23.49	301
5020	2024-03-02	20	10	0	9.59	304
5021	2024-03-05	8	45	12	8.20	204
5022	2024-03-07	10	12	34	117.45	210
5023	2024-03-10	11	55	23	16.50	214
5024	2024-03-12	13	20	40	52.99	218
5025	2024-03-15	15	10	15	7.90	222
5026	2024-03-18	16	40	50	7.20	230
5027	2024-03-20	17	35	11	28.20	234
5028	2024-03-22	19	0	5	9.60	238
5029	2024-03-25	9	15	18	19.20	244
5030	2024-03-27	11	30	22	1.45	248
5031	2024-03-30	14	25	47	24.50	252
5032	2024-04-02	16	15	33	18.30	257
5033	2024-04-04	18	40	12	2.20	263
5034	2024-04-06	8	20	55	15.98	267
5035	2024-04-09	10	0	42	13.94	272
5036	2024-04-11	12	10	19	2.10	276
5037	2024-04-14	14	50	31	35.00	283
5038	2024-04-16	15	30	14	11.40	287
5039	2024-04-19	17	15	25	7.00	291
5040	2024-04-21	19	45	36	74.98	294
5041	2024-04-24	9	40	8	38.40	301
5042	2024-04-26	11	0	17	10.48	304
5043	2024-04-29	13	15	29	19.80	310
5044	2024-05-01	15	55	43	20.50	314
5045	2024-05-03	17	20	50	32.99	318
5046	2024-05-06	18	10	4	72.80	322
5047	2024-05-08	8	50	16	4.00	326
5048	2024-05-11	10	35	27	5.70	332
5049	2024-05-13	12	25	39	14.00	337
5050	2024-05-16	14	0	51	7.80	341
5051	2024-05-18	16	45	23	6.20	346
5052	2024-05-21	18	30	55	14.60	350
5053	2024-05-23	9	10	12	4.00	201
5054	2024-05-26	11	15	34	8.00	204
5055	2024-05-28	13	40	46	5.67	207
5056	2024-05-31	15	20	58	14.20	210
5057	2024-06-02	17	0	21	17.00	214
5058	2024-06-04	19	15	33	54.98	218
5059	2024-06-07	8	35	45	15.40	222
5060	2024-06-09	10	50	57	20.10	230
5061	2024-06-12	12	15	10	21.40	234
5062	2024-06-14	14	30	22	10.60	238
5063	2024-06-17	16	10	34	12.40	244
5064	2024-06-19	18	55	46	7.19	248
5065	2024-06-22	9	25	59	10.50	252
5066	2024-06-24	11	40	11	9.59	257
5067	2024-06-27	13	0	23	10.80	263
5068	2024-06-29	15	45	35	18.80	267
5069	2024-07-02	17	20	47	8.40	272
5070	2024-07-04	19	10	59	14.00	276
5071	2024-07-07	8	40	14	6.93	283
5072	2024-07-09	10	15	26	4.90	287
5073	2024-07-12	12	55	38	22.00	291
5074	2024-07-14	14	25	50	21.30	294
5075	2024-07-17	16	0	2	3.20	301
5076	2024-07-19	18	35	15	20.49	304
5077	2024-07-22	9	50	27	4.00	310
5078	2024-07-24	11	10	39	40.40	314
5079	2024-07-27	13	45	51	4.70	318
5080	2024-07-29	15	30	3	2.25	322
5081	2024-08-01	17	15	16	19.50	326
5082	2024-08-03	19	0	28	4.50	332
5083	2024-08-06	8	15	40	17.50	337
5084	2024-08-08	10	45	52	10.48	341
5085	2024-08-11	12	30	4	11.00	346
5086	2024-08-13	14	0	16	11.60	350
5087	2024-08-16	16	55	28	10.50	201
5088	2024-08-18	18	20	40	4.80	204
5089	2024-08-21	9	30	52	4.30	207
5090	2024-08-23	11	0	4	9.00	210
5091	2024-08-26	13	40	17	3.60	214
5092	2024-08-28	15	15	29	7.40	218
5093	2024-08-31	17	50	41	4.96	222
5094	2024-09-02	19	35	53	8.50	230
5095	2024-09-05	8	55	6	10.40	234
5096	2024-09-07	10	20	18	31.49	238
5097	2024-09-10	12	10	30	15.40	244
5098	2024-09-12	14	45	42	18.30	248
5099	2024-09-15	16	30	54	21.40	252
5100	2024-09-17	18	0	6	7.30	257
5101	2024-09-20	9	15	19	12.90	263
5102	2024-09-22	11	55	31	4.20	267
5103	2024-09-25	13	25	43	10.50	272
5104	2024-09-27	15	10	55	3.60	276
5105	2024-09-30	17	40	7	5.40	283
5106	2024-10-02	19	20	20	17.25	287
5107	2024-10-05	8	30	32	5.80	291
5108	2024-10-07	10	0	44	24.40	294
5109	2024-10-10	12	45	56	4.46	301
5110	2024-10-12	14	15	8	4.90	304
5111	2024-10-15	16	35	20	19.50	310
5112	2024-10-17	18	55	32	11.40	314
5113	2024-10-20	9	45	44	3.70	318
5114	2024-10-22	11	20	56	22.50	322
5115	2024-10-25	13	50	9	4.00	326
5116	2024-10-27	15	30	21	40.40	332
5117	2024-10-30	17	10	33	4.70	337
5118	2024-11-01	19	0	45	2.30	341
5119	2024-11-03	8	25	57	10.40	346
5120	2024-11-06	10	55	10	4.50	350
5121	2024-11-08	12	40	22	17.00	201
5122	2024-11-11	14	20	34	10.48	204
5123	2024-11-13	16	0	46	11.00	207
5124	2024-11-16	18	45	58	11.60	210
5125	2024-11-18	9	10	11	10.50	214
5126	2024-11-21	11	35	23	4.30	218
5127	2024-11-23	13	15	35	4.30	222
5128	2024-11-26	15	50	47	9.00	230
5129	2024-11-28	17	30	59	2.70	234
5130	2024-11-30	19	20	12	5.89	238
5131	2024-12-02	8	45	24	3.47	244
5132	2024-12-04	10	10	36	8.50	248
5133	2024-12-07	12	35	48	11.60	252
5134	2024-12-09	14	55	0	36.49	257
5135	2024-12-12	16	15	12	15.40	263
5136	2024-12-14	18	40	24	18.30	267
5137	2024-12-17	9	30	36	21.40	272
5138	2024-12-19	11	0	48	7.30	276
5139	2024-12-22	13	50	0	12.90	283
5140	2024-12-23	15	25	12	4.20	287
5141	2024-12-24	17	10	24	10.50	291
5142	2024-12-24	19	45	36	3.60	294
5143	2024-12-27	10	15	48	5.40	301
5144	2024-12-28	12	0	0	17.25	304
5145	2024-12-29	14	35	12	5.80	310
5146	2024-12-30	16	50	24	9.00	314
5147	2024-12-31	11	20	36	4.46	318
5148	2024-12-31	13	40	48	4.90	322
5149	2024-12-31	15	55	0	19.50	326
5150	2024-12-31	18	15	12	85.78	332
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: supermarket_chain; Owner: neondb_owner
--

COPY supermarket_chain.suppliers (supplier_code, vat_number, company_name, headquarter_city) FROM stdin;
1	GB012345678  	British Farms Ltd	London
2	GB098765432  	Highland Meats	Edinburgh
3	GB112233445  	GreenGroves Farm	Kent
4	GB998877665  	Cotswold Dairy	Gloucester
5	GB554433221  	Golden Crust Bakery	Manchester
6	GB887766554  	Cosmetics & Care Group	London
7	GB111222333  	Beverage Brands UK	Birmingham
8	GB555666777  	IceFood Distributors	Leeds
9	GB999888777  	Cornish Agriculture	Truro
10	GB444555666  	Atlantic Seafoods	Aberdeen
11	GB121212121  	Unilever UK	London
12	GB343434343  	Procter & Gamble UK	Weybridge
13	GB565656565  	Barilla International	London
14	GB787878787  	Ferrero UK	Greenford
15	GB909090909  	L'Oréal UK	London
16	GB131313131  	Nestlé UK	Gatwick
17	GB242424242  	Purina PetCare UK	Gatwick
18	GB353535353  	Highland Spring	Blackford
19	GB464646464  	Henkel UK	Hemel Hempstead
20	GB575757575  	Moy Park	Craigavon
21	GB686868686  	Richmond Meats	Kerry
22	GB797979797  	Arla Foods	Leeds
23	GB808080808  	Müller UK	Market Drayton
24	GB919191919  	Cathedral City	Davidstow
25	GB020202020  	Heinz UK	London
26	GB131415161  	De Cecco UK	London
27	GB242526272  	Baxters Food Group	Edinburgh
28	GB353637383  	Lavazza UK	Uxbridge
29	GB464748494  	Illy UK	Northampton
30	GB575859505  	Taylors of Harrogate	Harrogate
31	GB686960616  	Camden Town Brewery	London
32	GB797071727  	Heineken UK	Edinburgh
33	GB808182838  	Diageo	London
34	GB919293949  	Bacardi Martini	Winchester
35	GB020304050  	McCain Foods	Scarborough
36	GB132435465  	Birds Eye	Bedfont
37	GB243546576  	Wall's Ice Cream	London
38	GB354657687  	Ben & Jerry's UK	Windsor
39	GB465768798  	McVitie's	Hayes
40	GB576879809  	Cadbury	Birmingham
41	GB687980910  	Fox's Biscuits	Batley
42	GB798091021  	Premier Foods	St Albans
43	GB809102132  	Buitoni UK	London
44	GB910213243  	Charlie Bigham's	London
45	GB021324354  	Princes Group	Liverpool
46	GB132435001  	Del Monte UK	Staines
47	GB243546002  	Innocent Drinks	London
48	GB354657003  	Chiquita Brands	London
49	GB465768004  	Pink Lady UK	Kent
50	GB576879005  	Fyffes UK	Basingstoke
51	GB687980006  	Nivea (Beiersdorf)	Birmingham
52	GB798091007  	Johnson & Johnson UK	High Wycombe
53	GB809102008  	Colgate-Palmolive UK	Guildford
54	GB910213009  	Bolton Group UK	London
55	GB021324010  	Reckitt	Slough
56	GB132435011  	SC Johnson UK	Camberley
57	GB243546012  	Andrex (Kimberly-Clark)	Kings Hill
58	GB354657013  	Cushelle (Essity)	Dunstable
59	GB465768014  	Pampers UK	Weybridge
60	GB576879015  	Tommee Tippee	Cramlington
\.


--
-- Name: playing_with_neon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.playing_with_neon_id_seq', 20, true);


--
-- Name: playing_with_neon playing_with_neon_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.playing_with_neon
    ADD CONSTRAINT playing_with_neon_pkey PRIMARY KEY (id);


--
-- Name: availability availability_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.availability
    ADD CONSTRAINT availability_pkey PRIMARY KEY (branch_code, product_code);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (branch_code);


--
-- Name: customer_phones customer_phones_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.customer_phones
    ADD CONSTRAINT customer_phones_pkey PRIMARY KEY (loyalty_card_id, phone_number);


--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (loyalty_card_id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_code);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_code);


--
-- Name: employees employees_ssn_key; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.employees
    ADD CONSTRAINT employees_ssn_key UNIQUE (ssn);


--
-- Name: procurements procurements_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.procurements
    ADD CONSTRAINT procurements_pkey PRIMARY KEY (supplier_code, product_code, branch_code);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_code);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (loyalty_card_id, receipt_number);


--
-- Name: purchases purchases_receipt_number_key; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.purchases
    ADD CONSTRAINT purchases_receipt_number_key UNIQUE (receipt_number);


--
-- Name: receipt_details receipt_details_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.receipt_details
    ADD CONSTRAINT receipt_details_pkey PRIMARY KEY (receipt_number, product_code);


--
-- Name: receipts receipts_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.receipts
    ADD CONSTRAINT receipts_pkey PRIMARY KEY (receipt_number);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplier_code);


--
-- Name: suppliers suppliers_vat_number_key; Type: CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.suppliers
    ADD CONSTRAINT suppliers_vat_number_key UNIQUE (vat_number);


--
-- Name: availability availability_branch_code_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.availability
    ADD CONSTRAINT availability_branch_code_fkey FOREIGN KEY (branch_code) REFERENCES supermarket_chain.branches(branch_code);


--
-- Name: availability availability_product_code_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.availability
    ADD CONSTRAINT availability_product_code_fkey FOREIGN KEY (product_code) REFERENCES supermarket_chain.products(product_code);


--
-- Name: customer_phones customer_phones_loyalty_card_id_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.customer_phones
    ADD CONSTRAINT customer_phones_loyalty_card_id_fkey FOREIGN KEY (loyalty_card_id) REFERENCES supermarket_chain.customers(loyalty_card_id);


--
-- Name: employees employees_branch_code_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.employees
    ADD CONSTRAINT employees_branch_code_fkey FOREIGN KEY (branch_code) REFERENCES supermarket_chain.branches(branch_code);


--
-- Name: employees employees_department_code_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.employees
    ADD CONSTRAINT employees_department_code_fkey FOREIGN KEY (department_code) REFERENCES supermarket_chain.departments(department_code);


--
-- Name: procurements procurements_branch_code_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.procurements
    ADD CONSTRAINT procurements_branch_code_fkey FOREIGN KEY (branch_code) REFERENCES supermarket_chain.branches(branch_code);


--
-- Name: procurements procurements_product_code_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.procurements
    ADD CONSTRAINT procurements_product_code_fkey FOREIGN KEY (product_code) REFERENCES supermarket_chain.products(product_code);


--
-- Name: procurements procurements_supplier_code_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.procurements
    ADD CONSTRAINT procurements_supplier_code_fkey FOREIGN KEY (supplier_code) REFERENCES supermarket_chain.suppliers(supplier_code);


--
-- Name: products products_department_code_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.products
    ADD CONSTRAINT products_department_code_fkey FOREIGN KEY (department_code) REFERENCES supermarket_chain.departments(department_code);


--
-- Name: purchases purchases_loyalty_card_id_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.purchases
    ADD CONSTRAINT purchases_loyalty_card_id_fkey FOREIGN KEY (loyalty_card_id) REFERENCES supermarket_chain.customers(loyalty_card_id);


--
-- Name: purchases purchases_receipt_number_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.purchases
    ADD CONSTRAINT purchases_receipt_number_fkey FOREIGN KEY (receipt_number) REFERENCES supermarket_chain.receipts(receipt_number);


--
-- Name: receipt_details receipt_details_product_code_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.receipt_details
    ADD CONSTRAINT receipt_details_product_code_fkey FOREIGN KEY (product_code) REFERENCES supermarket_chain.products(product_code);


--
-- Name: receipt_details receipt_details_receipt_number_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.receipt_details
    ADD CONSTRAINT receipt_details_receipt_number_fkey FOREIGN KEY (receipt_number) REFERENCES supermarket_chain.receipts(receipt_number);


--
-- Name: receipts receipts_employee_code_fkey; Type: FK CONSTRAINT; Schema: supermarket_chain; Owner: neondb_owner
--

ALTER TABLE ONLY supermarket_chain.receipts
    ADD CONSTRAINT receipts_employee_code_fkey FOREIGN KEY (employee_code) REFERENCES supermarket_chain.employees(employee_code);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

\unrestrict Prvssis2sWtvSqg4vRZvWQ3j1r88uinSa2K51XQ0aIdPIGqxftR1He7QiB7vYc8

