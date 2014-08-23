# Ruby On Rails On Docker

This is a little project of mine where I try to set up a Ruby on Rails production environment running on Docker.
It is work in progress. Every step to get the application running should be provided here.

Notice: These steps are not considered "best practice". They're just the steps which got it working. I'm sure
there is much room for improvement.

**Todo:**

  * [x] MySQL container
  * [x] Rails container using Unicorn
  * [x] Nginx as load balancer/reverse proxy
  * [x] Memcached for caching
  * [x] Sidekiq container for background jobs
  * [x] Use Brightbox Ruby Packages instead of RVM
  * [ ] Fluentd for log collection
  * [ ] Elasticsearch for log storage
  * [ ] Kibana for log analysis
  * [ ] Use [data volume containers](https://docs.docker.com/userguide/dockervolumes/) for Mysql data
  * [ ] MySQL Slave for backups
  * [ ] Replace MySQL with Postgres

**Environment:**
I'm running this on a Mac using the famous `boot2docker` command line
tool. For its Virtual Box image I set up some port forwarding. You can
do this on the command line or within the Virtual Box GUI.
Actually I only forward the port 8080 on the host to the guest's port 80 (nginx).

## Quick Start

Just run the following command if you want to get up and running quickly:

```shell
bin/bootstrap.sh
```

All containers should now be running und you should be able to navigate your browser to the page
(`http://localhost:8080`). All steps are described bellow.

## Database Container DB1

    docker run -d --name db1 -p 3306:3306 -e MYSQL_PASS=mypass tutum/mysql

## Redis Container REDIS1

    docker run -d --name redis1 redis

## Memcached Container CACHE1

    docker build -t neckhair/memcached config/container/memcached
    docker run -d --name cache1 neckhair/memcached

## Rails Container APP1

    docker build -t neckhair/rails .
    docker run -d -e SECRET_KEY_BASE=abcdefg --name app1 --link db1:db --link redis1:redis --link cache1:cache neckhair/rails /usr/bin/start-server

If you're running this the first time you might need to setup the database right after building the rails container:

    docker run -t -e RAILS_ENV=production --link db1:db --link redis1:redis --link cache1:cache neckhair/rails /bin/bash -l -c "bundle exec rake db:setup"

Stuff to figure out:

  * Better handling of the mysql password
  * Where to store the secret key?
  * Script these steps with capistrano

## Sidekiq Container WORKER1

    docker run -d -e SECRET_KEY_BASE=abcdefg --name worker1 --link db1:db --link redis1:redis neckhair/rails /usr/bin/start-sidekiq

## Nginx Container WEB1

    docker build -t neckhair/nginx config/container/nginx
    docker run -d -p 80:80 --link app1:app1 --name web1 neckhair/nginx

Nginx now listens on port 80 on the Docker host. Requests are passed to one of the two app servers.

