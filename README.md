
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Container high throttle rate incident.
---

This incident type typically occurs when a container is being throttled, meaning it is being limited in the amount of resources it can use. This can happen due to various reasons such as exceeding resource limits, network connectivity issues, or other performance problems. This can cause an interruption in the normal functioning of the application or service running in the container. It requires immediate attention to identify and resolve the underlying cause of the throttling to ensure normal operation of the application or service.

### Parameters
```shell
export CONTAINER_NAME="PLACEHOLDER"

export CONTAINER_PORT="PLACEHOLDER"

export MAX_THROTTLE_RATE="PLACEHOLDER"

export IMAGE_NAME="PLACEHOLDER"

export ADDITIONAL_PARAMETERS="PLACEHOLDER"
```

## Debug

### 1. Check the CPU usage of the container instance
```shell
docker stats ${CONTAINER_NAME}
```

### 2. Check the logs of the container for any errors or exceptions
```shell
docker logs ${CONTAINER_NAME}
```

### 3. Check if the container is running out of memory
```shell
docker stats --format "table {{.Name}}\t{{.MemUsage}}" ${CONTAINER_NAME}
```

### 4. Check the network traffic and connections of the container
```shell
sudo netstat -tulpn | grep ${CONTAINER_PORT}
```

### 7. Check the running processes inside the container
```shell
docker exec -it ${CONTAINER_NAME} ps aux
```

### 6. Check the container's resource limits
```shell
docker inspect ${CONTAINER_NAME} | grep -i mem
```

### 8. Check the container's environment variables
```shell
docker exec -it ${CONTAINER_NAME} env
```

### 10. Check the container's uptime and resource usage history
```shell
docker stats ${CONTAINER_NAME}
```

### The container may be processing more requests than it can handle, leading to a high throttle rate.
```shell


#!/bin/bash



# Set the container name to ${CONTAINER_NAME}

container_name="${CONTAINER_NAME}"



# Get the current throttle rate for the container

throttle_rate=$(docker stats --no-stream $container_name | awk 'NR==2{print $3}' | cut -d'%' -f1)



# Set the maximum throttle rate to ${MAX_THROTTLE_RATE}

max_throttle_rate=${MAX_THROTTLE_RATE}



# Check if the throttle rate is above the maximum

if [ "$throttle_rate" -gt "$max_throttle_rate" ]; then

  echo "Warning: Container is being throttled at $throttle_rate%"

  echo "Checking logs for high request rate..."

  

  # Look for log entries indicating a high request rate

  if docker logs $container_name | grep "high request rate"; then

    echo "Found log entries indicating a high request rate."

    echo "Checking network traffic..."

    

    # Check if there is high network traffic to the container

    if netstat -an | grep ":80" | grep "ESTABLISHED" | wc -l | awk '{print $1}' | tr -d '\n' > 100; then

      echo "High network traffic detected."

      echo "Suggest reducing the number of requests to the container or scaling up resources."

    else

      echo "No high network traffic detected."

      echo "Suggest checking for performance issues in the application or service running inside the container."

    fi

  else

    echo "No log entries indicating a high request rate."

    echo "Suggest checking for performance issues in the application or service running inside the container."

  fi

else

  echo "Container is not being throttled."

fi


```

## Repair

### A Script to restart the docker container
```shell
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


```