{{/*
Expand the name of the chart.
*/}}
{{- define "waktusolat.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "waktusolat.fullname" -}}
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
{{- define "waktusolat.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "waktusolat.labels" -}}
helm.sh/chart: {{ include "waktusolat.chart" . }}
{{ include "waktusolat.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "waktusolat.selectorLabels" -}}
app.kubernetes.io/name: {{ include "waktusolat.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "waktusolat.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "waktusolat.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Celery /base/base/celery.py template
*/}}
{{- define "waktusolat.celery-py" -}}
from __future__ import absolute_import, unicode_literals
import os
from celery import Celery
from celery.schedules import crontab
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "base.settings.main")
app = Celery("base")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks()


app.conf.beat_schedule = {
    # clean and update prayer times every 0000 hour
    "clean_db_every_0000": {
        "task": "base.tasks.clean_db_task",
        "schedule": crontab(hour=0, minute=0),
    },
    # notify solat schedule every 0500 hour
    "notify_solat_schedule_every_0500": {
        "task": "base.tasks.notify_solat_schedule_task",
        "schedule": crontab(hour=5, minute=0),
    },
    # check and notify solat time every sharp minute
    "notify_solat_times_every_minute": {
        "task": "base.tasks.notify_solat_times_task",
        "schedule": crontab(minute="*"),
    },
    # check for any posts that need to be posted every 1 second
    "post_scheduler_every_1s": {
        "task": "base.tasks.post_scheduler_task",
        "schedule": 1.0,
    },
}


@app.task(bind=True)
def debug_task(self):
    print("Request: {0!r}".format(self.request))
{{- end }}

{{/*
Celery /base/base/__init__.py template
*/}}
{{- define "waktusolat.celery-init-py" -}}
from .celery import app as celery_app

__all__ = ("celery_app",)
{{- end }}
