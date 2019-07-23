FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /csvgo
WORKDIR /csvgo

COPY Gemfile /csvgo/Gemfile
COPY Gemfile.lock /csvgo/Gemfile.lock

RUN bundle install

COPY . /csvgo
