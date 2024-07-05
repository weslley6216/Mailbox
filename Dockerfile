FROM ruby:3.2.3

RUN apt-get clean all && apt-get update -qq && apt-get install -y build-essential \ 
    libpq-dev curl gnupg2 apt-utils postgresql-client postgresql-server-dev-all  \
    git libcurl3-dev cmake libssl-dev pkg-config openssl imagemagick file \ 
    nodejs npm yarn cron && rm -rf /var/lib/apt/lists/*

WORKDIR opt/app

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

COPY . .
RUN bundle install

EXPOSE 3000
CMD ["./bin/rails", "server"]
