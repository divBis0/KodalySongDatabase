# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Build latest:
docker-compose run shell bundle update
docker-compose build

To run:
docker-compose up web
navigate to localhost:8080

e.g. adding column:
docker-compose run shell rails generate migration add_image_id_to_song image_id:string
docker-compose run shell rake db:migrate