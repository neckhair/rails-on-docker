FROM dockerfile/ruby
MAINTAINER phil@neckhair.ch

RUN apt-get -qy update
RUN apt-get -qy install build-essential libsqlite3-dev libmysqlclient-dev

ADD ./ /rails
WORKDIR /rails

RUN gem update bundler --no-ri --no-rdoc
RUN bundle install --jobs 8
RUN bundle exec rake db:setup

EXPOSE 8080
