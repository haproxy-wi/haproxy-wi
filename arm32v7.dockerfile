FROM debian:buster as debian

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz
RUN apt-get update && apt-get install curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components

