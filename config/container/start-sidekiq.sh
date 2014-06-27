#!/bin/bash
cd /rails
source /etc/profile.d/rvm.sh

bundle exec sidekiq -e production -c 25
