
# docker build -t misaelgomes/nginx-openresty .
# docker run -d -p 3142:3142 misaelgomes/eg_apt_cacher_ng
# acessar localhost:3142 copiar proxy correto e colar abaixo em Acquire
# docker run -d -p 80:80 misaelgomes/tengine-php74

FROM openresty/openresty:1.25.3.2-0-jammy

WORKDIR /var/www/html


RUN addgroup --system --gid 101 nginx
RUN adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

RUN apt-get update
RUN apt-get install -y tzdata apt-utils locales
RUN apt-get install -y nginx-common libmaxminddb0 libmaxminddb-dev mmdb-bin nano gcc flex make bison build-essential pkg-config g++ libtool autoconf git 
RUN apt-get install -y libcurl4-openssl-dev libatomic-ops-dev libjemalloc-dev libxml2-dev          
RUN apt-get install -y zlib1g curl ca-certificates openssl libxslt-dev libc-dev unzip libgeoip-dev zlib1g-dev         
RUN apt-get install -y automake autotools-dev libjemalloc2 libssl-dev webp libgd-dev
RUN apt-get install -y libpcre3 libpcre3-dev
RUN apt-get install -y libperl-dev
RUN apt-get upgrade -y --fix-missing

ENV NGINX_CONFIG "\
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --with-libatomic \
    --with-pcre-jit \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=www-data \
    --group=www-data\
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-http_xslt_module \
    --with-compat \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_realip_module \
    --with-http_slice_module \
    --with-file-aio \
    --with-http_v2_module \ 
    --with-stream_ssl_preread_module \
    --with-ld-opt='-ljemalloc' \
    --with-http_perl_module \
    --with-http_image_filter_module \
    --add-module=./packages/naxsi/naxsi_src \
    --add-module=./packages/ngx_brotli  \
    --add-module=./packages/ngx_http_geoip2_module"

COPY ./openresty-1.25.3.2.zip /tmp
RUN unzip /tmp/openresty-1.25.3.2.zip -d /tmp

RUN cd /tmp/openresty-1.25.3.2 && ./configure $NGINX_CONFIG
RUN cd /tmp/openresty-1.25.3.2 && make && make install

RUN echo "America/Sao_Paulo" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
RUN apt-get install ntp -y --fix-missing
RUN echo 'server 0.centos.pool.ntp.org' >> /etc/ntp.conf
RUN echo 'server 1.centos.pool.ntp.org' >> /etc/ntp.conf
RUN echo 'server 2.centos.pool.ntp.org' >> /etc/ntp.conf

RUN apt-get remove -y gcc flex make bison build-essential pkg-config
RUN apt-get remove -y g++ libtool automake autoconf software-properties-common
RUN apt-get remove -y git automake autotools-dev
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
        
RUN rm -fr /tmp/*

RUN mkdir -p /var/cache/nginx/
RUN mkdir -p /etc/nginx/extras
RUN nginx -t

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]