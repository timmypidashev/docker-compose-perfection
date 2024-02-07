PROJECT_NAME							:= "docker-compose-perfection"
PROJECT_AUTHORS 						:= "Timothy Pidashev (timmypidashev) <pidashev.tim@gmail.com>"
PROJECT_VERSION 						:= "v0.0.0"
PROJECT_LICENSE 						:= "MIT"
PROJECT_SOURCES							:= "https://github.com/timmypidashev/docker-compose-perfection"
PROJECT_REGISTRY						:= "https://ghcr.io/timmypidashev/docker-compose-perfection"

CONTAINER_PROXY_NAME					:= "proxy"
CONTAINER_PROXY_VERSION 				:= "v0.0.0"
CONTAINER_PROXY_LOCATION				:= "./proxy"
CONTAINER_PROXY_DESCRIPTION				:= "An example caddy docker container serving as a reverse proxy."

CONTAINER_WEBAPP_NAME					:= "webapp"
CONTAINER_WEBAPP_VERSION				:= "v0.0.0"
CONTAINER_WEBAPP_LOCATION				:= "./webapp"
CONTAINER_WEBAPP_DESCRIPTION			:= "An example container running a reflex webapp."

.PHONY: run build push bump

run:
	# Arguments:
	# [environment]: 'dev' or 'prod'
	# 
	# Explanation:
	# * Runs the docker compose file with the specified environment(compose.dev.yml, or compose.prod.yml)
	# * Passes all generated arguments to the compose file.

build:
	# Arguments
	# [context]: Build context(where the Dockerfile is located for the image to be built)
	# [environment]: 'dev' or 'prod'
	#
	# Explanation:
	# * Builds the specified docker image with the appropriate environment.
	# * Passes all generated arguments to docker build-kit.

push:
	# Arguments
	# ToDo: Figure out the general process for push once run and build are implemented.
