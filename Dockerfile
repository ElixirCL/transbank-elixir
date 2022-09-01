FROM elixir:latest
RUN apt-get update && apt-get install
RUN mkdir -p /sdk
WORKDIR /sdk
COPY . /sdk