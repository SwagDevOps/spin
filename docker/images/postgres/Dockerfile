FROM kamaze/alpine_server:0.0.1

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=en_US.utf8 \
    POSTGRES_DATAPATH=/var/lib/postgresql/data \
    POSTGRES_USERNAME=postgres \
    POSTGRES_PASSWORD='' \
    POSTGRES_DATABASE='postgres'

RUN apk add --no-cache \
    sudo libpq postgresql-client postgresql postgresql-contrib

COPY /data /

EXPOSE 5432
ENTRYPOINT ["/boot/run"]
CMD ["/sbin/runsvdir-start"]
