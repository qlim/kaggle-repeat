CREATE MATERIALIZED VIEW features AS
    SELECT s.*
        ,oi.category_id AS category_id
        ,oi.company_id AS company_id
        ,oi.brand_id AS brand_id
        ,oi.offer_value AS offer_value
        ,oi.brand_value_share AS brand_value_share
        ,oi.brand_num_transactions AS brand_num_transactions
        ,oi.brand_num_customers AS brand_num_customers
        ,oi.category_total_value as category_total_value
        ,oi.category_num_transactions AS category_num_transactions
        ,oi.category_num_customers AS category_num_customers

        ,f_ot_agg180.amount AS amt_purchases_last180
        ,f_ot_agg180.quantity AS qty_purchases_last180
        ,f_ot_vis180.visits AS num_visits_last180

        ,f_ot_agg60.amount AS amt_purchases_last60
        ,f_ot_agg60.quantity AS qty_purchases_last60
        ,f_ot_vis60.visits AS num_visits_last60

        ,f_ot_agg30.amount AS amt_purchases_last30
        ,f_ot_agg30.quantity AS qty_purchases_last30
        ,f_ot_vis30.visits AS num_visits_last30

        ,f_oct_agg180.quantity AS qty_category_purchases_last180
        ,f_oct_agg180.amount AS amt_category_purchases_last180
        ,f_oct_agg180.amount / NULLIF(f_ot_agg180.amount,0) AS pct_category_of_total_wallet_last180
        ,f_oct_vis180.visits AS num_category_visits_last180
        ,f_oct_vis180.visits / NULLIF(f_ot_vis180.visits,0) AS pct_category_visits_of_total_last180

        ,f_oct_agg60.quantity AS qty_category_purchases_last60
        ,f_oct_agg60.amount AS amt_category_purchases_last60
        ,f_oct_agg60.amount / NULLIF(f_ot_agg60.amount,0) AS pct_category_of_total_wallet_last60
        ,f_oct_vis60.visits AS num_category_visits_last60
        ,f_oct_vis60.visits / NULLIF(f_ot_vis60.visits,0) AS pct_category_visits_of_total_last60

        ,f_oct_agg30.quantity AS qty_category_purchases_last30
        ,f_oct_agg30.amount AS amt_category_purchases_last30
        ,f_oct_agg30.amount / NULLIF(f_ot_agg30.amount,0) AS pct_category_of_total_wallet_last30
        ,f_oct_vis30.visits AS num_category_visits_last30
        ,f_oct_vis30.visits / NULLIF(f_ot_vis30.visits,0) AS pct_category_visits_of_total_last30

        ,f_ocbt_agg180.quantity AS qty_category_brand_purchases_last180
        ,f_ocbt_agg180.amount AS amt_category_brand_purchases_last180
        ,f_ocbt_agg180.amount / NULLIF(f_oct_agg180.amount,0) AS pct_category_brand_of_total_wallet_last180
        ,f_ocbt_vis180.visits AS num_category_brand_visits_last180
        ,f_ocbt_vis180.visits / NULLIF(f_oct_vis180.visits,0) AS pct_category_brand_visits_of_total_last180

        ,f_ocbt_agg60.quantity AS qty_category_brand_purchases_last60
        ,f_ocbt_agg60.amount AS amt_category_brand_purchases_last60
        ,f_ocbt_agg60.amount / NULLIF(f_oct_agg60.amount,0) AS pct_category_brand_of_total_wallet_last60
        ,f_ocbt_vis60.visits AS num_category_brand_visits_last60
        ,f_ocbt_vis60.visits / NULLIF(f_oct_vis60.visits,0) AS pct_category_brand_visits_of_total_last60

        ,f_ocbt_agg30.quantity AS qty_category_brand_purchases_last30
        ,f_ocbt_agg30.amount AS amt_category_brand_purchases_last30
        ,f_ocbt_agg30.amount / NULLIF(f_oct_agg30.amount,0) AS pct_category_brand_of_total_wallet_last30
        ,f_ocbt_vis30.visits AS num_category_brand_visits_last30
        ,f_ocbt_vis30.visits / NULLIF(f_oct_vis30.visits,0) AS pct_category_brand_visits_of_total_last30

        ,f_oct_brands180.num_brands AS num_unique_brand_purchases_in_category_last180
        ,f_oct_brands60.num_brands AS num_unique_brand_purchases_in_category_last60
        ,f_oct_brands30.num_brands AS num_unique_brand_purchases_in_category_last30

    FROM training_set s
    LEFT JOIN offer_info oi ON
        oi.offer_id = s.offer_id
    LEFT JOIN f_ot_agg180 ON 
        f_ot_agg180.customer_id = s.customer_id 
        AND f_ot_agg180.offer_id = s.offer_id
    LEFT JOIN f_ot_agg60 ON 
        f_ot_agg60.customer_id = s.customer_id 
        AND f_ot_agg60.offer_id = s.offer_id
    LEFT JOIN f_ot_agg30 ON 
        f_ot_agg30.customer_id = s.customer_id 
        AND f_ot_agg30.offer_id = s.offer_id
    LEFT JOIN f_oct_agg180 ON 
        f_oct_agg180.customer_id = s.customer_id 
        AND f_oct_agg180.offer_id = s.offer_id
    LEFT JOIN f_oct_agg60 ON 
        f_oct_agg60.customer_id = s.customer_id 
        AND f_oct_agg60.offer_id = s.offer_id
    LEFT JOIN f_oct_agg30 ON 
        f_oct_agg30.customer_id = s.customer_id 
        AND f_oct_agg30.offer_id = s.offer_id
    LEFT JOIN f_oct_vis180 ON 
        f_oct_vis180.customer_id = s.customer_id 
        AND f_oct_vis180.offer_id = s.offer_id
    LEFT JOIN f_oct_vis60 ON 
        f_oct_vis60.customer_id = s.customer_id 
        AND f_oct_vis60.offer_id = s.offer_id
    LEFT JOIN f_oct_vis30 ON 
        f_oct_vis30.customer_id = s.customer_id 
        AND f_oct_vis30.offer_id = s.offer_id
    LEFT JOIN f_ot_vis180 ON 
        f_ot_vis180.customer_id = s.customer_id 
        AND f_ot_vis180.offer_id = s.offer_id
    LEFT JOIN f_ot_vis60 ON 
        f_ot_vis60.customer_id = s.customer_id 
        AND f_ot_vis60.offer_id = s.offer_id
    LEFT JOIN f_ot_vis30 ON 
        f_ot_vis30.customer_id = s.customer_id 
        AND f_ot_vis30.offer_id = s.offer_id
    LEFT JOIN f_ocbt_agg180 ON 
        f_ocbt_agg180.customer_id = s.customer_id 
        AND f_ocbt_agg180.offer_id = s.offer_id
    LEFT JOIN f_ocbt_agg60 ON 
        f_ocbt_agg60.customer_id = s.customer_id 
        AND f_ocbt_agg60.offer_id = s.offer_id
    LEFT JOIN f_ocbt_agg30 ON 
        f_ocbt_agg30.customer_id = s.customer_id 
        AND f_ocbt_agg30.offer_id = s.offer_id
    LEFT JOIN f_ocbt_vis180 ON 
        f_ocbt_vis180.customer_id = s.customer_id 
        AND f_ocbt_vis180.offer_id = s.offer_id
    LEFT JOIN f_ocbt_vis60 ON 
        f_ocbt_vis60.customer_id = s.customer_id 
        AND f_ocbt_vis60.offer_id = s.offer_id
    LEFT JOIN f_ocbt_vis30 ON 
        f_ocbt_vis30.customer_id = s.customer_id 
        AND f_ocbt_vis30.offer_id = s.offer_id
    LEFT JOIN f_oct_brands_180 ON 
        f_oct_brands_180.customer_id = s.customer_id 
        AND f_oct_brands_180.offer_id = s.offer_id
    LEFT JOIN f_oct_brands_60 ON 
        f_oct_brands_60.customer_id = s.customer_id 
        AND f_oct_brands_60.offer_id = s.offer_id
    LEFT JOIN f_oct_brands_30 ON 
        f_oct_brands_30.customer_id = s.customer_id 
        AND f_oct_brands_30.offer_id = s.offer_id
    ORDER BY s.offer_date ASC
;

