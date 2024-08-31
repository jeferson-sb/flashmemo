# Rails API

[<img src="https://run.pstmn.io/button.svg" alt="Run In Postman" style="width: 128px; height: 32px;">](https://app.getpostman.com/run-collection/6435402-ff52c2f9-8d97-48d2-8cf3-1359b71f521f?action=collection%2Ffork&source=rip_markdown&collection-url=entityId%3D6435402-ff52c2f9-8d97-48d2-8cf3-1359b71f521f%26entityType%3Dcollection%26workspaceId%3D83618443-db3a-4dc4-9ae8-c1b3085d965f)

## Regular Setup

```
bin/bundle install
```

### Database setup

```
rails db:create
rails db:migrate
rails db:seed
```

### Start server

```
bin/rails s
```

## Docker setup

```sh
cp .env.example .env # Fill with your details
docker compose up --build
```

### Database setup

```sh
docker compose run api rails db:create
docker compose run api rails db:migrate
docker compose run api rails db:seed
```

## Tests

```
rspec .
```

## Linting

```
rubocop -a
```
