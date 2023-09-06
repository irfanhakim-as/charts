{{/*
Celery /etc/default/celeryd template
*/}}
{{- define "rizz.default-celeryd" -}}
# Names of nodes to start
#   most people will only start one node:
#CELERYD_NODES="worker1"
#   but you can also start multiple and configure settings
#   for each in CELERYD_OPTS
#CELERYD_NODES="worker1 worker2 worker3"
#   alternatively, you can specify the number of nodes to start:
#CELERYD_NODES=10
CELERYD_NODES="worker1"

# Absolute or relative path to the 'celery' command:
#CELERY_BIN="/usr/local/bin/celery"
#CELERY_BIN="/virtualenvs/def/bin/celery"
CELERY_BIN="/usr/local/bin/celery"

# App instance to use
# comment out this line if you don't use an app
#CELERY_APP="proj"
# or fully qualified:
#CELERY_APP="proj.tasks:app"
CELERY_APP="base"

# Where to chdir at start.
#CELERYD_CHDIR="/opt/Myproject/"
CELERYD_CHDIR="/base/"

# Extra command-line arguments to the worker
#CELERYD_OPTS="--time-limit=300 --concurrency=8"
# Configure node-specific settings by appending node name to arguments:
#CELERYD_OPTS="--time-limit=300 -c 8 -c:worker2 4 -c:worker3 2 -Ofair:worker1"
CELERYD_OPTS="--time-limit=300 --concurrency=8 --without-gossip --without-mingle --without-heartbeat -Ofair --pool=solo"

# Set logging level
#CELERYD_LOG_LEVEL="DEBUG"
CELERYD_LOG_LEVEL="WARNING"

# %n will be replaced with the first part of the nodename.
#CELERYD_LOG_FILE="/var/log/celery/%n%I.log"
#CELERYD_PID_FILE="/var/run/celery/%n.pid"
CELERYD_LOG_FILE="/var/log/celery/%n%I.log"
CELERYD_PID_FILE="/var/run/celery/%n.pid"

# Workers should run as an unprivileged user.
#   You need to create this user manually (or you can choose
#   a user/group combination that already exists (e.g., nobody).
#CELERYD_USER="celery"
#CELERYD_GROUP="celery"
CELERYD_USER="root"
CELERYD_GROUP="root"

# If enabled pid and log directories will be created if missing,
# and owned by the userid/group configured.
#CELERY_CREATE_DIRS=1
CELERY_CREATE_DIRS=1
{{- end }}

{{/*
Celery /etc/init.d/celeryd template
*/}}
{{- define "rizz.initd-celeryd" -}}
#!/bin/sh -e
# ============================================
#  celeryd - Starts the Celery worker daemon.
# ============================================
#
# :Usage: /etc/init.d/celeryd {start|stop|force-reload|restart|try-restart|status}
# :Configuration file: /etc/default/celeryd (or /usr/local/etc/celeryd on BSD)
#
# See https://docs.celeryq.dev/en/latest/userguide/daemonizing.html#generic-init-scripts


### BEGIN INIT INFO
# Provides:          celeryd
# Required-Start:    $network $local_fs $remote_fs
# Required-Stop:     $network $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: celery task worker daemon
### END INIT INFO
#
#
# To implement separate init-scripts, copy this script and give it a different
# name.  That is, if your new application named "little-worker" needs an init,
# you should use:
#
#   cp /etc/init.d/celeryd /etc/init.d/little-worker
#
# You can then configure this by manipulating /etc/default/little-worker.
#
VERSION=10.1
echo "celery init v${VERSION}."
if [ $(id -u) -ne 0 ]; then
    echo "Error: This program can only be used by the root user."
    echo "       Unprivileged users must use the 'celery multi' utility, "
    echo "       or 'celery worker --detach'."
    exit 1
fi

origin_is_runlevel_dir () {
    set +e
    dirname $0 | grep -q "/etc/rc.\.d"
    echo $?
}

