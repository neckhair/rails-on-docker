# Ruby On Rails On Docker

This is a little project of mine where I try to set up a Ruby on Rails production environment running on Docker.
It is work in progress. Every step to get the application running should be provided here.

Notice: These steps are not considered "best practice". They're just the steps which got it working. I'm sure
there is much room for improvement.

**Todo:**

  * [x] MySQL container
  * [x] Rails container using Unicorn
  * [x] Nginx as load balancer/reverse proxy
  * [ ] Redis as session store and for caching
  * [x] Sidekiq container for background jobs
  * [ ] Fluentd for log collection
  * [ ] Elasticsearch for log storage
  * [ ] Kibana for log analysis
  * [ ] Use [data volume containers](https://docs.docker.com/userguide/dockervolumes/) for Mysql data
  * [ ] MySQL Slave for backups
  * [ ] Disable `serve_static_assets` and let nginx serve assets
  * [ ] Replace MySQL with Postgres

**Environment:**
I'm running this on a Mac using the famous `boot2docker` command line
tool. For its Virtual Box image I set up some port forwarding. You can
to this on the command line or within the Virtual Box GUI.
Actually I only forward the port 8080 on the host to the guest's port 80 (nginx).

## Database Container DB1

    docker run -d --name db1 -p 3306:3306 -e MYSQL_PASS=mypass tutum/mysql

## Redis Container REDIS1

    docker run -d --name redis1 redis

## Rails Container APP1

    docker build -t neckhair/rails .

    docker run -t -e RAILS_ENV=production --link db1:db --link redis1:redis neckhair/rails /bin/bash -l -c "bundle exec rake db:setup"

    docker run -t -e RAILS_ENV=production --link db1:db --link redis1:redis neckhair/rails /bin/bash -l -c "bundle exec rake assets:precompile"
    docker commit $(docker ps -l -q) neckhair/rails

    docker run -d -e SECRET_KEY_BASE=abcdefg --name app1 --link db1:db --link redis1:redis neckhair/rails /usr/bin/start-server

Stuff to figure out:

  * Better handling of the mysql password
  * Where to store the secret key?
  * Script these steps with capistrano

## Sidekiq Container WORKER1

    docker run -d -e SECRET_KEY_BASE=abcdefg --name worker1 --link db1:db --link redis1:redis neckhair/rails /usr/bin/start-sidekiq

## Nginx Container WEB1

    docker build -t neckhair/nginx config/container/nginx
    docker run -d -p 80:80 --link app1:app1 --name web1 neckhair/nginx

Nginx now listens on port 80 on the Docker host.

Stuff to figure out:

  * How to better build the upstream block in `nginx.conf`? It's very static now and only allows 1 app server.
