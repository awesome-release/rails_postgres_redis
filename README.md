# rails_postgres_redis

This repository demonstrates an application setup using Rails, Postgres, and Redis which will run in Release. You can fork this repository and use it in Release to get started.

The following changes from a vanilla Rails app have been applied


### config/application.rb

```
# NOTE: This should not be left completely wide open after getting your application running
config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
```

While this repository can be used as a way to get started, it needs to be noted that it currently
allows for requests from anywhere to be let through. This is good for getting up and running on Release
but should not be used for a long lived environment.

### Gemfile

```
gem 'faker'
gem 'sidekiq'
gem 'rack-cors'
```

### config/database.yml

```
username: <%= ENV.fetch("POSTGRES_USERNAME") { 'postgres' } %>
password: <%= ENV.fetch("POSTGRES_PASSWORD") { 'postgres' } %>
host: <%= ENV.fetch("POSTGRES_HOST") { 'localhost' } %>
port: <%= ENV.fetch("POSTGRES_PORT") { '5432' } %>
```

Added setting up the database configuration from environment variables.

### config/environments/development.rb

```
# Whitelist the app to run on Release
config.hosts << /.*\.releaseapp\.io/
```

Allow Rails to receive requests from Release.

### db/migrate && app/models && app/controllers && app/jobs

Added a migration to create a `users` table and with it a `User` model and `UsersController`. Also 
created `CreateUsersJob` which will be used to create users asynchronously.


### lib/tasks/db_exists.rake

A rake task to check and see if the database exists in Postgresql or not; used in the startup
command in `docker-compose.yml`.

### Dockerfile

The `Dockerfile` is based on alpine and installs the bare minimum packages to run Rails.

### docker-compose.yml

Defines the application and is used by Release to generate the Application Configuration.
