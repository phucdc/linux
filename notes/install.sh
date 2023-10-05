#!/bin/bash

function prerequisite() {
    printf "=====[Prerequisite]=====\n"
    apt-get update -y -qq &&
    apt-get install -y apt-utils autoconf automake build-essential git libcurl4-openssl-dev libgeoip-dev liblmdb-dev libpcre++-dev libtool libxml2-dev libyajl-dev pkgconf wget zlib1g-dev -qq > /dev/null 2>&1 &&
    echo "-----[Done]-----\n\n"
}

function modsec3() {
    printf "=====[Install modsecurity3 module]=====\n"
    (git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity && cd ModSecurity
    git submodule init && git submodule update &&
    ./build.sh && mv ../ltmain.sh . ; ./build.sh && ./configure &&
    make && make install) &&
    cd .. && printf "-----[Done]-----\n\n"
}

function connector() {
    printf "=====[Installing connector]=====\n"
    NGINX_VER=$(nginx -v 2>&1 | cut -d'/' -f2 | awk '{print $1}')
    git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git &&
    wget "http://nginx.org/download/nginx-${NGINX_VER}.tar.gz" &&
    tar -xvzf nginx-${NGINX_VER}.tar.gz && cd nginx-${NGINX_VER} &&
    ./configure --with-compat --add-dynamic-module=../ModSecurity-nginx &&
    make modules && ( [ ! -d /etc/nginx/modules ] && mkdir /etc/nginx/modules ) && 
    cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules/ngx_http_modsecurity_module.so &&
    cd .. &&
    wget https://raw.githubusercontent.com/phucdc/linux/main/notes/nginx.conf &&
    mv nginx.conf /etc/nginx/nginx.conf &&
    printf "-----[Done]-----\n\n"
}

function configure() {
    printf "=====[Configuring]=====\n"
    [ ! -d /etc/nginx/modsec ] && mkdir /etc/nginx/modsec &&
    wget -P /etc/nginx/modsec/ https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended &&
    mv /etc/nginx/modsec/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf &&
    cp ModSecurity/unicode.mapping /etc/nginx/modsec &&
    sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf &&
    wget -P /etc/nginx/modsec/ https://raw.githubusercontent.com/phucdc/linux/main/notes/main.conf &&
    printf "-----[Done]-----\n\n"
}

function modsecurity_crs() {
    printf "=====[Setting up modsecurity_crs]=====\n"
    git clone https://github.com/coreruleset/coreruleset /usr/local/modsecurity-crs &&
    wget -P /usr/local/modsecurity-crs/ https://raw.githubusercontent.com/phucdc/linux/main/notes/crs-setup.conf &&
    mv /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf &&
    printf "-----[Done]-----\n\n"
}

function final() {
    printf "=====[Final step]=====\n"
    wget https://raw.githubusercontent.com/phucdc/linux/main/notes/default &&
    mv default /etc/nginx/sites-available/default && mkdir /usr/local/modsec/ &&
    wget -P /usr/local/modsec/ https://raw.githubusercontent.com/phucdc/linux/main/notes/custom.conf &&
    nginx -t && ( nginx || nginx -s reload ) &&
    printf "-----[Done]-----\n\n"
}

cd /
prerequisite && modsec3 && connector && configure && modsecurity_crs && final && curl 'http://localhost/?exec=/bin/bash'
