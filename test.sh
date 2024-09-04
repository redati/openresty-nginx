#apt-get install -y libatomic-ops-dev libjemalloc-dev # for jmaloc nginx
#sudo apt install -y libgeoip-dev libmaxminddb0 libmaxminddb-dev mmdb-bin #for geioip
#sudo apt-get install -y libxslt-dev libxml2-dev #for nginx xslt
#sudo apt-get install libgd-dev webp #for nginx image filter

cd openresty-1.25.3.2 
./configure \
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
    --with-cc-opt='-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -DTCP_FASTOPEN=23,--param=ssp-buffer-size=4' \
    --with-ld-opt='-ljemalloc' \
    --with-http_perl_module \
    --with-http_image_filter_module \
    --add-module=./packages/naxsi/naxsi_src \
    --add-module=./packages/ngx_brotli  \
    --add-module=./packages/ngx_http_geoip2_module 

    make test -j8