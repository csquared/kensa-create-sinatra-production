# Deploy Hooks 2.0


This repository is a sinatra application that uses the

    "requires" : ["deploy_notify"]

feature to implement a deploy hooks service.

See http://devcenter.heroku.com/articles/deploy-hooks for how it works to a user.

## Under the hood

  * `Sinatra` for the frontend
  * `Sequel` for models and persistence
  * `queue_classic` to run hooks in bg
  * `test/unit` with `rack::test` for unit tests 
  * `test/unit` with `capybara` for integration tests

## After Cloning

create a .env file to run in foreman with:

    SSO_SALT={from manifest api/sso_salt}
    HEROKU_USERNAME={from manifest id}
    HEROKU_PASSWORD={from manifest api/password}
    DATABASE_URL=postgres://localhost/deploy-hooks-db
    SMTP_USERNAME={from smtp service ie: sendgrid}
    SMTP_PASSWORD={from smtp service ie: sendgrid}

run migrations with

    $ bundle exec sequel -m db/migrations postgres://localhost/deploy-hooks-db

fire it up with foreman

    $ foreman start
