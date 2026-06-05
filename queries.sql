-- SuperMarket Chain Database
-- Difficulty progression: queries S1-S10 for database structure overview, queries 1-5 basic, queries 6-30 increasing in complexity

SET search_path TO supermarket_chain;


-- DATABASE STRUCTURE OVERVIEW

-- Query S1: Show all physical stores with their location details.
SELECT branch_code, city, street, number, postal_code
FROM branches
ORDER BY branch_code;

-- Query S2: Show all organizational units inside each branch with their code and name.
SELECT department_code, name
FROM departments
ORDER BY department_code;

-- Query S3: Show all distinct employee roles across the company.
SELECT DISTINCT role
FROM employees
ORDER BY role;

-- Query S4: How many employees work in each branch.
SELECT b.branch_code, b.city, COUNT(e.employee_code) AS num_employees
FROM branches b INNER JOIN employees e ON b.branch_code = e.branch_code
GROUP BY b.branch_code, b.city
ORDER BY branch_code;

-- Query S5: How many employees work in each department (size of each organizational unit)
SELECT d.name AS department_name, COUNT(e.employee_code) AS num_employees
FROM departments d INNER JOIN employees e ON d.department_code = e.department_code
GROUP BY d.department_code, d.name
ORDER BY num_employees DESC, department_name;

-- Query S6: Show all suppliers with their company name and headquarter city.
SELECT supplier_code, vat_number, company_name, headquarter_city
FROM suppliers
ORDER BY company_name;

-- Query S7: Show all customers with their loyalty points.
SELECT loyalty_card_id, first_name, last_name, accumulated_points
FROM customers
ORDER BY accumulated_points DESC, last_name ASC;

-- Query S8: Show all types of products available in the database.
SELECT DISTINCT category
FROM products
ORDER BY category;

-- Query S9: Show all product catalogue with category, brand, department, and standard price.
SELECT product_code, category, detail, brand, department_code, standard_price
FROM products
ORDER BY category, product_code;

-- Query S10: How many products belong to each department (product distribution across departments)
SELECT d.department_code, name, COUNT(product_code) AS num_products
FROM departments d INNER JOIN products p ON d.department_code = p.department_code
GROUP BY d.department_code, name
ORDER BY num_products DESC, name;




-- BASIC LEVEL


-- Query 1: Show all customers who currently have more than 500 accumulated loyalty points.
SELECT loyalty_card_id, first_name, last_name, email, accumulated_points
FROM customers
WHERE accumulated_points > 500
ORDER BY accumulated_points DESC, last_name ASC;

-- Query 2: Show products whose category starts with the word 'Baby Toiletries' (to use LIKE).
SELECT product_code, category, detail, brand, standard_price
FROM products
WHERE category LIKE 'Baby Toiletries%'
ORDER BY standard_price DESC, product_code;

-- Query 3: Show all employees with their full department name.
SELECT e.employee_code,
       e.first_name,
       e.last_name,
       e.role,
       e.branch_code,
       d.name AS department_name
FROM employees e
INNER JOIN departments d ON e.department_code = d.department_code
ORDER BY e.branch_code, d.name, e.last_name;

-- Query 4: Show all employees working at the checkout department.
SELECT employee_code,
       first_name,
       last_name,
       role,
       branch_code
FROM employees
WHERE department_code = 'CHK'
ORDER BY branch_code, last_name, first_name;

-- Query 5: Show products available in a specific branch (branch_code = 1),
-- with their local price compared to the standard price.
SELECT p.product_code,
       p.category,
       p.brand,
       p.standard_price,
       a.local_price,
       (a.local_price - p.standard_price) AS price_difference
FROM products p
INNER JOIN availability a ON p.product_code = a.product_code
WHERE a.branch_code = 1
ORDER BY price_difference DESC, p.category;




-- INTERMEDIATE LEVEL


-- Query 6: Show all products and, where available, their stock quantity in branch 1.
-- Products not stocked in branch 1 appear with NULL quantity (LEFT OUTER JOIN).
SELECT p.product_code,
       p.category,
       p.brand,
       p.standard_price,
       a.quantity,
       a.local_price
FROM products p LEFT OUTER JOIN availability a ON p.product_code = a.product_code
                               AND a.branch_code = 1
ORDER BY a.quantity DESC, p.category;

-- Query 7: Show each product together with the name of its department.
SELECT p.product_code,
       p.category,
       p.detail,
       p.brand,
       d.department_code,
       d.name AS department_name,
       p.standard_price
FROM products p
INNER JOIN departments d ON p.department_code = d.department_code
ORDER BY d.name, p.category, p.product_code;

