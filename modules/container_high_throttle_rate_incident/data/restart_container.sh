bash

#!/bin/bash



# Set the name of the container to restart

container_name=${CONTAINER_NAME}



# Stop the container

docker stop $container_name



# Remove the container

docker rm $container_name



# Pull the latest image

docker pull ${IMAGE_NAME}



# Start a new container with the same parameters as the old one

docker run --name $container_name ${ADDITIONAL_PARAMETERS} ${IMAGE_NAME}