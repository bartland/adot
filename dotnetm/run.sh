#!/bin/bash

#https://github.com/aws-observability/aws-otel-dotnet/tree/main/integration-test-app

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean) | x(c+b)"
  exit 0
}
c() {
  echo "clean..."
  docker compose down -v
}
cc() {
  c
  docker rm -f otel-n-test; docker image rm -f aspnetapp; docker image prune -f
}
b() {
  echo "build..."
  docker build -t aspnetapp .
  docker-compose up #--remove-orphans
}
x() {
  c
  b
}

$cmd

sleep 2
docker ps
