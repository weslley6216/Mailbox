source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.3'
gem 'rails', '~> 7.0.8', '>= 7.0.8.1'
gem 'pg', '~> 1.5', '>= 1.5.6'
gem 'puma', '~> 5.0'
gem 'sidekiq', '~> 7.3'
gem 'redis'
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'whenever', require: false

group :development, :test do
  gem 'pry-byebug', '~> 3.10', '>= 3.10.1'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.2'
end

group :test do
  gem 'shoulda-matchers', '~> 6.2'
  gem 'database_cleaner-active_record', '~> 2.1'
end

