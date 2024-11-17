#!/usr/bin/env bash
# 定义常量


function init_pcre() {
    cd /usr/local/src || exit
#    sudo wget https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz
    sudo tar -zxvf pcre-8.44.tar.gz
    cd pcre-8.44 || exit
    sudo ./configure
    sudo make
    sudo make install
}

function init_zlib() {
    cd /usr/local/src || exit
#    sudo wget http://zlib.net/zlib-1.2.11.tar.gz
    sudo tar -zxvf zlib-1.2.11.tar.gz
    cd zlib-1.2.11 || exit
    sudo ./configure
    sudo make
    sudo make install
}

function init_ssl() {
    cd /usr/local/src || exit
#    sudo wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz
    sudo tar -zxvf openssl-1.1.1g.tar.gz
}


function init_nginx() {
    cd /usr/local/src || exit
#    sudo wget http://nginx.org/download/nginx-1.18.0.tar.gz
    sudo tar -zxvf nginx-1.18.0.tar.gz
    cd nginx-1.18.0 || exit

    sudo ./configure --sbin-path=/usr/local/nginx/nginx \
    --conf-path=/usr/local/nginx/nginx.conf \
    --pid-path=/usr/local/nginx/nginx.pid \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-file-aio \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-pcre=/usr/local/src/pcre-8.44 \
    --with-zlib=/usr/local/src/zlib-1.2.11 \
    --with-openssl=/usr/local/src/openssl-1.1.1g

    sudo make -j2
    sudo make install

}


function main() {
#    script_user=`whoami`
#    if [ "${script_user}" != "ops" ]
#    then
#        echo '使用须知, 将整个init_project直接打包压缩，并拷贝到目标目录上进行解压。 请务必在ops用户下执行 bash init.sh'
#        exit 1
#    fi

    if [ -f "/usr/local/nginx/nginx" ];then
        echo "机器已经安装nginx，请勿重复安装"
        return
    fi

    sudo yum -y install gcc automake autoconf libtool make
    sudo yum install gcc gcc-c++
    sudo mkdir -p /usr/local/src
    cd /usr/local/src || exit
    init_pcre
    init_zlib
    init_ssl
    init_nginx

    echo '启动nginx'
    sudo /usr/local/nginx/nginx


    if [ $? != 0 ];then
      echo "nginx安装启动失败 ！！！！"
      return
    fi
    echo "nginx 安装并启动成功"
}

main




