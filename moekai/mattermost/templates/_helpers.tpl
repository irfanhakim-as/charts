{{/*
Expand the name of the chart.
*/}}
{{- define "mattermost.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mattermost.fullname" -}}
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
{{- define "mattermost.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mattermost.labels" -}}
helm.sh/chart: {{ include "mattermost.chart" . }}
{{ include "mattermost.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mattermost.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mattermost.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mattermost.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mattermost.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Volume mounts for the storage volumes
*/}}
{{- define "mattermost.volumeMounts" -}}
{{- $dataPersistence := eq (include "mattermost.dataPersistence" .) "true" -}}
{{- $logPersistence := eq (include "mattermost.logPersistence" .) "true" -}}
{{- $dataSubPath := include "mattermost.dataSubPath" . -}}
{{- $logSubPath := include "mattermost.logSubPath" . -}}
{{- if or $dataPersistence $logPersistence -}}
volumeMounts:
  {{- if $dataPersistence }}
  - name: {{ .Release.Name }}-mattermost-data
    mountPath: {{ include "mattermost.dataMountPath" . | quote }}
    {{- if $dataSubPath }}
    subPath: {{ $dataSubPath | quote }}
    {{- end }}
  {{- end }}
  {{- if $logPersistence }}
  - name: {{ .Release.Name }}-mattermost-log
    mountPath: {{ include "mattermost.logMountPath" . | quote }}
    {{- if $logSubPath }}
    subPath: {{ $logSubPath | quote }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Volumes for the storage volumes
*/}}
{{- define "mattermost.volumes" -}}
{{- $dataPersistence := eq (include "mattermost.dataPersistence" .) "true" -}}
{{- $logPersistence := eq (include "mattermost.logPersistence" .) "true" -}}
{{- if or $dataPersistence $logPersistence -}}
volumes:
  {{- if $dataPersistence }}
  - name: {{ .Release.Name }}-mattermost-data
    persistentVolumeClaim:
      claimName: {{ .Release.Name }}-mattermost-data-pvc
  {{- end }}
  {{- if $logPersistence }}
  - name: {{ .Release.Name }}-mattermost-log
    persistentVolumeClaim:
      claimName: {{ .Release.Name }}-mattermost-log-pvc
  {{- end }}
{{- end }}
{{- end }}

{{/*
Startup probe for the Mattermost container
*/}}
{{- define "mattermost.startupProbe" -}}
{{- $enabled := .Values.probes.mattermost.startup.enabled -}}
{{- $spec := .Values.probes.mattermost.startup.spec -}}
{{- if and $enabled $spec -}}
startupProbe:
  {{- toYaml $spec | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Liveness probe for the Mattermost container
*/}}
{{- define "mattermost.livenessProbe" -}}
{{- $enabled := .Values.probes.mattermost.liveness.enabled -}}
{{- $spec := .Values.probes.mattermost.liveness.spec -}}
{{- if $enabled -}}
livenessProbe:
  {{- if $spec }}
  {{- toYaml $spec | nindent 2 }}
  {{- else }}
  httpGet:
    path: /api/v4/system/ping
    port: mattermost
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3
  successThreshold: 1
  {{- end }}
{{- end }}
{{- end }}

{{/*
Readiness probe for the Mattermost container
*/}}
{{- define "mattermost.readinessProbe" -}}
{{- $enabled := .Values.probes.mattermost.readiness.enabled -}}
{{- $spec := .Values.probes.mattermost.readiness.spec -}}
{{- if $enabled -}}
readinessProbe:
  {{- if $spec }}
  {{- toYaml $spec | nindent 2 }}
  {{- else }}
  httpGet:
    path: /api/v4/system/ping
    port: mattermost
  initialDelaySeconds: 10
  periodSeconds: 5
  timeoutSeconds: 5
  failureThreshold: 6
  successThreshold: 1
  {{- end }}
{{- end }}
{{- end }}
