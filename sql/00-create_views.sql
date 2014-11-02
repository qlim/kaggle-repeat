CREATE VIEW training_set AS
    SELECT * FROM offer_performance ORDER BY offer_date ASC
--        LIMIT (SELECT (count(*)*0.7)::int from offer_performance)
;

CREATE VIEW offer_transactions AS
    SELECT op.customer_id as customer_id
        ,op.offer_id as offer_id
        ,op.offer_date as offer_date
        ,o.category_id as offer_category_id
        ,t.quantity as quantity
        ,t.amount as amount
        ,t.occurred as occurred
        ,t.chain_id as chain_id
        ,t.category_id as category_id
    FROM offer_performance op
    LEFT JOIN offers o ON o.offer_id = op.offer_id
    LEFT JOIN transactions t ON t.customer_id = op.customer_id
    WHERE t.occurred < op.offer_date
;


CREATE VIEW offer_category_transactions AS
    SELECT op.customer_id as customer_id
        ,op.offer_id as offer_id
        ,op.offer_date as offer_date
        ,o.category_id as category_id
        ,t.quantity as quantity
        ,t.amount as amount
        ,t.occurred as occurred
        ,t.chain_id as chain_id
        ,t.brand_id as brand_id
    FROM offer_performance op
    LEFT JOIN offers o ON o.offer_id = op.offer_id
    LEFT JOIN transactions t ON t.customer_id = op.customer_id
        AND t.category_id = o.category_id
    WHERE t.occurred < op.offer_date
;

CREATE VIEW offer_category_brand_transactions AS
    SELECT op.customer_id as customer_id
        ,op.offer_id as offer_id
        ,op.offer_date as offer_date
        ,o.category_id as category_id
        ,t.quantity as quantity
        ,t.amount as amount
        ,t.occurred as occurred
        ,t.chain_id as chain_id
    FROM offer_performance op
    LEFT JOIN offers o ON o.offer_id = op.offer_id
    LEFT JOIN transactions t ON t.customer_id = op.customer_id
        AND t.category_id = o.category_id
        AND t.brand_id = o.brand_id
    WHERE t.occurred < op.offer_date
;


