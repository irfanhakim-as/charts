{{/*
Celery /base/base/celery.py template
*/}}
{{- define "rizz.celery-py" -}}
from __future__ import absolute_import, unicode_literals
import os
from celery import Celery
from celery.schedules import crontab
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "base.conf.main")
app = Celery("base")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks()


app.conf.beat_schedule = {
    # clean data
    "clean_data" : {
        "task" : "base.tasks.clean_data_task",
        "schedule" : crontab(hour=CLEAN_DATA_HOURS, minute="0"),
    },
    # update data
    "update_data" : {
        "task" : "base.tasks.update_data_task",
        "schedule" : crontab(hour=UPDATE_DATA_HOURS, minute="0"),
    },
    # check for any posts that need to be posted
    "post_scheduler" : {
        "task" : "base.tasks.post_scheduler_task",
        "schedule" : crontab(hour=POST_SCHEDULER_HOURS, minute="0"),
    },
}


@app.task(bind=True)
def debug_task(self):
    print("Request: {0!r}".format(self.request))
{{- end }}
