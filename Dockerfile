FROM phusion/baseimage:0.9.11

RUN apt-get update && \
    apt-get install -qy curl nodejs libmysqlclient-dev

RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.2"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

ADD config/container/start-server.sh /usr/bin/start-server
RUN chmod +x /usr/bin/start-server

ADD config/container/start-sidekiq.sh /usr/bin/start-sidekiq
RUN chmod +x /usr/bin/start-sidekiq

# Add rails project to project directory
ADD ./ /rails

# set WORKDIR
WORKDIR /rails

RUN /bin/bash -l -c "bundle install --without development test"

# Publish port 8080
EXPOSE 8080
