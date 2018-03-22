FROM jenkins/jenkins:lts

ARG HOST_DOCKER_VERSION
ARG HOST_DOCKER_COMPOSE_VERSION
ARG HOST_DOCKER_GID

# installing requirements as root for being able to run docker commands within this image
USER root

RUN groupadd -g ${HOST_DOCKER_GID} docker && \
apt-get update && \
apt-get -y install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
apt-get update && \
apt-get -y install docker-ce=$HOST_DOCKER_VERSION && \
usermod -aG docker jenkins

#install docker-compose too
RUN curl -L https://github.com/docker/compose/releases/download/$HOST_DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose && \
docker-compose --version

# then back to jenkins user before doing the rest
USER jenkins

# copy some configs
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
COPY log.properties /usr/share/jenkins/ref/log.properties

#install some plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt