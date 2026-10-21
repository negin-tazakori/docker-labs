#!/bin/bash

REGISTRY="localhost:5000"

IMAGES=("nginx" "alpine" "mariadb")

for img in "${IMAGES[@]}"; do
    docker pull "$img:latest"
    docker tag "$img:latest" "$REGISTRY/$img:latest"
    docker push "$REGISTRY/$img:latest"
done

echo "Pushed ${IMAGES[*]} to $REGISTRY."
