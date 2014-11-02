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

