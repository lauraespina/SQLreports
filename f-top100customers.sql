CREATE OR REPLACE FUNCTION get_top_100customers(startdate timestamp DEFAULT date_trunc('MONTH', NOW() - INTERVAL '6 month'), enddate timestamp DEFAULT date_trunc('MONTH', NOW()) - INTERVAL '1 day')
	RETURNS TABLE(customer_id int, customer_nr int, nameperson varchar, email varchar, country varchar, city varchar, spent numeric, nr_transactions bigint, last_transaction timestamp)
	LANGUAGE plpgsql
AS $$
BEGIN
	RETURN query
	WITH custotals AS (
		SELECT
			coo.customer_id AS "customer_id",
			sum(coo.total) AS "spent",
			count(coo.total) AS "nr_transactions",
			max(coo.created_time) AS "last_transaction"
		FROM customer_order.orders coo
		WHERE coo.created_time BETWEEN startdate AND enddate
		GROUP BY coo.customer_id
		ORDER BY "spent" DESC
		)
	SELECT
		custotals.customer_id::int,
		cucu.customer_number::int,
		CONCAT(cucu.first_name, ' ', cucu.last_name)::varchar,
		cucu.email::varchar,
		ac.name::varchar,
		aa.city::varchar,
		custotals.spent::numeric,
		custotals.nr_transactions::bigint,
		custotals.last_transaction::timestamp
	FROM custotals
	LEFT JOIN customer.customers cucu ON custotals.customer_id = cucu.id
	LEFT JOIN reporting.preferred_addresses_view pa ON custotals.customer_id = pa.customer_id
	LEFT JOIN address.addresses aa ON pa.delivery_address_id = aa.id
	LEFT JOIN address.countries ac ON aa.country_id = ac.id
	WHERE custotals.customer_id NOT IN (SELECT re.customer_id FROM reporting.exclusions re)
	ORDER BY spent DESC
	LIMIT 100;
END;
$$
