# Blazer Docker

An experimental Docker image for [Blazer](https://github.com/ankane/blazer)

Build

```sh
docker build -t blazer .
```

Run

```sh
docker run -ti -e DATABASE_URL=postgres://user:password@hostname:5432/dbname -p 8080:8080 blazer
```

And visit [http://localhost:8080](http://localhost:8080)

> On Mac, use `host.docker.internal` instead of `localhost` to access the host machine (requires Docker 18.03+)

Plan

- instructions for migrations
- instructions for customizing
- instructions for authentication
- more adapters
- publish to Docker Hub
