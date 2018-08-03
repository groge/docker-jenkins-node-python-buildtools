FROM jenkins/jenkins:lts-alpine

LABEL maintainer="groge <groge.choi@gmail.com>"
MAINTAINER groge "<groge.choi@gmail.com>"

ENV NODE_VERSION 10.8.0

# Switch to root user
USER root
RUN apk add --no-cache \
        libstdc++ \
        python \
        build-base \ 
        libtool \
        autoconf \
        automake \
        jq \
        rsync \
    && apk add --no-cache --virtual .build-deps \
        binutils-gold \
        g++ \
        gcc \
        libgcc \
        linux-headers \
        make \
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

RUN npm version && npm install -g node-gyp 

# Switch to jenkins user
USER jenkins
