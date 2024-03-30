#!/bin/bash

# Install MongoDB on Ubuntu 22.04
# Author: Cris
run(){
		if [[ -x "$(command -v lsb_release)"]]; then
		ubuntu_version=$(lsb_release -rs)
	else
		echo "Asegurate de estar usando este script en un sistema Ubuntu"
		exit 1
	fi
	requiered_version="22.04"
	if [[ $(echo "$ubuntu_version >= $requiered_version" | bc) -eq 1 ]]; then
		echo "Instalando MongoDB en Ubuntu 22.04"
		setup_mongodb
	else
		echo "Asegurate de estar usando este script en un sistema Ubuntu con version 22.04"
		exit 1
	fi

}
install_mongodb() {
	sudo apt update
	sudo apt install -y mongodb
	read -p "Deseas habilitar y arrancar el servicio de MongoDB? (y/n): " response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
		enable_mongodb
	else
		echo "No se ha habilitado el servicio de MongoDB"
	fi
}
enable_mongodb(){
	sudo systemctl start mongodb
	sudo systemctl enable mongodb
	sudo systemctl status mongodb
}
setup_mongodb(){
	echo "Instalando los comandos necesarios para importar la clave publica de MongoDB"
	sudo apt-get install gnupg curl
	
	echo "importando la clave publica de MongoDB"
	curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
	echo "Creando el archivo de lista de repositorios de MongoDB en /etc/apt/sources.list.d/mongodb-org-7.0.list"
	echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
	echo "Actualizando la lista de paquetes"
	sudo apt-get update
	echo "Instalando MongoDB"
	install_mongodb
}
run
