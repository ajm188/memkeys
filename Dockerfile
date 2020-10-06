ARG distro=bionic
FROM ubuntu:${distro}

LABEL maintainer="Andrew Mason <amason@slack-corp.com>, Regrets <null@void>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y git \
                       build-essential \
                       libpcap-dev \
                       libpcre3-dev \
                       libncurses5-dev \
                       autoconf \
                       libtool \
                       ruby \
                       ruby-dev \
                       rubygems && \
    gem install --no-ri --no-rdoc fpm


ADD . /memkeys

RUN cd /memkeys && \
    ./build-eng/autogen.sh && \
    ./configure --disable-shared \
                --enable-static && \
    make
RUN cd /memkeys/src/ && \
    fpm \
        -s dir \
        -t deb \
        -a "x86_64" \
        --depends libncurses5-dev \
        --depends libpcap-dev \
        --depends libpcre3-dev \
        --deb-no-default-config-files \
        -n memkeys \
        --description "Show your memcache key usage in realtime." \
        --url "https://github.com/ajm188/memkeys" \
        -m "Andrew Mason <amason@slack-corp.com>" \
        -f \
        -v 0.2-1-2 \
        --prefix /usr/local/bin \
        memkeys
