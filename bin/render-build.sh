#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
./bin/rails assets:precompile
./bin/rails assets:clean
./bin/rails db:drop:_unsafe
./bin/rails db:create
./bin/rails db:migrate
