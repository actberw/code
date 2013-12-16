#!/bin/bash
#example file to build /etc/init.d/ scripts.
#		This file should be used to construct scripts for /etc/init.d.
#
#		Written by Miquel van Smoorenburg <miquels@cistron.nl>.
#		Modified for Debian
#               Modified by wangjian <actberw@gmail.com>
#
#

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

DAEMON=scribed
NAME=scribe
DESC=scribe

DAEMON_OPTS="-c /etc/scribe.conf"

SCRIBE_CTRL=scribe_ctrl

#which $DAEMON || exit 0

# Include scribe defaults if available
if [ -f /etc/default/scribe ] ; then
	. /etc/default/scribe
fi

set -e

case "$1" in
  start)
	echo -n "Starting $DESC: "
	start-stop-daemon --start --quiet --background --exec `which $DAEMON` -- $DAEMON_OPTS
	echo "$NAME."
	;;
  stop)
	echo -n "Stopping $DESC: "
	$SCRIBE_CTRL stop
	echo "$NAME."
	;;
  status)
        echo -n "Get $DESC status: "
        X=`$SCRIBE_CTRL status 2>&1 ||echo ""`
        echo "$X"
        if [ "$X" = "ALIVE" ]; then
            R=0
        else
            R=1
        fi
        exit $R
        ;;
  reload)
	echo "Reloading $DESC configuration files."
	$SCRIBE_CTRL reload
  	;;
  restart)
        echo -n "Restarting $DESC: "
	$SCRIBE_CTRL stop
	sleep 1
	start-stop-daemon --start --quiet --background --exec `which $DAEMON` -- $DAEMON_OPTS
	echo "$NAME."
	;;
  *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|status|restart|reload}" >&2
	exit 1
	;;
esac

exit 0
