FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Actualizamos e instalamos el servidor DHCP
RUN apt-get update && \
    apt-get install -y isc-dhcp-server net-tools iproute2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copiamos la configuración. 
# NOTA: Asumimos que el build context es la raíz del proyecto
COPY config/dhcpd.conf /etc/dhcp/dhcpd.conf

# El archivo de leases es necesario para que arranque
RUN touch /var/lib/dhcp/dhcpd.leases

# Comando de arranque
CMD ["dhcpd", "-4", "-f", "-d", "--no-pid"]
