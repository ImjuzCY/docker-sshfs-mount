FROM alpine:3.8

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 TZ="Europe/Berlin" PUID=1000 PGID=1000 MOUNT_DIR=/sshfs

RUN \
  echo "**** install s6-overlay ****" && \
  apk add --no-cache curl && \
  curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz | tar xvzf - -C / && \
  apk del --no-cache curl && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    bash \
    tzdata && \
  echo "**** configure fuse ****" && \
  sed -ri 's/^#user_allow_other/user_allow_other/' /etc/fuse.conf && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/*

COPY root/ /
VOLUME ["/sshfs"]
CMD ["/init"]
