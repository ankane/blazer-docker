FROM ruby:2.7.4-alpine3.13

MAINTAINER Andrew Kane <andrew@ankane.org>

RUN apk add --update ruby-dev build-base \
  libxml2-dev libxslt-dev pcre-dev libffi-dev \
  postgresql-dev mysql-dev sqlite-dev git \
  unixodbc-dev freetds-dev

RUN gem install bundler

ENV INSTALL_PATH /app

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./

RUN bundle install --binstubs

COPY . .

RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname SECRET_TOKEN=dummytoken assets:precompile

ENV PORT 8080

EXPOSE 8080

CMD puma -C /app/config/puma.rb
