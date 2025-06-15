#!/bin/bash

# Mostrar mensajes en consola
echo "[INFO] Iniciando instalación de Nginx..."

# Actualizar lista de paquetes
sudo apt update -y

# Instalar Nginx
sudo apt install -y nginx

# Habilitar y arrancar el servicio
sudo systemctl enable nginx
sudo systemctl start nginx

# Crear archivo index.html personalizado
echo "<h1>Hola, soy Julio - $(date)</h1>" | sudo tee /var/www/html/index.html

# Confirmar estado del servicio
sudo systemctl status nginx --no-pager

echo "[INFO] Nginx instalado y funcionando en http://192.168.33.10"
