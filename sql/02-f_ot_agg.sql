CREATE MATERIALIZED VIEW f_ot_agg180 AS (
    SELECT ot.customer_id AS customer_id
        ,ot.offer_id AS offer_id
        ,SUM(ot.quantity) AS quantity
        ,SUM(ot.amount) AS amount
    FROM offer_transactions ot
    WHERE ot.occurred > ot.offer_date - 180
    GROUP BY ot.customer_id, ot.offer_id
); 

CREATE MATERIALIZED VIEW f_ot_agg60 AS (
    SELECT ot.customer_id AS customer_id
        ,ot.offer_id AS offer_id
        ,SUM(ot.quantity) AS quantity
        ,SUM(ot.amount) AS amount
    FROM offer_transactions ot
    WHERE ot.occurred > ot.offer_date - 60
    GROUP BY ot.customer_id, ot.offer_id
);

CREATE MATERIALIZED VIEW f_ot_agg30 AS (
    SELECT ot.customer_id AS customer_id
        ,ot.offer_id AS offer_id
        ,SUM(ot.quantity) AS quantity
        ,SUM(ot.amount) AS amount
    FROM offer_transactions ot
    WHERE ot.occurred > ot.offer_date - 30
    GROUP BY ot.customer_id, ot.offer_id
); 

