CREATE TABLE d_day (
    day_id SERIAL PRIMARY KEY,
    day_name TEXT NOT NULL
);

CREATE TABLE d_month (
    month_id SERIAL PRIMARY KEY,
    month_name TEXT NOT NULL
);

CREATE TABLE d_time (
    date_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    day_id INT NOT NULL,
    month_id INT NOT NULL,
    year INT NOT NULL,
    FOREIGN KEY (day_id) REFERENCES d_day(day_id),
    FOREIGN KEY (month_id) REFERENCES d_month(month_id)
);

CREATE TABLE d_pet_category (
    pet_category_id SERIAL PRIMARY KEY,
    pet_category_name TEXT
);

CREATE TABLE d_product_material (
    product_material_id SERIAL PRIMARY KEY,
    product_material_name TEXT
);

CREATE TABLE d_product_brand (
    product_brand_id SERIAL PRIMARY KEY,
    product_brand_name TEXT
);

CREATE TABLE d_product_category (
    product_category_id SERIAL PRIMARY KEY,
    product_category_name TEXT
);

CREATE TABLE d_product_color (
    product_color_id SERIAL PRIMARY KEY,
    product_color_name TEXT
);

CREATE TABLE d_country (
    country_id SERIAL PRIMARY KEY,
    country_name TEXT
);

CREATE TABLE d_city (
    city_id SERIAL PRIMARY KEY,
    city_name TEXT
);

CREATE TABLE d_kind (
    kind_id SERIAL PRIMARY KEY,
    kind_name TEXT
);

CREATE TABLE d_breed (
    breed_id SERIAL PRIMARY KEY,
    breed_name TEXT
);

CREATE TABLE d_name (
    name_id SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TABLE d_pet (
    pet_id SERIAL PRIMARY KEY,
    type_id INT,
    breed_id INT,
    pet_name_id INT,
    FOREIGN KEY (pet_name_id) REFERENCES d_name(name_id),
    FOREIGN KEY (type_id) REFERENCES d_kind(kind_id),
    FOREIGN KEY (breed_id) REFERENCES d_breed(breed_id)
);

CREATE TABLE d_last_name (
    last_name_id SERIAL PRIMARY KEY,
    last_name TEXT
);

CREATE TABLE d_customer (
    customer_id SERIAL PRIMARY KEY,
    customer_first_name_id INT,
    customer_last_name_id INT,
    customer_age INT,
    customer_email TEXT,
    customer_country_id INT,
    customer_postal_code TEXT,
    customer_pet_id INT,
    FOREIGN KEY (customer_first_name_id) REFERENCES d_name(name_id),
    FOREIGN KEY (customer_last_name_id) REFERENCES d_last_name(last_name_id),
    FOREIGN KEY (customer_country_id) REFERENCES d_country(country_id),
    FOREIGN KEY (customer_pet_id) REFERENCES d_pet(pet_id)
);

CREATE TABLE d_seller (
    seller_id SERIAL PRIMARY KEY,
    seller_first_name_id INT,
    seller_last_name_id INT,
    seller_email TEXT,
    seller_country_id INT,
    seller_postal_code TEXT,
    FOREIGN KEY (seller_first_name_id) REFERENCES d_name(name_id),
    FOREIGN KEY (seller_last_name_id) REFERENCES d_last_name(last_name_id),
    FOREIGN KEY (seller_country_id) REFERENCES d_country(country_id)
);

CREATE TABLE d_product_name (
    product_name_id SERIAL PRIMARY KEY,
    product_name TEXT
);

CREATE TABLE d_product (
    product_id SERIAL PRIMARY KEY,
    product_name_id INT,
    product_category_id INT,
    product_price DECIMAL,
    product_quantity INT,
    pet_category_id INT,
    product_weight DECIMAL,
    product_color_id INT,
    product_size TEXT,
    product_brand_id INT,
    product_material_id INT,
    product_description TEXT,
    product_rating DECIMAL,
    product_reviews INT,
    product_release_date_id INT,
    product_expiry_date_id INT,
    FOREIGN KEY (product_name_id) REFERENCES d_product_name(product_name_id),
    FOREIGN KEY (product_category_id) REFERENCES d_product_category(product_category_id),
    FOREIGN KEY (pet_category_id) REFERENCES d_pet_category(pet_category_id),
    FOREIGN KEY (product_color_id) REFERENCES d_product_color(product_color_id),
    FOREIGN KEY (product_brand_id) REFERENCES d_product_brand(product_brand_id),
    FOREIGN KEY (product_material_id) REFERENCES d_product_material(product_material_id),
    FOREIGN KEY (product_release_date_id) REFERENCES d_time(date_id),
    FOREIGN KEY (product_expiry_date_id) REFERENCES d_time(date_id)
);

CREATE TABLE d_store (
    store_id SERIAL PRIMARY KEY,
    store_location TEXT,
    store_city_id INT,
    store_state TEXT,
    store_country_id INT,
    store_phone TEXT,
    store_email TEXT,
    FOREIGN KEY (store_country_id) REFERENCES d_country(country_id),
    FOREIGN KEY (store_city_id) REFERENCES d_city(city_id)
);

CREATE TABLE d_supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name TEXT,
    supplier_contact TEXT,
    supplier_email TEXT,
    supplier_phone TEXT,
    supplier_address TEXT,
    supplier_city_id INT,
    supplier_country_id INT,
    FOREIGN KEY (supplier_country_id) REFERENCES d_country(country_id),
    FOREIGN KEY (supplier_city_id) REFERENCES d_city(city_id)
);

CREATE TABLE f_sale (
    sale_id SERIAL PRIMARY KEY,
    sale_date_id INT,
    sale_customer_id INT,
    sale_seller_id INT,
    sale_product_id INT,
    sale_store_id INT,
    sale_supplier_id INT,
    sale_quantity INT,
    sale_total_price DECIMAL,
    FOREIGN KEY (sale_customer_id) REFERENCES d_customer(customer_id),
    FOREIGN KEY (sale_seller_id) REFERENCES d_seller(seller_id),
    FOREIGN KEY (sale_product_id) REFERENCES d_product(product_id),
    FOREIGN KEY (sale_store_id) REFERENCES d_store(store_id),
    FOREIGN KEY (sale_supplier_id) REFERENCES d_supplier(supplier_id),
    FOREIGN KEY (sale_date_id) REFERENCES d_time(date_id)
);