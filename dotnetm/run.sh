#!/bin/bash

#https://github.com/aws-observability/aws-otel-dotnet/tree/main/integration-test-app

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean) | x(c+b)"
  exit 0
}
c() {
  echo "clean..."
  docker compose down -v --remove-orphans
}
cc() {
  c
  docker rm -f otel-n-test; docker image rm -f aspnetapp; docker image prune -f
}
i() {
    docker network inspect m2m > /dev/null 2>&1 || {
        echo docker network create m2m
        docker network create m2m
    }
}
b() {
  echo "build..."
  docker build -t aspnetapp .
  docker-compose up -d
}
x() {
  c
  i
  b
}

$cmd

sleep 2
docker ps
