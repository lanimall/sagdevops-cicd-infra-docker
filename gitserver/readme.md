# Git Server General Setup

Start with:

POSTGRES_USER=admin \
POSTGRES_PASSWORD=<password> \
docker-compose up -d

http://localhost:10080

OR in swarm:

POSTGRES_USER=admin \
POSTGRES_PASSWORD=<password> \
docker stack deploy --compose-file docker-compose-swarm.yml gitserver