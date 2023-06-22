#!/bin/bash

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean) | x(c+b)"
  exit 0
}
c() {
  echo "clean..."
  docker compose down -v --remove-orphans
  #rm -rf log
}
cc() {
  c
  echo "docker rm -f collector grafana prometheus jaeger loki"
  docker rm -f collector grafana prometheus jaeger loki > /dev/null 2>&1
  docker image prune -f
}
b() {
  echo "build..."
  mkdir -p log; chmod -R 777 log
  docker compose up -d
}
x() {
  c
  b
}

$cmd

sleep 2
docker ps
