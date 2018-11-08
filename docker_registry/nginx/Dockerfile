FROM nginx:alpine

# nginx conf files
COPY nginx.conf /etc/nginx/
COPY conf/ /etc/nginx/

# copy the sites conf
COPY sites/ /etc/nginx/sites-enabled/

####### if copying these in the image, make sure to comment the volume mounts in the docker-compose file
# Copy the password file for basic auth
#COPY registry.passwd /etc/nginx/registry.passwd

# Copy the certs for ssl
#COPY ssl/certs /etc/ssl/certs
#COPY ssl/private /etc/ssl/private