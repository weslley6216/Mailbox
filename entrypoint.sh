#!/bin/bash

# Starts cron and updates tasks whenever
service cron start
bundle exec whenever --update-crontab
crontab -l

# Keeps the container active
tail -f /dev/null
