INSERT INTO d_day (day_name)
VALUES
('Monday'), ('Tuesday'), ('Wednesday'), ('Thursday'),
('Friday'), ('Saturday'), ('Sunday');

INSERT INTO d_month (month_name)
VALUES
('January'), ('February'), ('March'), ('April'),
('May'), ('June'), ('July'), ('August'),
('September'), ('October'), ('November'), ('December');

INSERT INTO d_time (date, day_id, month_id, year)
WITH sub AS (SELECT DISTINCT sale_date AS data FROM mock_data union (SELECT DISTINCT product_release_date AS data FROM mock_data UNION SELECT product_expiry_date AS data FROM mock_data))
SELECT DISTINCT
	sub.data::date,
    EXTRACT(DOW FROM sub.data::date) + 1,
    EXTRACT(MONTH FROM sub.data::date),
    EXTRACT(YEAR FROM sub.data::date)
FROM sub;

INSERT INTO d_country (country_name)
WITH sub AS (SELECT DISTINCT seller_country AS data
FROM mock_data UNION (SELECT DISTINCT store_country AS data
FROM mock_data UNION (SELECT DISTINCT customer_country AS data
FROM mock_data UNION SELECT DISTINCT supplier_country AS data
FROM mock_data)))
SELECT DISTINCT data FROM sub
WHERE data IS NOT NULL;

INSERT INTO d_city (city_name)
with sub1 AS (SELECT DISTINCT store_city AS city FROM mock_data),
sub2 AS (SELECT DISTINCT supplier_city AS city FROM mock_data)
SELECT DISTINCT * FROM (SELECT city FROM sub1 UNION SELECT city FROM sub2)
WHERE city IS NOT NULL;

INSERT INTO d_kind (kind_name)
SELECT DISTINCT customer_pet_type
FROM mock_data
WHERE customer_pet_type IS NOT NULL;

INSERT INTO d_breed (breed_name)
SELECT DISTINCT customer_pet_breed
FROM mock_data
WHERE customer_pet_breed IS NOT NULL;

INSERT INTO d_pet_category (pet_category_name)
SELECT DISTINCT pet_category
FROM mock_data
WHERE pet_category IS NOT NULL;

INSERT INTO d_product_category (product_category_name)
SELECT DISTINCT product_category
FROM mock_data
WHERE product_category IS NOT NULL;

INSERT INTO d_product_color (product_color_name)
SELECT DISTINCT product_color
FROM mock_data
WHERE product_color IS NOT NULL;

INSERT INTO d_product_brand (product_brand_name)
SELECT DISTINCT product_brand
FROM mock_data
WHERE product_brand IS NOT NULL;

INSERT INTO d_product_material (product_material_name)
SELECT DISTINCT product_material
FROM mock_data
WHERE product_material IS NOT NULL;

INSERT INTO d_name (name)
WITH sub AS (SELECT DISTINCT customer_first_name AS data
FROM mock_data UNION (SELECT DISTINCT customer_pet_name AS data
FROM mock_data UNION (SELECT DISTINCT seller_first_name AS data
FROM mock_data)))
SELECT DISTINCT data FROM sub
WHERE data IS NOT NULL;

INSERT INTO d_pet (type_id, breed_id, pet_name_id)
SELECT DISTINCT
    (SELECT kind_id FROM d_kind WHERE kind_name = md.customer_pet_type),
    (SELECT breed_id FROM d_breed WHERE breed_name = md.customer_pet_breed),
    (SELECT name_id FROM d_name WHERE name = md.customer_pet_name)
FROM mock_data as md;

INSERT INTO d_last_name (last_name)
WITH sub AS (SELECT DISTINCT customer_last_name AS data
FROM mock_data UNION (SELECT DISTINCT seller_last_name AS data
FROM mock_data))
SELECT DISTINCT data FROM sub
WHERE data IS NOT NULL;

INSERT INTO d_customer (customer_first_name_id, customer_last_name_id, customer_age, customer_email, customer_country_id, customer_postal_code, customer_pet_id)
SELECT distinct
	(SELECT name_id FROM d_name WHERE name = md.customer_first_name),
    (SELECT last_name_id FROM d_last_name WHERE last_name = md.customer_last_name),
    md.customer_age,
    md.customer_email,
    (SELECT country_id FROM d_country WHERE country_name = md.customer_country),
    md.customer_postal_code,
    (
        SELECT pet_id
        FROM d_pet
        WHERE type_id = (SELECT kind_id FROM d_kind WHERE kind_name = md.customer_pet_type)
          AND breed_id = (SELECT breed_id FROM d_breed WHERE breed_name = md.customer_pet_breed)
          AND pet_name_id = (SELECT name_id FROM d_name WHERE name = md.customer_pet_name)
    )
