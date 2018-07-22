# README

KodalySongDatabase is a web application designed to organize analyses of songs for teachers practicing the Kodaly method.


To roll your own server, here's some basic (incomplete) instructions to start a local instance:

Build latest:
* docker-compose run shell bundle update
* docker-compose build

To run:
* docker-compose up web
* Using a browser, navigate to localhost:8080

You'll need to sign-up for a cloudinary account and setup a config/cloudinary.yml file if you want to upload images.
