{{/*
Celery /base/base/celery.py template
*/}}
{{- define "waktusolat.celery-py" -}}
from __future__ import absolute_import, unicode_literals
import os
from celery import Celery
from celery.schedules import crontab
from datetime import timedelta
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
        "schedule": crontab(minute="*/1"),
    },
    # check for any posts that need to be posted every 1 second
    "post_scheduler_every_1s": {
        "task": "base.tasks.post_scheduler_task",
        "schedule": timedelta(seconds=1),
    },
}


@app.task(bind=True)
def debug_task(self):
    print("Request: {0!r}".format(self.request))
{{- end }}
