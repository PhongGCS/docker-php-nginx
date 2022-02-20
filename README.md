# Start server
sudo ./prodject-up.sh

# Stop server
docker-compose stop

# Stop all container 
docker stop $(docker ps -aq) 