-- Query 8: Show all customers together with their phone numbers, including customers who do not have any registered phone number (NULL).
SELECT c.loyalty_card_id,
       c.first_name,
       c.last_name,
       cp.phone_number
FROM customers c LEFT OUTER JOIN customer_phones cp ON c.loyalty_card_id = cp.loyalty_card_id
ORDER BY c.loyalty_card_id, cp.phone_number;

-- Query 9: Show each employee with branch city and department name (triple JOIN).
SELECT e.employee_code,
       e.first_name,
       e.last_name,
       e.role,
       b.city AS branch_city,
       d.name AS department_name
FROM employees e INNER JOIN branches b    ON e.branch_code    = b.branch_code
                 INNER JOIN departments d ON e.department_code = d.department_code
ORDER BY b.city, d.name, e.last_name;

-- Query 10: Compute the average standard price of products for each department.
SELECT p.department_code,
       d.name AS department_name,
       AVG(p.standard_price) AS average_standard_price
FROM products p INNER JOIN departments d ON p.department_code = d.department_code
GROUP BY p.department_code, d.name
ORDER BY average_standard_price DESC, p.department_code;

-- Query 11: Show only the departments whose average product price is greater than 5.
SELECT p.department_code,
       d.name AS department_name,
       ROUND(AVG(p.standard_price), 2) AS average_standard_price
FROM products p
INNER JOIN departments d ON p.department_code = d.department_code
GROUP BY p.department_code, d.name
HAVING AVG(p.standard_price) > 5
ORDER BY average_standard_price DESC;

-- Query 12: Show how many distinct products are available in each branch.
SELECT b.branch_code,
       b.city,
       COUNT(DISTINCT a.product_code) AS num_products_available
FROM branches b
INNER JOIN availability a ON b.branch_code = a.branch_code
GROUP BY b.branch_code, b.city
ORDER BY num_products_available DESC;

-- Query 13: Show the customers who have at least one registered phone number (IN).
SELECT loyalty_card_id, first_name, last_name
FROM customers
WHERE loyalty_card_id IN (SELECT loyalty_card_id
                          FROM customer_phones)
ORDER BY loyalty_card_id;

-- Query 14: Show the customers who do not have any registered phone number (NOT IN).
SELECT loyalty_card_id, first_name, last_name
FROM customers
WHERE loyalty_card_id NOT IN (SELECT loyalty_card_id
                              FROM customer_phones)
ORDER BY loyalty_card_id;

-- Query 15: Show the products whose standard price is above the overall average standard price.
SELECT product_code, category, detail, brand, standard_price
FROM products
WHERE standard_price > (SELECT AVG(standard_price)
                        FROM products)
ORDER BY standard_price DESC, product_code;




-- ADVANCED LEVEL


-- Query 16: Show, for each department, the number of products and the minimum, average, and maximum standard price.
SELECT p.department_code,
       d.name AS department_name,
       COUNT(*) AS number_of_products,
       MIN(p.standard_price) AS minimum_price,
       AVG(p.standard_price) AS average_price,
       MAX(p.standard_price) AS maximum_price
FROM products p
INNER JOIN departments d ON p.department_code = d.department_code
GROUP BY p.department_code, d.name
ORDER BY number_of_products DESC, p.department_code;

-- Query 17: Show the branches that currently have no rows in the availability table, using NOT EXISTS.
-- Note: with the current dataset all branches have at least one product in availability,
-- so the result is intentionally empty. The query is logically correct.
SELECT b.branch_code, b.city, b.street, b.number
FROM branches b
WHERE NOT EXISTS (SELECT *
                  FROM availability a
                  WHERE a.branch_code = b.branch_code)
ORDER BY b.branch_code;

-- Query 18: Show the suppliers that currently have no rows in the procurements table, using NOT EXISTS.
-- Note: if all suppliers have at least one procurement row, the result is intentionally empty.
SELECT s.supplier_code, s.company_name, s.headquarter_city
FROM suppliers s
WHERE NOT EXISTS (SELECT *
                  FROM procurements p
                  WHERE p.supplier_code = s.supplier_code)
ORDER BY s.supplier_code;

-- Query 19: Show the employees who work in a branch located in London or Manchester.
SELECT e.employee_code,
       e.first_name,
       e.last_name,
       e.role,
       b.city
FROM employees e
INNER JOIN branches b ON e.branch_code = b.branch_code
WHERE b.city IN ('London', 'Manchester')
ORDER BY b.city, e.last_name, e.first_name;

