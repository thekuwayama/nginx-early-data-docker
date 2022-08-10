FROM thekuwayama/openssl:1.1.1q

ARG openssl_version="1.1.1q"
RUN apt-get update && apt-get install -y --no-install-recommends \
        libpcre3-dev

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
