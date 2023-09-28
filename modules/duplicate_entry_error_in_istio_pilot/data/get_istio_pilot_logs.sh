bash

#!/bin/bash



# Set variables

NAMESPACE=${NAMESPACE}

POD_NAME=${POD_NAME}

CONTAINER_NAME=${YOUR_CONTAINER_NAME}

LOG_FILE=${YOUR_LOG_FILE_PATH}



# Get logs from the Istio Pilot container

kubectl logs -n $NAMESPACE $POD_NAME -c $CONTAINER_NAME > $LOG_FILE 2>&1



# Check if the log file contains any configuration errors

if grep -q "configuration error" $LOG_FILE; then

  echo "Configuration error detected in Istio Pilot logs."

  echo "Please check the configuration settings for Istio Pilot."

else

  echo "No configuration errors detected in Istio Pilot logs."

fi