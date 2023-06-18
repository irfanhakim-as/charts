{{/*
Expand the name of the chart.
*/}}
{{- define "clog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "clog.fullname" -}}
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
{{- define "clog.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "clog.labels" -}}
helm.sh/chart: {{ include "clog.chart" . }}
{{ include "clog.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "clog.selectorLabels" -}}
app.kubernetes.io/name: {{ include "clog.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "clog.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "clog.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Apache site-config.conf template
*/}}
{{- define "clog.site-config-conf" -}}
<VirtualHost *:80>
    ServerName DOMAIN:443
    UseCanonicalName On
    ServerAdmin support@mikahomelab.com
    DocumentRoot /clog
    WSGIScriptAlias / /clog/clog/wsgi.py
    WSGIDaemonProcess DOMAIN python-path=/clog
    WSGIProcessGroup DOMAIN

    <Directory /clog/clog>
        <Files wsgi.py>
            Require all granted
        </Files>
    </Directory>

    Alias /static /static
    <Directory /static>
        Require all granted
    </Directory>

    Alias /media /clog/media
    <Directory /clog/media>
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/apache.error.log
    CustomLog /var/log/apache2/apache.access.log combined
</VirtualHost>
{{- end }}
