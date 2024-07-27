FROM ruby:3.2.0

WORKDIR /usr/app

COPY Gemfile Gemfile.lock  ./

RUN bundle install

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]