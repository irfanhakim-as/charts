{{/*
Expand the name of the chart.
*/}}
{{- define "telego.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "telego.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "telego.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "telego.labels" -}}
helm.sh/chart: {{ include "telego.chart" . }}
{{ include "telego.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "telego.selectorLabels" -}}
app.kubernetes.io/name: {{ include "telego.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "telego.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "telego.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Apache site-config.conf template
*/}}
{{- define "telego.site-config-conf" -}}
<VirtualHost *:80>
    ServerName DOMAIN:443
    UseCanonicalName On
    ServerAdmin support@domain.org
    DocumentRoot /telego
    WSGIScriptAlias / /telego/telego/wsgi.py
    WSGIDaemonProcess DOMAIN python-path=/telego
    WSGIProcessGroup DOMAIN

    <Directory /telego/telego>
        <Files wsgi.py>
            Require all granted
        </Files>
    </Directory>

    Alias /static /static
    <Directory /static>
        Require all granted
    </Directory>

    ErrorLog /telego/logs/apache.error.log
    CustomLog /telego/logs/apache.access.log combined
</VirtualHost>
{{- end }}

{{/*
APScheduler /entrypoint.sh template
*/}}
{{- define "telego.apscheduler-entrypoint-sh" -}}
#!/bin/bash

export APP_ROOT="base"

# ================= DO NOT EDIT BEYOND THIS LINE =================

python3 manage.py makemigrations

python3 manage.py migrate

tail -f /dev/null
{{- end }}

{{/*
APScheduler /base/base/apps.py template
*/}}
{{- define "telego.apscheduler-apps-py" -}}
from django.apps import AppConfig

class BaseConfig(AppConfig):
    name = "base"

    def ready(self):
        from . import signals
        from . import tasks
        tasks.start()
{{- end }}

{{/*
APScheduler /base/base/tasks.py template
*/}}
{{- define "telego.apscheduler-tasks-py" -}}
from django.conf import settings
from base.scheduler import object_scheduler
from lib.telegram import clean_model
from apscheduler.schedulers.blocking import BlockingScheduler


SCHEDULER_TIMEZONE = getattr(settings, "SCHEDULER_TIMEZONE")


def start():
    scheduler = BlockingScheduler(timezone=SCHEDULER_TIMEZONE)

    job_name = "clean_model"
    scheduler.add_job(clean_model, "cron", hour=CLEAN_MODEL_HOURS, id=job_name, replace_existing=True)

    job_name = "object_scheduler"
    scheduler.add_job(object_scheduler, "cron", second=OBJECT_SCHEDULER_SECONDS, id=job_name, replace_existing=True)

    scheduler.start()
{{- end }}

{{/*
Celery /etc/default/celeryd template
*/}}
{{- define "telego.default-celeryd" -}}
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
Celery /etc/init.d/celerybeat template
*/}}
{{- define "telego.initd-celerybeat" -}}
#!/bin/sh -e
# =========================================================
#  celerybeat - Starts the Celery periodic task scheduler.
# =========================================================
#
# :Usage: /etc/init.d/celerybeat {start|stop|force-reload|restart|try-restart|status}
# :Configuration file: /etc/default/celerybeat or /etc/default/celeryd
#
# See https://docs.celeryq.dev/en/latest/userguide/daemonizing.html#generic-init-scripts

### BEGIN INIT INFO
# Provides:          celerybeat
# Required-Start:    $network $local_fs $remote_fs
# Required-Stop:     $network $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: celery periodic task scheduler
### END INIT INFO

# Cannot use set -e/bash -e since the kill -0 command will abort
# abnormally in the absence of a valid process ID.
#set -e
VERSION=10.1
echo "celery init v${VERSION}."

if [ $(id -u) -ne 0 ]; then
    echo "Error: This program can only be used by the root user."
    echo "       Unprivileged users must use 'celery beat --detach'"
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

# /etc/init.d/celerybeat: start and stop the celery periodic task scheduler daemon.

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

scripts=""

if test -f /etc/default/celeryd; then
    scripts="/etc/default/celeryd"
    _config_sanity /etc/default/celeryd
    . /etc/default/celeryd
fi

EXTRA_CONFIG="/etc/default/${SCRIPT_NAME}"
if test -f "$EXTRA_CONFIG"; then
    scripts="$scripts, $EXTRA_CONFIG"
    _config_sanity "$EXTRA_CONFIG"
    . "$EXTRA_CONFIG"
fi

echo "Using configuration: $scripts"

CELERY_BIN=${CELERY_BIN:-"celery"}
DEFAULT_USER="celery"
DEFAULT_PID_FILE="/var/run/celery/beat.pid"
DEFAULT_LOG_FILE="/var/log/celery/beat.log"
DEFAULT_LOG_LEVEL="WARNING"
DEFAULT_CELERYBEAT="$CELERY_BIN"

CELERYBEAT=${CELERYBEAT:-$DEFAULT_CELERYBEAT}
CELERYBEAT_LOG_LEVEL=${CELERYBEAT_LOG_LEVEL:-${CELERYBEAT_LOGLEVEL:-$DEFAULT_LOG_LEVEL}}

CELERYBEAT_SU=${CELERYBEAT_SU:-"su"}
CELERYBEAT_SU_ARGS=${CELERYBEAT_SU_ARGS:-""}

# Sets --app argument for CELERY_BIN
CELERY_APP_ARG=""
if [ ! -z "$CELERY_APP" ]; then
    CELERY_APP_ARG="--app=$CELERY_APP"
fi

CELERYBEAT_USER=${CELERYBEAT_USER:-${CELERYD_USER:-$DEFAULT_USER}}

# Set CELERY_CREATE_DIRS to always create log/pid dirs.
CELERY_CREATE_DIRS=${CELERY_CREATE_DIRS:-0}
CELERY_CREATE_RUNDIR=$CELERY_CREATE_DIRS
CELERY_CREATE_LOGDIR=$CELERY_CREATE_DIRS
if [ -z "$CELERYBEAT_PID_FILE" ]; then
    CELERYBEAT_PID_FILE="$DEFAULT_PID_FILE"
    CELERY_CREATE_RUNDIR=1
fi
if [ -z "$CELERYBEAT_LOG_FILE" ]; then
    CELERYBEAT_LOG_FILE="$DEFAULT_LOG_FILE"
    CELERY_CREATE_LOGDIR=1
fi

export CELERY_LOADER

if [ -n "$2" ]; then
    CELERYBEAT_OPTS="$CELERYBEAT_OPTS $2"
fi

CELERYBEAT_LOG_DIR=`dirname $CELERYBEAT_LOG_FILE`
CELERYBEAT_PID_DIR=`dirname $CELERYBEAT_PID_FILE`

# Extra start-stop-daemon options, like user/group.

CELERYBEAT_CHDIR=${CELERYBEAT_CHDIR:-$CELERYD_CHDIR}
if [ -n "$CELERYBEAT_CHDIR" ]; then
    DAEMON_OPTS="$DAEMON_OPTS --workdir=$CELERYBEAT_CHDIR"
fi


export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"

check_dev_null() {
    if [ ! -c /dev/null ]; then
        echo "/dev/null is not a character device!"
        exit 75  # EX_TEMPFAIL
    fi
}

maybe_die() {
    if [ $? -ne 0 ]; then
        echo "Exiting: $*"
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
        if [ -n "$CELERYBEAT_USER" ]; then
            echo "- Changing owner of '$1' to '$CELERYBEAT_USER'"
            chown "$CELERYBEAT_USER" "$1"
            maybe_die "Couldn't change owner of $1"
        fi
        if [ -n "$CELERYBEAT_GROUP" ]; then
            echo "- Changing group of '$1' to '$CELERYBEAT_GROUP'"
            chgrp "$CELERYBEAT_GROUP" "$1"
            maybe_die "Couldn't change group of $1"
        fi
    fi
}

check_paths() {
    if [ $CELERY_CREATE_LOGDIR -eq 1 ]; then
        create_default_dir "$CELERYBEAT_LOG_DIR"
    fi
    if [ $CELERY_CREATE_RUNDIR -eq 1 ]; then
        create_default_dir "$CELERYBEAT_PID_DIR"
    fi
}


create_paths () {
    create_default_dir "$CELERYBEAT_LOG_DIR"
    create_default_dir "$CELERYBEAT_PID_DIR"
}

is_running() {
    pid=$1
    ps $pid > /dev/null 2>&1
}

wait_pid () {
    pid=$1
    forever=1
    i=0
    while [ $forever -gt 0 ]; do
        if ! is_running $pid; then
            echo "OK"
            forever=0
        else
            kill -TERM "$pid"
            i=$((i + 1))
            if [ $i -gt 60 ]; then
                echo "ERROR"
                echo "Timed out while stopping (30s)"
                forever=0
            else
                sleep 0.5
            fi
        fi
    done
}


stop_beat () {
    echo -n "Stopping ${SCRIPT_NAME}... "
    if [ -f "$CELERYBEAT_PID_FILE" ]; then
        wait_pid $(cat "$CELERYBEAT_PID_FILE")
    else
        echo "NOT RUNNING"
    fi
}

_chuid () {
    ${CELERYBEAT_SU} ${CELERYBEAT_SU_ARGS} \
        "$CELERYBEAT_USER" -c "$CELERYBEAT $*"
}

start_beat () {
    echo "Starting ${SCRIPT_NAME}..."
    _chuid $CELERY_APP_ARG $DAEMON_OPTS beat --detach \
                 --pidfile="$CELERYBEAT_PID_FILE"      \
                 --logfile="$CELERYBEAT_LOG_FILE"      \
                 --loglevel="$CELERYBEAT_LOG_LEVEL"    \
                 $CELERYBEAT_OPTS
}


check_status () {
    local failed=
    local pid_file=$CELERYBEAT_PID_FILE
    if [ ! -e $pid_file ]; then
        echo "${SCRIPT_NAME} is down: no pid file found"
        failed=true
    elif [ ! -r $pid_file ]; then
        echo "${SCRIPT_NAME} is in unknown state, user cannot read pid file."
        failed=true
    else
        local pid=`cat "$pid_file"`
        local cleaned_pid=`echo "$pid" | sed -e 's/[^0-9]//g'`
        if [ -z "$pid" ] || [ "$cleaned_pid" != "$pid" ]; then
            echo "${SCRIPT_NAME}: bad pid file ($pid_file)"
            failed=true
        else
            local failed=
            kill -0 $pid 2> /dev/null || failed=true
            if [ "$failed" ]; then
                echo "${SCRIPT_NAME} (pid $pid) is down, but pid file exists!"
                failed=true
            else
                echo "${SCRIPT_NAME} (pid $pid) is up..."
            fi
        fi
    fi

    [ "$failed" ] && exit 1 || exit 0
}


case "$1" in
    start)
        check_dev_null
        check_paths
        start_beat
    ;;
    stop)
        check_paths
        stop_beat
    ;;
    reload|force-reload)
        echo "Use start+stop"
    ;;
    status)
        check_status
    ;;
    restart)
        echo "Restarting celery periodic task scheduler"
        check_paths
        stop_beat && check_dev_null && start_beat
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
        echo "Usage: /etc/init.d/${SCRIPT_NAME} {start|stop|restart|create-paths|status}"
        exit 64  # EX_USAGE
    ;;
esac

exit 0
{{- end }}
