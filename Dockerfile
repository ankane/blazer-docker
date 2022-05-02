FROM ruby:3.0.4-alpine3.15

MAINTAINER Andrew Kane <andrew@ankane.org>

ARG INSTALL_PATH=/app
ARG RAILS_ENV=production
ARG DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname
ARG SECRET_TOKEN=dummytoken

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY . .

RUN apk add --update ruby-dev build-base libxml2-dev libxslt-dev pcre-dev libffi-dev libpq-dev mariadb-dev sqlite-dev git unixodbc-dev libpq mariadb-connector-c sqlite-libs unixodbc && \
    gem install bundler && \
    bundle install && \
    bundle exec rails app:update:bin && \
    bundle exec rake assets:precompile && \
    apk del ruby-dev build-base libxml2-dev libxslt-dev pcre-dev libffi-dev libpq-dev mariadb-dev sqlite-dev git unixodbc-dev && \
    rm -rf /var/cache/apk/*

ENV PORT 8080

EXPOSE 8080

CMD puma -C /app/config/puma.rb
