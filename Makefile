# Define the Docker image name
IMAGE_NAME=template-php
# Define the container name
CONTAINER_NAME=template-php

.PHONY: build run clean

build:
	docker build --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) -t $(IMAGE_NAME) .

run: build
	docker stop $(CONTAINER_NAME)
	docker run -d --rm --name $(CONTAINER_NAME) -p 8080:80 --user "$(shell id -u):$(shell id -g)" $(IMAGE_NAME)

clean:
	docker stop $(CONTAINER_NAME) || true && docker rm $(CONTAINER_NAME) || true
	docker rmi $(IMAGE_NAME) || true
