FROM swagdevops/alpine_server:3.8.1

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=en_US.utf8 \
    GLIBC_VERSION=2.29-r0 \
    POSTGRES_DATAPATH=/var/lib/postgresql/data \
    POSTGRES_USERNAME=postgres \
    POSTGRES_PASSWORD='' \
    POSTGRES_DATABASE='postgres'

RUN apk add --no-cache \
    sudo libpq postgresql-client postgresql postgresql-contrib

# @see https://github.com/sgerrand/alpine-pkg-glibc
# @see https://github.com/gliderlabs/docker-alpine/issues/144
RUN apk add --no-cache ca-certificates wget && \
    wget https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
         -O /etc/apk/keys/sgerrand.rsa.pub
RUN export GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc && \
    export RELEASE_URL=${GLIBC_REPO}/releases/download/${GLIBC_VERSION} && \
    cd /tmp && \
    wget ${RELEASE_URL}/glibc-${GLIBC_VERSION}.apk && \
    wget ${RELEASE_URL}/glibc-bin-${GLIBC_VERSION}.apk && \
    wget ${RELEASE_URL}/glibc-i18n-${GLIBC_VERSION}.apk && \
    apk add glibc-*.apk && rm *.apk && sync

COPY /data /
RUN ls /usr/glibc-compat/bin/* | while read line; do \
       ln -sfr "$line" /usr/local/bin; \
    done && \
    chmod +x /usr/local/bin/locale-gen && \
    locale-gen

EXPOSE 5432
ENTRYPOINT ["/boot/run"]
CMD ["/sbin/runsvdir-start"]
