# smsgateway
A micro service API server that handles inbound/outbound sms - a Ruby on Rails(v7) API application.

## Prerequisites

Before you begin, ensure you have installed following requirements:

- Ruby v3.2.3
- [PostgreSQL](https://www.postgresql.org/) as the database
- [Redis](https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/) as the cache store

## Local Development Setup

Within the app root directory, run the follwing
```
gem install bundler
bundle install
```

## To seed data from the sql dump 
```
rails db:create
psql smsgateway_development < db/schema.sql
```

## To run the app locally
```
rails s
```