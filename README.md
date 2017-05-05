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

Then prepare and start the app:

    docker-compose up -d db      # needs some time to initialize, so we start it first
    docker-compose logs db    # use this to check if db:mysql service  has finished starting
    docker-compose run web bundle exec rake db:setup # initialize the app's database
    docker-compose up            # start all services

All containers should now be running and you should be able to navigate your browser to the page [http://beer.docker](http://beer.docker).

Sometimes it does not work on the first try. Maybe MySQL was not up yet? Some other thing happened? Delete the containers and start over.

## How it works

All containers are managed by docker-compose. You can see the configuration in the `docker-compose.yml` file.

### proxy

The nginx proxy container contains the docker-gen service. This listens for new and stopped containers. As soon as a container with a `VIRTUAL_HOST` environment variable starts, it re-creates the nginx config file and reloads nginx. All requests to `VIRTUAL_HOST` (in our case "beer.docker") are passed through to one of the `app` containers.

### db

The MySQL container which is just a default MySQL container. The data is stored locally in the `./data` directory. This means we can start and stop the container without losing data.

The root password is passed via an environment variable. Don't do that in production!

### web

This container serves our Rails app in a Unicorn application server. Scaling up the app is as easy as running `docker-compose scale web=4`. Now you have 4 running web containers. The nginx proxy service acts as a load balancer in front of them and automatically picks new instances up.

### worker

This is another container based on the Rails app. But it does not run Unicorn but Sidekiq for processing background tasks (Brewing beer!).
### redis

We use Redis as the backend for [Sidekiq](http://sidekiq.org/).

### cache

This container runs a Memached instance for Rails fragment caching.

## About me

I'm a Ruby engineer at [nine.ch](https://nine.ch). I don't consider myself a Docker expert. But I had and still have fun experimenting with it. If you're interested or have question regarding this repo you'll find me on [Twitter](https://twitter.com/neckhair82).
