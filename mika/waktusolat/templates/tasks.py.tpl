{{/*
APScheduler /base/base/tasks.py template
*/}}
{{- define "waktusolat.apscheduler-tasks-py" -}}
from apscheduler.schedulers.blocking import BlockingScheduler
from django.conf import settings
from lib import solat
from lib.scheduler import post_scheduler


SCHEDULER_TIMEZONE = getattr(settings, "SCHEDULER_TIMEZONE", None)


def start():
    scheduler = BlockingScheduler(timezone=SCHEDULER_TIMEZONE)

    job_name = "clean_db"
    scheduler.add_job(solat.clean_db, 'cron', hour='0', id=job_name, replace_existing=True)

    job_name = "notify_solat_schedule"
    scheduler.add_job(solat.notify_solat_schedule, 'cron', hour='5', id=job_name, replace_existing=True)

    job_name = "notify_solat_times"
    scheduler.add_job(solat.notify_solat_times, 'cron', minute='*', id=job_name, replace_existing=True)

    job_name = "post_scheduler"
    scheduler.add_job(post_scheduler, 'cron', second='*/1', id=job_name, replace_existing=True)

    scheduler.start()
{{- end }}

{{/*
Celery /base/base/tasks.py template
*/}}
{{- define "waktusolat.celery-tasks-py" -}}
from __future__ import absolute_import, unicode_literals
import logging
from celery import shared_task
from lib import solat
from lib.scheduler import post_scheduler
logger=logging.getLogger('base')


# clean and update prayer times
@shared_task
def clean_db_task():
    solat.clean_db()


# notify solat schedule
@shared_task
def notify_solat_schedule_task():
    solat.notify_solat_schedule()


# check and notify solat time
@shared_task
def notify_solat_times_task():
    solat.notify_solat_times()


# check for any posts that need to be posted
@shared_task
def post_scheduler_task():
    post_scheduler()
{{- end }}
