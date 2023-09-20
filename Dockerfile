FROM ruby:3.2.2-alpine3.18

MAINTAINER Andrew Kane <andrew@ankane.org>

ARG INSTALL_PATH=/app
ARG RAILS_ENV=production
ARG DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname
ARG SECRET_TOKEN=dummytoken

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY . .

RUN apk add --update build-base gcompat git libpq-dev mariadb-dev libpq mariadb-connector-c unixodbc && \
    gem install bundler && \
    bundle install && \
    bundle binstubs --all && \
    bundle exec rake assets:precompile && \
    apk del build-base git libpq-dev mariadb-dev && \
    rm -rf /var/cache/apk/*

ENV PORT 8080

EXPOSE 8080

CMD puma -C /app/config/puma.rb
