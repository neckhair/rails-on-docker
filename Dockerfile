FROM alpine:3.4

ENV APP_DIR=/usr/app

RUN apk update && apk upgrade && \
    apk add ruby ruby-io-console ruby-bundler ruby-irb ruby-bigdecimal tzdata mysql-dev && \
    apk add nodejs

RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

# Cache bundle install
COPY Gemfile $APP_DIR/
COPY Gemfile.lock $APP_DIR/

RUN apk add --virtual build-dependencies curl-dev ruby-dev build-base && \
    cd $APP_DIR; bundle install --without development test -j4 && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

COPY . $APP_DIR
RUN chown -R nobody:nogroup $APP_DIR
USER nobody

ENV RAILS_ENV=production
RUN bundle exec rake assets:precompile

# Publish port 8080
EXPOSE 8080