# Can be a runlevel symlink (e.g., S02celeryd)
if [ $(origin_is_runlevel_dir) -eq 0 ]; then
    SCRIPT_FILE=$(readlink "$0")
else
    SCRIPT_FILE="$0"
fi
SCRIPT_NAME="$(basename "$SCRIPT_FILE")"

DEFAULT_USER="celery"
DEFAULT_PID_FILE="/var/run/celery/%n.pid"
DEFAULT_LOG_FILE="/var/log/celery/%n%I.log"
DEFAULT_LOG_LEVEL="WARNING"
DEFAULT_NODES="celery"
DEFAULT_CELERYD="-m celery worker --detach"

if [ -d "/etc/default" ]; then
	CELERY_CONFIG_DIR="/etc/default"
else
	CELERY_CONFIG_DIR="/usr/local/etc"
fi

CELERY_DEFAULTS=${CELERY_DEFAULTS:-"$CELERY_CONFIG_DIR/${SCRIPT_NAME}"}

# Make sure executable configuration script is owned by root
_config_sanity() {
    local path="$1"
    local owner=$(ls -ld "$path" | awk '{print $3}')
    local iwgrp=$(ls -ld "$path" | cut -b 6)
    local iwoth=$(ls -ld "$path" | cut -b 9)

    if [ "$(id -u $owner)" != "0" ]; then
        echo "Error: Config script '$path' must be owned by root!"
        echo
        echo "Resolution:"
        echo "Review the file carefully, and make sure it hasn't been "
        echo "modified with mailicious intent.  When sure the "
        echo "script is safe to execute with superuser privileges "
        echo "you can change ownership of the script:"
        echo "    $ sudo chown root '$path'"
        exit 1
    fi

    if [ "$iwoth" != "-" ]; then  # S_IWOTH
        echo "Error: Config script '$path' cannot be writable by others!"
        echo
        echo "Resolution:"
        echo "Review the file carefully, and make sure it hasn't been "
        echo "modified with malicious intent.  When sure the "
        echo "script is safe to execute with superuser privileges "
        echo "you can change the scripts permissions:"
        echo "    $ sudo chmod 640 '$path'"
        exit 1
    fi
    if [ "$iwgrp" != "-" ]; then  # S_IWGRP
        echo "Error: Config script '$path' cannot be writable by group!"
        echo
        echo "Resolution:"
        echo "Review the file carefully, and make sure it hasn't been "
        echo "modified with malicious intent.  When sure the "
        echo "script is safe to execute with superuser privileges "
        echo "you can change the scripts permissions:"
        echo "    $ sudo chmod 640 '$path'"
        exit 1
    fi
}

if [ -f "$CELERY_DEFAULTS" ]; then
    _config_sanity "$CELERY_DEFAULTS"
    echo "Using config script: $CELERY_DEFAULTS"
    . "$CELERY_DEFAULTS"
fi

# Sets --app argument for CELERY_BIN
CELERY_APP_ARG=""
if [ ! -z "$CELERY_APP" ]; then
    CELERY_APP_ARG="--app=$CELERY_APP"
fi

# Options to su
# can be used to enable login shell (CELERYD_SU_ARGS="-l"),
# or even to use start-stop-daemon instead of su.
CELERYD_SU=${CELERY_SU:-"su"}
CELERYD_SU_ARGS=${CELERYD_SU_ARGS:-""}

CELERYD_USER=${CELERYD_USER:-$DEFAULT_USER}

# Set CELERY_CREATE_DIRS to always create log/pid dirs.
CELERY_CREATE_DIRS=${CELERY_CREATE_DIRS:-0}
CELERY_CREATE_RUNDIR=$CELERY_CREATE_DIRS
CELERY_CREATE_LOGDIR=$CELERY_CREATE_DIRS
if [ -z "$CELERYD_PID_FILE" ]; then
    CELERYD_PID_FILE="$DEFAULT_PID_FILE"
    CELERY_CREATE_RUNDIR=1
