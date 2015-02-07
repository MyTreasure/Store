CREATE TABLE platforms (
      platform_id SERIAL PRIMARY KEY
    , platform_name TEXT
    , platform_description TEXT
    , platform_link TEXT
    , created_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
    , modified_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
 );

CREATE TABLE prices (
      price_id INTEGER
    , price MONEY
    , price_changed_by TEXT NOT NULL CHECK (price_changed_by <> '')
    , price_comments TEXT NOT NULL CHECK (price_comments <> '')
    , price_due_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
    , created_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
    , modified_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
 );

CREATE TABLE payment_methods (
      payment_method_id SERIAL PRIMARY KEY
    , payment_method_name TEXT
    , payment_method_description TEXT
    , created_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
    , modified_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

CREATE TABLE product_groups (
      product_group_id SERIAL PRIMARY KEY
    , product_group_name TEXT
    , product_group_description TEXT
    , product_group_link TEXT
    , created_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
    , modified_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
 );

CREATE TABLE products (
      product_id SERIAL PRIMARY KEY
    , product_name TEXT
    , product_description TEXT
    , product_link TEXT
    , product_group_id INTEGER REFERENCES product_groups (product_group_id)
    , created_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
    , modified_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
    -- , PRIMARY KEY (product_id, product_group_id)
 );

CREATE TABLE client_types (
      client_type_id SERIAL PRIMARY KEY
    , client_type_description TEXT
    , created_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
    , modified_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

CREATE TABLE clients (
      client_id SERIAL PRIMARY KEY
    , client_name TEXT
    , client_skype TEXT
    , client_phone TEXT
    , client_email TEXT
    , client_profile_link TEXT
    , client_type_id INTEGER REFERENCES client_types (client_type_id)
    -- , product_type_id INTEGER -- duplicates in orders
    -- , product_group_id INTEGER -- duplicates in orders
    , created_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
    , modified_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

CREATE TABLE orders (
      order_id SERIAL PRIMARY KEY
    , client_id INTEGER REFERENCES clients (client_id)
    , product_id INTEGER REFERENCES products (product_id)
    -- , product_group_id INTEGER -- REFERENCES products (product_group_id)
    -- , order_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
    , platform_id INTEGER REFERENCES platforms (platform_id)
    , price_id INTEGER -- REFERENCES prices (price_id)
    , payment_method_id INTEGER REFERENCES payment_methods (payment_method_id)
    , feedback TEXT
    , created_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
    , modified_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
    -- , FOREIGN KEY (product_id, product_group_id) REFERENCES products (product_id, product_group_id)
);

