# Despliegue Automatizado de Servicio DHCP con Docker 🐳

Este proyecto implementa un servidor DHCP completo utilizando **tecnología de contenedores (Docker)** sobre una imagen base de Ubuntu. Incluye un script de automatización avanzado en Bash que permite gestionar el ciclo de vida del servicio tanto mediante un **menú interactivo** como a través de **comandos directos (CLI)**.

## 📋 Descripción del Proyecto

El objetivo es facilitar el despliegue de un servicio de red crítico (DHCP) eliminando la complejidad de la instalación manual. El proyecto consta de:
1.  **Infraestructura como Código:** Un `Dockerfile` que genera una imagen personalizada con `isc-dhcp-server`.
2.  **Persistencia y Configuración:** Los archivos de configuración están desacoplados del contenedor, permitiendo editar la red sin reconstruir la imagen.
3.  **Automatización:** Un script `dhcp_manager.sh` que actúa como orquestador.

## 🚀 Funcionalidades

* **Menú Interactivo:** Interfaz visual en terminal para usuarios que prefieren guías paso a paso.
* **Modo CLI (Command Line Interface):** Soporte para argumentos (`--install`, `--start`, `--logs`) para integración con otros scripts o uso rápido.
* **Networking Real:** Uso del driver `network host` para que el contenedor sirva direcciones IP en la red física/virtual real, no solo en la red interna de Docker.
* **Gestión de Logs:** Visualización en tiempo real del estado del servicio.

## 🛠️ Estructura del Proyecto

```text
.
├── config/
│   └── dhcpd.conf       # Archivo de configuración del servidor DHCP (Editable)
├── docker/
│   └── Dockerfile       # Receta de construcción de la imagen Ubuntu + DHCP
├── logs/                # Directorio reservado para logs persistentes
├── scripts/
│   └── dhcp_manager.sh  # Script maestro de gestión y automatización
└── README.md            # Documentación del proyecto
