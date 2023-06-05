#!/bin/bash
set -e

function docker_tag_exists() {
    TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${UNAME}'", "password": "'${UPASS}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
    curl --silent -f --head -lL https://hub.docker.com/v2/repositories/$1/tags/$2/ > /dev/null
}

DOCKER_NEXUS_VERSION=`curl https://raw.githubusercontent.com/sonatype/docker-nexus3/main/Dockerfile --silent | grep "ARG NEXUS_VERSION"`

NEXUS_VERSION_ARRAY=(${DOCKER_NEXUS_VERSION//=/ })
FULL_NEXUS_VERSION=${NEXUS_VERSION_ARRAY[2]}
NEXUS_VERSION_ARRAY=(${FULL_NEXUS_VERSION//-/ })
NEXUS_VERSION=${NEXUS_VERSION_ARRAY[0]}

if docker_tag_exists jeroenkolk/nexus3-docker-arm $NEXUS_VERSION; then
    echo exist
else
  echo $FULL_NEXUS_VERSION
  docker buildx build . --build-arg=NEXUS_VERSION=$FULL_NEXUS_VERSION \
    --platform "linux/arm/v7,linux/arm64" \
    --pull \
    --tag "$REGISTRY_USER/nexus3-docker-arm:main" \
    --tag "$REGISTRY_USER/nexus3-docker-arm:$NEXUS_VERSION" \
    --output "type=image,push=true" \
fi
