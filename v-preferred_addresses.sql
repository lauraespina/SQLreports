CREATE VIEW reporting.preferred_addresses_view AS
WITH lastorders AS (
  SELECT
     co1.customer_id,
    co1.created_time,
    co1.delivery_address_id,
    co1.billing_address_id
  FROM
    customer_order.orders co1
  INNER JOIN (
    SELECT
      customer_id,
      max(created_time) created_time
    FROM customer_order.orders
    GROUP BY customer_id
    )
    co2 ON co1.customer_id = co2.customer_id AND co1.created_time = co2.created_time
  ORDER BY co1.customer_id 
  )
SELECT
	cucu.id AS "customer_id",
	CASE
		WHEN cucu.default_billing_address_id IS NULL THEN lastorders.billing_address_id
		ELSE cucu.default_billing_address_id
	END AS "billing_address_id",
	CASE
		WHEN cucu.default_billing_address_id IS NULL
		AND lastorders.billing_address_id IS NULL THEN NULL
		WHEN cucu.default_billing_address_id IS NOT NULL THEN 'Customer default'
		ELSE 'Last order'
	END AS "billing_address_source",
	CASE
		WHEN cucu.default_delivery_address_id IS NULL THEN lastorders.delivery_address_id
		ELSE cucu.default_delivery_address_id
	END AS "delivery_address_id",
	CASE
		WHEN cucu.default_delivery_address_id IS NULL
		AND lastorders.delivery_address_id IS NULL THEN NULL
		WHEN cucu.default_delivery_address_id IS NOT NULL THEN 'Customer default'
		ELSE 'Last order'
	END AS "delivery_address_source"
FROM customer.customers cucu
LEFT JOIN lastorders ON cucu.id = lastorders.customer_id
ORDER BY cucu.id
