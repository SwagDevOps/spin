FROM kamaze/alpine_server:0.0.1

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    BUNDLE_APP_CONFIG=/usr/lib/bundle

RUN gem install bundler \
    && apk add --no-cache sudo \
       build-base ruby-dev \
       alpine-sdk libc6-compat \
       g++ make libcurl openssl-dev sqlite-dev cmake \
    && setcap cap_net_bind_service=+ep /usr/bin/ruby

COPY /data /

EXPOSE 80
ENTRYPOINT ["/boot/run"]
CMD ["/sbin/runsvdir-start"]
