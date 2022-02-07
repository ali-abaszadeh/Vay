
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
        openssl \
        libssl-dev \
        gcc \
        make \
        build-essential \
        zlib1g-dev \
        libpcre3-dev \
        perl \
        libperl-dev \
        libgd3 \
        libgd-dev \
        gettext-base \
        net-tools vim curl telnet \
        git && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean


# Add Nginx source file to the build environment
RUN mkdir /tmp/nginx
COPY ./nginx-source-file/nginx.tar.gz /tmp
RUN tar -xzvf /tmp/nginx.tar.gz -C /tmp/nginx --strip-components=1


# Build Nginx
WORKDIR /tmp/nginx


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
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-file-aio \
        --with-threads \
        --with-select_module \
        --without-poll_module && \
    make && \
    make install

WORKDIR /tmp 

# Add nginx user
RUN adduser --system --home /nonexistent --shell /bin/false --no-create-home --disabled-login --disabled-password --gecos "nginx user" --group nginx

RUN touch /run/nginx.pid

# Manage environment variable in the nginx container

COPY ./nginx.conf /etc/nginx

COPY ./nginx.conf.template /etc/nginx

COPY ./docker-entrypoint.sh /

RUN chmod 755 /docker-entrypoint.sh
#

# Cleanup after Nginx build
RUN apt remove -y \
        gcc \
        make \
        git && \
    apt autoremove -y && \
    rm -rf /tmp/*

ADD ./conf.d  /etc/nginx/conf.d
ADD ./certificates /etc/nginx/certs

RUN chown -R nginx:nginx /etc/nginx /etc/nginx/nginx.conf /var/log/nginx /usr/share/nginx /run/nginx.pid

#ENTRYPOINT ["/docker-entrypoint.sh"]
# Running script every 5 second to get new variables for nginx

WORKDIR /

RUN nohup ./docker-entrypoint.sh &

# PORTS
EXPOSE 10080
EXPOSE 10443

USER nginx

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
