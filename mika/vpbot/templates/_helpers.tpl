{{/*
Expand the name of the chart.
*/}}
{{- define "vpbot.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vpbot.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "vpbot.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "vpbot.labels" -}}
helm.sh/chart: {{ include "vpbot.chart" . }}
{{ include "vpbot.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "vpbot.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vpbot.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "vpbot.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "vpbot.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Apache site-config.conf template
*/}}
{{- define "vpbot.site-config-conf" -}}
<VirtualHost *:80>
    ServerName DOMAIN:443
    UseCanonicalName On
    ServerAdmin support@mikahomelab.com
    DocumentRoot /quarantine-bot
    WSGIScriptAlias / /quarantine-bot/quarantine_bot/wsgi.py
    WSGIDaemonProcess DOMAIN python-path=/quarantine-bot
    WSGIProcessGroup DOMAIN

    <Directory /quarantine-bot/quarantine_bot>
        <Files wsgi.py>
            Require all granted
        </Files>
    </Directory>

    Alias /static /static
    <Directory /static>
        Require all granted
    </Directory>

    Alias /media /quarantine-bot/media
    <Directory /quarantine-bot/media>
        Require all granted
    </Directory>

    ErrorLog /quarantine-bot/logs/apache.error.log
    CustomLog /quarantine-bot/logs/apache.access.log combined
</VirtualHost>
{{- end }}
