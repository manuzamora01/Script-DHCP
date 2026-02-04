#!/bin/bash

# --- VARIABLES ---
IMAGE_NAME="mi-dhcp-server"
CONTAINER_NAME="dhcp-container"
CONFIG_PATH="$(pwd)/config/dhcpd.conf"


mostrar_header() {
    clear
    echo "==================================================="
    echo "          GESTOR DE SERVICIO DHCP (BASH)           "
    echo "==================================================="
    echo "DATOS DE RED:"
    # Muestra IP y nombre de interfaz (filtra loopback)
    ip -4 -o addr show | grep -v "127.0.0.1" | awk '{print "Interfaz: " $2 " | IP: " $4}'
    echo "---------------------------------------------------"
    echo "ESTADO DEL SERVICIO (DOCKER):"
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo " [OK] El contenedor está CORRIENDO."
    elif [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
        echo " [STOP] El contenedor existe pero está DETENIDO."
    else
        echo " [NULL] El servicio NO está instalado/creado."
    fi
    echo "==================================================="
    echo ""
}

instalar_servicio() {
    echo "Selecciona método de instalación:"
    echo "1) Docker (Recomendado)"
    echo "2) Comandos (Nativo)"
    echo "3) Ansible (Simulado)"
    read -p "Opción: " method

    case $method in
        1)
            echo "Construyendo imagen Docker..."
            # Construimos desde el directorio padre (..) para ver la carpeta config
            docker build -t $IMAGE_NAME -f docker/Dockerfile .
            ;;
        2)
            echo "Instalando isc-dhcp-server en local..."
            sudo apt update && sudo apt install -y isc-dhcp-server
            ;;
        *)
            echo "Opción no implementada en este script aún."
            ;;
    esac
}

poner_marcha() {
    echo "Arrancando contenedor..."
    # --network host es vital para DHCP para que acceda a la red real
    docker run -d --name $CONTAINER_NAME --network host --privileged -v "$CONFIG_PATH":/etc/dhcp/dhcpd.conf $IMAGE_NAME
}

parar_servicio() {
    echo "Deteniendo servicio..."
    docker stop $CONTAINER_NAME
}

eliminar_servicio() {
    echo "Eliminando contenedor e imagen..."
    docker rm -f $CONTAINER_NAME
    docker rmi $IMAGE_NAME
}

consultar_logs() {
    echo "Mostrando últimos 20 logs..."
    docker logs --tail 20 $CONTAINER_NAME
}

editar_config() {
    echo "Abriendo configuración..."
    nano config/dhcpd.conf
    echo "AVISO: Debes reiniciar el servicio para aplicar cambios."
}

mostrar_ayuda() {
    echo "Uso por comandos: ./dhcp_manager.sh [OPCION]"
    echo "  -i, --install    Instalar servicio"
    echo "  -s, --start      Arrancar servicio"
    echo "  -x, --stop       Parar servicio"
    echo "  -r, --remove     Eliminar servicio"
    echo "  -l, --logs       Ver logs"
    echo "  -e, --edit       Editar configuración"
}

# --- LÓGICA PRINCIPAL ---

# Si hay argumentos, ejecutamos modo comando
if [ $# -gt 0 ]; then
    case "$1" in
        -i|--install) instalar_servicio ;;
        -s|--start)   poner_marcha ;;
        -x|--stop)    parar_servicio ;;
        -r|--remove)  eliminar_servicio ;;
        -l|--logs)    consultar_logs ;;
        -e|--edit)    editar_config ;;
        -h|--help)    mostrar_ayuda ;;
        *) echo "Opción desconocida. Usa -h para ayuda." ;;
    esac
    exit 0
fi

# Si no hay argumentos, mostramos menú interactivo
while true; do
    mostrar_header
    echo "MENÚ PRINCIPAL:"
    echo "1. Instalación del servicio (Build)"
    echo "2. Puesta en marcha (Run)"
    echo "3. Parada (Stop)"
    echo "4. Eliminación del servicio"
    echo "5. Consultar logs"
    echo "6. Editar configuración"
    echo "0. Salir"
    echo ""
    read -p "Elige una opción: " opcion

    case $opcion in
        1) instalar_servicio ;;
        2) poner_marcha ;;
        3) parar_servicio ;;
        4) eliminar_servicio ;;
        5) consultar_logs ;;
        6) editar_config ;;
        0) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción no válida";;
    esac
    read -p "Presiona Enter para continuar..."
done
