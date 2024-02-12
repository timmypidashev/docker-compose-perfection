PROJECT_NAME							:= "docker-compose-perfection"
PROJECT_AUTHORS 						:= "Timothy Pidashev (timmypidashev) <pidashev.tim@gmail.com>"
PROJECT_VERSION 						:= "v0.0.0"
PROJECT_LICENSE 						:= "MIT"
PROJECT_SOURCES							:= "https://github.com/timmypidashev/docker-compose-perfection"
PROJECT_REGISTRY						:= "https://ghcr.io/timmypidashev/docker-compose-perfection"

CONTAINER_PROXY_NAME					:= "proxy"
CONTAINER_PROXY_VERSION 				:= "v0.0.0"
CONTAINER_PROXY_LOCATION				:= "./src/proxy"
CONTAINER_PROXY_DESCRIPTION				:= "An example caddy docker container serving as a reverse proxy."

CONTAINER_WEBAPP_NAME					:= "webapp"
CONTAINER_WEBAPP_VERSION				:= "v0.0.0"
CONTAINER_WEBAPP_LOCATION				:= "./src/webapp"
CONTAINER_WEBAPP_DESCRIPTION			:= "An example container running a reflex webapp."

.PHONY: run build push bump
.IGNORE: run
.SILENT:

run:
	# Arguments:
	# [environment]: 'dev' or 'prod'
	# 
	# Explanation:
	# * Runs the docker compose file with the specified environment(compose.dev.yml, or compose.prod.yml)
	# * Passes all generated arguments to the compose file.
	
	# Make sure we have been given proper arguments.
	@if [ "$(word 2,$(MAKECMDGOALS))" = "dev" ]; then \
		echo "Running in development environment"; \
	elif [ "$(word 2,$(MAKECMDGOALS))" = "prod" ]; then \
		echo "Running in production environment"; \
	else \
		echo "Invalid usage. Please use 'make run dev' or 'make run prod'"; \
		exit 1; \
	fi

	# Run docker compose within the proper environment, passing all generated arguments to docker.
	docker compose -f compose.$(word 2,$(MAKECMDGOALS)).yml up $$(args)

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

prune:
	# Removes all built and cached docker images and containers.


# This function generates Docker build arguments based on variables defined in the Makefile.
# It extracts variable assignments, removes whitespace, and formats them as build arguments.
# Additionally, it appends any custom shell generated arguments defined below.
define args
    @echo -n $(shell \
        grep -E '^[[:alnum:]_]+[[:space:]]*[:?]?[[:space:]]*=' $(MAKEFILE_LIST) | \
        awk 'BEGIN {FS = ":="} { \
            gsub(/^[[:space:]]+|[[:space:]]+$$/, "", $$2); \
            gsub(/^/, "\x27", $$2); \
            gsub(/$$/, "\x27", $$2); \
            gsub(/[[:space:]]+/, "", $$1); \
            gsub(":", "", $$1); \
            printf "--build-arg %s=%s ", $$1, $$2 \
        }') \
        --build-arg BUILD_DATE='"$(shell date)"' \
		--build-arg GIT_COMMIT='"$(shell git rev-parse HEAD)"'
endef
