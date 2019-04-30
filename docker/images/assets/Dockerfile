FROM swagdevops/alpine_server:3.8.1

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apk add --no-cache lighttpd && \
    gem install mime-types && \
    rm -rf /etc/lighttpd

COPY /data /

EXPOSE 80
ENTRYPOINT ["/boot/run"]
CMD ["/sbin/runsvdir-start"]
