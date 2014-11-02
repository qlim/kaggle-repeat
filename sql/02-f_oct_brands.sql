CREATE MATERIALIZED VIEW f_oct_brands180 AS (
    SELECT v.customer_id
        ,v.offer_id
        ,COUNT(*) AS num_brands
    FROM (
        SELECT DISTINCT customer_id
            ,offer_id
            ,brand_id
        FROM offer_category_transactions
        WHERE occurred > offer_date - 180
    ) v
    GROUP BY v.customer_id, v.offer_id
);

CREATE MATERIALIZED VIEW f_oct_brands60 AS (
    SELECT v.customer_id
        ,v.offer_id
        ,COUNT(*) AS num_brands
    FROM (
        SELECT DISTINCT customer_id
            ,offer_id
            ,brand_id
        FROM offer_category_transactions
        WHERE occurred > offer_date - 60
    ) v
    GROUP BY v.customer_id, v.offer_id
);


CREATE MATERIALIZED VIEW f_oct_brands30 AS (
    SELECT v.customer_id
        ,v.offer_id
        ,COUNT(*) AS num_brands
    FROM (
        SELECT DISTINCT customer_id
            ,offer_id
            ,brand_id
        FROM offer_category_transactions
        WHERE occurred > offer_date - 30
    ) v
    GROUP BY v.customer_id, v.offer_id
);



