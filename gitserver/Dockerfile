FROM gogs/gogs:latest

ARG GOGS_CUSTOM_DIR
RUN mkdir -p $GOGS_CUSTOM_DIR/conf/
COPY app.ini $GOGS_CUSTOM_DIR/conf/app.ini