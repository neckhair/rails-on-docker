FROM alpine:3.4

RUN apk update && apk upgrade && \
    apk add curl-dev ruby-dev mysql-dev build-base && \
    apk add ruby ruby-io-console ruby-bundler ruby-irb ruby-bigdecimal tzdata && \
    apk add nodejs && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /usr/app
WORKDIR /usr/app

# Cache bundle install
COPY Gemfile /usr/app/
COPY Gemfile.lock /usr/app/

RUN bundle install --without development test -j4

COPY . /usr/app
RUN chown -R nobody:nogroup /usr/app
USER nobody

ENV RAILS_ENV=production
RUN bundle exec rake assets:precompile

# Publish port 8080
EXPOSE 8080
