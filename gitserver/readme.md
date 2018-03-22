Start with:

POSTGRES_USER=<your_db_user> \
POSTGRES_PASSWORD=<your_db_password> \
docker-compose up -d

http://localhost:10080

OR in swarm:

POSTGRES_USER=<your_db_user> \
POSTGRES_PASSWORD=<your_db_password> \
docker stack deploy --compose-file docker-compose-swarm.yml gitserver