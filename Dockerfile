FROM acrisliu/jenkins-nodejs:latest
LABEL maintainer="groge <groge.choi@gmail.com>"
MAINTAINER groge "<groge.choi@gmail.com>"

# Switch to root user
USER root
RUN npm version && npm install -g node-gyp npm@latest

# Install Python & essential
RUN apk update
RUN apk add --no-cache python build-base libtool autoconf automake jq rsync

# Switch to jenkins user
USER jenkins
