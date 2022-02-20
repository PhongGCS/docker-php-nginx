# Start server
docker-compose up -d

# Stop server
docker-compose up -d

# Stop all container 
docker stop $(docker ps -aq) 
