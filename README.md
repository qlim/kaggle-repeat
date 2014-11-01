Code for the Kaggle repeat-customer acquisition challenge

# Feature building

The feature building process is optimized to run on a multi-core server with
sufficient memory to hold the entire database (~60GB)

First, create indexes that will be useful for frequently-made joins

The fab script will execute in parallel code to create materialized views
that calculate features.

A final script runs the query that joins these views together to output the final data.


# Features

For each training instance (an offer given to a customer) we will calculate the following features:

## Features for a single-offer model

* Data already available
    * `chain_id` - the store the customer frequents
    * `market_id` - the region that the store is located in
* Transaction analysis
    * Customer's past activity in this category
        * `amt_category_purchases_lastX` Total customer spend in this category in the past x days
        * `pct_category_of_total_wallet_lastX` Category share of wallet for this customer in the past x days [this needs the full, not reduced transaction dataset]
        * `amt_category_purchases_lastX` Quantity purchased in this category in the past x days
        * `num_category_visits_lastX` Number of visits (unique chain-date) in this category in the past X days
        * `pct_category_visits_of_total_lastX) Number of visits in this category as % of total in the last X days
    * Customer's past history with brands in this category
        * `amt_category_brand_purchases_lastX` Total customer spend on this brand in this category in the past X days
        * `pct_category_brand_total_wallet_lastX` Share of customer wallet in this category that this brand holds
        * Number of other brands customer has purchased from in this category
        * (Could do similar for company instead of brand)
    * Propensity to develop loyalty
        * Avg unique products purchased per category
    * Offer timing
        * Month offered
        * % of annual demand for brand in month offered
        * % of annual demand for category in month offered

## Features for a multi-offer model

* Data already available
    * Features of the offer
        * `brand_id` - relates the underlying conversion for the brand
        * `category_id` - ditto for category
        * `dept_id` - ditto for department

# Things to consider

* `offer_date` - chunk it based on time (e.g. month, week or day of week?)
* Properties of the underlying demand for the offered brand - e.g. if it's a seasaonal product we may get higher conversion rates when in-season

