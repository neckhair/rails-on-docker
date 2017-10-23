FROM ruby:2.4

ENV APP_DIR=/app

RUN apt-get update && \
    apt-get install -y libmysqlclient-dev nodejs locales tzdata && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

# Cache bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test -j2

COPY . $APP_DIR

RUN bundle exec rake assets:precompile

EXPOSE 8080

CMD [ "/app/docker/start.sh" ]
