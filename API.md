# API

## Get Orders count

~~~sh
curl -i -X --insecure GET http://localhost:3000/hels
~~~

## Debug Order creation:

~~~sh
curl -i -X POST http://localhost:3000/debug/orders \
    -H "Content-Type: application/json" \
    -d '{"order": {"currency": "GBP", "country_code": "GB", "first_name": "Herbert", "last_name": "Conroy", "address1": "930 Kiehn Walks", "address2": "44216", "city": "Lake Terrance", "postal_code": "67570-3035", "line_items": [{"product_handle": "ab-roller", "size": null, "color": "blue", "quantity": 1}]}}'
~~~
