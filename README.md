# sagdevops-cicd-infra-docker

Author: Fabien Sanglier

Docker files and scripts to build a full SoftwareAG CI/CD environment all provisioned using Docker.
Some standard components like Jenkins, Docker Registry, Git servers are also provided for completion and ease of testing. 
(of course, these components may already be available in your infrastructure)

## Requirements

### Docker common resources

Of course, Docker should be installed!

And all docker-compose files in this project use the same docker network "sagdevops".
Let's create it first:

```
$ docker network create sagdevops
```

### Base Builder image on Docker Store

All the SoftwareAG docker images rely on the "commandcentral builder" image located on docker store
(store/softwareag/commandcentral:10.1.0.1-builder) 

To access that image, we'll first need to check it out on docker store at https://store.docker.com/images/softwareag-commandcentral
Then, on our workstation, we'll have to docker login (with the same credentials used to check out the image on the docker store) and pull it.

```
docker login
docker pull store/softwareag/commandcentral:10.1.0.1-builder
```

## Start Docker Registry

Follow instructions at [docker_registry](docker_registry/readme.md)

Then, start with:

```
$ cd docker_registry
$ docker-compose up -d
```

Accessible at: 
 * registry.docker.tests (eg. docker push registry.docker.tests/imagename:version)
 * https://registryweb.docker.tests

## Start Git Server

```
$ cd gitserver
$ POSTGRES_USER=admin \
  POSTGRES_PASSWORD=<password> \
  docker-compose up -d
```

Accessible at http://localhost:10080/

## Start Jenkins

```
$ cd jenkins
$ docker-compose up -d
```

Accessible at http://localhost:8080/jenkins/

## Create SoftwareAG images

### SoftwareAG software repository

In order to create any SoftwareAG image from the "commandcentral builder", you'll need to provide repository info from which to pull the softwareag product and fixes.
This info must be accurately entered in each of the *init.yaml* files in the various wM products, as follow:
 * repo.products.location: <some url location for products>
 * repo.fixes.location: <some url location for fixes>
 * repo.username: <repo username>
 * repo.password: <repo password>

### Create ABE image

This assumes you have updated the init.yaml correctly.

```
$ cd wm_abe
$ docker-compose build abe
```

The script should run for a few minutes while it's pulling all the required binaries from the SoftwareAG products/fixes repositopry.
At the end, you should have image "registry.docker.tests/softwareag/abe:10.1" in your local reposiory.
Next step would be to push this image to the registry, as follows:
```
docker push registry.docker.tests/softwareag/abe:10.1
```