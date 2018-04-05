# MUST start with builder image to run provisioning using template.yaml
FROM store/softwareag/commandcentral:10.1.0.1-builder as builder

# ADOPTED from docker file created by running /opt/softwareag/IntegrationServer/docker/is_container.sh createDockerfile
FROM centos:7

ENV SAG_HOME=/opt/softwareag
ENV JAVA_HOME $SAG_HOME/jvm/jvm/
ENV JRE_HOME $SAG_HOME/jvm/jvm/jre/
ENV ANT_HOME $SAG_HOME/common/lib/ant
ENV EXIT_AFTER_COMMAND true

# Set path to the main executable folder in the IS profile
ENV PATH=/bin:/usr/bin:$JAVA_HOME/bin:$ANT_HOME/bin

#copy specific files (for now, all, but soon chose only the ones needed)
#COPY --from=builder $SAG_HOME $SAG_HOME

COPY --from=builder $SAG_HOME/jvm/jvm/ $SAG_HOME/jvm/jvm/
COPY --from=builder $SAG_HOME/install/jars/ $SAG_HOME/install/jars/
COPY --from=builder $SAG_HOME/install/profile/ $SAG_HOME/install/profile/
COPY --from=builder $SAG_HOME/install/products/ $SAG_HOME/install/products/
COPY --from=builder $SAG_HOME/Licenses/sagosch $SAG_HOME/Licenses/sagosch

COPY --from=builder $SAG_HOME/common/AssetBuildEnvironment/ $SAG_HOME/common/AssetBuildEnvironment/
COPY --from=builder $SAG_HOME/common/bin/ $SAG_HOME/common/bin/
COPY --from=builder $SAG_HOME/common/conf/ $SAG_HOME/common/conf/
COPY --from=builder $SAG_HOME/common/db/ $SAG_HOME/common/db/
COPY --from=builder $SAG_HOME/common/lib/ $SAG_HOME/common/lib/
COPY --from=builder $SAG_HOME/common/runtime/ $SAG_HOME/common/runtime/

COPY --from=builder $SAG_HOME/WS-Stack/ $SAG_HOME/WS-Stack/

COPY --from=builder $SAG_HOME/Designer/ $SAG_HOME/Designer/
COPY --from=builder $SAG_HOME/IntegrationServer/bin/ $SAG_HOME/IntegrationServer/bin/
COPY --from=builder $SAG_HOME/IntegrationServer/lib/ $SAG_HOME/IntegrationServer/lib/
COPY --from=builder $SAG_HOME/IntegrationServer/updates/ $SAG_HOME/IntegrationServer/updates/
COPY --from=builder $SAG_HOME/IntegrationServer/instances/ $SAG_HOME/IntegrationServer/instances/
COPY --from=builder $SAG_HOME/IntegrationServer/.tc.dev.log4j.properties $SAG_HOME/IntegrationServer/.tc.dev.log4j.properties

# copy license file in the right place
COPY licenseKey.xml $SAG_HOME/IntegrationServer/instances/$INSTANCE_NAME/config/licenseKey.xml

LABEL com.softwareag.product="wMTestSuites" \com.softwareag.product.version="10.1.0.0"

#add entrypoint in the global bin
COPY entrypoint.sh /usr/bin

#create a workspace to build code, and map it to a volume
RUN mkdir /workspace
VOLUME /workspace
WORKDIR /workspace

ENTRYPOINT ["entrypoint.sh"]