#!/usr/bin/env bash

#get script dir so we can call this script from anywhere
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
DOCKER_COMPOSE_FILE="$SCRIPT_DIR/docker-compose-build.yml"
REGISTRY=registry.docker.tests

build(){
    #if no param passed, build all in the docker-compose
    if [ "$#" == "0" ]; then
        echo "Building all services in $DOCKER_COMPOSE_FILE"
        #docker-compose -f $DOCKER_COMPOSE_FILE build
    fi

    ## if params passed, iterate over and build each one
    for var in "$@"
    do
        echo "Building services $var in $DOCKER_COMPOSE_FILE"
        #docker-compose -f $DOCKER_COMPOSE_FILE build $var
    done

    list
}

tag(){
    ## tag with version and registry
    images=$(docker-compose -f $DOCKER_COMPOSE_FILE config | grep 'image: ' | awk -F ':' '{ print ""$2":"$3 }')
    imageNameGrep=""
    for image in $images
    do
      imageName=$(echo $image | awk -F ':' '{ print $1 }')
      imageVersion=$(echo $image | awk -F ':' '{ print $2 }')

      docker tag "${imageName}:${imageVersion}" "${REGISTRY}/${imageName}:${imageVersion}"
      docker tag "${imageName}:${imageVersion}" "${REGISTRY}/${imageName}:latest"
      docker tag "${imageName}:${imageVersion}" "${imageName}:latest"

      if [ "x${imageNameGrep}" != "x" ]; then
         imageNameGrep="${imageNameGrep}\|"
      fi
      imageNameGrep="${imageNameGrep}${imageName}"
    done

    list
}

list(){
    ## check what the images were in the docker-compose-build
    imageNames=$(docker-compose -f $DOCKER_COMPOSE_FILE config | grep 'image: ' | awk -F ':' '{ print $2 }')
    imageNameGrep=""
    for imageName in $imageNames
    do
      if [ "x${imageNameGrep}" != "x" ]; then
         imageNameGrep="${imageNameGrep}\|"
      fi
      imageNameGrep="${imageNameGrep}${imageName}"
    done

    echo "Image Listing relevant to $DOCKER_COMPOSE_FILE:"
    docker images | grep $imageNameGrep
}

BIN_NAME=$1
shift
case "$BIN_NAME" in
    build)
        build $@
        ;;
    tag)
        tag $@
        ;;
    list)
        list $@
        ;;
    *)
        echo $"Usage: $0 {build|tag|list}"
        exit 1
esac