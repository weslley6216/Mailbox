ENV.each { |k, v| env(k, v) }

env :PATH, ENV['PATH']
set :environment, "development"
set :output, "#{path}/log/cron.log"

every 1.minute do
  runner "ExpirePasswordJob.perform_later"
end
