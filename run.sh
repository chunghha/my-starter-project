#!/usr/bin/env bash

mvn clean package -Pproduction

docker-compose up --build -d vaadin