FROM ruby:2.7-alpine

RUN apk --update add --no-cache git build-base && \
    rm -rf /var/lib/apt/lists/*

COPY src/ /usr/local/src/integrationer-helpers/
