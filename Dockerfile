FROM redis:7.2-alpine

WORKDIR /redis

# Copiar archivos necesarios
COPY entrypoint.sh /entrypoint.sh
COPY redis.conf /usr/local/etc/redis/redis.conf

# Hacer ejecutable el entrypoint
RUN chmod +x /entrypoint.sh

# Establecer el entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Comando predeterminado
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]