Code for the Kaggle repeat-customer acquisition challenge

# Features

For each training instance (an offer given to a customer) we will calculate the following features:

* Data already available
    * `chain_id` - the store the customer frequents
    * `market_id` - the region that the store is located in
* Transaction analysis
    * Customer's behaviour
        * `num_chains_visited_lastX` Number of unique chains visited in the past x days
        * `num_visits_lastX` Number of total visits in the past x days
        * `avg_spend_per_visit_lastX` Average spend per visit in the past x days
        * `amt_purchases_lastX` Total spend in the past x days
        * `avg_price_lastX` Average price of item purchased in the past x days
        * `num_categories_shopped_lastX` Total number of categories shopped in the past x days
    * Customer's past activity in this category
        * `amt_category_purchases_lastX` Total customer spend in this category in the past x days
        * `pct_category_of_total_wallet_lastX` Category share of wallet for this customer in the past x days
        * `amt_category_purchases_lastX` Quantity purchased in this category in the past x days
        * `num_category_visits_lastX` Number of visits (unique chain-date) in this category in the past X days
        * `pct_category_visits_of_total_lastX) Number of visits in this category as % of total in the last X days
    * Customer's past history with brands in this category
        * `amt_category_brand_purchases_lastX` Total customer spend on this brand in this category in the past X days
        * `pct_category_brand_total_wallet_lastX` Share of customer wallet in this category that this brand holds
        * `num_unique_brand_purchases_in_category_lastX` Number of other brands customer has purchased from in this category
        * (Could do similar for company instead of brand)
    * Customer's past history with this brand in other categories
    * Customer's history with this department
    * Propensity to develop loyalty
        * Avg unique products purchased per category
    * Offer timing
        * Month offered
        * % of annual demand for brand in month offered
        * % of annual demand for category in month offered

# Things to consider

* `offer_date` - chunk it based on time (e.g. month, week or day of week?)
* Properties of the underlying demand for the offered brand - e.g. if it's a seasaonal product we may get higher conversion rates when in-season

