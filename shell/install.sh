#!/usr/bin/env bash

PACKAGES=(atom bson douban elixir gdata pymongo pika)
SO_FILE=(Levenshtein cmemcached)
EASYINSTALL_PACKAGES=(pil flup sqlalchemy msgpack-python redis ConcurrentLogHandler)

SCRIPT_URL=http://cdn.pylonshq.com/download/1.0/go-pylons.py

function install_env () {
    cd $HOME
    if [ ! -e go-pylons.py ];then
        
        echo 'Start download go-pylons.py'
        wget $SCRIPT_URL

        if [ $? -ne 0 ]; then
            echo 'download error, please try later!'
            exit 1
        fi
    fi

    echo -n 'Please enter virtual evn dir name, default is virtual, use default just press enter!'
    read VIRTUAL_NAME

    if [ -z $VIRTUAL_NAME ]; then
        VIRTUAL_NAME=virtual
    fi

    echo "You have set virtual dir as ${VIRTUAL_NAME}"

    python ./go-pylons.py --no-site-packages $VIRTUAL_NAME
    echo $?
}


function ln_packages () {
    cd "${HOME}/${VIRTUAL_NAME}/lib/python2.6/site-packages/" 
    for p in ${PACKAGES[@]}; do
       path=`python -c "import ${p};print ${p}.__path__[0]"`
       ln -s $path ${path##*/}
    done
    echo "${HOME}/${VIRTUAL_NAME}/lib/python2.6/site-packages/" 
    for p in ${SO_FILE[@]};do
        path=`python -c "import ${p};print ${p}.__file__"`
        ln -s $path ${path##*/}
    done
}

function install_dependency () {
    cd $HOME
    source "${HOME}/${VIRTUAL_NAME}/bin/activate"
    for p in ${EASYINSTALL_PACKAGES[@]};do
        easy_install $p
    done
}

install_env
ln_packages
install_dependency

echo "cp config.ini to development.ini, and change the port parameter."
