#/usr/bin/env bash
cd
echo "Install dependencies"
aptitude install autoconf automake pkg-config libtool libevent-dev libevent-2.0-5 libboost-all-dev
# centos 
# sudo yum install libevent libevent-devel openssl-devel
# wget http://sourceforge.net/projects/boost/files/boost/1.46.0/boost_1_46_0.tar.gz/download;tar zxvf boost_1_46_0.tar.gz;cd boost_1_46_0;
# ./bootstrap.sh --prefix=/usr/local
# sudo ./bjam --with-filesystem --with-system install # bjam --show-libraries
# ldconfig
echo "Download thrift and extract source file"
wget http://archive.apache.org/dist/thrift/0.9.0/thrift-0.9.0.tar.gz
tar zxvf thrift-0.9.0.tar.gz
cd thrift-0.9.0

echo "Install thrift"
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
echo "Install scribe"
#git clone https://github.com/facebook/scribe.git
wget https://github.com/facebook/scribe/archive/master.zip;unzip master.zip
cd scribe
./bootstrap.sh
./configure CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H -DBOOST_FILESYSTEM_VERSION=2"
make
cd src;g++  -Wall -O3 -L/usr/lib  -o scribed store.o store_queue.o conf.o file.o conn_pool.o scribe_server.o network_dynamic_config.o dynamic_bucket_updater.o  env_default.o  -L/usr/local/lib -L/usr/local/lib -L/usr/local/lib -lfb303 -lthrift -lthriftnb -levent -lpthread  libscribe.a libdynamicbucketupdater.a -lboost_system-mt -lboost_filesystem-mt;cd ../
make install

echo "Copy python package"
cd /usr/lib/python2.7/site-packages;sudo cp -r ./ ../dist-packages/
cd
