# Database Container DB1

    docker run -d -p 3306:3306 --name db1 -e MYSQL_PASS=mypass tutum/mysql

# Rails Container APP1

    docker build -t neckhair/rails .

    docker run --link db1:db neckhair/rails /bin/bash -l -c "bundle exec rake db:setup"
    docker run -p 80:80 --name app1 --link db1:db neckhair/rails /usr/bin/start-server

Bash:

    docker run -p 80:80 --name app1 --link db1:db -i -t neckhair/rails /bin/bash

Tunnel to boot2docker instance:

    boot2docker ssh -L 8000:localhost:80
