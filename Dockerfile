ARG RUBY_VERSION=3.0.0
FROM ruby:${RUBY_VERSION}-alpine
RUN apk add --update --no-cache bash build-base nodejs tzdata postgresql-dev yarn shared-mime-info
RUN gem install bundler

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --check-files

COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install --verbose --jobs 20 --retry 5

COPY . ./

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
