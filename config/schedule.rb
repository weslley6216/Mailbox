set :output, "log/cron.log"

every 1.day, at: '12:00 am' do
  runner "ExpirePasswordJob.perform_now"
end
