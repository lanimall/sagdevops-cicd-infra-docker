# sagdevops-cicd-infra-docker

Author: Fabien Sanglier

Docker files and scripts to build a full SoftwareAG CI/CD environment all provisioned using Docker.
Some standard components like Jenkins, Docker Registry, Git servers are also provided for completion and ease of testing. 
(of course, these components may already be available in your infrastructure)

## Requirements

### Docker common resources

Of course, Docker should be installed.
Installing docker for your platform is explained here: https://docs.docker.com/install/

Also, we will leverage docker-compose, so this should be installed too. 
More info on that at: https://docs.docker.com/compose/install/

Test that it all work well by running:

```
docker version
```

And 

```
docker-compose version
```

### Base Builder Docker Image on Docker Store

The SoftwareAG docker images rely some base "commandcentral" images located on docker store (${TAG} is the targetted version)
 * store/softwareag/commandcentral-node:${TAG}
 * store/softwareag/commandcentral-builder:${TAG}
 
To access that image, you first need to request access to it on docker store at https://store.docker.com/images/softwareag-commandcentral
by clicking "proceed to checkout" button (this is a one time operation)

Then, once succesfully registered, you should be able to "pull" the image down in your local docker registry (either on a server or your own workstation)
To do so, you'll need to run the following commands:

NOTE: I replaced ${TAG} with the version of command central that I need (10.3)

```
docker login
docker pull store/softwareag/commandcentral-node:10.3
docker pull store/softwareag/commandcentral-builder:10.3
```

### Base Docker Images

In this section, this is where we create some base Docker images from which all the future product images will inherit from.
This is generally a good practice because we can specify in a central place all the common software pieces that all our images will require, like:
 * base Operating System (OS) to use (eg. centos or other)
 * With specific modules that would need to be installed on that base OS, for example:
   * specific users, groups,
   * specific version of Java
   * etc...

For this sample, we will create 3 main images:
 * A Base OS image (centos:7)
 * A base JAVA image, that extends the "Base OS image" above + install the right java binaries and version.
 * A Base "Command Central" image which is essentially the same as the one on Docker Store, BUT pre-configured with your own specifics, such as:
   * REPO_PRODUCT_URL (Empower or mirror URL for SoftwareAG products)
   * REPO_FIX_URL  (Empower or mirror URL for SoftwareAG fixes)
   * REPO_USERNAME (Empower or mirror username)
   * REPO_PASSWORD (Empower or user password)
   * LICENSES_URL  (licenses files for the products...)

For the "Command Central" image to build and configure properly, all these variables should be specified and passed to the docker build.
There are various ways to do this efficiently, and hard-coding these values in the docker-compose or docker file is most certainly the least good of them :)

A good and simple practice is to set these variables as environment variables so they can be loaded in your shell directly.

For Linux-based environment, you would run the following export commands to use the SoftwareAG Empower repository.
NOTE: Make sure to also set the variables $EMPOWER_USER and $EMPOWER_PWD with your actual empower user and password.

```
export EMPOWER_USER=myempower@softwareag.com
export EMPOWER_PWD=verySecurePassword

export REPO_PRODUCT_URL=http://sdc.softwareag.com/dataservewebM103/repository/
export REPO_FIX_URL=http://sdc.softwareag.com/updates/prodRepo
export REPO_USERNAME=$EMPOWER_USER
export REPO_PASSWORD=$EMPOWER_PWD
export LICENSES_URL=
```

NOTE about LICENSES_URL: For this one, it is not strictly needed at docker build time... 
As it will be possible to use docker volumes to map the right product license for the right product at runtime.
Another option could be that you could create an extended docker image for a particular product where you simply add the right license in the right place.
That all being said, if you want to leverage command central builds to also add the license in the right place, 
then yes, the LICENSES_URL variable will need to specify a URL to a ZIP file containing all the license key files you need.

Once all the variable are set in your shell, we'll run the base image build by navigating to the "base-infra" folder and building the docker-compose file, as follows:

```
cd base-infra
docker-compose build
```

The command should run for a few minutes...at the end of which you should have 3 new docker images created on your local registry:
 * softwareag_ccbuild/base:10.3
 * softwareag_ccbuild/java:10.3
 * softwareag_ccbuild/commandcentral-builder:10.3
 
To check that out, you can simply run something like:

```
docker images | grep "softwareag_ccbuild"
```

which shoudl show you these 3 images. If that's not the case, something wrong happened 
and you should check the trace for the previous "docker-compose build" command.

## Create SoftwareAG Docker Images

At this point, we should be ready to build some docker images for any SoftwareAG product that supports Command Central builds.

