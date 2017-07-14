# Ruby On Rails On Docker

This is a little project of mine where I try to set up a Ruby on Rails production environment running on Docker. It is work in progress. Every step to get the application running should be provided here.

Notice: These steps are not considered "best practice". They're just the steps which got it working. I'm sure there is much room for improvement.

**Todo:**

  * [x] MySQL container
  * [x] Rails container using Unicorn
  * [x] Nginx as load balancer/reverse proxy
  * [x] Memcached for caching
  * [x] Sidekiq container for background jobs
  * [x] Use Brightbox Ruby Packages instead of RVM
  * [x] Using Docker Compose for orchestration
  * [x] Use Alpine Linux for the Rails container
  * [ ] Share secrets in environment files
  * [ ] Fluentd for log collection
  * [ ] Elasticsearch for log storage
  * [ ] Kibana for log analysis
  * [ ] MySQL/Postgresql Slave for backups
  * [ ] Replace MySQL with Postgres

**Environment:**
I am running this on a Mac using [Docker for Mac](https://docs.docker.com/docker-for-mac/).

## Quick Start

First install Docker for Mac (Docker.app) and start it. How this is done is very well documented all over the internet.

To later access the app in the browser open your `/etc/hosts` file with ~~vim~~ your editor of choice and add the following line:

    127.0.0.1 beer.docker

Then start the app:

    docker-compose up

All containers should now magically be running and you should be able to navigate your browser to the page [http://beer.docker](http://beer.docker).

To stop and remove all containers simply take everything down:

    docker-compose down

## How it works

All containers are managed by docker-compose. You can see the configuration in the `docker-compose.yml` file.

### proxy

The nginx proxy container contains the docker-gen service. This listens for new and stopped containers. As soon as a container with a `VIRTUAL_HOST` environment variable starts, it re-creates the nginx config file and reloads nginx. All requests to `VIRTUAL_HOST` (in our case "beer.docker") are passed through to one of the `app` containers.

### db

The MariaDB container which is just a default MariaDB container. The data is stored locally in a mapped volume. This means the data is persisted on your local machine, not in the Docker container. When you restart the Docker container `db` all your data should still be there. If you want to start from scratch just delete all the files in `./data`:

    rm -rf ./data/*

### web

This container serves our Rails app from a Puma application server. Scaling up the app is as easy as running `docker-compose scale web=4`. Now you have 4 running web containers. The nginx proxy service acts as a load balancer in front of them and automatically picks new instances up.

The command of the container is set to the `docker/start.sh` script. This script waits until it gets an answer from the MariaDB container. As soon as the database is up it checks if the database is already initialized. If not it runs `rake db:setup` to initialize the app's database.

### worker

This is another container based on the Rails app. But it does not run Puma but Sidekiq for processing background tasks (Brewing beer!).

### redis

We use Redis as the backend for [Sidekiq](http://sidekiq.org/).

### cache

This container runs a Memached instance for Rails fragment caching.

## About me

I'm a Ruby engineer at [nine.ch](https://nine.ch). I had and still have fun experimenting with Docker. If you're interested or have a question regarding this repo you'll find me on [Twitter](https://twitter.com/neckhair82).
