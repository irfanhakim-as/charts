{{/*
APScheduler /base/base/tasks.py template
*/}}
{{- define "rizz.apscheduler-tasks-py" -}}

{{- $clean_data_hour := .Values.rizz.scheduler.schedule.clean_data.hour | default "0" | toString -}}
{{- $clean_data_minute := .Values.rizz.scheduler.schedule.clean_data.minute | default "0" | toString -}}
{{- $clean_data_second := .Values.rizz.scheduler.schedule.clean_data.second | default "0" | toString -}}
{{- $post_scheduler_hour := .Values.rizz.scheduler.schedule.post_scheduler.hour | default "8-23/3" | toString -}}
{{- $post_scheduler_minute := .Values.rizz.scheduler.schedule.post_scheduler.minute | default "0" | toString -}}
{{- $post_scheduler_second := .Values.rizz.scheduler.schedule.post_scheduler.second | default "0" | toString -}}
{{- $update_data_hour := .Values.rizz.scheduler.schedule.update_data.hour | default "7-22/3" | toString -}}
{{- $update_data_minute := .Values.rizz.scheduler.schedule.update_data.minute | default "0" | toString -}}
{{- $update_data_second := .Values.rizz.scheduler.schedule.update_data.second | default "0" | toString -}}

from apscheduler.schedulers.blocking import BlockingScheduler
from django.conf import settings
from lib.rss import (
    clean_data,
    update_data,
)
from lib.scheduler import post_scheduler


SCHEDULER_TIMEZONE = getattr(settings, "SCHEDULER_TIMEZONE")


def start():
    scheduler = BlockingScheduler(timezone=SCHEDULER_TIMEZONE)

    job_name = "clean_data"
    scheduler.add_job(clean_data, "cron", id=job_name, replace_existing=True, hour="{{ $clean_data_hour }}", minute="{{ $clean_data_minute }}", second="{{ $clean_data_second }}")

    job_name = "post_scheduler"
    scheduler.add_job(post_scheduler, "cron", id=job_name, replace_existing=True, hour="{{ $post_scheduler_hour }}", minute="{{ $post_scheduler_minute }}", second="{{ $post_scheduler_second }}")

    job_name = "update_data"
    scheduler.add_job(update_data, "cron", id=job_name, replace_existing=True, hour="{{ $update_data_hour }}", minute="{{ $update_data_minute }}", second="{{ $update_data_second }}")

    scheduler.start()
{{- end }}

{{/*
Celery /base/base/tasks.py template
*/}}
{{- define "rizz.celery-tasks-py" -}}
from __future__ import absolute_import, unicode_literals
from celery import shared_task
from lib.rss import (
    clean_data,
    update_data,
)
from lib.scheduler import post_scheduler


# clean data
@shared_task
def clean_data_task():
    clean_data()


# update data
@shared_task
def update_data_task():
    update_data()


# check for any posts that need to be posted
@shared_task
def post_scheduler_task():
    post_scheduler()
{{- end }}
