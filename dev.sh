#!/bin/bash

set -e  # exit on error

# Paths to each compose file
GATEWAY="gateway.docker-compose.yml"
FRONTEND="advancing-film-frontend.docker-compose.yml"
API="advancing-film-api.docker-compose.yml"

# Shared Docker network
NETWORK="traefik-net"

# Create the network if it doesn't exist
create_network() {
  if ! docker network inspect $NETWORK > /dev/null 2>&1; then
    echo "🔧 Creating network: $NETWORK"
    docker network create $NETWORK
  fi
}

# Compose up
compose_up() {
  echo "🚀 Starting all services..."
  docker compose -f $GATEWAY -f $FRONTEND -f $API up -d
}

# Compose down
compose_down() {
  echo "🧹 Stopping and removing all services..."
  docker compose -f $GATEWAY -f $FRONTEND -f $API down
}

# Show logs
compose_logs() {
  docker compose -f $GATEWAY -f $FRONTEND -f $API logs -f
}

# Rebuild images
compose_rebuild() {
  echo "♻️ Rebuilding Docker images..."
  docker build -t advancing-film-frontend ./advancing-film-frontend
  docker build -t advancing-film-api ./advancing-film-api
}

# Main logic
case "$1" in
  down)
    compose_down
    ;;
  logs)
    compose_logs
    ;;
#  rebuild)
#    compose_rebuild
#    compose_up
#    ;;
  up)
    create_network
    compose_up
    ;;
esac
