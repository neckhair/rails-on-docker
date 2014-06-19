FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -qy curl nodejs
RUN apt-get install -qy libmysqlclient-dev

RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.2"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

ADD config/container/start-server.sh /usr/bin/start-server
RUN chmod +x /usr/bin/start-server

# Add rails project to project directory
ADD ./ /rails

# set WORKDIR
WORKDIR /rails

RUN /bin/bash -l -c "bundle install"

# Publish port 80
EXPOSE 80

# Startup commands
# ENTRYPOINT /usr/bin/start-server

