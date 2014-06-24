# Ruby On Rails On Docker

This is a little project of mine where I try to set up a Ruby on Rails production environment running on Docker.
It is work in progress. Every step to get the application running should be provided here.

Notice: These steps are not considered "best practice". They're just the steps which got it working. I'm sure
there is much room for improvement.

**Todo:**

  * [x] MySQL container
  * [x] Rails container using Unicorn
  * [ ] MySQL Slave for backups
  * [ ] Nginx as load balancer
  * [ ] Redis as session store and for caching
  * [ ] Sidekiq container for background jobs
  * [ ] Fluentd for log collection
  * [ ] Elasticsearch for log storage
  * [ ] Kibana for log analysis
  * [ ] Use [data volume containers](https://docs.docker.com/userguide/dockervolumes/)

**Environment:**
I'm running this on a Mac using the famous `boot2docker` command line
tool. For its Virtual Box image I set up some port forwarding. You can
to this on the command line or within the Virtual Box GUI.
Actually I only forward the port 8080 on the host to the guest's port 80 (nginx).

## Database Container DB1

    docker run -d -p 3306:3306 --name db1 -e MYSQL_PASS=mypass tutum/mysql

## Rails Container APP1

    docker build -t neckhair/rails .

    docker run -e RAILS_ENV=production --link db1:db neckhair/rails /bin/bash -l -c "bundle exec rake db:setup"

    docker run -e RAILS_ENV=production --link db1:db neckhair/rails /bin/bash -l -c "bundle exec rake assets:precompile"
    docker commit $(docker ps -l -q) neckhair/rails

    docker run -d -e SECRET_KEY_BASE=$(rake secret) -p 80:80 --name app1 --link db1:db neckhair/rails /usr/bin/start-server

The app now listens on port 80 and I can reach it when I point my browser to http://localhost:8080. (Because of some
  port forwarding I did.)

Stuff to figure out:

  * Better handling of the mysql password
  * Where to store the secret key base?
  * Script these steps with capistrano
