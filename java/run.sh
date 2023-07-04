#!/bin/bash

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean) | x(c+b)"
  exit 0
}
c() {
  echo "clean..."
  docker compose down -v --remove-orphans
  mvn clean
  rm -rf target
}
cc() {
  c
  rm -f aws-opentelemetry-agent.jar
  docker rm -f otel-j-app > /dev/null 2>&1
  docker image rm -f otel-j-app
}
otel-agent() {
  if [[ ! -e target/aws-opentelemetry-agent.jar ]]; then
    if [[ -e aws-opentelemetry-agent.jar ]]; then
      cp aws-opentelemetry-agent.jar target
    else
      #tag="v1.26.0"
      gh release download $tag -p aws-opentelemetry-agent.jar --repo aws-observability/aws-otel-java-instrumentation --dir target
      cp target/aws-opentelemetry-agent.jar .
    fi
  fi
  cp otel.properties target
}
i() {
    docker network inspect m2m > /dev/null 2>&1 || {
        echo docker network create m2m
        docker network create m2m
    }
}
b() {
  echo "build..."
  mvn package -Dmaven.test.skip=true
  otel-agent
  docker compose up -d
}
x() {
  c
  i
  b
}

$cmd

sleep 2
docker ps
echo
echo ../hello.sh j
