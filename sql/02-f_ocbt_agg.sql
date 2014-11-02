CREATE MATERIALIZED VIEW f_ocbt_agg180 AS (
    SELECT ocbt.customer_id
        ,ocbt.offer_id
        ,SUM(ocbt.quantity) AS quantity
        ,SUM(ocbt.amount) AS amount
    FROM offer_category_brand_transactions ocbt
    WHERE ocbt.occurred > ocbt.offer_date - 180
    GROUP BY ocbt.customer_id, ocbt.offer_id
);

CREATE MATERIALIZED VIEW f_ocbt_agg60 AS (
    SELECT ocbt.customer_id
        ,ocbt.offer_id
        ,SUM(ocbt.quantity) AS quantity
        ,SUM(ocbt.amount) AS amount
    FROM offer_category_brand_transactions ocbt
    WHERE ocbt.occurred > ocbt.offer_date - 60
    GROUP BY ocbt.customer_id, ocbt.offer_id
);

CREATE MATERIALIZED VIEW f_ocbt_agg30 AS (
    SELECT ocbt.customer_id
        ,ocbt.offer_id
        ,SUM(ocbt.quantity) AS quantity
        ,SUM(ocbt.amount) AS amount
    FROM offer_category_brand_transactions ocbt
    WHERE ocbt.occurred > ocbt.offer_date - 30
    GROUP BY ocbt.customer_id, ocbt.offer_id
); 

