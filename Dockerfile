FROM ruby:2.7-alpine

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

RUN gem update --system 3.4.22 && gem install activesupport 'faraday:2.8.1' faraday-retry money 'nokogiri:1.15.6' pry-byebug rexml --no-doc

ENV HOME=/tmp/app-tmp
ENV TMPDIR=/tmp/app-tmp
ENV GEM_HOME=/tmp/gem-home
ENV GEM_PATH=/tmp/gem-home:/usr/local/bundle:/usr/local/lib/ruby/gems/2.7.0
