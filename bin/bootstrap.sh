#!/bin/bash

# Cleanup
docker kill web1 app1 app2 worker1 db1 redis1 cache1 skydns skydock
docker rm $(docker ps -a -q)

# DNS
docker run -d -p 172.17.42.1:53:53/udp --name skydns crosbymichael/skydns -nameserver 8.8.8.8:53 -domain docker
docker run -d -v /var/run/docker.sock:/docker.sock --name skydock crosbymichael/skydock \
            -ttl 30 -environment dev -s /docker.sock -domain docker -name skydns

# Mysql
docker build -t neckhair/mysql config/container/mysql
docker run -d --name db1 -p 3306:3306 -v /data/mysql:/var/lib/mysql -e MYSQL_PASS=mypass neckhair/mysql

# Redis
docker run -d --name redis1 redis

# Memcached
docker build -t neckhair/memcached config/container/memcached
docker run -d --name cache1 neckhair/memcached

# Rails App
docker build -t neckhair/rails .
docker run -t -e RAILS_ENV=production --rm neckhair/rails /bin/bash -l -c "bundle exec rake db:setup"

docker run -d -e SECRET_KEY_BASE=abcdefg --name app1 -h app1 neckhair/rails /usr/bin/start-server
docker run -d -e SECRET_KEY_BASE=abcdefg --name app2 -h app2 neckhair/rails /usr/bin/start-server

# Sidekiq Worker
docker run -d -e SECRET_KEY_BASE=abcdefg --name worker1 neckhair/rails /usr/bin/start-sidekiq

# Nginx
docker build -t neckhair/nginx config/container/nginx
docker run -d -p 80:80 --name web1 neckhair/nginx
