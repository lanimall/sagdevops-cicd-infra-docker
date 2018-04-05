# base Command Central server image
FROM store/softwareag/commandcentral:10.1.0.1-builder

ADD . /src
WORKDIR /src

ENV SAG_HOME=/opt/softwareag

# MODIFY THIS to make your env name
ENV CC_ENV=default
ENV REPO_USR=
ENV REPO_PWD=

# start tooling, apply template(s), cleanup
RUN sagccant startcc setup stopcc -Dbuild.dir=/tmp -Dinstall.dir=/opt/softwareag && \
    cd $SAG_HOME && rm -fr /tmp/* common/conf/nodeId.txt profiles/SPM/logs/* profiles/CCE/logs/* && \
    rm -fr /src/*
