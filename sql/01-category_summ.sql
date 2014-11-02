CREATE MATERIALIZED VIEW category_summ AS
    SELECT dept_id
        ,category_id
        ,SUM(amount) AS amount
        ,COUNT(amount) AS transactions
        ,COUNT(DISTINCT customer_id) AS customers

    FROM transactions
    GROUP BY dept_id, category_id
;

