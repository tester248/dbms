#!/bin/bash

# ===============================
# Oracle XE 21c Docker Runner
# ===============================

ORACLE_PASSWORD="Mmcoe123!"
CONTAINER_NAME="oracle-xe"
IMAGE_NAME="gvenzl/oracle-xe:21-slim"

# Function to check container status
check_container() {
    docker ps -a --filter "name=^/${CONTAINER_NAME}$" --format "{{.Status}}"
}

# Handle reset option
if [ "$1" == "reset" ]; then
    echo "Reset option selected. Removing existing container and data..."
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
    rm -rf $DATA_DIR
    mkdir -p $DATA_DIR

    echo "Pulling latest Oracle XE image..."
    docker pull $IMAGE_NAME

    echo "Creating a fresh Oracle XE container..."
    docker run -d --name $CONTAINER_NAME \
      -p 1521:1521 -p 5500:5500 \
      -e ORACLE_PASSWORD=$ORACLE_PASSWORD \
      $IMAGE_NAME

    echo "Oracle XE container has been reset and started fresh."
    docker ps --filter "name=$CONTAINER_NAME"
    exit 0
fi

# Normal run logic
STATUS=$(check_container)

if [ -z "$STATUS" ]; then
    echo "No existing container found. Pulling image and creating a new container..."
    docker pull $IMAGE_NAME
    docker run -d --name $CONTAINER_NAME \
      -p 1521:1521 -p 5500:5500 \
      -e ORACLE_PASSWORD=$ORACLE_PASSWORD \
      $IMAGE_NAME
    echo "Oracle XE container created and started."
elif [[ "$STATUS" == *"Up"* ]]; then
    echo "Container '$CONTAINER_NAME' is already running."
elif [[ "$STATUS" == *"Exited"* ]] || [[ "$STATUS" == *"Created"* ]]; then
    echo "Container '$CONTAINER_NAME' exists but is stopped. Starting it..."
    docker start $CONTAINER_NAME
    echo "Container '$CONTAINER_NAME' started."
else
    echo "Container '$CONTAINER_NAME' exists with status: $STATUS"
    echo "Please check logs: docker logs $CONTAINER_NAME"
fi

# Show container status
docker ps --filter "name=$CONTAINER_NAME"