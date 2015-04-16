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
  * [x] Using Docker Compose for orchestration
  * [ ] Use [data volume containers](https://docs.docker.com/userguide/dockervolumes/) for Mysql data
  * [ ] Fluentd for log collection
  * [ ] Elasticsearch for log storage
  * [ ] Kibana for log analysis
  * [ ] MySQL Slave for backups
  * [ ] Replace MySQL with Postgres

**Environment:**
I am running this on a Mac using the [boot2docker](http://boot2docker.io) command line tool.

Boot2docker exposes all its ports on its IP address. This address is usually 192.168.59.103. It tells you its
IP when you run `boot2docker ip`. To make reaching the vm more comfortable and to use the virtual host feature
I made an entry in my `/etc/hosts`:

    192.168.59.103   beer.docker

All services within the boot2docker VM are now reachable via beer.docker:<port> from my OS X command line.

## Quick Start

First install boot2docker and the Docker command line tools. How this is done is very well documented
all over the internet. Then start that whole stuff:

    boot2docker up
    $(boot2docker shellinit)
    docker-compose run web bundle exec rake db:setup
    docker-compose up

All containers should now be running and you should be able to navigate your browser to the page
[http://beer.docker](http://beer.docker).

## How it works

All containers are managed by docker-compose. You can see the configuration in the `docker-compose.yml`
file.

The nginx proxy container contains the docker-gen service. This listens for new and stopped containers.
As soon as a container with a `VIRTUAL_HOST` environment variable starts, it re-creates the nginx config file
and reloads nginx.

Scaling up the app is as easy as running `docker-compose scale web=4`. Now you have 4 running web containers.
The nginx proxy service acts as a load balancer in front of them.
