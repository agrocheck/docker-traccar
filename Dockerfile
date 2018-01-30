FROM openjdk:8-alpine

EXPOSE 80/tcp
EXPOSE 5000-5199/tcp
EXPOSE 5000-5199/udp

ENV CONFIG_USE_ENVIRONMENT_VARIABLES true
ENV LOGGER_FILE /dev/stdout
ENV WEB_PORT 80

WORKDIR /opt/traccar
COPY build .

CMD ["java", "-jar", "tracker-server.jar", "default.xml"]
