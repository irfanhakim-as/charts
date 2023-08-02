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
