-- SuperMarket Chain Database - Queries 
-- Obiettivi:
-- 1) Mostrare la struttura completa del database (filiali, reparti, prodotti, clienti, fornitori, disponibilità, approvvigionamenti, telefoni).
-- 2) Usare le principali tecniche SQL viste a lezione
-- 3) Presentare scenari “quasi reali”.

SET search_path TO supermarket_chain;

------------------------------------------------------------
-- SCENA 1: PANORAMICA AZIENDA
-- Obiettivo: capire come è organizzata la catena (filiali, reparti, prodotti).
------------------------------------------------------------

-- Query 1: Elenco delle filiali con indirizzo & Numero di prodotti distinti disponibili per filiale 
-- Scenario: il direttore generale vuole un elenco sintetico di tutte le filiali e confrontare la “ricchezza” dell’assortimento di esse.
SELECT b.branch_code,
       city,
       street,
       number,
       postal_code,
       COUNT(DISTINCT a.product_code) AS num_products_available
FROM branches AS b LEFT JOIN availability AS a
       ON b.branch_code = a.branch_code
GROUP BY b.branch_code, city, street, number, postal_code
ORDER BY num_products_available DESC, b.branch_code;

-- Query 2: Reparti e distribuzione prodotti
-- Scenario: l’area organizzazione vuole sapere quanti prodotti sono assegnati a ogni reparto.
-- Tecniche: JOIN + GROUP BY.
SELECT d.department_code,
       name AS department_name,
       COUNT(product_code) AS num_products
FROM departments AS d LEFT JOIN products AS p
       ON d.department_code = p.department_code
GROUP BY d.department_code, name
ORDER BY num_products DESC, d.department_code;

-- Query 3: Catalogo prodotti con reparto e prezzo standard
-- Scenario: l’ufficio marketing vuole un estratto del catalogo con reparto e prezzo standard,
-- per confrontarlo con i volantini promozionali.
SELECT product_code,
       category,
       detail,
       brand,
       d.department_code,
       name AS department_name,
       standard_price
FROM products AS p JOIN departments AS d
        ON p.department_code = d.department_code
ORDER BY name, category, product_code;

------------------------------------------------------------
-- SCENA 2: GESTIONE CLIENTI E FEDELIZZAZIONE
-- Obiettivo: capire meglio il comportamento dei clienti e i loro contatti.
------------------------------------------------------------

-- Query 4: Clienti più fedeli per punti
-- Scenario: il responsabile CRM vuole identificare i clienti “top” con più di 500 punti
-- per inviare una campagna personalizzata.
SELECT loyalty_card_id,
       first_name,
       last_name,
       email,
       accumulated_points
FROM customers
WHERE accumulated_points > 500
ORDER BY accumulated_points DESC, last_name, first_name;

-- Query 5: Ruoli diversi presenti in azienda
-- Scenario: HR vuole un elenco dei diversi ruoli presenti in tutta la catena.
-- Tecniche: DISTINCT.
SELECT DISTINCT role
FROM employees
ORDER BY role;

-- Query 6: Clienti senza numeri di telefono
-- Nota: sostituendo NOT IN con IN si ottengono i clienti con almeno un numero.
-- Scenario: il CRM vuole una lista dei clienti per cui manca un contatto telefonico,
-- Tecniche: NOT IN + subquery; gestione NULL coerente con gli appunti.
SELECT c.loyalty_card_id,
       c.first_name,
       c.last_name,
       c.email
FROM customers AS c
WHERE c.loyalty_card_id NOT IN ( SELECT cp.loyalty_card_id
                                 FROM customer_phones AS cp
)
ORDER BY c.loyalty_card_id;

-- Query 7: Clienti con elenco di numeri (inclusi quelli senza numeri)
-- Scenario: estrazione completa per contatti, con i clienti che possono avere più numeri,
-- o nessuno (NULL).
-- Tecniche: LEFT JOIN.
SELECT c.loyalty_card_id,
       c.first_name,
       c.last_name,
       cp.phone_number
FROM customers AS c LEFT JOIN customer_phones AS cp
       ON c.loyalty_card_id = cp.loyalty_card_id
