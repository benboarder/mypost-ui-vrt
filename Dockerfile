FROM benboarder/mypost-ui-base:latest

LABEL name="auspost-styles" \
      maintainer="MyPost <mypost@auspost.com.au>" \
      version="1.0" \
      description="VRT docker container for MyPost UI testing"

ENV TZ="/usr/share/zoneinfo/Australia/Melbourne"
ENV LANG C.UTF-8
ENV NPM_CONFIG_LOGLEVEL warn
ENV NPM_CONFIG_UNSAFE_PERM=true

ARG PHANTOMJS_VERSION=2.1.7
ARG CASPERJS_VERSION=1.1.4
ARG SLIMERJS_VERSION=0.10.3
ARG BACKSTOPJS_VERSION=2.6.14
ARG PHANTOMCSS_VERSION=latest

ARG USER_HOME_DIR="/tmp"
ARG APP_DIR="/src"

RUN apt-get update && \
  apt-get install -y git sudo software-properties-common python-software-properties


# ADD display-chromium /usr/bin/display-chromium
# ADD xvfb-chromium /usr/bin/xvfb-chromium
# ADD xvfb-chromium-webgl /usr/bin/xvfb-chromium-webgl

RUN sudo npm install -g --unsafe-perm=true --allow-root phantomjs@${PHANTOMJS_VERSION}
RUN sudo npm install -g --unsafe-perm=true --allow-root casperjs@${CASPERJS_VERSION}
RUN sudo npm install -g --unsafe-perm=true --allow-root slimerjs@${SLIMERJS_VERSION}
RUN sudo npm install -g --unsafe-perm=true --allow-root backstopjs@${BACKSTOPJS_VERSION}

RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub && sudo apt-key add linux_signing_key.pub
RUN sudo add-apt-repository "deb http://dl.google.com/linux/chrome/deb/ stable main"

RUN apt-get -y update \
  && apt-get -y install google-chrome-stable

RUN apt-get install -y firefox-esr

WORKDIR $APP_DIR

ENTRYPOINT ["backstop"]
