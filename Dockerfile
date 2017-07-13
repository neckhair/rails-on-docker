FROM ruby:2.4-alpine

ENV APP_DIR=/app

RUN apk update  && \
    apk add --no-cache tzdata mysql-dev mysql-client nodejs curl-dev ruby-dev build-base bash

RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

# Cache bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test -j2

COPY . $APP_DIR
RUN chown -R nobody:nogroup $APP_DIR
USER nobody

RUN bundle exec rake assets:precompile

EXPOSE 8080

CMD [ "/app/docker/start.sh" ]
