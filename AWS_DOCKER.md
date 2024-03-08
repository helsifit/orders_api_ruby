# AWS deployment with RDS database

## Build image

~~~sh
docker build -t orders-ruby .
~~~

## Run container

Create `.env.production` based on `.env.example` and update with your RDS database credentials.

~~~sh
cp .env.example .env.production
~~~

~~~sh
docker run --rm --name orders-container -d -i -t \
  --env-file .env.production \
  -p 3000:3000 \
  orders-ruby /bin/sh
~~~

~~~sh
docker run --rm --name orders-container -d -i -t \
  --env-file .env.production \
  -p 3000:3000 \
  orders-ruby
~~~

~~~sh
docker ps
docker logs orders-container
~~~

## Exec in contaner

~~~sh
docker exec -it orders-container bin/create_db.rb
docker exec -it orders-container bin/migrate_db.rb
docker exec -it orders-container pry
docker exec -it orders-container /bin/sh
~~~
