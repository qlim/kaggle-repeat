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
