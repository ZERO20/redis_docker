# Makefile para interactuar con Redis en Docker
# Basado en el archivo docker-compose.yml ubicado en el mismo directorio

# Variables
CONTAINER_NAME = redis-local
REDIS_PORT = 6379

# Colores para mejor visibilidad
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Ayuda
.PHONY: help
help:
	@echo "${YELLOW}=== Comandos disponibles para Redis Docker ===${NC}"
	@echo "${GREEN}make start${NC}        - Inicia el contenedor Redis"
	@echo "${GREEN}make stop${NC}         - Detiene el contenedor Redis"
	@echo "${GREEN}make restart${NC}      - Reinicia el contenedor Redis"
	@echo "${GREEN}make cli${NC}          - Abre Redis CLI interactivo"
	@echo "${GREEN}make ping${NC}         - Hace PING a Redis"
	@echo "${GREEN}make info${NC}         - Muestra información de Redis"
	@echo "${GREEN}make monitor${NC}      - Monitorea comandos en tiempo real"
	@echo "${GREEN}make logs${NC}         - Muestra logs del contenedor Redis"
	@echo "${GREEN}make status${NC}       - Muestra el estado del contenedor Redis"
	@echo "${GREEN}make setup-host${NC}   - Configura el host para optimizar Redis (requiere sudo)"
	@echo "${GREEN}make cmd CMD=\"comando\"${NC} - Ejecuta un comando específico de Redis"
	@echo "${GREEN}make stats${NC}        - Muestra las estadísticas del contenedor"
	@echo "${YELLOW}===============================================${NC}"

# Iniciar el contenedor
.PHONY: start
start:
	@echo "${GREEN}Iniciando Redis...${NC}"
	@docker-compose up -d
	@echo "${GREEN}Redis iniciado en el puerto ${REDIS_PORT}${NC}"

# Detener el contenedor
.PHONY: stop
stop:
	@echo "${RED}Deteniendo Redis...${NC}"
	@docker-compose down
	@echo "${RED}Redis detenido${NC}"

# Reiniciar el contenedor
.PHONY: restart
restart:
	@echo "${YELLOW}Reiniciando Redis...${NC}"
	@docker-compose restart
	@echo "${GREEN}Redis reiniciado${NC}"

# Abrir Redis CLI
.PHONY: cli
cli:
	@echo "${GREEN}Abriendo Redis CLI...${NC}"
	@docker exec -it $(CONTAINER_NAME) redis-cli

# Hacer PING a Redis
.PHONY: ping
ping:
	@echo "${YELLOW}Haciendo PING a Redis...${NC}"
	@docker exec -it $(CONTAINER_NAME) redis-cli PING

# Mostrar información de Redis
.PHONY: info
info:
	@echo "${GREEN}Información de Redis:${NC}"
	@docker exec -it $(CONTAINER_NAME) redis-cli INFO | grep -v "#"

# Monitorear comandos en tiempo real
.PHONY: monitor
monitor:
	@echo "${YELLOW}Monitoreando comandos Redis en tiempo real (Ctrl+C para salir)...${NC}"
	@docker exec -it $(CONTAINER_NAME) redis-cli MONITOR

# Mostrar logs del contenedor
.PHONY: logs
logs:
	@echo "${YELLOW}Mostrando logs de Redis...${NC}"
	@docker logs $(CONTAINER_NAME)

# Mostrar últimas 100 líneas de logs y seguir mostrando
.PHONY: logs-follow
logs-follow:
	@echo "${YELLOW}Siguiendo logs de Redis en tiempo real (Ctrl+C para salir)...${NC}"
	@docker logs -f --tail=100 $(CONTAINER_NAME)

# Mostrar el estado del contenedor
.PHONY: status
status:
	@echo "${GREEN}Estado de Redis:${NC}"
	@docker ps -a | grep $(CONTAINER_NAME)

# Ejecutar un comando específico de Redis
.PHONY: cmd
cmd:
	@echo "${GREEN}Ejecutando comando: ${CMD}${NC}"
	@docker exec -it $(CONTAINER_NAME) redis-cli $(CMD)

# Configurar el host para un rendimiento óptimo de Redis
.PHONY: setup-host
setup-host:
	@echo "${YELLOW}Configurando el host para un rendimiento óptimo de Redis...${NC}"
	@echo "${RED}NOTA: Este comando requiere permisos de sudo${NC}"
	@echo "Configurando vm.overcommit_memory=1"
	@sudo sysctl -w vm.overcommit_memory=1
	@echo "Añadiendo vm.overcommit_memory=1 a /etc/sysctl.conf"
	@grep -q "vm.overcommit_memory" /etc/sysctl.conf || echo "vm.overcommit_memory=1" | sudo tee -a /etc/sysctl.conf
	@echo "Deshabilitando THP"
	@echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
	@echo "${GREEN}Configuración del host completada${NC}"

# Mostrar estadísticas del contenedor
.PHONY: stats
stats:
	@echo "${YELLOW}Estadísticas del contenedor Redis:${NC}"
	@docker stats $(CONTAINER_NAME) --no-stream

# Por defecto, muestra la ayuda
.DEFAULT_GOAL := help 