#!/bin/bash -e

psql -c "DROP DATABASE IF EXISTS helsifit_orders_dev;"
psql -c "DROP DATABASE IF EXISTS helsifit_orders_test;"

psql -c "CREATE DATABASE helsifit_orders_dev;"
psql -c "CREATE DATABASE helsifit_orders_test;"

DB_DATABASE=helsifit_orders_dev bundle exec bin/db_migrate
DB_DATABASE=helsifit_orders_test bundle exec bin/db_migrate
