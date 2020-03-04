FROM maven:3.6-jdk-11 as builder

ENV NVM_VERSION v0.35.2
ENV NODE_VERSION v12.16.1
ENV PROJECT_NAME my-starter-project

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get install -y build-essential curl

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

RUN source ~/.nvm/nvm.sh; \
    nvm install $NODE_VERSION; \
    nvm use $NODE_VERSION;

WORKDIR /$PROJECT_NAME
COPY $PROJECT_NAME.iml .
COPY webpack.config.js .
COPY package.json .
COPY pom.xml .
COPY frontend/ ./frontend/
COPY src/ ./src/

RUN mvn clean
RUN mvn com.github.eirslett:frontend-maven-plugin:1.9.1:install-node-and-npm -DnodeVersion=$NODE_VERSION 
RUN mvn package -Pproduction


FROM tomee:11-jre-8.0.1-webprofile

ENV PROJECT_NAME my-starter-project

WORKDIR /usr/local/tomee
# ADD tomee/tomee.xml ./conf/
ADD tomee/tomcat-users.xml ./conf/
ADD tomee/settings.xml ./conf/

COPY --chown=root:root --from=builder \
  /$PROJECT_NAME/target/$PROJECT_NAME-*.war ./webapps/$PROJECT_NAME.war
