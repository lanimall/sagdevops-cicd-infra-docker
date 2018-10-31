ARG PARENT_BUILDER_IMAGE

FROM ${PARENT_BUILDER_IMAGE}

# this is just to store the work done by the builder because it takes some time...
# This image is not meant to be run as is...
# but rather extended to copy only the needed files

# build args
ARG REPO_PRODUCT_URL
ARG REPO_FIX_URL
ARG REPO_USERNAME
ARG REPO_PASSWORD
ARG LICENSES_URL

ENV REPO_PRODUCT_URL $REPO_PRODUCT_URL
ENV REPO_FIX_URL $REPO_FIX_URL
ENV REPO_USERNAME $REPO_USERNAME
ENV REPO_PASSWORD $REPO_PASSWORD
ENV LICENSES_URL $LICENSES_URL

##run provision on build
RUN $CC_HOME/provision.sh && $CC_HOME/cleanup.sh

ENTRYPOINT ["echo", "This image is not meant to be instantiated"]