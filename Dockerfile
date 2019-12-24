FROM tomee:11-jre-8.0.0-M3-webprofile

ADD target/my-starter-project-*.war /usr/local/tomee/webapps/my-starter-project.war
