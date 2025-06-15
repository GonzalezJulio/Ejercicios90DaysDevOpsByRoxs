#!/usr/bin/env bash

# Actualiza repositorios
apt update

# Instala Nginx, git y docker
apt install -y nginx git docker.io

# Limpia sitio por defecto
rm -rf /var/www/html/*

# Copia tu template desde la carpeta sincronizada
cp -R /home/vagrant/template/* /var/www/html/

# Personaliza index.html (si quieres agregar tu nombre y fecha)
sed -i "s/Solid State/VM DevOps de Julio González/" /var/www/html/index.html
echo "<!-- Fecha de despliegue: $(date) -->" >> /var/www/html/index.html

# Reinicia nginx
systemctl restart nginx
