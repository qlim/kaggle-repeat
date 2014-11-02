CREATE MATERIALIZED VIEW f_ot_cat_uniq180 AS (
    SELECT v.customer_id
        ,v.offer_id
        ,COUNT(*) AS unique_categories
    FROM (
        SELECT DISTINCT customer_id
            ,offer_id
            ,category_id
        FROM offer_transactions
        WHERE occurred > offer_date - 180
    ) v
    GROUP BY v.customer_id, v.offer_id
);

CREATE MATERIALIZED VIEW f_ot_cat_uniq60 AS (
    SELECT v.customer_id
        ,v.offer_id
        ,COUNT(*) AS unique_categories
    FROM (
        SELECT DISTINCT customer_id
            ,offer_id
            ,category_id
        FROM offer_transactions
        WHERE occurred > offer_date - 60
    ) v
    GROUP BY v.customer_id, v.offer_id
);

CREATE MATERIALIZED VIEW f_ot_cat_uniq30 AS (
    SELECT v.customer_id
        ,v.offer_id
        ,COUNT(*) AS unique_categories
    FROM (
        SELECT DISTINCT customer_id
            ,offer_id
            ,category_id
        FROM offer_transactions
        WHERE occurred > offer_date - 30
    ) v
    GROUP BY v.customer_id, v.offer_id
);


