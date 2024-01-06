# Rails API
```
bin/bundle install
```

## Database setup

```
docker-compose up -d
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

## Server

```
bin/rails s
```

## Tests

```
rspec .
```

## Linting

```
rubocop -a
```
