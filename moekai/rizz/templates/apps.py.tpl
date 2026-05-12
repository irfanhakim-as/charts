{{/*
APScheduler /base/base/apps.py template
*/}}
{{- define "rizz.apscheduler-apps-py" -}}
from django.apps import AppConfig

class BaseConfig(AppConfig):
    name = "base"

    def ready(self):
        from . import signals
        from . import tasks
        tasks.start()
{{- end }}
