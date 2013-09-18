#!/usr/bin/env sh
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"
 
OLDGW=`netstat -nr | grep '^default' | grep 'ppp' | sed 's/default *\([0-9\.]*\) .*/\1/'`
 
if [ ! -e /tmp/pptp_oldgw ]; then
        echo "${OLDGW}" > /tmp/pptp_oldgw
    fi
     
    dscacheutil -flushcache
     
    #slideshare.net
    route add -host 174.36.28.11 "${OLDGW}"
     
    #mail.google.com
    route add -net 74.125.128.0/24 "${OLDGW}"
     
    #facebook
    route add -host 173.252.100.18 "${OLDGW}"
     
    #twitter.com
    route add -host 199.59.149.243 "${OLDGW}"
     
    #youtube.com
    route add -host 173.194.43.6 "${OLDGW}"
     
    #t.co
    route add -host 199.59.148.12 "${OLDGW}"
     
    #bit.ly
    route add -host 69.58.188.40 "${OLDGW}"
     
    #google
    route add -host 74.125.128.147 "${OLDGW}"
