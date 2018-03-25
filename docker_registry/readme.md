# Registry General Setup
############################

In this setup, we're going to use NGINX as the point-of-entry proxy for both the docker registry and registry front-end app.
And as such, SSL termination will be achieved by NGINX.

## Nginx Self-Signed SSL setup

The following commands assume:
 * you are in this folder (so that the certs end up in the right path)
 * The registry URL will be "registry.docker.tests" (important because using vhost in nginx config)
 * The registry frontend URL will be "registryweb.docker.tests" (important because using vhost in nginx config)

To changing these URLs, you'll need to:
 * Update the "server_name" entries in the NGINX site configs (at nginx/sites), 
 * Update the certs CN and possibly certs name (although that's optional)
 * Update the path related to the host names (like for trusting the certificates on linux)
 
1. Generate the self signed certs:

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx/ssl/private/registry.docker.tests.key -out nginx/ssl/certs/registry.docker.tests.crt
```

For the "common name (CN)", pick the right domain name: "registry.docker.tests"

2. Create strong Diffie-Hellman group

While we are using OpenSSL, we should also create a strong Diffie-Hellman group, which is used in negotiating Perfect Forward Secrecy with clients. 
We can do this by typing:

```
openssl dhparam -out nginx/ssl/certs/dhparam.pem 2048
```

This will take a few minutes, but when it's done you will have a strong DH group at nginx/etc/ssl/certs/dhparam.pem that we will use in our configuration.

3. Build the image using docker-compose

  1. Embedding the certs in the docker image
  
    The above should have added the certs in the right place for the DockerFile to copy them in the resulting NGINX docker image.
    Simply run the following to build the custom NGINX image with the certs and everythign else needed to proxy the registry / regiustry-frontend

```
docker-compose build
```

  2. Using volumes to provide the certs to the docker container
   
    Alternatitevy, if you prefer not to copy these certs, you can map each of them using docker volumes, as shown in the docker-compose extract below:

```
    volumes:
      - /some/local/path/registry.docker.tests.key:/etc/ssl/private/registry.docker.tests.key
      - /some/local/path/registry.docker.tests.crt:/etc/ssl/certs/registry.docker.tests.crt
      - /some/local/path/dhparam.pem:/etc/ssl/certs/dhparam.pem
```

4. Start/Stop all the services

Start:

```
docker-compose up -d
```

Stop and destroy:

```
docker-compose down
```

4. Force docker clients to trust these self-signed certs

Since these certs are self-signed, we'll need some extra setup (essentially forcing docker to trust them) on all the docker clients that will need access this registry.

  1. Steps for Linux:

  * Stop the docker daemon.
  
  * Copy the public cert to the right place, as follow:

```bash
$ sudo mkdir -p /etc/docker/certs.d/registry.docker.tests:443
$ sudo cp /some/local/path/registry.docker.tests.crt /etc/docker/certs.d/registry.docker.tests:443/ca.crt
```

  * Restart docker daemon.

  2. Steps for Mac:

    * Stop the docker daemon.

    * Create a file in "~/.docker/daemon.json" and add the insecure-registries as follow:
    
```
{
  "debug" : true,
  "insecure-registries" : [
    "registryweb.docker.tests:443"
  ],
  "experimental" : false
}
```

    * Restart docker daemon.

  3. Steps for Windows:
  
  TBD


## Check that it all works

Push a docker images in the registry (eg. push the busybox image

```
docker pull busybox:latest
docker tag busybox:latest registry.docker.tests/busybox:latest
docker push registry.docker.tests/busybox:latest
```

You now should have the busybox in the registry.

To check, simply access the registry front end https://registryweb.docker.tests and see if the busybox image is there:

You can also try to pull it back to your local by first removing the busybox image on your local, and then pulling from the registry.

Remove the busybox image:

```
docker rmi registry.docker.tests/busybox:latest
```

Pull it fro mthe regsitry again:
```
docker pull registry.docker.tests/busybox:latest
```

## Extra instruction for Swarm and Swarm Secrets

Instead of copying the certs in the docker image, we could use the "swarm secret" mechanism, as follow

1. On the SWARM manager, add the certs to the swarm secret

```
$ docker secret create registry.docker.tests.crt /some/path/registry.docker.tests.crt
$ docker secret create registry.docker.tests.key /some/path/registry.docker.tests.key
$ docker secret create dhparam.pem /some/path/dhparam.pem
```

2. Use the secrets paths in nginx

Simply replace the certs path in the nginx ssl.conf file with the "secrets" one, as follows:
 * /run/secrets/registry.docker.tests.crt
 * /run/secrets/registry.docker.tests.key
 * /run/secrets/dhparam.pem

3. Start with

docker stack deploy --compose-file docker-compose-swarm.yml dockerregistry

4. Stop with

docker stack rm dockerregistry