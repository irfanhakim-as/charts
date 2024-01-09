{{/*
Celery /base/base/__init__.py template
*/}}
{{- define "waktusolat.celery-init-py" -}}
from .celery import app as celery_app

__all__ = ("celery_app",)
{{- end }}
