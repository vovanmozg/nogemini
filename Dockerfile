# docker build -t nogemini .
# docker run --env LOG_LEVEL=debug --env LOG_OUT=STDOUT -v /users/user/files:/shared_files nogemini bin/index /shared_files

FROM ruby:2.7.4 AS base

RUN apt-get update -qq \
  && apt-get install -yq \
     libjpeg-dev \
     libpng-dev \
     imagemagick

RUN mkdir -p /app
WORKDIR /app

COPY . .
RUN bundle install
