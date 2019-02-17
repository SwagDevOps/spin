FROM kamaze/alpine_server:0.0.1

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apk add --no-cache sudo darkhttpd \
    && setcap cap_net_bind_service=+ep /usr/bin/darkhttpd

COPY /data /

EXPOSE 80
ENTRYPOINT ["/boot/run"]
CMD ["/sbin/runsvdir-start"]
