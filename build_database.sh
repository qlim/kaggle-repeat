#!/bin/bash

set -e

table_exists() {
    psql -d kaggle -c "select pg_relation_size('$1')" > /dev/null 2>&1
}

build_object() {
    if table_exists $1 ; then
        echo "Object already exists: $1"
    else
        echo "Building $1..."
        psql -d kaggle -f $2
    fi
}

psql_file() {
    psql -d kaggle -f $1 > /dev/null 2>&1
}

build_object transactions_customers_idx sql/00-create_indexes.sql
psql_file sql/00-create_views.sql

build_object category_summ sql/01-category_summ.sql &
build_object offer_perf_summary sql/01-offer_perf_summary.sql &

wait

build_object brand_category sql/02-brand_category.sql &
build_object f_ot_agg180 sql/02-f_ot_agg.sql &

wait

build_object f_ot_vis180 sql/02-f_ot_vis.sql &
build_object f_oct_agg180 sql/02-f_oct_agg.sql &

wait

build_object f_oct_vis180 sql/02-f_oct_vis.sql &
build_object f_ocbt_agg180 sql/02-f_ocbt_agg.sql &
build_object f_ocbt_vis180 sql/02-f_ocbt_vis.sql &

wait

build_object f_oct_brands180 sql/02-f_oct_brands.sql &
build_object f_ot_vis_uniq180 sql/02-f_ot_vis_uniq.sql &
build_object f_ot_cat_uniq180 sql/02-f_ot_cat_uniq.sql &

wait

build_object offer_info sql/03-offer_info.sql
build_object features sql/03-features.sql