### Create webMethods Asset Build Environment (ABE) image

The ABE docker builder assets are located in the wm_abe folder. Navigate to that folder first.

```
cd wm_abe
```

Then, before you run the actual docker build command, it is worth noting that by default,
the resulting docker images will be prefixed with the following registry URL: registry.docker.tests/

This value is specified in the variable REG in the ".env" file located in the same folder:

```
REG=registry.docker.tests/
```

This value can be changed to your own docker registry URL, if that makes sense in your environment.
If you don't plan to use a registry, you can also set REG to blank...

```
REG=
```

Ok, now this is the build time...
Simply run:

```
$ docker-compose -f docker-compose-build.yml build
```

The script will run for a few minutes while it's pulling all the required binaries from the SoftwareAG products/fixes repositopry.

At the end, you should have 3 images in your local repository:
 * registry.docker.tests/softwareag_ccbuild/abe:10.3
 * registry.docker.tests/softwareag_ccbuild/abe_managed:10.3 
 * softwareag_ccbuild/abe_builder:10.3
 
NOTE 1: The image "*_managed" contains the SPM components, and as such, will only be useful
if you plan/want to register this docker instance at runtime to a running Software AG Command Central

NOTE 2: If you just want a docker image with the needed component, then use the "non-managed" version...
as in "softwareag_ccbuild/abe:10.3" in this example.

NOTE 3: The image "softwareag_ccbuild/abe_builder" is really a temporary image and as such, could be deleted once you're satisfied with the final images.

### Create webMethods Deployer image

This follows the same concepts as the ABE images...
Condensed command below:

```
cd wm_deployer
docker-compose -f docker-compose-build.yml build
```

At the end, you should have 3 images in your local repository:
 * registry.docker.tests/softwareag_ccbuild/deployer:10.3
 * registry.docker.tests/softwareag_ccbuild/deployer_managed:10.3
 * softwareag_ccbuild/deployer_builder:10.3
 
### Create webMethods Test Suites image

Condensed command below:

```
cd wmTestsSuite
docker-compose -f docker-compose-build.yml build
```

At the end, you should have 3 images in your local repository:
 * registry.docker.tests/softwareag_ccbuild/wmtestsuite:10.3
 * registry.docker.tests/softwareag_ccbuild/wmtestsuite_managed:10.3
 * softwareag_ccbuild/wmtestsuite_builder:10.3
 
### Create webMethods Microservices Runtime image

NOTE: For the microservice runtime, it is available on docker store (at https://store.docker.com/images/softwareag-webmethods-microservicesruntime)
But we can also recreate that image using command central as well, using the same concepts.
A plausible reason to do that versus using the image from docker store directly 
would be to create a customized version of the microservicesruntime for your specific environment.

Condensed command below:

```
cd wm_msc
docker-compose -f docker-compose-build.yml build
```

At the end, you should have 3 images in your local repository:
 * registry.docker.tests/softwareag_ccbuild/webmethods-microservicesruntime:10.3
 * registry.docker.tests/softwareag_ccbuild/webmethods-microservicesruntime_managed:10.3
 * softwareag_ccbuild/webmethods-microservicesruntime_builder
 
### Create other images...

The library of builds in this project is not exhaustive by any means...
But should be a good base for building Docker images for any SoftwareAG product.

The main requirement will be to use accurate command central templates...
for which a very extensive library can be found at:

https://github.com/SoftwareAG/sagdevops-templates

## Optional Non-SoftwareAG Components for CI/CD

If you want to test things locally with CI/CD construct, I created 3 extra docker images:
 - docker registry (based on default docker registry V2... more at https://docs.docker.com/registry/)
 - git repository (based on GOGS -- https://gogs.io)
 - automated build server (jenkins -- https://jenkins.io)

### Start Docker Registry

If you want to test things out with a local registry, I created a simple docker-compose 
that will start a local "full-fledge" docker registry as well as a simple WEB-UI for that registry.

Follow instructions at [docker_registry](docker_registry/nginx/readme.md)

Then, start with:

```
$ cd docker_registry/nginx/
$ docker-compose up -d
```

Accessible at:
 * registry.docker.tests (eg. docker push registry.docker.tests/imagename:version)
 * https://registryweb.docker.tests

### Start Git Server

If you want to test things out with a local GIT repo, I've set up a simple GIT image based on GOGS (https://gogs.io)

```
$ cd gitserver
$ POSTGRES_USER=admin \
  POSTGRES_PASSWORD=<password> \
  docker-compose up -d
```

Accessible at http://localhost:10080/

### Start Jenkins

```
$ cd jenkins
$ docker-compose up -d
```

Accessible at http://localhost:8080/jenkins/