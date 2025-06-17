#!/bin/bash

# 📌 Configuración
SERVICIOS=("nginx" "mysql" "docker" "apache2")
ADMIN="aresden113@gmail.com"
ESTADO=""


for SERVICIO in "${SERVICIOS[@]}"; do
    if systemctl is-active --quiet $SERVICIO; then
        ESTADO+="✅ $SERVICIO está ACTIVO\n"
    else
        ESTADO+="❌ $SERVICIO está INACTIVO\n"
    fi
done


echo -e "$ESTADO"


if echo "$ESTADO" | grep -q "❌"; then
    echo -e "$ESTADO" | mail -s "⚠️ Alerta: Servicios Inactivos" $ADMIN
fi
