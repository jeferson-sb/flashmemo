# Rails API

## Regular Setup

```
bin/bundle install
```

### Database setup

```
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
