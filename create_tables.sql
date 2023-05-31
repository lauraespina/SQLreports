CREATE TABLE customers.customers (
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
	default_country_id int4 NULL,
	default_currency_id int4 NULL,
	default_payment_type_id int4 NOT NULL DEFAULT 1,
	default_payment_card_token text NULL,
	default_billing_address_id int4 NULL,
	default_delivery_address_id int4 NULL,
	customer_type_id int4 NOT NULL DEFAULT 1,
	CONSTRAINT customers_pkey PRIMARY KEY (id)
);

-- customer.customers foreign keys
/*
ALTER TABLE customer.customers ADD CONSTRAINT customers_customer_type_id_fkey FOREIGN KEY (customer_type_id) REFERENCES customer.customer_types(id);
ALTER TABLE customer.customers ADD CONSTRAINT customers_default_billing_address_id_fkey FOREIGN KEY (default_billing_address_id) REFERENCES address.addresses(id);
ALTER TABLE customer.customers ADD CONSTRAINT customers_default_country_id_fkey FOREIGN KEY (default_country_id) REFERENCES address.countries(id);
ALTER TABLE customer.customers ADD CONSTRAINT customers_default_currency_id_fkey FOREIGN KEY (default_currency_id) REFERENCES currency.currencies(id);
ALTER TABLE customer.customers ADD CONSTRAINT customers_default_delivery_address_id_fkey FOREIGN KEY (default_delivery_address_id) REFERENCES address.addresses(id);
ALTER TABLE customer.customers ADD CONSTRAINT customers_default_payment_type_id_fkey FOREIGN KEY (default_payment_type_id) REFERENCES customer.payment_types(id);
ALTER TABLE customer.customers ADD CONSTRAINT customers_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.sources(id);
*/
