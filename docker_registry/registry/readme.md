# Registry General Setup
############################

## SSL Setup

1 - Generate your own certificate:

$ mkdir -p certs; cd certs 

$ openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout certs/registry.docker.tests.key \
  -x509 -days 365 -out certs/registry.docker.tests.crt
  
Be sure to use the target host name as a CN

2 - Trust the certs on all the docker nodes by copying the certs in the following locations:

$ sudo mkdir -p /etc/docker/certs.d/registry.docker.tests:5000
$ sudo cp certs/registry.docker.tests.crt /etc/docker/certs.d/registry.docker.tests:5000/ca.crt

Standalone Instructions:

3 - 

Swarm Instructions:

3 - On the SWARM manager, add the certs to the swarm secret

$ docker secret create registry.docker.tests.crt certs/registry.docker.tests.crt
$ docker secret create registry.docker.tests.key certs/registry.docker.tests.key

4 - use the secrets in compose file

5 - Start with:
docker stack deploy --compose-file docker-compose-swarm.yml dockerregistry

Stop with:
docker stack rm dockerregistry