FROM openjdk:8-alpine

EXPOSE 80/tcp
EXPOSE 5000-5199/tcp
EXPOSE 5000-5199/udp

WORKDIR /opt/traccar
COPY build .

CMD ["java", "-jar", "tracker-server.jar", "traccar.xml"]
