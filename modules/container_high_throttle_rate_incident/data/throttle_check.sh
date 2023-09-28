

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