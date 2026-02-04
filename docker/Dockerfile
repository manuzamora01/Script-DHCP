FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Actualizamos e instalamos el servidor DHCP
RUN apt-get update && \
    apt-get install -y isc-dhcp-server net-tools iproute2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
