FROM elixir:1.11.4-alpine AS build

# Using args like this is not secure,
# We need to revisit this later and clean it up

ARG MIX_ENV=prod
ARG DATABASE_URL
ARG SECRET_KEY_BASE
ARG DEVISE_JWT_SECRET_KEY
ARG ERL_DIST_PORT
ARG COOKIE

ENV MIX_ENV=${MIX_ENV}
ENV DATABASE_URL=${DATABASE_URL}
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}
ENV COOKIE=${COOKIE}
ENV ERL_DIST_PORT=${ERL_DIST_PORT}

# install build dependencies
RUN apk add --no-cache build-base npm git python2

# prepare build dir
WORKDIR /app

# install hex + rebarv
RUN mix local.hex --force && \
    mix local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json ./assets/
RUN npm --prefix ./assets install
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

RUN apk add --no-cache openssl ncurses-libs curl jq 

WORKDIR /app

RUN chown nobody:nobody /app

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/leyden_jar /app

USER nobody:nobody

CMD ["bin/leyden_jar", "start"]