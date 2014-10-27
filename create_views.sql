DROP MATERIALIZED VIEW IF EXISTS offer_info;
DROP VIEW IF EXISTS offer_perf_summary;
DROP VIEW IF EXISTS brand_category;
DROP VIEW IF EXISTS category_summ;

CREATE VIEW category_summ AS
    SELECT category_id
        ,SUM(amount) AS amount
        ,COUNT(amount) AS transactions
        ,COUNT(DISTINCT customer_id) AS customers

    FROM transactions
    GROUP BY category_id
;


CREATE VIEW brand_category AS
    SELECT t.brand_id AS brand_id
        ,t.dept_id
        ,t.category_id AS category_id
        ,t.amount AS amount
        ,t.amount / ct.amount AS brand_value_share
        ,t.num_transactions AS num_transactions
        ,t.num_customers AS num_customers
    FROM (
        SELECT dept_id
            ,brand_id
            ,category_id
            ,SUM(amount) AS amount
            ,COUNT(customer_id) as num_transactions
            ,COUNT(DISTINCT customer_ID) as num_customers
        FROM transactions 
        GROUP BY dept_id, brand_id, category_id
    ) t
    LEFT JOIN category_summ ct ON t.category_id = ct.category_id
;

CREATE VIEW offer_perf_summary AS
    SELECT op.offer_id
        ,COUNT(DISTINCT op.customer_id) AS customers
        ,COUNT(DISTINCT op.chain_id) AS chains
        ,COUNT(DISTINCT op.market_id) AS markets
        ,AVG(op.repeat_trips) AS avg_repeat_trips
        ,COUNT(CASE WHEN op.repeat_trips > 0 THEN 1 END) AS customers_redeemed
        ,COUNT(CASE WHEN op.repeat_trips > 0 THEN 1 END) / CAST(COUNT(op.customer_id) AS real) AS conversion

    FROM offer_performance op
    GROUP BY op.offer_id
;

CREATE MATERIALIZED VIEW offer_info AS
    SELECT o.offer_id AS offer_id
        ,o.category_id AS category_id
        ,o.company_id AS company_id
        ,o.offer_value AS offer_value
        ,o.brand_id AS brand_id
        ,ops.customers AS customers_offered_to
        ,ops.customers_redeemed AS customers_redeemed
        ,ops.conversion AS offer_conversion
        ,ops.avg_repeat_trips AS offer_avg_repeat_trips
        ,bc.brand_value_share AS brand_value_share
        ,bc.num_transactions AS brand_num_transactions
        ,bc.num_customers AS brand_num_customers
        ,cs.amount AS category_total_value
        ,cs.transactions AS category_num_transactions
        ,cs.customers AS category_num_customers
    FROM offers o
    LEFT JOIN brand_category bc ON o.brand_id = bc.brand_id AND o.category_id = bc.category_id
    LEFT JOIN offer_perf_summary ops ON o.offer_id = ops.offer_id
    LEFT JOIN category_summ cs ON o.category_id = cs.category_id
;
