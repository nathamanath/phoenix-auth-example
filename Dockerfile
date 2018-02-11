FROM debian:stretch-slim

RUN apt-get update && apt-get install -yq \
  openssl \
  wget \
  gnupg2

RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN rm erlang-solutions_1.0_all.deb
RUN apt-get update && apt-get install -yq \
  esl-erlang \
  elixir

# Tidy up
RUN apt-get purge -yq wget
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG APP_NAME
ARG ELIXIR_ENV
ARG APP_VERSION

ENV APP_NAME=$APP_NAME
ENV APP_VERSION=$APP_VERSION
ENV PORT=4000
ENV REPLACE_OS_VARS=true

RUN useradd -ms /bin/bash elixiruser

# Copy in app release
COPY ./_build/$ELIXIR_ENV/rel/$APP_NAME/releases/$APP_VERSION/$APP_NAME.tar.gz /tmp/$APP_NAME
RUN mkdir /opt/$APP_NAME
RUN tar -xf /tmp/$APP_NAME --directory /opt/$APP_NAME
RUN chown -R elixiruser /opt/$APP_NAME

# Switch user
USER elixiruser

EXPOSE $PORT

CMD trap exit TERM; /opt/$APP_NAME/bin/$APP_NAME foreground & wait
