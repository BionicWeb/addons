# FROM debian:stretch
ARG BUILD_FROM
FROM $BUILD_FROM

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    cmake \
    jq \
    mosquitto-clients \
    nano

ADD sources/ /opt/
ADD config/ /etc/inverter/

RUN cd /opt/inverter-cli && \
    mkdir bin && cmake . && make && mv inverter_poller bin/
WORKDIR /opt
ENTRYPOINT ["/bin/bash", "/opt/inverter-mqtt/entrypoint.sh"]