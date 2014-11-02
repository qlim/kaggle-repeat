CREATE MATERIALIZED VIEW brand_category AS
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


