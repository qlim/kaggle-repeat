CREATE MATERIALIZED VIEW f_oct_vis180 AS (
    SELECT v.customer_id
        ,v.offer_id
        ,COUNT(*) AS visits
    FROM (
        SELECT DISTINCT customer_id
            ,offer_id
            ,chain_id
            ,occurred
        FROM offer_category_transactions
        WHERE occurred > offer_date - 180
    ) v
    GROUP BY v.customer_id, v.offer_id
);

CREATE MATERIALIZED VIEW f_oct_vis60 AS (
    SELECT v.customer_id
        ,v.offer_id
        ,COUNT(*) AS visits
    FROM (
        SELECT DISTINCT customer_id
            ,offer_id
            ,chain_id
            ,occurred
        FROM offer_category_transactions
        WHERE occurred > offer_date - 60
    ) v
    GROUP BY v.customer_id, v.offer_id
);

CREATE MATERIALIZED VIEW f_oct_vis30 AS (
    SELECT v.customer_id
        ,v.offer_id
        ,COUNT(*) AS visits
    FROM (
        SELECT DISTINCT customer_id
            ,offer_id
            ,chain_id
            ,occurred
        FROM offer_category_transactions
        WHERE occurred > offer_date - 30
    ) v
    GROUP BY v.customer_id, v.offer_id
);

