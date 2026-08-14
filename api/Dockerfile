FROM ruby:3.3.4

WORKDIR /usr/app

COPY Gemfile Gemfile.lock  ./

RUN bundle install --jobs 4 --retry 3

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]