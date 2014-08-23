#!/bin/bash
cd /rails
source /etc/profile.d/rvm.sh

bundle exec unicorn -E production -c config/unicorn.rb

