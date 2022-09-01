SHELL := /bin/bash

all: build run

run: build
	docker-compose run --rm web

build: .built .bundled

.built: Dockerfile
	docker-compose build
	touch .built

.bundled: mix.exs
	docker-compose run web mix deps.get
	touch .bundled

logs:
	docker-compose logs

clean:
	docker-compose rm
	rm .built
	rm .bundled