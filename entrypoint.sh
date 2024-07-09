#!/bin/bash

# Remove pid file if it exists
rm -f /opt/app/tmp/pids/server.pid

# Start cron service
service cron start

# Update cron tasks using Whenever
bundle exec whenever --update-crontab

# Display currently configured cron tasks
crontab -l

# Keep the container running
tail -f /dev/null
