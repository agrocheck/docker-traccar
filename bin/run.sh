#!/usr/bin/env bash
set -euo pipefail

port=8080
version=3.15-3

# Expose other ports by adding -p {host_port}:{container_port} as needed
docker run -d -p "${port}":80 "agrocheck/traccar:${version}" java -jar tracker-server.jar traccar.xml

echo "Go to http://localhost:${port} and log in using the following credentials:"
echo "Username: admin"
echo "Password: admin"
