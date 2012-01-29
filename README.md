# Kensa Create Production

    $ kensa create myaddon --template sinatra-production
    $ bundle install

## After Cloning


### create dev db:

    $ createdb myaddon-dev
    $ bundle exec sequel -m db/migrations postgres://localhost/myaddon-dev

### add to the .env file:

    DATABASE_URL=postgres://localhost/myaddon-dev
    SMTP_USERNAME={from smtp service ie: sendgrid}
    SMTP_PASSWORD={from smtp service ie: sendgrid}

### fire it up with foreman

    $ foreman start

### get in there!

    $ kensa test provivision
    $ kensa sso 1

### create test db

    $ createdb myaddon-test
    $ bundle exec sequel -m db/migrations postgres://localhost/myaddon-test

### run the tests...

    $ bundle exec rake

### fire up a worker!

    $ bundle exec rake work

## Under the hood

  * `Sinatra` for the frontend
  * `Sequel` for models and persistence
  * `queue_classic` for background processing
  * `test/unit` with `rack::test` for unit tests 
  * `test/unit` with `capybara` for integration tests
  * `fabricate` for test models
  * `rr` for test mocks
