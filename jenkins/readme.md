# Jenkins Docker Setup

First, build the stack:
docker-compose -f docker-compose-swarm.yml build

Then push to registry:
docker-compose -f docker-compose-swarm.yml push

Then, start the stack
docker stack deploy --compose-file docker-compose-swarm.yml scmserver

If first install, you'll need to enter the built-in code for admin...read the logs

docker service logs <jenkins service ID>

It shoudl output something like...copy the long code into the UI

scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | *************************************************************
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | *************************************************************
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | *************************************************************
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | 
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | Jenkins initial setup is required. An admin user has been created and a password generated.
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | Please use the following password to proceed to installation:
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | 
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | eert23o487239847239874932874982379238423987
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | 
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | 
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | *************************************************************
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | *************************************************************
scmserver_jenkins.1.kckxch9mzbsb@ip-172-30-2-48.ec2.internal    | *************************************************************

URL:
http://jenkins.docker.tests/jenkins/

User: jenkinsadmin


Kill it all:
docker stack rm scmserver
