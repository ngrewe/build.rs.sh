#!/bin/bash -eu
if [[ -n "${TRAVIS_TAG}" ]]; then
  docker tag ngrewe/build.rs:latest ${TRAVIS_TAG}	
fi

docker login -e "${DOCKER_EMAIL}" -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
trap 'docker logout' EXIT
docker push ngrewe/build.rs:latest

if [[ -n "${TRAVIS_TAG}" ]]; then
  docker push ngrewe/build.rs:${TRAVIS_TAG}
fi 
