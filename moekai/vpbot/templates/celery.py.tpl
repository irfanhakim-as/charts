{{/*
Celery /base/base/celery.py template
*/}}
{{- define "vpbot.celery-py" -}}
from __future__ import absolute_import, unicode_literals
import re
import os
from celery import Celery
from celery.schedules import crontab
from datetime import timedelta
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "base.settings")
app = Celery("base")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks()


# make integer from object scheduler seconds string
object_scheduler_seconds = int(re.sub(r"\D", "", OBJECT_SCHEDULER_SECONDS))


app.conf.beat_schedule = {
    # clean telegram model
    "telegram_clean_model" : {
        "task" : "base.tasks.telegram_clean_model_task",
        "schedule" : crontab(hour=CLEAN_MODEL_HOURS, minute="0"),
    },
    # check for any objects that need to be sent
    "object_scheduler" : {
        "task" : "base.tasks.object_scheduler_task",
        "schedule" : timedelta(seconds=object_scheduler_seconds),
    },
    # clean solat db
    "solat_clean_db" : {
        "task" : "base.tasks.solat_clean_db_task",
        "schedule" : crontab(hour=SOLAT_CLEAN_DB_HOURS, minute="0"),
    },
    # send prayer time notifications
    "solat_notify_solat_times" : {
        "task" : "base.tasks.solat_notify_solat_times_task",
        "schedule" : crontab(minute="*/" + SOLAT_NOTIF_MINUTES),
    },
}


@app.task(bind=True)
def debug_task(self):
    print("Request: {0!r}".format(self.request))
{{- end }}