fi
if [ -z "$CELERYD_LOG_FILE" ]; then
    CELERYD_LOG_FILE="$DEFAULT_LOG_FILE"
    CELERY_CREATE_LOGDIR=1
fi

CELERYD_LOG_LEVEL=${CELERYD_LOG_LEVEL:-${CELERYD_LOGLEVEL:-$DEFAULT_LOG_LEVEL}}
CELERY_BIN=${CELERY_BIN:-"celery"}
CELERYD_MULTI=${CELERYD_MULTI:-"$CELERY_BIN multi"}
CELERYD_NODES=${CELERYD_NODES:-$DEFAULT_NODES}

export CELERY_LOADER

if [ -n "$2" ]; then
    CELERYD_OPTS="$CELERYD_OPTS $2"
fi

CELERYD_LOG_DIR=`dirname $CELERYD_LOG_FILE`
CELERYD_PID_DIR=`dirname $CELERYD_PID_FILE`

# Extra start-stop-daemon options, like user/group.
if [ -n "$CELERYD_CHDIR" ]; then
    DAEMON_OPTS="$DAEMON_OPTS --workdir=$CELERYD_CHDIR"
fi


check_dev_null() {
    if [ ! -c /dev/null ]; then
        echo "/dev/null is not a character device!"
        exit 75  # EX_TEMPFAIL
    fi
}


maybe_die() {
    if [ $? -ne 0 ]; then
        echo "Exiting: $* (errno $?)"
        exit 77  # EX_NOPERM
    fi
}

create_default_dir() {
    if [ ! -d "$1" ]; then
        echo "- Creating default directory: '$1'"
        mkdir -p "$1"
        maybe_die "Couldn't create directory $1"
        echo "- Changing permissions of '$1' to 02755"
        chmod 02755 "$1"
        maybe_die "Couldn't change permissions for $1"
        if [ -n "$CELERYD_USER" ]; then
            echo "- Changing owner of '$1' to '$CELERYD_USER'"
            chown "$CELERYD_USER" "$1"
            maybe_die "Couldn't change owner of $1"
        fi
        if [ -n "$CELERYD_GROUP" ]; then
            echo "- Changing group of '$1' to '$CELERYD_GROUP'"
            chgrp "$CELERYD_GROUP" "$1"
            maybe_die "Couldn't change group of $1"
        fi
    fi
}


check_paths() {
    if [ $CELERY_CREATE_LOGDIR -eq 1 ]; then
        create_default_dir "$CELERYD_LOG_DIR"
    fi
    if [ $CELERY_CREATE_RUNDIR -eq 1 ]; then
        create_default_dir "$CELERYD_PID_DIR"
    fi
}

create_paths() {
    create_default_dir "$CELERYD_LOG_DIR"
    create_default_dir "$CELERYD_PID_DIR"
}

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"


_get_pidfiles () {
    # note: multi < 3.1.14 output to stderr, not stdout, hence the redirect.
    ${CELERYD_MULTI} expand "${CELERYD_PID_FILE}" ${CELERYD_NODES} 2>&1
}


_get_pids() {
    found_pids=0
    my_exitcode=0

    for pidfile in $(_get_pidfiles); do
        local pid=`cat "$pidfile"`
        local cleaned_pid=`echo "$pid" | sed -e 's/[^0-9]//g'`
        if [ -z "$pid" ] || [ "$cleaned_pid" != "$pid" ]; then
            echo "bad pid file ($pidfile)"
            one_failed=true
            my_exitcode=1
        else
            found_pids=1
            echo "$pid"
        fi

    if [ $found_pids -eq 0 ]; then
        echo "${SCRIPT_NAME}: All nodes down"
        exit $my_exitcode
    fi
    done
}


_chuid () {
    ${CELERYD_SU} ${CELERYD_SU_ARGS} "$CELERYD_USER" -c "$CELERYD_MULTI $*"
}


