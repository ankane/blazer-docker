# Blazer Docker

An experimental Docker image for [Blazer](https://github.com/ankane/blazer)

## Getting Started

Build

```sh
docker build -t blazer .
```

Create database tables

```sh
docker run -ti -e DATABASE_URL=postgres://user:password@hostname:5432/dbname blazer bin/rails db:migrate
```

Run the web server

```sh
docker run -ti -e DATABASE_URL=postgres://user:password@hostname:5432/dbname -p 8080:8080 blazer
```

And visit [http://localhost:8080](http://localhost:8080)

> On Mac, use `host.docker.internal` instead of `localhost` to access the host machine (requires Docker 18.03+)

## Customization

Create a `blazer.yml` file with:

```yml
# see https://github.com/ankane/blazer for more info

data_sources:
  main:
    url: <%= ENV["DATABASE_URL"] %>

    # statement timeout, in seconds
    # none by default
    # timeout: 15

    # caching settings
    # can greatly improve speed
    # off by default
    # cache:
    #   mode: slow # or all
    #   expires_in: 60 # min
    #   slow_threshold: 15 # sec, only used in slow mode

    # wrap queries in a transaction for safety
    # not necessary if you use a read-only user
    # true by default
    # use_transaction: false

    smart_variables:
      # zone_id: "SELECT id, name FROM zones ORDER BY name ASC"
      # period: ["day", "week", "month"]
      # status: {0: "Active", 1: "Archived"}

    linked_columns:
      # user_id: "/admin/users/{value}"

    smart_columns:
      # user_id: "SELECT id, name FROM users WHERE id IN {value}"

# create audits
audit: true

# change the time zone
# time_zone: "Pacific Time (US & Canada)"

# email to send checks from
# from_email: blazer@example.org

# webhook for Slack
# slack_webhook_url: <%= ENV["BLAZER_SLACK_WEBHOOK_URL"] %>

check_schedules:
  - "1 day"
  - "1 hour"
  - "5 minutes"

# enable map
# mapbox_access_token: <%= ENV["MAPBOX_ACCESS_TOKEN"] %>
```

Create a `Dockerfile` with:

```Dockerfile
FROM blazer

COPY blazer.yml /app/config/blazer.yml
```

And build your image:

```sh
docker build -t my-blazer .
```

## Plan

- instructions for checks
- instructions for authentication
- publish to Docker Hub
