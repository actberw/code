#/usr/bin/env bash

STATUS=0

for f in `git diff-index --cached --name-only HEAD`; do
    if [[ $f == *.py ]]; then
        pylint -E $f 
        if [ $? != 0 ]; then
            STATUS=1
        fi
    fi
done 

exit $STATUS
