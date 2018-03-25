FROM nginx:alpine

ARG baselocaldir

# nginx conf files
COPY $baselocaldir/nginx.conf /etc/nginx/
COPY $baselocaldir/conf/ /etc/nginx/

# copy the sites conf
COPY $baselocaldir/sites/ /etc/nginx/sites-enabled/

# Copy the password file for basic auth
COPY $baselocaldir/registry.passwd /etc/nginx/registry.passwd

# Copy the certs for ssl
COPY $baselocaldir/ssl/certs /etc/ssl/certs
COPY $baselocaldir/ssl/private /etc/ssl/private