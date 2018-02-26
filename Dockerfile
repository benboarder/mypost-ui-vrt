FROM benboarder/mypost-ui-base:latest

LABEL name="auspost-styles" \
      maintainer="MyPost <mypost@auspost.com.au>" \
      version="1.0" \
      description="VRT docker container for MyPost UI testing"

ENV TZ="/usr/share/zoneinfo/Australia/Melbourne"
ENV LANG C.UTF-8
ENV NPM_CONFIG_LOGLEVEL warn

USER root

RUN apt-get update \
    && apt-get install -y \
    bash \
    coreutils \
    curl \
    git \
    python \
    dbus \
    unzip \
    firefox-esr \
    fontconfig \
    ttf-freefont \
    chrpath \
    libssl-dev \
    libxft-dev \
    xvfb \
    libc6 \
    libstdc++6 \
    libgcc1 \
    libgtk2.0-0 \
    libasound2 \
    libxrender1 \
    libdbus-glib-1-2 \
    libfontconfig1 \
    libfontconfig1-dev \
    libfreetype6 \
    libfreetype6-dev

ADD display-chromium /usr/bin/display-chromium
ADD xvfb-chromium /usr/bin/xvfb-chromium
ADD xvfb-chromium-webgl /usr/bin/xvfb-chromium-webgl

ARG PHANTOMJS_VERSION=latest
ARG CASPERJS_VERSION=1.1.4
ARG SLIMERJS_VERSION=0.10.3
ARG BACKSTOPJS_VERSION=2.6.14
ARG PHANTOMCSS_VERSION=latest

ARG USER_HOME_DIR="/tmp"
ARG APP_DIR="/src"

ARG USER_ID=1000

ENV HOME "$USER_HOME_DIR"

RUN set -xe \
    && curl -sL https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 > /usr/bin/dumb-init \
    && chmod +x /usr/bin/dumb-init \
    && mkdir -p $USER_HOME_DIR \
    && chown $USER_ID $USER_HOME_DIR \
    && chmod a+rw $USER_HOME_DIR \
    && chown -R node /usr/local/lib /usr/local/include /usr/local/share /usr/local/bin \
    && (cd "$USER_HOME_DIR"; su node -c "npm i -g phantomjs-prebuilt@$PHANTOMJS_VERSION casperjs@$CASPERJS_VERSION slimerjs@$SLIMERJS_VERSION backstopjs@$BACKSTOPJS_VERSION phantomcss@$PHANTOMCSS_VERSION; npm cache clean --force")

# RUN \
#   addgroup -g 10101 bamboo && \
#   adduser -S -s /bin/false -u 10101 -G bamboo -g "Bamboo Service User" bamboo && \
#   mkdir /src && \
#   chown -R bamboo:bamboo /src

WORKDIR $APP_DIR
EXPOSE 4200

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

USER $USER_ID
