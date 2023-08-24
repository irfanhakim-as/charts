{{/*
Celery /base/base/__init__.py template
*/}}
{{- define "vpbot.celery-init-py" -}}
from .celery import app as celery_app

__all__ = ("celery_app",)
{{- end }}

{{/*
Celery /base/base/tasks.py template
*/}}
{{- define "vpbot.celery-tasks-py" -}}
from __future__ import absolute_import, unicode_literals
from celery import shared_task
from base.scheduler import object_scheduler
from lib.telegram import clean_model


# clean model
@shared_task
def clean_model_task():
    clean_model()


# check for any objects that need to be sent
@shared_task
def object_scheduler_task():
    object_scheduler()
{{- end }}
