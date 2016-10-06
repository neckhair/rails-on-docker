#!/usr/bin/env puma

environment ENV.fetch 'RAILS_ENV', 'production'

daemonize false

threads 0, 16

bind 'tcp://0.0.0.0:8080'

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
