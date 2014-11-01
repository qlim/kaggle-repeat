DROP VIEW IF EXISTS offer_transactions CASCADE;
DROP VIEW IF EXISTS offer_category_transactions CASCADE;
DROP VIEW IF EXISTS offer_category_brand_transactions CASCADE;
DROP VIEW IF EXISTS f_customer_category CASCADE;
DROP VIEW IF EXISTS training_set CASCADE;

CREATE VIEW training_set AS
    SELECT * FROM offer_performance ORDER BY offer_date ASC
--        LIMIT (SELECT (count(*)*0.7)::int from offer_performance)
;

CREATE VIEW offer_transactions AS
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

CREATE VIEW f_customer_category AS
    WITH oct_agg180 AS (
        SELECT oct.customer_id
            ,oct.offer_id
            ,SUM(oct.quantity) AS quantity
            ,SUM(oct.amount) AS amount
        FROM offer_category_transactions oct
        WHERE oct.occurred > oct.offer_date - 180
        GROUP BY oct.customer_id, oct.offer_id
    ) 
    ,oct_agg60 AS (
        SELECT oct.customer_id
            ,oct.offer_id
            ,SUM(oct.quantity) AS quantity
            ,SUM(oct.amount) AS amount
        FROM offer_category_transactions oct
        WHERE oct.occurred > oct.offer_date - 60
        GROUP BY oct.customer_id, oct.offer_id
    ) 
    ,oct_agg30 AS (
        SELECT oct.customer_id
            ,oct.offer_id
            ,SUM(oct.quantity) AS quantity
            ,SUM(oct.amount) AS amount
        FROM offer_category_transactions oct
        WHERE oct.occurred > oct.offer_date - 30
        GROUP BY oct.customer_id, oct.offer_id
    ) 
    ,ot_agg180 AS (
        SELECT ot.customer_id AS customer_id
            ,ot.offer_id AS offer_id
            ,SUM(ot.quantity) AS quantity
            ,SUM(ot.amount) AS amount
        FROM offer_transactions ot
        WHERE ot.occurred > ot.offer_date - 180
        GROUP BY ot.customer_id, ot.offer_id
    ) 
    ,ot_agg60 AS (
        SELECT ot.customer_id AS customer_id
            ,ot.offer_id AS offer_id
            ,SUM(ot.quantity) AS quantity
            ,SUM(ot.amount) AS amount
        FROM offer_transactions ot
        WHERE ot.occurred > ot.offer_date - 60
        GROUP BY ot.customer_id, ot.offer_id
    )
    ,ot_agg30 AS (
        SELECT ot.customer_id AS customer_id
            ,ot.offer_id AS offer_id
            ,SUM(ot.quantity) AS quantity
            ,SUM(ot.amount) AS amount
        FROM offer_transactions ot
        WHERE ot.occurred > ot.offer_date - 30
        GROUP BY ot.customer_id, ot.offer_id
    ) 
    ,oct_vis180 AS (
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
    )
    ,oct_vis60 AS (
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
    )
    ,oct_vis30 AS (
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
    )
    ,ot_vis180 AS (
        SELECT v.customer_id
            ,v.offer_id
            ,COUNT(*) AS visits
        FROM (
            SELECT DISTINCT customer_id
                ,offer_id
                ,chain_id
                ,occurred
            FROM offer_transactions
            WHERE occurred > offer_date - 180
        ) v
        GROUP BY v.customer_id, v.offer_id
    )
    ,ot_vis60 AS (
        SELECT v.customer_id
            ,v.offer_id
            ,COUNT(*) AS visits
        FROM (
            SELECT DISTINCT customer_id
                ,offer_id
                ,chain_id
                ,occurred
            FROM offer_transactions
            WHERE occurred > offer_date - 60
        ) v
        GROUP BY v.customer_id, v.offer_id
    )
    ,ot_vis30 AS (
        SELECT v.customer_id
            ,v.offer_id
            ,COUNT(*) AS visits
        FROM (
            SELECT DISTINCT customer_id
                ,offer_id
                ,chain_id
                ,occurred
            FROM offer_transactions
            WHERE occurred > offer_date - 30
        ) v
        GROUP BY v.customer_id, v.offer_id
    )
    ,ocbt_agg180 AS (
        SELECT ocbt.customer_id
            ,ocbt.offer_id
            ,SUM(ocbt.quantity) AS quantity
            ,SUM(ocbt.amount) AS amount
        FROM offer_category_brand_transactions ocbt
        WHERE ocbt.occurred > ocbt.offer_date - 180
        GROUP BY ocbt.customer_id, ocbt.offer_id
    ) 
    ,ocbt_agg60 AS (
        SELECT ocbt.customer_id
            ,ocbt.offer_id
            ,SUM(ocbt.quantity) AS quantity
            ,SUM(ocbt.amount) AS amount
        FROM offer_category_brand_transactions ocbt
        WHERE ocbt.occurred > ocbt.offer_date - 60
        GROUP BY ocbt.customer_id, ocbt.offer_id
    ) 
    ,ocbt_agg30 AS (
        SELECT ocbt.customer_id
            ,ocbt.offer_id
            ,SUM(ocbt.quantity) AS quantity
            ,SUM(ocbt.amount) AS amount
        FROM offer_category_brand_transactions ocbt
        WHERE ocbt.occurred > ocbt.offer_date - 30
        GROUP BY ocbt.customer_id, ocbt.offer_id
    ) 
    ,ocbt_vis180 AS (
        SELECT v.customer_id
            ,v.offer_id
            ,COUNT(*) AS visits
        FROM (
            SELECT DISTINCT customer_id
                ,offer_id
                ,chain_id
                ,occurred
            FROM offer_category_brand_transactions
            WHERE occurred > offer_date - 180
        ) v
        GROUP BY v.customer_id, v.offer_id
    )
    ,ocbt_vis60 AS (
        SELECT v.customer_id
            ,v.offer_id
            ,COUNT(*) AS visits
        FROM (
            SELECT DISTINCT customer_id
                ,offer_id
                ,chain_id
                ,occurred
            FROM offer_category_brand_transactions
            WHERE occurred > offer_date - 60
        ) v
        GROUP BY v.customer_id, v.offer_id
    )
    ,ocbt_vis30 AS (
        SELECT v.customer_id
            ,v.offer_id
            ,COUNT(*) AS visits
        FROM (
            SELECT DISTINCT customer_id
                ,offer_id
                ,chain_id
                ,occurred
            FROM offer_category_brand_transactions
            WHERE occurred > offer_date - 30
        ) v
        GROUP BY v.customer_id, v.offer_id
    )
    SELECT s.customer_id AS customer_id
        ,s.offer_id AS offer_id

        ,oct_agg180.quantity AS qty_category_purchases_last180
        ,oct_agg180.amount AS amt_category_purchases_last180
        ,oct_agg180.amount / NULLIF(ot_agg180.amount,0) AS pct_category_of_total_wallet_last180
        ,oct_vis180.visits AS num_category_visits_last180
        ,oct_vis180.visits / NULLIF(ot_vis180.visits,0) AS pct_category_visits_of_total_last180

        ,oct_agg60.quantity AS qty_category_purchases_last60
        ,oct_agg60.amount AS amt_category_purchases_last60
        ,oct_agg60.amount / NULLIF(ot_agg60.amount,0) AS pct_category_of_total_wallet_last60
        ,oct_vis60.visits AS num_category_visits_last60
        ,oct_vis60.visits / NULLIF(ot_vis60.visits,0) AS pct_category_visits_of_total_last60

        ,oct_agg30.quantity AS qty_category_purchases_last30
        ,oct_agg30.amount AS amt_category_purchases_last30
        ,oct_agg30.amount / NULLIF(ot_agg30.amount,0) AS pct_category_of_total_wallet_last30
        ,oct_vis30.visits AS num_category_visits_last30
        ,oct_vis30.visits / NULLIF(ot_vis30.visits,0) AS pct_category_visits_of_total_last30

        ,ocbt_agg180.quantity AS qty_category_brand_purchases_last180
        ,ocbt_agg180.amount AS amt_category_brand_purchases_last180
        ,ocbt_agg180.amount / NULLIF(oct_agg180.amount,0) AS pct_category_brand_of_total_wallet_last180
        ,ocbt_vis180.visits AS num_category_brand_visits_last180
        ,ocbt_vis180.visits / NULLIF(oct_vis180.visits,0) AS pct_category_brand_visits_of_total_last180

        ,ocbt_agg60.quantity AS qty_category_brand_purchases_last60
        ,ocbt_agg60.amount AS amt_category_brand_purchases_last60
        ,ocbt_agg60.amount / NULLIF(oct_agg60.amount,0) AS pct_category_brand_of_total_wallet_last60
        ,ocbt_vis60.visits AS num_category_brand_visits_last60
        ,ocbt_vis60.visits / NULLIF(oct_vis60.visits,0) AS pct_category_brand_visits_of_total_last60

        ,ocbt_agg30.quantity AS qty_category_brand_purchases_last30
        ,ocbt_agg30.amount AS amt_category_brand_purchases_last30
        ,ocbt_agg30.amount / NULLIF(oct_agg30.amount,0) AS pct_category_brand_of_total_wallet_last30
        ,ocbt_vis30.visits AS num_category_brand_visits_last30
        ,ocbt_vis30.visits / NULLIF(oct_vis30.visits,0) AS pct_category_brand_visits_of_total_last30

    FROM training_set s
    LEFT JOIN ot_agg180 ON 
        ot_agg180.customer_id = s.customer_id 
        AND ot_agg180.offer_id = s.offer_id
    LEFT JOIN ot_agg60 ON 
        ot_agg60.customer_id = s.customer_id 
        AND ot_agg60.offer_id = s.offer_id
    LEFT JOIN ot_agg30 ON 
        ot_agg30.customer_id = s.customer_id 
        AND ot_agg30.offer_id = s.offer_id
    LEFT JOIN oct_agg180 ON 
        oct_agg180.customer_id = s.customer_id 
        AND oct_agg180.offer_id = s.offer_id
    LEFT JOIN oct_agg60 ON 
        oct_agg60.customer_id = s.customer_id 
        AND oct_agg60.offer_id = s.offer_id
    LEFT JOIN oct_agg30 ON 
        oct_agg30.customer_id = s.customer_id 
        AND oct_agg30.offer_id = s.offer_id
    LEFT JOIN oct_vis180 ON 
        oct_vis180.customer_id = s.customer_id 
        AND oct_vis180.offer_id = s.offer_id
    LEFT JOIN oct_vis60 ON 
        oct_vis60.customer_id = s.customer_id 
        AND oct_vis60.offer_id = s.offer_id
    LEFT JOIN oct_vis30 ON 
        oct_vis30.customer_id = s.customer_id 
        AND oct_vis30.offer_id = s.offer_id
    LEFT JOIN ot_vis180 ON 
        ot_vis180.customer_id = s.customer_id 
        AND ot_vis180.offer_id = s.offer_id
    LEFT JOIN ot_vis60 ON 
        ot_vis60.customer_id = s.customer_id 
        AND ot_vis60.offer_id = s.offer_id
    LEFT JOIN ot_vis30 ON 
        ot_vis30.customer_id = s.customer_id 
        AND ot_vis30.offer_id = s.offer_id
    LEFT JOIN ocbt_agg180 ON 
        ocbt_agg180.customer_id = s.customer_id 
        AND ocbt_agg180.offer_id = s.offer_id
    LEFT JOIN ocbt_agg60 ON 
        ocbt_agg60.customer_id = s.customer_id 
        AND ocbt_agg60.offer_id = s.offer_id
    LEFT JOIN ocbt_agg30 ON 
        ocbt_agg30.customer_id = s.customer_id 
        AND ocbt_agg30.offer_id = s.offer_id
    LEFT JOIN ocbt_vis180 ON 
        ocbt_vis180.customer_id = s.customer_id 
        AND ocbt_vis180.offer_id = s.offer_id
    LEFT JOIN ocbt_vis60 ON 
        ocbt_vis60.customer_id = s.customer_id 
        AND ocbt_vis60.offer_id = s.offer_id
    LEFT JOIN ocbt_vis30 ON 
        ocbt_vis30.customer_id = s.customer_id 
        AND ocbt_vis30.offer_id = s.offer_id
;


