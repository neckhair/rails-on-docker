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
  * [x] Service discovery to avoid `--link`s
  * [ ] Fluentd for log collection
  * [ ] Elasticsearch for log storage
  * [ ] Kibana for log analysis
  * [ ] Use [data volume containers](https://docs.docker.com/userguide/dockervolumes/) for Mysql data
  * [ ] MySQL Slave for backups
  * [ ] Replace MySQL with Postgres

**Environment:**
I am running this on a Mac using the [boot2docker](http://boot2docker.io) command line tool.

Boot2docker exposes all its ports on its IP address. This address is usually 192.168.59.103. It tells you its IP when
you run `boot2docker ip`. To make reaching the vm more comfortable I made an entry in my `/etc/hosts`:

    192.168.59.103   dockerhost

All services within the boot2docker VM are now reachable via dockerhost:<port> from my OS X command line.

## Quick Start

We are going to run our own DNS service in one of the containers. So first we have to tell docker to make some changes
to each container's `/etc/resolv.conf`. Enter boot2docker via ssh and change the file `/var/lib/boot2docker/profile` as
follows:

    EXTRA_ARGS="--bip=172.17.42.1/16 --dns=172.17.42.1"

You can read more about this [here](https://github.com/crosbymichael/skydock).

Now exit boot2docker and run the following commands:

    boot2docker restart
    bin/bootstrap.sh

All containers should now be running and you should be able to navigate your browser to the page
[http://dockerhost](http://dockerhost). All steps are described bellow.

## DNS Containers

    docker run -d -p 172.17.42.1:53:53/udp --name skydns crosbymichael/skydns -nameserver 8.8.8.8:53 -domain docker
    docker run -d -v /var/run/docker.sock:/docker.sock --name skydock crosbymichael/skydock \
               -ttl 30 -environment dev -s /docker.sock -domain docker -name skydns

## Database Container DB1

    docker build -t neckhair/mysql config/container/mysql
    docker run -d --name db1 -p 3306:3306 -v /data/mysql:/var/lib/mysql -e MYSQL_PASS=mypass tutum/mysql

## Redis Container REDIS1

    docker run -d --name redis1 redis

## Memcached Container CACHE1

    docker build -t neckhair/memcached config/container/memcached
    docker run -d --name cache1 neckhair/memcached

## Rails Container APP1

    docker build -t neckhair/rails .
    docker run -d -e SECRET_KEY_BASE=abcdefg --name app1 --link redis1:redis --link cache1:cache neckhair/rails /usr/bin/start-server

If you're running this the first time you might need to setup the database right after building the rails container:

    docker run -t -e RAILS_ENV=production --rm --link redis1:redis --link cache1:cache neckhair/rails /bin/bash -l -c "bundle exec rake db:setup"

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
