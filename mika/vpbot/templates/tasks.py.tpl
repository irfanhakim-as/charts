{{/*
APScheduler /base/base/tasks.py template
*/}}
{{- define "vpbot.apscheduler-tasks-py" -}}
from apscheduler.schedulers.blocking import BlockingScheduler
from django.conf import settings
from base.scheduler import object_scheduler
from lib import (
    solat,
    telegram,
)


SCHEDULER_TIMEZONE = getattr(settings, "SCHEDULER_TIMEZONE")


def start():
    scheduler = BlockingScheduler(timezone=SCHEDULER_TIMEZONE)

    job_name = "telegram_clean_model"
    scheduler.add_job(telegram.clean_model, "cron", hour=CLEAN_MODEL_HOURS, id=job_name, replace_existing=True)

    job_name = "object_scheduler"
    scheduler.add_job(object_scheduler, "cron", second="*/" + OBJECT_SCHEDULER_SECONDS, id=job_name, replace_existing=True)

    job_name = "solat_clean_db"
    scheduler.add_job(solat.clean_db, "cron", hour=SOLAT_CLEAN_DB_HOURS, id=job_name, replace_existing=True)

    job_name = "solat_notify_solat_times"
    scheduler.add_job(solat.notify_solat_times, "cron", minute="*/" + SOLAT_NOTIF_MINUTES, id=job_name, replace_existing=True)

    scheduler.start()
{{- end }}

{{/*
Celery /base/base/tasks.py template
*/}}
{{- define "vpbot.celery-tasks-py" -}}
from __future__ import absolute_import, unicode_literals
from celery import shared_task
from base.scheduler import object_scheduler
from lib import (
    solat,
    telegram,
)


# clean telegram model
@shared_task
def telegram_clean_model_task():
    telegram.clean_model()


# check for any objects that need to be sent
@shared_task
def object_scheduler_task():
    object_scheduler()


# clean solat db
@shared_task
def solat_clean_db_task():
    solat.clean_db()


# send prayer time notifications
@shared_task
def solat_notify_solat_times_task():
    solat.notify_solat_times()
{{- end }}
