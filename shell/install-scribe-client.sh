#!/usr/bin/env bash

apt-get install libboost-dev libboost-test-dev libboost-program-options-dev libevent-dev automake libtool flex bison pkg-config g++ libssl-dev 

echo "Install thrift"
wget http://ftp.kddilabs.jp/infosystems/apache/thrift/0.9.0/thrift-0.9.0.tar.gz

tar zxvf thrift-0.9.0.tar.gz
cd thrift-0.9.0

./configure --with-ruby=no
make
make install
ldconfig
MSG=`thrift -version`
echo $MSG

echo "Install fb303"

cd contrib/fb303
./bootstrap.sh
make
make install
cd
