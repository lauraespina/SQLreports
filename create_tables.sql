CREATE SCHEMA IF NOT EXISTS order_customer
	AUTHORIZATION postgres;

CREATE SCHEMA IF NOT EXISTS customer
	AUTHORIZATION postgres;
	
CREATE SCHEMA IF NOT EXISTS address
	AUTHORIZATION postgres;
	
CREATE TABLE address.countries (
	id int8 NOT NULL,
	name varchar(255) NOT NULL,
	iso_code varchar(2) NOT NULL,
	iso_code_3_digit varchar(3) NOT NULL,
	created_time timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_address_countries PRIMARY KEY (id)
);

CREATE TABLE address.addresses (
	id int8 NOT NULL GENERATED ALWAYS AS IDENTITY,
	address_line_1 varchar(255) NOT NULL,
	address_line_2 varchar(255) NULL,
	address_line_3 varchar(255) NULL,
	city varchar(255) NOT NULL,
	county varchar(255) NOT NULL,
	post_code varchar(255) NOT NULL,
	country_id int8 NOT NULL,
	phone varchar(50) NULL,
	created_time timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	default_currency varchar(5) NOT NULL DEFAULT 'EUR'::character varying,
	CONSTRAINT pk_address_addresses PRIMARY KEY (id),
	CONSTRAINT fk_address_countries FOREIGN KEY(country_id) REFERENCES address.countries(id)
);

CREATE TABLE customer.address (
	customer_id int4 NOT NULL,
	address_id int4 NOT NULL,
	is_default bool NOT NULL DEFAULT FALSE,
	CONSTRAINT pk_customer_address_pkey PRIMARY KEY (customer_id, address_id),
	CONSTRAINT fk_address_addresses FOREIGN KEY(address_id) REFERENCES address.addresses(id)
);

CREATE TABLE customer.customers (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	first_name varchar(255) NOT NULL,
	last_name varchar(255) NOT NULL,
	email varchar(255) NOT NULL,
	date_of_birth timestamptz NULL,
	created_time timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	account_balance numeric NULL,
	account_created_time timestamptz NULL,
	account_updated_time timestamptz NULL,
	customer_number varchar(25) NULL,
	default_billing_address_id int4 NULL,
	default_delivery_address_id int4 NULL,
	CONSTRAINT pk_customer_customers PRIMARY KEY (id),
	CONSTRAINT fk_customer_default_billing_address_id FOREIGN KEY (default_billing_address_id) REFERENCES address.addresses(id),
	CONSTRAINT fk_customer_default_delivery_address_id FOREIGN KEY (default_delivery_address_id) REFERENCES address.addresses(id)
);


ALTER TABLE customer.address ADD CONSTRAINT fk_customer_customers FOREIGN KEY (customer_id) REFERENCES customer.customers(id) ON DELETE CASCADE
