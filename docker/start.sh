#!/bin/sh

# Wait for the database
./docker/wait-for-it.sh $MYSQL_HOST:3306 --timeout=60 --strict -- echo "Database is up!"

if bin/rake db:migrate:status > /dev/null; then
  echo "Database exists. Not initializing."
else
  echo "Initializing database..."
  bin/rake db:setup
fi

bin/rake db:migrate
exec bundle exec puma -C config/puma.rb
