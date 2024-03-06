# docker-compose-perfection
The perfect, yet elegantly simple docker compose developer pipeline.

### Overview
This repository houses a Makefile for orchestrating Docker Compose operations efficiently. The Makefile automates common tasks such as running, building, pushing Docker images to a registry, as well as pruning old images and containers. It's designed to streamline the development and deployment workflow for Docker-based projects.

### The Why
Have you ever been tired of having to run the same docker/docker compose commands over and over? I'm more than certain you probably began to rely on a CI process when it came to things like generating build arguments and docker labels for your images. And while CI/CD workflows are certainly great for managing docker image builds, There are many projects which just simply don't need this much overhead just to get some build arguments and labels for a docker image. But why all this abstraction for something as simple as writing a docker command.

### The Problem
Well, here's the issue I found myself in. When building an image, I wanted to have the ability to pass build arguments and labels to a docker image build. This may not sound that bad, until the reader 
decides to try and write out some commands on their own. Heres: a _simple_ docker build command with several build args:
```bash
docker buildx build --load -t api:dev -f "src/api"/Dockerfile.dev ./"src/api"/.
--build-arg PROJECT_NAME="docker-compose-perfection"
--build-arg PROJECT_AUTHORS="Timothy Pidashev (timmypidashev) <pidashev.tim@gmail.com>"
--build-arg PROJECT_VERSION="v0.0.0"
--build-arg PROJECT_LICENSE="MIT"
--build-arg PROJECT_SOURCES="https://github.com/timmypidashev/docker-compose-perfection"
--build-arg PROJECT_REGISTRY="ghcr.io/timmypidashev/docker-compose-perfection"
--build-arg PROJECT_ORGANIZATION="org.opencontainers"
--build-arg CONTAINER_WEBAPP_NAME="webapp"
--build-arg CONTAINER_WEBAPP_VERSION="v0.2.0"
--build-arg CONTAINER_WEBAPP_LOCATION="src/webapp"
--build-arg CONTAINER_WEBAPP_DESCRIPTION="An example container running a reflex webapp."
--build-arg CONTAINER_API_NAME="api"
--build-arg CONTAINER_API_VERSION="v0.0.0"
--build-arg CONTAINER_API_LOCATION="src/api"
--build-arg CONTAINER_API_DESCRIPTION="An example node api backend service."
--build-arg BUILD_DATE="Wed Mar  6 08:52:02 AM PST 2024"
--build-arg GIT_COMMIT="d61eb24e19c5c35e2e149f54df5a8c2a54755d9f"
--label "org.opencontainers".image.title="api"
--label "org.opencontainers".image.description="An example node api backend service."
--label "org.opencontainers".image.authors="Timothy Pidashev (timmypidashev) <pidashev.tim@gmail.com>"
--label "org.opencontainers".image.url="https://github.com/timmypidashev/docker-compose-perfection"
--label "org.opencontainers".image.source="https://github.com/timmypidashev/docker-compose-perfection"/"src/api"
--no-cache
```
It would definitely not be fun to have to write out all these commands by hand, and allowing a program to generate these commands empowers the user to not only pass static arguments, 
but also generate git commit hashes and time artifacts based on the image build, just to name a few.

### Why a Makefile?
I had the same question, which is why this whole endeavour started as a bash script. However, over time I realized that this presents a problem within itself as well. 
The main reason for a makefile though, is just how well suited it is for such a task.

### The How
Using the makefile is simple really, you just copy it into your projects root and begin configuring it for your use case.
At the top of the example makefile are many variables already defined. These are the primitive configuration method used here. Instead of having a separate json or toml file, the Makefile 
is the only file needed here(apart from your dockerfiles & or compose files)
```bash
PROJECT_NAME := "docker-compose-perfection"
PROJECT_AUTHORS := "Timothy Pidashev (timmypidashev) <pidashev.tim@gmail.com>"
PROJECT_VERSION := "v0.0.0"
PROJECT_LICENSE := "MIT"
PROJECT_SOURCES := "https://github.com/timmypidashev/docker-compose-perfection"
PROJECT_REGISTRY := "ghcr.io/timmypidashev/docker-compose-perfection"
PROJECT_ORGANIZATION := "org.opencontainers"

CONTAINER_WEBAPP_NAME	:= "webapp"
CONTAINER_WEBAPP_VERSION := "v0.2.0"
CONTAINER_WEBAPP_LOCATION := "src/webapp"
CONTAINER_WEBAPP_DESCRIPTION := "An example container running a reflex webapp."

CONTAINER_API_NAME := "api"
CONTAINER_API_VERSION := "v0.0.0"
CONTAINER_API_LOCATION := "src/api"
CONTAINER_API_DESCRIPTION := "An example node api backend service."
```
Here are the requirements for the configuration:
1. All variables need to be in uppercase format.
2. The `PROJECT` variables are required.
3. The `CONTAINER` variables follow the `CONTAINER_%_%` format, and can really be anything.
   NOTE: `CONTAINER_%_LOCATION` is required, and points to the container's dockerfile root.
   NOTE: `CONTAINER_%_VERSION` is required.

* This is at the end of the day a script, so the reader can modify it to their liking. Don't want container versioning, get rid of it. This is the freedom this makefile gives you.

# Usage
Once configured, usage is simple. 
* run           - Runs the docker compose file with the specified environment (dev or prod)
* build         - Builds the specified docker image with the appropriate environment
* push          - Pushes the built docker image to the registry
* prune         - Removes all built and cached docker images and containers
* bump          - Bumps the project and container versions

That's about it! This makefile just does what its told to, and can be modified per project. As always, feedback is always appreciated(just open a a github issue), and criticism accepted. Have fun :D
