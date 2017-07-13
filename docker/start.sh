#!/bin/sh

# Wait for the database
./docker/wait-for-it.sh db:3306 --timeout=30 --strict -- echo "Database is up!"

export MYSQL_PWD=$MYSQL_PASSWORD
if echo "select * from schema_migrations;" | mysql -h db -u$MYSQL_USER beer_production; then
  echo "Database exists. Not initializing."
else
  echo "Initializing database..."
  bin/rake db:setup
fi
unset $MYSQL_PWD

exec bundle exec puma -C config/puma.rb
