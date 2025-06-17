#!/bin/bash

LOG="logs_despliegue.txt"
iniciar_gunicorn() {
         echo "=== Iniciando Gunicorn ===" | tee -a $LOG
         pkill -f "gunicorn.*library_site" || true
         nohup venv/bin/gunicorn  -w 4 -b 127.0.0.1:8000 library_site:app >> $LOG 2>&1 &
  sleep 3 
}
configurar_nginx() {
  echo "=== Configurando Nginx ===" | tee -a ../$LOG

  # Crear archivo de configuración en la carpeta correcta
  sudo tee /etc/nginx/sites-available/booklibrary > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

  # Crear enlace simbólico en sites-enabled (si no existe)
  if [ ! -L /etc/nginx/sites-enabled/booklibrary ]; then
    sudo ln -s /etc/nginx/sites-available/booklibrary /etc/nginx/sites-enabled/
  fi

  # Verificar sintaxis
  sudo nginx -t

  # Reiniciar Nginx para aplicar cambios
  sudo systemctl restart nginx
}


verificar_servicios() {
  echo "=== Verificando servicios ===" | tee -a $LOG

  if systemctl is-active --quiet nginx; then
    echo "✓ Nginx está activo" | tee -a $LOG
  else
    echo "✗ Nginx no está activo" | tee -a $LOG
  fi

  if pgrep -f "gunicorn.*library_site" > /dev/null; then
    echo "✓ Gunicorn está corriendo" | tee -a $LOG
  else
    echo "✗ Gunicorn no está corriendo" | tee -a $LOG
  fi

  if curl -s http://127.0.0.1:8000 > /dev/null; then
    echo "✓ Gunicorn responde correctamente" | tee -a $LOG
  else
    echo "✗ Gunicorn no responde" | tee -a $LOG
  fi

  if curl -s http://127.0.0.1/ > /dev/null; then
    echo "✓ Nginx redirige correctamente a Gunicorn" | tee -a $LOG
  else
    echo "✗ Nginx no redirige correctamente" | tee -a $LOG
  fi
}
clonar_app() {
  echo "=== Clonando la aplicación ===" | tee -a $LOG
  if [ -d "devops-static-web/.git" ]; then
    echo "La carpeta ya existe, actualizando repositorio..." | tee -a $LOG
    cd devops-static-web
    git pull origin booklibrary >> $LOG 2>&1
  else
    git clone -b booklibrary https://github.com/roxsross/devops-static-web.git >> $LOG 2>&1
    cd devops-static-web
  fi
}

configurar_entorno() {
         echo "=== Configurando enterno virtual ===" | tee -a ../$LOG
         python3 -m venv venv
         source venv/bin/activate
         pip install -r requirements.txt >> ../$LOG 2>&1
         pip install gunicorn >> ../$LOG 2>&1
}
instalar_dependencias() {
         echo "=== Iniciando la Instalacion ===" | tee -a $LOG
         sudo apt update >> $LOG 2>&1
         sudo apt install -y python3 python3-pip python3-venv nginx git >> $LOG 2>&1
         sudo systemctl enable nginx >> $LOG 2>&1
}
main() {
         echo "=== Iniciando despliegue de Book Library ===" | tee $LOG
         instalar_dependencias
         clonar_app
         configurar_entorno
         iniciar_gunicorn
  configurar_nginx
  verificar_servicios
  echo "=== Despliegue finalizado ===" | tee -a $LOG
  echo "Visita: http://$(hostname -I | awk '{print $1}')" | tee -a $LOG

}

main