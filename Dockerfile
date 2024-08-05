FROM ruby:2.7.1

COPY hangman.rb /
RUN gem install debug colorize i18n

COPY . /