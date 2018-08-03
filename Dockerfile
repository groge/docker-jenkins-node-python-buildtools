FROM jenkins/jenkins:lts-alpine

LABEL maintainer="groge <groge.choi@gmail.com>"
MAINTAINER groge "<groge.choi@gmail.com>"

ENV NODE_VERSION 9.9.0

# Switch to root user
USER root

RUN apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        binutils-gold \
        g++ \
        gcc \
        libgcc \
        linux-headers \
        make \
        python \
        build-base \
        libtool \
        autoconf \
        automake \
        jq \
        rsync \
    && cd /tmp \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && apk del .build-deps \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz"

ENV YARN_VERSION 1.9.2
RUN curl -fSL -o /usr/local/bin/yarn "https://github.com/yarnpkg/yarn/releases/download/v$YARN_VERSION/yarn-$YARN_VERSION.js" \
    && chmod +x /usr/local/bin/yarn

RUN apk add --no-cache \
        python \
        build-base \
        libtool \
        autoconf \
        automake \
        jq \
        rsync \
    && npm version \
    && npm install -g node-gyp


# Switch to jenkins user
USER jenkins
