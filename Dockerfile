# Dev container
# FROM hexpm/elixir:1.11.2-erlang-23.1.1-ubuntu-bionic-20200630
# RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
#   DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential dialog apt-utils gpg-agent \
#   apt-transport-https software-properties-common git curl postgresql-client inotify-tools && \
#   curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
#   apt-get update && apt-get install -y nodejs && \
#   mix local.hex --force && \
#   mix archive.install hex phx_new 1.5.6 --force && \
#   mix local.rebar --force && \
#   apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# ENV APP_HOME /app
# RUN mkdir $APP_HOME
# WORKDIR $APP_HOME
# CMD ["mix", "phx.server"]


# Build container
# Needed ENV to build
# MIX_ENV
# DATABASE_URL
# SECRET_KEY_BASE"

FROM elixir:1.11.4-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git python2

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force



# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app

RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

COPY --from=build --chown=nobody:nobody ./_build/prod/rel/leyden_jar .

USER nobody:nobody

CMD ["bin/leyden_jar", "start"]