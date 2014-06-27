#!/bin/bash
cd /rails
source /etc/profile.d/rvm.sh

bundle exec unicorn -p 80 -E production -c config/unicorn.rb

