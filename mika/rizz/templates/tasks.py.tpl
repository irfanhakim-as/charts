{{/*
APScheduler /base/base/tasks.py template
*/}}
{{- define "rizz.apscheduler-tasks-py" -}}
from django.conf import settings
from lib.rss import (
    clean_data,
    update_data,
)
from lib.scheduler import post_scheduler
from apscheduler.schedulers.blocking import BlockingScheduler


SCHEDULER_TIMEZONE = getattr(settings, "SCHEDULER_TIMEZONE")


def start():
    scheduler = BlockingScheduler(timezone=SCHEDULER_TIMEZONE)

    job_name = "clean_data"
    scheduler.add_job(clean_data, "cron", hour=CLEAN_DATA_HOURS, id=job_name, replace_existing=True)

    job_name = "update_data"
    scheduler.add_job(update_data, "cron", hour=UPDATE_DATA_HOURS, id=job_name, replace_existing=True)

    job_name = "post_scheduler"
    scheduler.add_job(post_scheduler, "cron", hour=POST_SCHEDULER_HOURS, id=job_name, replace_existing=True)

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
