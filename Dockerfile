FROM ruby:latest

RUN gem install bundler

WORKDIR /usr/src/app
ADD . .
RUN bundle
RUN rake install

EXPOSE 4567
CMD spagett