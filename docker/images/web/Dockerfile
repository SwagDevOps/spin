FROM swagdevops/alpine_server:3.8.1

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    BUNDLE_APP_CONFIG=/usr/lib/bundle/ \
    BUNDLE_PATH=/usr/lib/bundle/vendor/ \
    BUNDLE_CACHE_PATH=/usr/lib/bundle/cache \
    BUNDLE_GLOBAL_GEM_CACHE=true \
    BUNDLE_CONSOLE=pry \
    BUNDLE_DISABLE_VERSION_CHECK=true \
    BUNDLE_SILENCE_ROOT_WARNING=true \
    BUNDLE_IGNORE_CONFIG=true

RUN gem install bundler \
    && apk add --no-cache sudo \
       build-base ruby-dev \
       alpine-sdk libc6-compat \
       g++ make libcurl openssl-dev sqlite-dev cmake \
       libatomic linux-headers \
    && mkdir -p "${BUNDLE_CACHE_PATH}" \
    && setcap cap_net_bind_service=+ep /usr/bin/ruby

COPY /data /

EXPOSE 80
ENTRYPOINT ["/boot/run"]
CMD ["/sbin/runsvdir-start"]
