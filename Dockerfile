
# Download base image ubuntu 20.04
FROM ubuntu:20.04

# LABEL about the custom image
LABEL maintainer="a.abaszadeh1363@gmail.com"
LABEL version="0.1"
LABEL description="This is custom Docker Image for \
the Nginx Services."

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update

WORKDIR /tmp

# Install prerequisites for Nginx compile
RUN apt install -y \ 
        wget \
        openssl \
        gcc \
        make \
        zlib1g-dev \
        libpcre3-dev \
        git && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean


# Git clone official github nginx and Nginx modules source
#RUN wget http://nginx.org/download/nginx-1.9.3.tar.gz -O nginx.tar.gz && \
RUN git clone https://github.com/nginx/nginx.git /tmp
    #tar -xzvf nginx.tar.gz -C /tmp/nginx --strip-components=1 &&\


# Build Nginx
WORKDIR /tmp/nginx

# Change at commit 285a495d using command "git reset --hard <COMMIT-SHA-ID>"
RUN git reset --hard 285a495d


RUN ./configure \
        --user=nginx \
        --with-debug \
        --group=nginx \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/run/nginx.pid \
        --lock-path=/run/lock/subsys/nginx \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --with-http_ssl_module \
        --with-http_spdy_module \
        --with-pcre \
        --with-http_image_filter_module \
        --with-file-aio \
        --with-ipv6 \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module && \
    make && \
    make install

WORKDIR /tmp

# Add nginx user
RUN adduser -c "Nginx user" nginx && \
    setcap cap_net_bind_service=ep /usr/sbin/nginx

RUN touch /run/nginx.pid

RUN chown nginx:nginx /etc/nginx /etc/nginx/nginx.conf /var/log/nginx /usr/share/nginx /run/nginx.pid

# Cleanup after Nginx build
RUN apt remove -y \
        wget \
        gcc \
        gcc-c++ \
        make \
        git && \
    apt autoremove -y && \
    rm -rf /tmp/*

# PORTS
EXPOSE 80
EXPOSE 443

USER nginx
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]


