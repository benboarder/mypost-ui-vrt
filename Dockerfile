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

ARG PHANTOMJS_VERSION=2.1.1
ARG CASPERJS_VERSION=1.1.4
ARG SLIMERJS_VERSION=0.10.3
ARG BACKSTOPJS_VERSION=2.6.14

# Installing dependencies from archives - not only this allows us to control versions,
# but the resulting image size is 130MB+ less (!) compared to an npm install (440MB vs 575MB).
RUN \
  mkdir -p /opt && \
  # PhantomJS
  echo "Downloading PhantomJS v${PHANTOMJS_VERSION}..." && \
  curl -sL "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2" | tar jx && \
  mv phantomjs-${PHANTOMJS_VERSION}-linux-x86_64 /opt/phantomjs && \
  ln -s /opt/phantomjs/bin/phantomjs /usr/bin/phantomjs

RUN \
  # CasperJS
  echo "Downloading CasperJS v${CASPERJS_VERSION}..." && \
  curl -sL "https://github.com/casperjs/casperjs/archive/${CASPERJS_VERSION}.tar.gz" | tar zx && \
  mv casperjs-${CASPERJS_VERSION} /opt/casperjs && \
  ln -s /opt/casperjs/bin/casperjs /usr/bin/casperjs

RUN \
  # SlimerJS
  echo "Downloading SlimerJS v${SLIMERJS_VERSION}..." && \
  curl -sL -O "http://download.slimerjs.org/releases/${SLIMERJS_VERSION}/slimerjs-${SLIMERJS_VERSION}.zip" && \
  unzip -q slimerjs-${SLIMERJS_VERSION}.zip && rm -f slimerjs-${SLIMERJS_VERSION}.zip && \
  mv slimerjs-${SLIMERJS_VERSION} /opt/slimerjs && \
  # Run slimer with xvfb
  echo '#!/usr/bin/env bash\nxvfb-run /opt/slimerjs/slimerjs "$@"' > /opt/slimerjs/slimerjs.sh && \
  chmod +x /opt/slimerjs/slimerjs.sh && \
  ln -s /opt/slimerjs/slimerjs.sh /usr/bin/slimerjs

# RUN \
  # BackstopJS
  # echo "Installing BackstopJS v${BACKSTOPJS_VERSION}..." && \
  # npm install -g backstopjs@${BACKSTOPJS_VERSION}


# RUN \
#   addgroup -g 10101 bamboo && \
#   adduser -S -s /bin/false -u 10101 -G bamboo -g "Bamboo Service User" bamboo && \
#   mkdir /src && \
#   chown -R bamboo:bamboo /src

WORKDIR /src

ENTRYPOINT ["backstop"]
