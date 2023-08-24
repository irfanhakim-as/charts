{{/*
APScheduler /base/base/tasks.py template
*/}}
{{- define "vpbot.apscheduler-tasks-py" -}}
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
    scheduler.add_job(object_scheduler, "cron", second="*/" + OBJECT_SCHEDULER_SECONDS, id=job_name, replace_existing=True)

    scheduler.start()
{{- end }}
