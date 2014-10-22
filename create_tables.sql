CREATE TABLE IF NOT EXISTS offers (
    offer_id        integer PRIMARY KEY,
    category_id     integer,
    quantity        integer,
    company_id      integer,
    offer_value     real,
    brand_id        integer
);

CREATE TABLE IF NOT EXISTS transactions(
    customer_id     bigint,
    chain_id        integer,
    dept_id         integer,
    category_id     integer,
    company_id      bigint,
    brand_id        integer,
    occurred        date,
    product_size    real,
    product_measure varchar(3),
    quantity        integer,
    amount          real
);

CREATE TABLE IF NOT EXISTS offer_performance(
    customer_id     bigint,
    chain_id        integer,
    offer_id        integer,
    market_id       integer,
    repeat_trips    integer,
    repeater        boolean,
    offer_date      date
)
