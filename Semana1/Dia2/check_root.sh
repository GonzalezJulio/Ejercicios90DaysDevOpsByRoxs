#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "¡Error! Necesitas ser root."
    exit 1
fi



