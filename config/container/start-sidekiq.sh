#!/bin/bash
cd /rails
bundle exec sidekiq -e production -c 25
