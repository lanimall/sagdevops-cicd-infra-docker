# DB Creator for SoftwareAG products

A project to automatically add the right DB schemas / objects etc... for any products

## Requirements

### Docker Available
Before you start ensure you have installed [Docker](https://www.docker.com/products/overview)
including docker-compose tool.

### Get Command Central image from Docker Store
Also, the project relies on the Command Central image that can be found on Docker Store.
Refer to https://store.docker.com/images/softwareag-commandcentral

Once you login to docker, you should pull the Command Central image locally.

If not logged in yet:

```bash
docker login
```

Then, pull the image as follow:

```bash
docker pull store/softwareag/commandcentral:10.1.0.1-server
```

Image should not be in your local reporisotry. Verify:

```bash
docker images
```

### Create the base Oracle image for SoftwareAG products

Simply build the base image "softwareag/base-oracle-xe-11g:latest" by running:

```bash
docker-compose -f docker-compose-baseoracle.yml build
Building db
Step 1/2 : FROM wnameless/oracle-xe-11g
 ---> f794779ccdb9
Step 2/2 : ADD init.sql /docker-entrypoint-initdb.d/
 ---> Using cache
 ---> f1a2053eed31
Successfully built f1a2053eed31
Successfully tagged softwareag/base-oracle-xe-11g:latest
```

## Creating the Database for a SoftwareAG product

### Creation

To create a database with all the DB objects required by the SoftwareAG products, 
simply use the rigtht docker-compose file in following commands:

For BPMS (IS/BPMS/MWS):

```bash
docker-compose -f docker-compose-bpms.yml  run --rm dbsetup
```

For IS:

```bash
docker-compose -f docker-compose-is.yml  run --rm dbsetup
```

### Verifications (using BPMS configuration)

Run:

```bash
docker-compose -f docker-compose-bpms.yml  run --rm dbsetup
```

After few minutes, the script should be succesfull, and the running oracle instance should have the required DB object loaded.

Verify running DB instance:

```bash
docker ps
```

CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                                      NAMES
ceedc56c1354        softwareag/oracle-xe-11g   "/bin/sh -c '/usr/sb…"   About an hour ago   Up 8 minutes        8080/tcp, 0.0.0.0:49160->22/tcp, 0.0.0.0:49161->1521/tcp   wmdbcreator_wMBPMS_db_1

Verify the DB instance:

Login to the running DB instance and use sqlplus as usual:

```bash
docker exec -it ceedc56c1354 /bin/bash
root@ceedc56c1354:/# sqlplus /nolog

SQL*Plus: Release 11.2.0.2.0 Production on Thu Apr 5 15:41:05 2018

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

SQL> connect webmbpms/strong123!
Connected.
SQL> select tablespace_name, table_name from user_tables;
TABLESPACE_NAME 	       TABLE_NAME
------------------------------ ------------------------------
WEBMDATA		       COMPONENT_EVENT
WEBMDATA		       AGW_EVENT_TXN
WEBMDATA		       AGW_EVENT_METRICS
WEBMDATA		       AGW_EVENT_LC
WEBMDATA		       AGW_EVENT_ERR
WEBMDATA		       AGW_EVENT_PV
WEBMDATA		       AGW_EVENT_MON
WEBMDATA		       AGW_EVENT_EG
etc...
etc...
etc...
```