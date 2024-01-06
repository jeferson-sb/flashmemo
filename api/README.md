# README

Test your knowledge and memorize by using flash cards! 🟦🟩🟨

Features

- Exams (collection of questions)
- Questions and multiple options
- User account creation and signin in via JWT
- Categories
- Exams evaluation
- Revisions to practice wrong answered questions
- User Progress by period (monthly, yearly, semester)

```
cd api && bin/bundle install
```

## Database setup

```
docker-compose up -d
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

## API

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
