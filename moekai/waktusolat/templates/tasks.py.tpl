{{/*
APScheduler /base/base/tasks.py template
*/}}
{{- define "waktusolat.apscheduler-tasks-py" -}}

{{- $clean_db_hour := .Values.scheduler.schedule.clean_db.hour | default "0" | toString -}}
{{- $clean_db_minute := .Values.scheduler.schedule.clean_db.minute | default "0" | toString -}}
{{- $clean_db_second := .Values.scheduler.schedule.clean_db.second | default "0" | toString -}}
{{- $notify_solat_schedule_hour := .Values.scheduler.schedule.notify_solat_schedule.hour | default "5" | toString -}}
{{- $notify_solat_schedule_minute := .Values.scheduler.schedule.notify_solat_schedule.minute | default "0" | toString -}}
{{- $notify_solat_schedule_second := .Values.scheduler.schedule.notify_solat_schedule.second | default "0" | toString -}}
{{- $notify_solat_times_hour := .Values.scheduler.schedule.notify_solat_times.hour | default "*" | toString -}}
{{- $notify_solat_times_minute := .Values.scheduler.schedule.notify_solat_times.minute | default "*/1" | toString -}}
{{- $notify_solat_times_second := .Values.scheduler.schedule.notify_solat_times.second | default "0" | toString -}}
{{- $post_scheduler_hour := .Values.scheduler.schedule.post_scheduler.hour | default "*" | toString -}}
{{- $post_scheduler_minute := .Values.scheduler.schedule.post_scheduler.minute | default "*" | toString -}}
{{- $post_scheduler_second := .Values.scheduler.schedule.post_scheduler.second | default "*/1" | toString -}}

from apscheduler.schedulers.blocking import BlockingScheduler
from django.conf import settings
from lib.scheduler import post_scheduler
from lib.solat import (
    clean_db,
    notify_solat_schedule,
    notify_solat_times,
)


SCHEDULER_TIMEZONE = getattr(settings, "SCHEDULER_TIMEZONE")


def start():
    scheduler = BlockingScheduler(timezone=SCHEDULER_TIMEZONE)

    job_name = "clean_db"
    scheduler.add_job(clean_db, "cron", id=job_name, replace_existing=True, hour="{{ $clean_db_hour }}", minute="{{ $clean_db_minute }}", second="{{ $clean_db_second }}")

    job_name = "notify_solat_schedule"
    scheduler.add_job(notify_solat_schedule, "cron", id=job_name, replace_existing=True, hour="{{ $notify_solat_schedule_hour }}", minute="{{ $notify_solat_schedule_minute }}", second="{{ $notify_solat_schedule_second }}")

    job_name = "notify_solat_times"
    scheduler.add_job(notify_solat_times, "cron", id=job_name, replace_existing=True, hour="{{ $notify_solat_times_hour }}", minute="{{ $notify_solat_times_minute }}", second="{{ $notify_solat_times_second }}")

    job_name = "post_scheduler"
    scheduler.add_job(post_scheduler, "cron", id=job_name, replace_existing=True, hour="{{ $post_scheduler_hour }}", minute="{{ $post_scheduler_minute }}", second="{{ $post_scheduler_second }}")

    scheduler.start()
{{- end }}

{{/*
Celery /base/base/tasks.py template
*/}}
{{- define "waktusolat.celery-tasks-py" -}}
from __future__ import absolute_import, unicode_literals
from celery import shared_task
from lib.scheduler import post_scheduler
from lib.solat import (
    clean_db,
    notify_solat_schedule,
    notify_solat_times,
)


# clean and update prayer times
@shared_task
def clean_db_task():
    clean_db()


# notify solat schedule
@shared_task
def notify_solat_schedule_task():
    notify_solat_schedule()


# check and notify solat time
@shared_task
def notify_solat_times_task():
    notify_solat_times()


# check for any posts that need to be posted
@shared_task
def post_scheduler_task():
    post_scheduler()
{{- end }}
