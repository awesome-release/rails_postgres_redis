FROM ruby:2.7.1-alpine
RUN apk add --update --no-cache bash build-base nodejs tzdata postgresql-dev yarn
RUN gem install bundler

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --check-files

COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install --verbose --jobs 20 --retry 5

COPY . ./

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]