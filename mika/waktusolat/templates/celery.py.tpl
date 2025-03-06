{{/*
Celery /base/base/celery.py template
*/}}
{{- define "waktusolat.celery-py" -}}

{{- $clean_db_hour := .Values.scheduler.schedule.clean_db.hour | default "0" | toString -}}
{{- $clean_db_minute := .Values.scheduler.schedule.clean_db.minute | default "0" | toString -}}
{{- $clean_db_second := .Values.scheduler.schedule.clean_db.second | toString -}}
{{- $notify_solat_schedule_hour := .Values.scheduler.schedule.notify_solat_schedule.hour | default "5" | toString -}}
{{- $notify_solat_schedule_minute := .Values.scheduler.schedule.notify_solat_schedule.minute | default "0" | toString -}}
{{- $notify_solat_schedule_second := .Values.scheduler.schedule.notify_solat_schedule.second | toString -}}
{{- $notify_solat_times_hour := .Values.scheduler.schedule.notify_solat_times.hour | default "*" | toString -}}
{{- $notify_solat_times_minute := .Values.scheduler.schedule.notify_solat_times.minute | default "*/1" | toString -}}
{{- $notify_solat_times_second := .Values.scheduler.schedule.notify_solat_times.second | toString -}}
{{- $post_scheduler_hour := .Values.scheduler.schedule.post_scheduler.hour | default "*" | toString -}}
{{- $post_scheduler_minute := .Values.scheduler.schedule.post_scheduler.minute | default "*" | toString -}}
{{- $post_scheduler_second := .Values.scheduler.schedule.post_scheduler.second | toString -}}

from __future__ import absolute_import, unicode_literals
import os
import re
from celery import Celery
from celery.schedules import crontab
from datetime import timedelta
from dotenv import load_dotenv; load_dotenv()
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "base.conf.main")
app = Celery("base")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks()


app.conf.beat_schedule = {
    # clean and update prayer times
    "clean_db": {
        "task": "base.tasks.clean_db_task",
        {{- if $clean_db_second }}
        "schedule": timedelta(seconds=int(re.sub(r"\D", "", {{ $clean_db_second | quote }}))),
        {{- else }}
        "schedule": crontab(hour="{{ $clean_db_hour }}", minute="{{ $clean_db_minute }}"),
        {{- end }}
    },
    # notify solat schedule
    "notify_solat_schedule": {
        "task": "base.tasks.notify_solat_schedule_task",
        {{- if $notify_solat_schedule_second }}
        "schedule": timedelta(seconds=int(re.sub(r"\D", "", {{ $notify_solat_schedule_second | quote }}))),
        {{- else }}
        "schedule": crontab(hour="{{ $notify_solat_schedule_hour }}", minute="{{ $notify_solat_schedule_minute }}"),
        {{- end }}
    },
    # check and notify solat time
    "notify_solat_times": {
        "task": "base.tasks.notify_solat_times_task",
        {{- if $notify_solat_times_second }}
        "schedule": timedelta(seconds=int(re.sub(r"\D", "", {{ $notify_solat_times_second | quote }}))),
        {{- else }}
        "schedule": crontab(hour="{{ $notify_solat_times_hour }}", minute="{{ $notify_solat_times_minute }}"),
        {{- end }}
    },
    # check for any posts that need to be posted
    "post_scheduler": {
        "task": "base.tasks.post_scheduler_task",
        {{- if $post_scheduler_second }}
        "schedule": timedelta(seconds=int(re.sub(r"\D", "", {{ $post_scheduler_second | quote }}))),
        {{- else }}
        "schedule": crontab(hour="{{ $post_scheduler_hour }}", minute="{{ $post_scheduler_minute }}"),
        {{- end }}
    },
}


@app.task(bind=True)
def debug_task(self):
    print("Request: {0!r}".format(self.request))
{{- end }}
