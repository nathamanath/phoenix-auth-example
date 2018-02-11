DOCKER_IMAGE_NAME = nathamanath/auth_demo
APP_NAME = auth

MIX_ENV ?= prod

VERSION = `cat ./version.txt`

release: build docker

build:
	mix clean
	mix deps.get --only prod
	MIX_ENV=$(MIX_ENV) PORT=4000 mix compile

	cd ./assets; \
			./node_modules/brunch/bin/brunch build --production

	MIX_ENV=$(MIX_ENV) mix phx.digest

	PORT=4000 MIX_ENV=$(MIX_ENV) mix release --env=$(MIX_ENV)

docker:
	docker build \
		--build-arg APP_NAME=${APP_NAME} \
		--build-arg ELIXIR_ENV=$(MIX_ENV) \
		--build-arg APP_VERSION=$(VERSION) \
		-t $(DOCKER_IMAGE_NAME) .

	docker tag $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_NAME)-$(MIX_ENV):latest
	docker tag $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_NAME)-$(MIX_ENV):$(VERSION)

.PHONY: build docker
