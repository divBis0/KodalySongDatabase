FROM heroku/heroku:18-build
RUN apt-get update -qq && apt-get install -y nodejs
RUN gem install bundler
RUN mkdir /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
WORKDIR /app
RUN bundle install
RUN cp Gemfile.lock ~/Gemfile.lock
