ARG PARENT_BUILDER
ARG PARENT_IMAGE

# MUST start with builder image to run provisioning using template.yaml
FROM $PARENT_BUILDER as builder

FROM $PARENT_IMAGE

MAINTAINER fabien.sanglier@softwareaggov.com

ENV SAG_HOME /opt/softwareag
ENV JAVA_HOME $SAG_HOME/jvm/jvm/
ENV JRE_HOME $SAG_HOME/jvm/jvm/jre/
ENV ANT_HOME $SAG_HOME/common/lib/ant
ENV INSTANCE_NAME default
ENV EXIT_AFTER_COMMAND true

# Set path to the main executable folder in the IS profile
ENV PATH=/bin:/usr/bin:$SAG_HOME/profiles/IS_$INSTANCE_NAME/bin:$JAVA_HOME/bin:$ANT_HOME/bin

COPY --from=builder $SAG_HOME/jvm/jvm/ $SAG_HOME/jvm/jvm/

COPY --from=builder $SAG_HOME/install/jars/ $SAG_HOME/install/jars/
COPY --from=builder $SAG_HOME/install/profile/ $SAG_HOME/install/profile/
COPY --from=builder $SAG_HOME/install/products/ $SAG_HOME/install/products/

COPY --from=builder $SAG_HOME/Licenses/sagosch $SAG_HOME/Licenses/sagosch

COPY --from=builder $SAG_HOME/common/bin/ $SAG_HOME/common/bin/
COPY --from=builder $SAG_HOME/common/conf/ $SAG_HOME/common/conf/
COPY --from=builder $SAG_HOME/common/db/ $SAG_HOME/common/db/
COPY --from=builder $SAG_HOME/common/lib/ $SAG_HOME/common/lib/
COPY --from=builder $SAG_HOME/common/runtime/ $SAG_HOME/common/runtime/

COPY --from=builder $SAG_HOME/WS-Stack/ $SAG_HOME/WS-Stack/

COPY --from=builder $SAG_HOME/IntegrationServer/bin/ $SAG_HOME/IntegrationServer/bin/
COPY --from=builder $SAG_HOME/IntegrationServer/lib/ $SAG_HOME/IntegrationServer/lib/
COPY --from=builder $SAG_HOME/IntegrationServer/updates/ $SAG_HOME/IntegrationServer/updates/
COPY --from=builder $SAG_HOME/IntegrationServer/.tc.dev.log4j.properties $SAG_HOME/IntegrationServer/.tc.dev.log4j.properties

# instances
COPY --from=builder $SAG_HOME/IntegrationServer/instances/ $SAG_HOME/IntegrationServer/instances/

# profile
COPY --from=builder $SAG_HOME/profiles/IS_${INSTANCE_NAME}/ $SAG_HOME/profiles/IS_${INSTANCE_NAME}/

# expose any ports from runtimes defined in the template.yaml
EXPOSE 5555 9999

#add entrypoint in the global bin
ADD *.sh /usr/bin

#create a workspace where we can do ci/cd ant deploys, and map it to a volume
RUN mkdir /workspace
VOLUME /workspace
WORKDIR /workspace

ENTRYPOINT ["entrypoint.sh"]