FROM mock_data AS md;

INSERT INTO d_seller (seller_first_name_id, seller_last_name_id, seller_email, seller_country_id, seller_postal_code)
SELECT DISTINCT
	(SELECT name_id FROM d_name WHERE name = md.seller_first_name),
    (SELECT last_name_id FROM d_last_name WHERE last_name = md.seller_last_name),
    md.seller_email,
    (SELECT country_id FROM d_country WHERE country_name = md.seller_country),
    md.seller_postal_code
FROM mock_data as md;

INSERT INTO d_product_name (product_name)
SELECT DISTINCT product_name
FROM mock_data
WHERE product_name IS NOT NULL;

INSERT INTO d_product (product_name_id, product_category_id, product_price, product_quantity, pet_category_id, product_weight, product_color_id, product_size, product_brand_id, product_material_id, product_description, product_rating, product_reviews, product_release_date_id, product_expiry_date_id)
SELECT DISTINCT
    (SELECT product_name_id FROM d_product_name WHERE product_name = md.product_name),
    (SELECT product_category_id FROM d_product_category WHERE product_category_name = md.product_category),
    md.product_price,
    md.product_quantity,
    (SELECT pet_category_id FROM d_pet_category WHERE pet_category_name = md.pet_category),
    md.product_weight,
    (SELECT product_color_id FROM d_product_color WHERE product_color_name = md.product_color),
    md.product_size,
    (SELECT product_brand_id FROM d_product_brand WHERE product_brand_name = md.product_brand),
    (SELECT product_material_id FROM d_product_material WHERE product_material_name = md.product_material),
    md.product_description,
    md.product_rating,
    md.product_reviews,
    (SELECT date_id FROM d_time WHERE date = md.product_release_date::date),
    (SELECT date_id FROM d_time WHERE date = md.product_expiry_date::date)
FROM mock_data as md;

INSERT INTO d_store (store_location, store_city_id, store_state, store_country_id, store_phone, store_email)
SELECT DISTINCT
    md.store_location,
    (SELECT city_id FROM d_city WHERE city_name = md.store_city),
    md.store_state,
    (SELECT country_id FROM d_country WHERE country_name = md.store_country),
    md.store_phone,
    md.store_email
FROM mock_data md;

INSERT INTO d_supplier (supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city_id, supplier_country_id)
SELECT DISTINCT
    md.supplier_name,
    md.supplier_contact,
    md.supplier_email,
    md.supplier_phone,
    md.supplier_address,
    (SELECT city_id FROM d_city WHERE city_name = md.supplier_city),
    (SELECT country_id FROM d_country WHERE country_name = md.supplier_country)
FROM mock_data md;

INSERT INTO f_sale (sale_date_id, sale_customer_id, sale_seller_id, sale_product_id, sale_store_id, sale_supplier_id, sale_quantity, sale_total_price)
SELECT DISTINCT
    (SELECT date_id FROM d_time WHERE Date = md.sale_date::date),
    (SELECT customer_id FROM d_customer WHERE customer_email = md.customer_email LIMIT 1),
    (SELECT seller_id FROM d_seller WHERE seller_email = md.seller_email LIMIT 1),
    (
        SELECT product_id
        FROM d_product
        WHERE product_name_id = (SELECT product_name_id FROM d_product_name WHERE product_name = md.product_name) 
          AND product_category_id = (SELECT product_category_id FROM d_product_category WHERE product_category_name = md.product_category)
          AND product_price = md.product_price
          AND product_quantity = md.product_quantity
          AND pet_category_id = (SELECT pet_category_id FROM d_pet_category WHERE pet_category_name = md.pet_category)
          AND product_weight = md.product_weight
          AND product_color_id = (SELECT product_color_id FROM d_product_color WHERE product_color_name = md.product_color)
          AND product_size = md.product_size
          AND product_brand_id = (SELECT product_brand_id FROM d_product_brand WHERE product_brand_name = md.product_brand)
          AND product_material_id = (SELECT product_material_id FROM d_product_material WHERE product_material_name = md.product_material)
          AND product_description = md.product_description
          AND product_rating = md.product_rating
          AND product_reviews = md.product_reviews
          AND product_release_date_id = (SELECT date_id FROM d_time WHERE date = md.product_release_date::date)
          AND product_expiry_date_id = (SELECT date_id FROM d_time WHERE date = md.product_expiry_date::date)
    ),
    (SELECT store_id FROM d_store WHERE store_email = md.store_email),
    (SELECT supplier_id FROM d_supplier WHERE supplier_email = md.supplier_email),
    md.sale_quantity,
    md.sale_total_price
FROM mock_data md;