ORDER BY c.loyalty_card_id, cp.phone_number;

------------------------------------------------------------
-- SCENA 3: POLITICHE DI PREZZO E DISPONIBILITÀ IN NEGOZIO
-- Obiettivo: analizzare disponibilità e prezzi locali rispetto a quelli standard.
------------------------------------------------------------

-- Query 8: Prodotti disponibili in una filiale specifica con confronto prezzi
-- Scenario: il category manager della filiale 1 vuole vedere quali prodotti sono presenti in negozio e come i prezzi locali si discostano dal prezzo standard.
-- Tecniche: JOIN + colonna calcolata.
SELECT p.product_code,
       category,
       brand,
       standard_price,
       branch_code,
       local_price,
       (local_price - p.standard_price) AS price_difference
FROM products AS p JOIN availability AS a
        ON p.product_code = a.product_code
WHERE branch_code = 1
ORDER BY price_difference DESC, category, p.product_code;









-- NON DA RISULTATI PERCHé CI SONO TUTTI -> DA CAPIRE SE TENERE PER MOSTRARE O SOSTITUIRE CON ALTRO -> togliere una riga dalla tabella availability per branch 1 (un prodotto specifico) e far vedere che compare.


-- Query 9: Prodotti non presenti in una specifica filiale
-- Scenario: un’analisi di assortimento per capire quali prodotti del catalogo non sono ancora stati introdotti nella filiale 1.
-- Tecniche: NOT EXISTS con subquery correlata.
SELECT p.product_code,
       category,
       detail,
       brand
FROM products AS p
WHERE NOT EXISTS ( SELECT *
                    FROM availability AS a
                    WHERE a.product_code = p.product_code
                    AND a.branch_code = 1
)
ORDER BY category, p.product_code;

-- Query 10: Reparti usati solo dai dipendneti e non dai prodotti
-- Scenario: il controllo organizzazione vuole capire se ci sono reparti che esistono nel catalogo dipendenti ma non hanno prodotti dedicati.
-- Tecniche: EXCEPT.
SELECT department_code
FROM employees
EXCEPT
SELECT department_code
FROM products
ORDER BY department_code;

------------------------------------------------------------
-- SCENA 4: ORGANICO, REPARTI E RUOLI
-- Obiettivo: analizzare la struttura del personale per filiale e reparto.
------------------------------------------------------------

-- Query 11: Elenco dipendenti con filiale e reparto
-- Scenario: HR vuole un report completo con città della filiale e nome del reparto per ogni dipendente.
-- Tecniche: triple JOIN.
SELECT employee_code,
       first_name,
       last_name,
       role,
       city AS branch_city,
       name AS department_name
FROM employees AS e
     JOIN branches AS b
        ON e.branch_code = b.branch_code
     JOIN departments AS d
        ON e.department_code = d.department_code
ORDER BY city, department_name, employee_code, last_name;

-- Query 12: Statistiche per reparto (contatore, min, max, media prezzo dei prodotti)
-- Scenario: il responsabile acquisti vuole capire la fascia di prezzo dei prodotti
-- per ogni reparto, per valutare eventuali riposizionamenti.
-- Tecniche: GROUP BY + funzioni di aggregazione.
SELECT p.department_code,
       name AS department_name,
       COUNT(*) AS number_of_products,
       MIN(standard_price) AS minimum_price,
       AVG(standard_price) AS average_price,
       MAX(standard_price) AS maximum_price
FROM products AS p
     JOIN departments AS d
        ON p.department_code = d.department_code
GROUP BY p.department_code, name
ORDER BY number_of_products DESC, p.department_code;

-- Query 13: Reparti con almeno N dipendenti (es. 5)
-- Scenario: HR vuole individuare i reparti “grandi”, con almeno 5 dipendenti,
-- per pianificare percorsi di formazione dedicati.
-- Tecniche: GROUP BY + HAVING.
SELECT e.department_code,
       d.name AS department_name,
       COUNT(*) AS number_of_employees
FROM employees AS e
     JOIN departments AS d
        ON e.department_code = d.department_code
GROUP BY e.department_code, d.name
HAVING COUNT(*) >= 5
ORDER BY number_of_employees DESC, e.department_code;

