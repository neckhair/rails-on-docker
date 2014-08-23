#!/bin/bash
cd /rails
bundle exec unicorn -E production -c config/unicorn.rb

