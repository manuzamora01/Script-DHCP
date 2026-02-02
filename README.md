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

## ⚙️ Requisitos Previos

* Sistema Operativo Linux (Probado en Ubuntu).
* Docker instalado y configurado.
* Permisos de ejecución para el script (`chmod +x scripts/dhcp_manager.sh`).

## 📖 Instrucciones de Uso

### 1. Configuración de Red (¡Importante!)
Antes de arrancar, edita el archivo `config/dhcpd.conf` para que coincida con tu subred local.
* **Ejemplo:** Si tu IP es `10.0.2.15`, tu subred en el archivo debe ser `10.0.2.0`.

### 2. Ejecución Interactiva (Menú)
Ejecuta el script sin argumentos para entrar al modo visual:

```bash
./scripts/dhcp_manager.sh

Desde aquí podrás ver tu IP actual, instalar la imagen, arrancar el contenedor y ver logs.

### 3. Ejecución por Comandos (CLI)
Puedes gestionar el servicio directamente sin entrar al menú:

| Acción | Comando |
| :--- | :--- |
| **Ayuda** | `./scripts/dhcp_manager.sh --help` |
| **Instalar/Build** | `./scripts/dhcp_manager.sh --install` |
| **Arrancar** | `./scripts/dhcp_manager.sh --start` |
| **Parar** | `./scripts/dhcp_manager.sh --stop` |
| **Ver Logs** | `./scripts/dhcp_manager.sh --logs` |
| **Editar Config** | `./scripts/dhcp_manager.sh --edit` |

## 🔧 Detalles Técnicos de Implementación

### Dockerización
Se ha utilizado una imagen base `ubuntu:22.04` optimizada para evitar interacciones durante la instalación (`DEBIAN_FRONTEND=noninteractive`). El contenedor monta el archivo de configuración en tiempo de ejecución (`-v`), lo que permite modificar las reglas del DHCP sin necesidad de regenerar la imagen Docker.

### Scripting (Bash)
El script `dhcp_manager.sh` utiliza estructuras de control `case` para gestionar los argumentos y un bucle `while` para el menú interactivo. Incluye comprobaciones de estado mediante `docker ps` para informar al usuario si el servicio está activo, detenido o no instalado.

---
**Autor:** Adrián Alonso Ridao, Iván Guerrero Antona y Manuel Zamora del Cerro
**Repositorio:** [https://github.com/manuzamora01/Script-DHCP]
