{{/*
APScheduler /entrypoint.sh template
*/}}
{{- define "rizz.apscheduler-entrypoint-sh" -}}
#!/bin/bash

export APP_ROOT="base"

# ================= DO NOT EDIT BEYOND THIS LINE =================

python3 manage.py makemigrations

python3 manage.py migrate

tail -f /dev/null
{{- end }}
