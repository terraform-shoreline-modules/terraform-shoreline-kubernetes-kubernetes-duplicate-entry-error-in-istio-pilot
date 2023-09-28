

#!/bin/bash



# Restart Istio Pilot service

kubectl rollout restart deployment/${ISTIO_PILOT_DEPLOYMENT_NAME}



# Wait for the service to restart

echo "Waiting for Istio Pilot service to restart..."

sleep 20



# Check if the service is running

if kubectl get pods -l app=${ISTIO_PILOT_APP_LABEL} | grep Running; then

    echo "Istio Pilot service restarted successfully!"

else

    echo "Failed to restart Istio Pilot service. Rolling back to previous version..."



    # Rollback to previous version

    kubectl rollout undo deployment/${ISTIO_PILOT_DEPLOYMENT_NAME}



    # Wait for the service to roll back

    echo "Waiting for Istio Pilot service to roll back..."

    sleep 20



    # Check if the service is running

    if kubectl get pods -l app=${ISTIO_PILOT_APP_LABEL} | grep Running; then

        echo "Istio Pilot service rolled back successfully!"

    else

        echo "Failed to roll back Istio Pilot service. Please investigate further."

    fi

fi