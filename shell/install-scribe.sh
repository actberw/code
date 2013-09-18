#/usr/bin/env bash
cd
echo "Install dependencies"
aptitude install autoconf automake libtool pkg-config libtool libevent-dev libevent-2.0-5 libboost-all-dev
echo "Download and extract source file"
wget http://ftp.kddilabs.jp/infosystems/apache/thrift/0.9.0/thrift-0.9.0.tar.gz
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
git clone https://github.com/facebook/scribe.git
cd scribe
./bootstrap.sh
./configure CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H -DBOOST_FILESYSTEM_VERSION=2"
make
cd src;g++  -Wall -O3 -L/usr/lib  -o scribed store.o store_queue.o conf.o file.o conn_pool.o scribe_server.o network_dynamic_config.o dynamic_bucket_updater.o  env_default.o  -L/usr/local/lib -L/usr/local/lib -L/usr/local/lib -lfb303 -lthrift -lthriftnb -levent -lpthread  libscribe.a libdynamicbucketupdater.a -lboost_system-mt -lboost_filesystem-mt;cd ../
make install

echo "Copy python package"
cd /usr/lib/python2.7/site-packages;sudo cp -r ./ ../dist-packages/
cd