start_workers () {
    if [ ! -z "$CELERYD_ULIMIT" ]; then
        ulimit $CELERYD_ULIMIT
    fi
    _chuid $* start $CELERYD_NODES $DAEMON_OPTS     \
                 --pidfile="$CELERYD_PID_FILE"      \
                 --logfile="$CELERYD_LOG_FILE"      \
                 --loglevel="$CELERYD_LOG_LEVEL"    \
                 $CELERY_APP_ARG                    \
                 $CELERYD_OPTS
}


dryrun () {
    (C_FAKEFORK=1 start_workers --verbose)
}


stop_workers () {
    _chuid stopwait $CELERYD_NODES $DAEMON_OPTS --pidfile="$CELERYD_PID_FILE"
}


restart_workers () {
    _chuid restart $CELERYD_NODES $DAEMON_OPTS      \
                   --pidfile="$CELERYD_PID_FILE"    \
                   --logfile="$CELERYD_LOG_FILE"    \
                   --loglevel="$CELERYD_LOG_LEVEL"  \
                   $CELERY_APP_ARG                  \
                   $CELERYD_OPTS
}


kill_workers() {
    _chuid kill $CELERYD_NODES $DAEMON_OPTS --pidfile="$CELERYD_PID_FILE"
}


restart_workers_graceful () {
    echo "WARNING: Use with caution in production"
    echo "The workers will attempt to restart, but they may not be able to."
    local worker_pids=
    worker_pids=`_get_pids`
    [ "$one_failed" ] && exit 1

    for worker_pid in $worker_pids; do
        local failed=
        kill -HUP $worker_pid 2> /dev/null || failed=true
        if [ "$failed" ]; then
            echo "${SCRIPT_NAME} worker (pid $worker_pid) could not be restarted"
            one_failed=true
        else
            echo "${SCRIPT_NAME} worker (pid $worker_pid) received SIGHUP"
        fi
    done

    [ "$one_failed" ] && exit 1 || exit 0
}


check_status () {
    my_exitcode=0
    found_pids=0

    local one_failed=
    for pidfile in $(_get_pidfiles); do
        if [ ! -r $pidfile ]; then
            echo "${SCRIPT_NAME} down: no pidfiles found"
            one_failed=true
            break
        fi

        local node=`basename "$pidfile" .pid`
        local pid=`cat "$pidfile"`
        local cleaned_pid=`echo "$pid" | sed -e 's/[^0-9]//g'`
        if [ -z "$pid" ] || [ "$cleaned_pid" != "$pid" ]; then
            echo "bad pid file ($pidfile)"
            one_failed=true
        else
            local failed=
            kill -0 $pid 2> /dev/null || failed=true
            if [ "$failed" ]; then
                echo "${SCRIPT_NAME} (node $node) (pid $pid) is down, but pidfile exists!"
                one_failed=true
            else
                echo "${SCRIPT_NAME} (node $node) (pid $pid) is up..."
            fi
        fi
    done

    [ "$one_failed" ] && exit 1 || exit 0
}


case "$1" in
    start)
        check_dev_null
        check_paths
        start_workers
    ;;

    stop)
        check_dev_null
        check_paths
        stop_workers
    ;;

    reload|force-reload)
        echo "Use restart"
    ;;

    status)
        check_status
    ;;

    restart)
        check_dev_null
        check_paths
        restart_workers
    ;;

    graceful)
        check_dev_null
        restart_workers_graceful
    ;;

    kill)
        check_dev_null
        kill_workers
    ;;

    dryrun)
        check_dev_null
        dryrun
    ;;

    try-restart)
        check_dev_null
        check_paths
        restart_workers
    ;;

    create-paths)
        check_dev_null
        create_paths
    ;;

    check-paths)
        check_dev_null
        check_paths
    ;;

    *)
        echo "Usage: /etc/init.d/${SCRIPT_NAME} {start|stop|restart|graceful|kill|dryrun|create-paths}"
        exit 64  # EX_USAGE
    ;;
esac

exit 0
{{- end }}
