#!/bin/bash

# Cleanup
docker kill web1 app1 app2 worker1 db1 redis1 cache1
docker rm $(docker ps -a -q)

# Mysql
docker run -d --name db1 -p 3306:3306 -e MYSQL_PASS=mypass tutum/mysql

# Redis
docker run -d --name redis1 redis

# Memcached
docker build -t neckhair/memcached config/container/memcached
docker run -d --name cache1 neckhair/memcached

# Rails App
docker build -t neckhair/rails .
docker run -t -e RAILS_ENV=production --link db1:db --link redis1:redis --link cache1:cache neckhair/rails /bin/bash -l -c "bundle exec rake db:setup"

#docker run -t -e RAILS_ENV=production --link db1:db --link redis1:redis --link cache1:cache neckhair/rails /bin/bash -l -c "bundle exec rake assets:precompile"
#docker commit $(docker ps -l -q) neckhair/rails

docker run -d -e SECRET_KEY_BASE=abcdefg --name app1 --link db1:db --link redis1:redis --link cache1:cache neckhair/rails /usr/bin/start-server
docker run -d -e SECRET_KEY_BASE=abcdefg --name app2 --link db1:db --link redis1:redis --link cache1:cache neckhair/rails /usr/bin/start-server

# Sidekiq Worker
docker run -d -e SECRET_KEY_BASE=abcdefg --name worker1 --link db1:db --link redis1:redis neckhair/rails /usr/bin/start-sidekiq

# Nginx
docker build -t neckhair/nginx config/container/nginx
docker run -d -p 80:80 --link app1:app1 --link app2:app2 --name web1 neckhair/nginx