-- Query 14: Prodotti dei reparti con molti dipendenti
-- Scenario: si vuole vedere il catalogo dei reparti “ad alta intensità di personale”,
-- per verificare se la complessità di gamma è coerente con le risorse.
-- Tecniche: subquery con GROUP BY + HAVING e filtro IN.
SELECT p.product_code,
       p.category,
       p.detail,
       p.brand,
       p.department_code,
       p.standard_price
FROM products AS p
WHERE p.department_code IN (
    SELECT e.department_code
    FROM employees AS e
    GROUP BY e.department_code
    HAVING COUNT(*) >= 5
)
ORDER BY p.department_code, p.product_code;

-- NON DA RISULTATI QUINDI NON C'è NE SONO SUP ALLA MEDIA
-- Query 15: Filiali con più dipendenti della media
-- Scenario: la direzione HR vuole sapere quali filiali hanno un organico
-- superiore alla media aziendale, per riequilibrare le risorse.
-- Tecniche: subquery annidata con media su conteggi per filiale.
SELECT e.branch_code,
       b.city,
       COUNT(*) AS number_of_employees
FROM employees AS e
     JOIN branches AS b
        ON e.branch_code = b.branch_code
GROUP BY e.branch_code, b.city
HAVING COUNT(*) > (
    SELECT AVG(branch_employee_count)
    FROM (
        SELECT COUNT(*) AS branch_employee_count
        FROM employees
        GROUP BY branch_code
    ) AS employee_counts
)
ORDER BY number_of_employees DESC, e.branch_code;

------------------------------------------------------------
-- SCENA 5: SUPPLIERS & PROCUREMENT
-- Obiettivo: usare fornitori e approvvigionamenti in modo realistico.
------------------------------------------------------------

-- Query 16: Fornitori senza approvvigionamenti registrati
-- Scenario: l’ufficio acquisti vuole identificare i fornitori mai usati,
-- per valutare se mantenere o meno il rapporto.
-- Tecniche: NOT EXISTS.
SELECT s.supplier_code,
       vat_number,
       company_name,
       headquarter_city
FROM suppliers AS s
WHERE NOT EXISTS ( SELECT *
                   FROM procurements AS pr
                   WHERE pr.supplier_code = s.supplier_code
)
ORDER BY s.supplier_code;

-- Query 17: Città in cui la catena è presente come filiale o come sede di un fornitore
-- Scenario: la direzione vuole una “mappa geografica” riassuntiva delle città
-- in cui la catena è presente, sia come negozio che come partner logistico.
-- Tecniche: UNION per combinare due fonti in un elenco unico.
SELECT b.city AS city_name,
       'branch' AS presence_type
FROM branches AS b
UNION
SELECT s.headquarter_city AS city_name,
       'supplier' AS presence_type
FROM suppliers AS s
ORDER BY city_name, presence_type;

------------------------------------------------------------
-- SCENA 6: ANALISI DEL CATALOGO
-- Obiettivo: usare subquery ALL/ANY e confronti con medie.
------------------------------------------------------------

-- Query 18: Prodotti più costosi nella loro categoria
-- Scenario: il pricing manager vuole identificare, per ogni categoria,
-- il prodotto (o i prodotti) di punta con il prezzo massimo.
-- Tecniche: subquery correlata con ALL.
SELECT product_code,
       p.category,
       detail,
       brand,
       p.standard_price
FROM products AS p
WHERE p.standard_price >= ALL ( SELECT p2.standard_price
                                FROM products AS p2
                                WHERE p2.category = p.category
)
ORDER BY p.category, product_code;


-- Query 19: Prodotti sopra la media della loro categoria
-- Scenario: il pricing manager vuole identificare i prodotti “premium”rispetto ai prodotti della stessa categoria.
-- Tecniche: subquery scalare correlata con AVG.
SELECT product_code,
       p.category,
       detail,
       brand,
       p.standard_price
FROM products AS p
WHERE p.standard_price > ( SELECT AVG(p2.standard_price)
                           FROM products AS p2
                           WHERE p2.category = p.category
)
ORDER BY p.category, p.standard_price DESC, p.product_code;

