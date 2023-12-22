{{/*
Celery /base/base/celery.py template
*/}}
{{- define "waktusolat.celery-py" -}}
from __future__ import absolute_import, unicode_literals
import os
import re
from celery import Celery
from celery.schedules import crontab
from datetime import timedelta
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "base.settings.main")
app = Celery("base")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks()


# make integer from object scheduler seconds string
post_scheduler_seconds = int(re.sub(r"\D", "", POST_SCHEDULER_SECONDS))


app.conf.beat_schedule = {
    # clean and update prayer times
    "clean_db": {
        "task": "base.tasks.clean_db_task",
        "schedule": crontab(hour=CLEAN_DB_HOURS, minute="0"),
    },
    # notify solat schedule
    "notify_solat_schedule": {
        "task": "base.tasks.notify_solat_schedule_task",
        "schedule": crontab(hour=SOLAT_SCHED_HOURS, minute="0"),
    },
    # check and notify solat time
    "notify_solat_times": {
        "task": "base.tasks.notify_solat_times_task",
        "schedule": crontab(minute="*/" + SOLAT_NOTIF_MINUTES),
    },
    # check for any posts that need to be posted
    "post_scheduler": {
        "task": "base.tasks.post_scheduler_task",
        "schedule": timedelta(seconds=post_scheduler_seconds),
    },
}


@app.task(bind=True)
def debug_task(self):
    print("Request: {0!r}".format(self.request))
{{- end }}
