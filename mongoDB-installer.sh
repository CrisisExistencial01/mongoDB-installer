#!/bin/bash

# Install MongoDB on Ubuntu 22.04
# Author: Cris
#!/bin/bash

install_mongodb() {
    sudo apt update > /dev/null
    sudo apt install -y mongodb-org > /dev/null
    read -p "¿Deseas habilitar y arrancar el servicio de MongoDB? (y/n): " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        enable_mongodb
    else
        echo "No se ha habilitado el servicio de MongoDB"
    fi
}

enable_mongodb() {
    sudo systemctl start mongod
    sudo systemctl enable mongod
    sudo systemctl status mongod
}

setup_mongodb() {
    echo "Instalando los comandos necesarios para importar la clave pública de MongoDB"
    sudo apt-get install gnupg curl -y > /dev/null
    
    echo "Importando la clave pública de MongoDB"
    curl -fsSL https://www.mongodb.org/static/pgp/server-5.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-archive-keyring.gpg --dearmor
    
    echo "Creando el archivo de lista de repositorios de MongoDB en /etc/apt/sources.list.d/mongodb-org-5.0.list"
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list > /dev/null
    
    echo "Actualizando la lista de paquetes"
    sudo apt-get update > /dev/null
    
    echo "Instalando MongoDB"
    install_mongodb
}

run() {
    if [[ -x "$(command -v lsb_release)" ]]; then
        ubuntu_version=$(lsb_release -rs)
    else
        echo "Asegúrate de estar usando este script en un sistema Ubuntu"
        exit 1
    fi
    
    required_version="22.04"
    if [[ "$ubuntu_version" == "$required_version" ]]; then
        echo "Instalando MongoDB en Ubuntu 22.04"
        setup_mongodb
    else
        echo "Asegúrate de estar usando este script en un sistema Ubuntu con versión 22.04"
        exit 1
    fi
}

run

