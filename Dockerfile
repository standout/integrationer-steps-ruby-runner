FROM ruby:2.7.8-alpine

MAINTAINER devops@standout.se

ENV USER=runner
ENV GROUP=runner
ENV UID=10000
ENV GID=10000

RUN apk --update add --no-cache git build-base && \
    rm -rf /var/lib/apt/lists/*

RUN addgroup -g $GID $GROUP && \
    adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$USER" \
    --uid "$UID" \
    "$USER"

USER $USER

COPY config/gemrc /etc/gemrc
COPY config/gemrc /usr/local/etc/gemrc

COPY src/ /home/runner/

RUN gem install \
  'activesupport:6.1.7.7' \
  'activesupport:7.1.3.3' \
  'base64:0.2.0' \
  'builder:3.2.4' \
  'crack:1.0.0' \
  'csv:3.3.0' \
  'date:3.3.4' \
  'down:5.4.2' \
  'faraday-retry:2.2.1' \
  'faraday:2.8.1' \
  'json:2.7.2' \
  'money:6.19.0' \
  'nokogiri:1.15.6' \
  'pdf-reader:2.12.0' \
  'rexml:3.2.8' \
  'roo:2.10.1' \
  'moss_generator' \
  'pry-byebug' \
  --no-doc

ENV HOME=/tmp/app-tmp
ENV TMPDIR=/tmp/app-tmp
ENV GEM_HOME=/tmp/gem-home
ENV GEM_PATH=/tmp/gem-home:/usr/local/bundle:/usr/local/lib/ruby/gems/2.7.0
