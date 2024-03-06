# Orders API

## Dependencies

PostgreSQL version >= 15, Ruby version 3.3.0

## Setup

Install Ruby gems and copy sample env files:

~~~sh
bin/setup.rb
~~~

Edit development DB settings and add Stripe testing API key in `.env` file.

Edit test DB name in `.env.test` file.

Create and migrate dev and testing DB (update with your DB settings):

~~~sh
bin/create_db.rb
DB_DATABASE=helsifit_orders_test bin/create_db.rb

bin/migrate_db.rb
DB_DATABASE=helsifit_orders_test bin/migrate_db.rb
~~~

## RSpec Testing:

~~~sh
bundle exec rspec
~~~

## Development

Start development server:

~~~sh
bundle exec rackup -p 3000
~~~

## [API](/API.md)

Create Order with JSON data:

~~~sh
curl -i -X POST http://localhost:3000/orders \
    -H "Content-Type: application/json" \
    -d '{"order": {"currency": "GBP", "country_code": "GB", "first_name": "Herbert", "last_name": "Conroy", "address1": "930 Kiehn Walks", "address2": "44216", "city": "Lake Terrance", "postal_code": "67570-3035", "line_items": [{"product_handle": "ab-roller", "size": null, "color": "blue", "quantity": 1}]}}'
~~~

Create Order with form-urlencoded data:

~~~sh
curl -i -X POST http://localhost:3000/orders \
   -H "Content-Type: application/x-www-form-urlencoded" \
   -d "order[currency]=GBP&order[country_code]=GB&order[first_name]=Herbert&order[last_name]=Conroy&order[address1]=930 Kiehn Walks&order[address2]=44216&order[city]=Lake Terrance&order[postal_code]=67570-3035&order[line_items][][product_handle]=ab-roller&order[line_items][][size]=&order[line_items][][color]=blue&order[line_items][][quantity]=1"
~~~

Creating order redirects to Stripe, Stripe requests callback orders API URL and orders API redirects to frontend /success.html page.
