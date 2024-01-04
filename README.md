# Real-Time Search Analytics

This application provides real-time search analytics, allowing users to track and analyze search terms.

## Table of Contents

- [Ruby version](#ruby-version)
- [System dependencies](#system-dependencies)
- [Database creation](#database-creation)
- [How to run the test suite](#how-to-run-the-test-suite)

## Ruby version

This application is built using Ruby on Rails. The recommended Ruby version is specified in the `.ruby-version` file.

## System dependencies

Ensure you have Ruby and Ruby on Rails installed on your system. Additionally, check the `Gemfile` for any other dependencies and install them using Bundler:

```bash
bundle install
```

## Database creation

Create the database by running the following commands:

```bash
rails db:create
rails db:migrate
```

## How to run the test suite

Run the test suite to ensure the application functions correctly:

```bash
rails test
```
