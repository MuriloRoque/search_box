# Real-Time Search Analytics

This application provides real-time search analytics, allowing users to track and analyze search terms.

## Table of Contents

- [Ruby version](#ruby-version)
- [System dependencies](#system-dependencies)
- [Database creation](#database-creation)
- [How to run the test suite](#how-to-run-the-test-suite)
- [How it works](#how-it-works)
- [Live Demo](#live-demo)

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

## How it works

- The app detects the user's session, meaning you can clear the session or open the app in the incognito mode to "refresh" the session and act as a new user.
- As the user types in the search input, the Popular Searches section is updated, but the term will be updated instead of being created. This ensures that the term will be recorded only when the user finishes typing (considering that the user finishes when they close the window).
- When a new user session is initialized, the Popular Searches data will still have other users' search data (a ranking), but when the user types, a new search term will be created.

## Live Demo

Check the deployed app in https://search-box-mtrt.onrender.com/
