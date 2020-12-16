FROM elixir:1.11.2-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git python3

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# copy entrypoint
COPY entrypoint entrypoint

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
COPY lib lib

RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs bash

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/the_rush ./
COPY --from=build --chown=nobody:nobody /app/priv/support_files /app/priv/support_files
COPY --from=build --chown=nobody:nobody /app/entrypoint /usr/local/bin/entrypoint

RUN chmod +x /usr/local/bin/entrypoint

ENV HOME=/app

ENTRYPOINT ["entrypoint"]
CMD ["bin/the_rush", "start"]
