FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf \
        bison \
        build-essential \
        ca-certificates \
        curl \
        gzip \
        libreadline-dev \
        patch \
        pkg-config \
        sed \
        zlib1g-dev \
        libpcre3-dev


# openssl
ARG openssl_version="1.1.1c"

RUN mkdir -p /build/openssl
RUN curl -s https://www.openssl.org/source/openssl-${openssl_version}.tar.gz | tar -C /build/openssl -xzf - && \
        cd /build/openssl/openssl-${openssl_version} && \
        ./Configure \
        --prefix=/opt/openssl/openssl-${openssl_version} \
        enable-crypto-mdebug enable-crypto-mdebug-backtrace \
        linux-x86_64 && \
        make && make install_sw


# nginx
ARG nginx_version="1.15.12"

RUN mkdir -p /build/nginx

RUN curl -s https://nginx.org/download/nginx-${nginx_version}.tar.gz | tar -C /build/nginx -xzf - && \
        cd /build/nginx/nginx-${nginx_version} && \
        ./configure --with-openssl=/build/openssl/openssl-${openssl_version} \
        --with-http_ssl_module \
        --prefix=/opt/nginx/nginx-${nginx_version} && \
        make && make install

ENV PATH /opt/nginx/nginx-${nginx_version}/sbin:$PATH

COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /var/www/html/ && echo 'OK' > /var/www/html/index.html
EXPOSE 4433

STOPSIGNAL SIGTERM
