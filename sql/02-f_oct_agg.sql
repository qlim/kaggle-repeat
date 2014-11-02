CREATE MATERIALIZED VIEW f_oct_agg180 AS (
    SELECT oct.customer_id
        ,oct.offer_id
        ,SUM(oct.quantity) AS quantity
        ,SUM(oct.amount) AS amount
    FROM offer_category_transactions oct
    WHERE oct.occurred > oct.offer_date - 180
    GROUP BY oct.customer_id, oct.offer_id
);

CREATE MATERIALIZED VIEW f_oct_agg60 AS (
    SELECT oct.customer_id
        ,oct.offer_id
        ,SUM(oct.quantity) AS quantity
        ,SUM(oct.amount) AS amount
    FROM offer_category_transactions oct
    WHERE oct.occurred > oct.offer_date - 60
    GROUP BY oct.customer_id, oct.offer_id
);

CREATE MATERIALIZED VIEW f_oct_agg30 AS (
    SELECT oct.customer_id
        ,oct.offer_id
        ,SUM(oct.quantity) AS quantity
        ,SUM(oct.amount) AS amount
    FROM offer_category_transactions oct
    WHERE oct.occurred > oct.offer_date - 30
    GROUP BY oct.customer_id, oct.offer_id
); 

