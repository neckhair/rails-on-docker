FROM ubuntu:trusty

RUN apt-get update && \
    apt-get install -qy software-properties-common

RUN apt-add-repository -y ppa:brightbox/ruby-ng
RUN apt-get update && apt-get upgrade -y

# Ruby and dependencies
RUN apt-get install -qy curl nodejs libmysqlclient-dev libsqlite3-dev build-essential \
                        ruby2.3 ruby2.3-dev
RUN gem install bundler --no-ri --no-rdoc

# Cache bundle install
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install --without development test

# Add rails project to project directory
ADD ./ /rails

# set WORKDIR
WORKDIR /rails

RUN bundle exec rake assets:precompile

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Publish port 8080
EXPOSE 8080
