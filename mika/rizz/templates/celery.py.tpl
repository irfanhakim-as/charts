{{/*
Celery /base/base/celery.py template
*/}}
{{- define "rizz.celery-py" -}}

{{- $clean_data_hour := .Values.scheduler.schedule.clean_data.hour | default "0" | toString -}}
{{- $clean_data_minute := .Values.scheduler.schedule.clean_data.minute | default "0" | toString -}}
{{- $clean_data_second := .Values.scheduler.schedule.clean_data.second | toString -}}
{{- $post_scheduler_hour := .Values.scheduler.schedule.post_scheduler.hour | default "8-23/3" | toString -}}
{{- $post_scheduler_minute := .Values.scheduler.schedule.post_scheduler.minute | default "0" | toString -}}
{{- $post_scheduler_second := .Values.scheduler.schedule.post_scheduler.second | toString -}}
{{- $update_data_hour := .Values.scheduler.schedule.update_data.hour | default "7-22/3" | toString -}}
{{- $update_data_minute := .Values.scheduler.schedule.update_data.minute | default "0" | toString -}}
{{- $update_data_second := .Values.scheduler.schedule.update_data.second | toString -}}

from __future__ import absolute_import, unicode_literals
import os
import re
from celery import Celery
from celery.schedules import crontab
from datetime import timedelta
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "base.conf.main")
app = Celery("base")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks()


app.conf.beat_schedule = {
    # clean data
    "clean_data" : {
        "task" : "base.tasks.clean_data_task",
        {{- if $clean_data_second }}
        "schedule": timedelta(seconds=int(re.sub(r"\D", "", {{ $clean_data_second | quote }}))),
        {{- else }}
        "schedule": crontab(hour="{{ $clean_data_hour }}", minute="{{ $clean_data_minute }}"),
        {{- end }}
    },
    # check for any posts that need to be posted
    "post_scheduler" : {
        "task" : "base.tasks.post_scheduler_task",
        {{- if $post_scheduler_second }}
        "schedule": timedelta(seconds=int(re.sub(r"\D", "", {{ $post_scheduler_second | quote }}))),
        {{- else }}
        "schedule": crontab(hour="{{ $post_scheduler_hour }}", minute="{{ $post_scheduler_minute }}"),
        {{- end }}
    },
    # update data
    "update_data" : {
        "task" : "base.tasks.update_data_task",
        {{- if $update_data_second }}
        "schedule": timedelta(seconds=int(re.sub(r"\D", "", {{ $update_data_second | quote }}))),
        {{- else }}
        "schedule": crontab(hour="{{ $update_data_hour }}", minute="{{ $update_data_minute }}"),
        {{- end }}
    },
}


@app.task(bind=True)
def debug_task(self):
    print("Request: {0!r}".format(self.request))
{{- end }}
