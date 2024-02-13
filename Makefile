PROJECT_NAME							:= "docker-compose-perfection"
PROJECT_AUTHORS 						:= "Timothy Pidashev (timmypidashev) <pidashev.tim@gmail.com>"
PROJECT_VERSION 						:= "v0.0.0"
PROJECT_LICENSE 						:= "MIT"
PROJECT_SOURCES							:= "https://github.com/timmypidashev/docker-compose-perfection"
PROJECT_REGISTRY						:= "https://ghcr.io/timmypidashev/docker-compose-perfection"

CONTAINER_WEBAPP_NAME					:= "webapp"
CONTAINER_WEBAPP_VERSION				:= "v0.0.0"
CONTAINER_WEBAPP_LOCATION				:= "src/webapp"
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
	docker compose -f compose.$(word 2,$(MAKECMDGOALS)).yml up --remove-orphans $$(args)


build:
	# Arguments
	# [context]: Build context(where the Dockerfile is located for the image to be built)
	# [environment]: 'dev' or 'prod'
	#
	# Explanation:
	# * Builds the specified docker image with the appropriate environment.
	# * Passes all generated arguments to docker build-kit.
	# * 
	
	# Extract container and environment inputted.
	$(eval INPUT_TARGET := $(word 2,$(MAKECMDGOALS)))
	$(eval INPUT_CONTAINER := $(firstword $(subst :, ,$(INPUT_TARGET))))
	$(eval INPUT_ENVIRONMENT := $(lastword $(subst :, ,$(INPUT_TARGET))))

	# Validate input container name.
	@if [ -z "$(filter $(INPUT_CONTAINER),$(shell echo "$(containers)"))" ]; then \
        echo "Invalid container name. Please specify one of the following: $(strip $(foreach var,$(.VARIABLES),$(if $(filter CONTAINER_%_NAME,$(var)),$(strip $($(var))))))"; \
        exit 1; \
    fi

	# Validate input environment
	@if [ "$(strip $(INPUT_ENVIRONMENT))" != "dev" ] && [ "$(strip $(INPUT_ENVIRONMENT))" != "prod" ]; then \
        echo "Invalid environment. Please specify 'dev' or 'prod'"; \
        exit 1; \
    fi

	# Build the selected image within its proper build environment.
	docker buildx build --load -t $(INPUT_CONTAINER):$(INPUT_ENVIRONMENT) -f $(strip $(subst $(SPACE),,$(call container_location,$(INPUT_CONTAINER))))/Dockerfile.$(INPUT_ENVIRONMENT) ./$(strip $(subst $(SPACE),,$(call container_location,$(INPUT_CONTAINER))))/. --no-cache $$(args)

push:
	# Arguments
	# ToDo: Figure out the general process for push once run and build are implemented.

prune:
	# Removes all built and cached docker images and containers.

bump:
	# Future: consider adding this; for now manually bumping project and container versions is acceptable :D

# This function generates Docker build arguments based on variables defined in the Makefile.
# It extracts variable assignments, removes whitespace, and formats them as build arguments.
# Additionally, it appends any custom shell generated arguments defined below.
define args
    $(shell \
        @echo -n grep -E '^[[:alnum:]_]+[[:space:]]*[:?]?[[:space:]]*=' $(MAKEFILE_LIST) | \
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

# This function returns a list of container names defined in the Makefile.
# In order for this function to return a container, it needs to have this format: CONTAINER_%_NAME!
define containers
    $(strip $(filter-out $(_NL),$(foreach var,$(.VARIABLES),$(if $(filter CONTAINER_%_NAME,$(var)),$(strip $($(var)))))))
endef

define container_location
	$(strip $(eval CONTAINER_NAME := $(shell echo $(1) | tr '[:lower:]' '[:upper:]'))) \
	$(if $(CONTAINER_$(CONTAINER_NAME)_LOCATION), \
		$(CONTAINER_$(CONTAINER_NAME)_LOCATION), \
		$(error Location data for container $(1) not found))
endef

define container_version
	$(strip $(eval CONTAINER_NAME := $(shell echo $(1) | tr '[:lower:]' '[:upper:]'))) \
	$(if $(CONTAINER_$(CONTAINER_NAME)_VERSION), \
		$(CONTAINER_$(CONTAINER_NAME)_VERSION), \
		$(error Version data for container $(1) not found))
endef