-- Query 20: Show the most expensive product or products in the whole catalog using ALL.
SELECT product_code, category, detail, brand, standard_price
FROM products
WHERE standard_price >= ALL (SELECT standard_price
                             FROM products)
ORDER BY product_code;

-- Query 21: Show the cheapest product or products in the whole catalog using MIN in a nested query.
SELECT product_code, category, detail, brand, standard_price
FROM products
WHERE standard_price = (SELECT MIN(standard_price)
                        FROM products)
ORDER BY product_code;

-- Query 22: Show products whose price is greater than at least one product in the 'Beverages' category, using ANY.
SELECT product_code, category, brand, standard_price
FROM products
WHERE standard_price > ANY (SELECT standard_price
                            FROM products
                            WHERE category = 'Beverages')
ORDER BY standard_price DESC, product_code;

-- Query 23: Show, for every branch and department combination that actually appears in the data, how many employees belong to it.
SELECT e.branch_code,
       b.city,
       e.department_code,
       d.name AS department_name,
       COUNT(*) AS number_of_employees
FROM employees e
INNER JOIN branches b    ON e.branch_code    = b.branch_code
INNER JOIN departments d ON e.department_code = d.department_code
GROUP BY e.branch_code, b.city, e.department_code, d.name
ORDER BY e.branch_code, number_of_employees DESC, e.department_code;

-- Query 24: Show the departments that have at least five employees in total.
SELECT e.department_code,
       d.name AS department_name,
       COUNT(*) AS number_of_employees
FROM employees e
INNER JOIN departments d ON e.department_code = d.department_code
GROUP BY e.department_code, d.name
HAVING COUNT(*) >= 5
ORDER BY number_of_employees DESC, e.department_code;

-- Query 25: Show the products that belong to departments where at least ten employees work.
SELECT p.product_code,
       p.category,
       p.detail,
       p.brand,
       p.department_code,
       p.standard_price
FROM products p
WHERE p.department_code IN (SELECT e.department_code
                            FROM employees e
                            GROUP BY e.department_code
                            HAVING COUNT(*) >= 10)
ORDER BY p.department_code, p.product_code;




-- HIGHER LEVEL


-- Query 26: Show the branches whose number of employees is greater than the average number of employees per branch.
SELECT e.branch_code,
       b.city,
       COUNT(*) AS number_of_employees
FROM employees e
INNER JOIN branches b ON e.branch_code = b.branch_code
GROUP BY e.branch_code, b.city
HAVING COUNT(*) > (SELECT AVG(branch_employee_count)
                   FROM (SELECT COUNT(*) AS branch_employee_count
                         FROM employees
                         GROUP BY branch_code) AS employee_counts)
ORDER BY number_of_employees DESC, e.branch_code;

-- Query 27: Show the departments that are used both by employees and by products, using INTERSECT.
SELECT department_code
FROM employees
INTERSECT
SELECT department_code
FROM products
ORDER BY department_code;

-- Query 28: Show the departments that currently appear in employees but not in products, using EXCEPT.
SELECT department_code
FROM employees
EXCEPT
SELECT department_code
FROM products
ORDER BY department_code;

-- Query 29: Show the branches that employ at least one cashier and at least one manager or store manager.
SELECT b.branch_code, b.city
FROM branches b
WHERE EXISTS (SELECT *
              FROM employees e
              WHERE e.branch_code = b.branch_code
                AND e.role = 'Cashier')
  AND EXISTS (SELECT *
              FROM employees e
              WHERE e.branch_code = b.branch_code
                AND (e.role = 'Manager' OR e.role = 'Store Manager'))
ORDER BY b.branch_code;

-- Query 30: Show the branches for which there is no department represented by more than one employee.
SELECT b.branch_code, b.city
FROM branches b
WHERE NOT EXISTS (SELECT e.department_code
                  FROM employees e
                  WHERE e.branch_code = b.branch_code
                  GROUP BY e.department_code
                  HAVING COUNT(*) > 1)
ORDER BY b.branch_code;

-- Query 31: Show all department codes that appear in employees or in products, using UNION.
-- (combines two sources into a single deduplicated list; compare with Q27 INTERSECT and Q28 EXCEPT)
SELECT department_code, 'employees' AS source
FROM employees
UNION
SELECT department_code, 'products' AS source
FROM products
ORDER BY department_code, source;

-- Query 32: Show all cities where the chain has a presence, either as a branch location
-- or as a supplier headquarter city, using UNION.
SELECT city AS city_name, 'branch' AS type
FROM branches
UNION
SELECT headquarter_city, 'supplier'
FROM suppliers
ORDER BY city_name, type;
