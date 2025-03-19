#!/bin/sh
set -e

# Verificar la configuración de memoria (en lugar de intentar modificarla)
echo "Verificando configuración de vm.overcommit_memory"
OVERCOMMIT=$(cat /proc/sys/vm/overcommit_memory || echo "0")
if [ "$OVERCOMMIT" = "1" ]; then
  echo "vm.overcommit_memory ya está configurado correctamente (1)"
else
  echo "ADVERTENCIA: vm.overcommit_memory no está configurado a 1. Redis funciona mejor con este valor."
  echo "Se recomienda ejecutar 'sysctl -w vm.overcommit_memory=1' en el host."
fi

# Verificar Transparent Huge Pages
echo "Verificando Transparent Huge Pages"
if [ -f /sys/kernel/mm/transparent_hugepage/enabled ]; then
  THP=$(cat /sys/kernel/mm/transparent_hugepage/enabled)
  if echo "$THP" | grep -q "\[never\]"; then
    echo "Transparent Huge Pages ya está deshabilitado (never)"
  else
    echo "ADVERTENCIA: Transparent Huge Pages no está establecido en 'never'. Redis funciona mejor con THP deshabilitado."
    echo "Se recomienda ejecutar 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' en el host."
  fi
else
  echo "No se puede verificar el estado de Transparent Huge Pages, archivo no encontrado."
fi

# Mostrar información de la configuración
echo "Iniciando Redis con la siguiente configuración:"
echo "Argumentos: $@"

# Ejecutar Redis con los parámetros proporcionados
exec redis-server "$@"
