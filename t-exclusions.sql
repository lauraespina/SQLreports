CREATE TABLE reporting.exclusions(
customer_id int NOT NULL,
CONSTRAINT fk_exclusions_id
 	FOREIGN KEY(customer_id)
	REFERENCES customer.customers(id)
	ON DELETE cascade
)

INSERT INTO reporting.exclusions (customer_id)
SELECT id
FROM customer.customers
WHERE id = 1774355
