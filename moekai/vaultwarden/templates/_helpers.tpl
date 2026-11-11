{{/*
Expand the name of the chart.
*/}}
{{- define "vaultwarden.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vaultwarden.fullname" -}}
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
{{- define "vaultwarden.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "vaultwarden.labels" -}}
helm.sh/chart: {{ include "vaultwarden.chart" . }}
{{ include "vaultwarden.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "vaultwarden.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vaultwarden.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Volume mounts for the storage volumes
*/}}
{{- define "vaultwarden.volumeMounts" -}}
{{- $dataPersistence := eq (include "vaultwarden.dataPersistence" .) "true" -}}
{{- $dataSubPath := include "vaultwarden.dataSubPath" . -}}
{{- $extraVolumeMounts := include "vaultwarden.extraVolumeMounts" . -}}
{{- if or $dataPersistence $extraVolumeMounts -}}
volumeMounts:
  {{- if $dataPersistence }}
  - name: {{ .Release.Name }}-vaultwarden-data
    mountPath: {{ include "vaultwarden.dataMountPath" . | quote }}
    {{- if $dataSubPath }}
    subPath: {{ $dataSubPath | quote }}
    {{- end }}
  {{- end }}
  {{- with $extraVolumeMounts }}
  {{- . | nindent 2 }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Volumes for the storage volumes
*/}}
{{- define "vaultwarden.volumes" -}}
{{- $dataPersistence := eq (include "vaultwarden.dataPersistence" .) "true" -}}
{{- $extraVolumes := include "vaultwarden.extraVolumes" . -}}
{{- if or $dataPersistence $extraVolumes -}}
volumes:
  {{- if $dataPersistence }}
  - name: {{ .Release.Name }}-vaultwarden-data
    persistentVolumeClaim:
      claimName: {{ .Release.Name }}-vaultwarden-data-pvc
  {{- end }}
  {{- with $extraVolumes }}
  {{- . | nindent 2 }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Ingress annotations
*/}}
{{- define "vaultwarden.ingressAnnotations" -}}
cert-manager.io/cluster-issuer: {{ include "vaultwarden.clusterIssuer" . | quote }}
cert-manager.io/private-key-algorithm: "ECDSA"
nginx.ingress.kubernetes.io/affinity: "cookie"
nginx.ingress.kubernetes.io/affinity-mode: "persistent"
nginx.ingress.kubernetes.io/proxy-body-size: "100m"
nginx.ingress.kubernetes.io/session-cookie-expires: "172800"
nginx.ingress.kubernetes.io/session-cookie-max-age: "172800"
nginx.ingress.kubernetes.io/session-cookie-name: "route"
nginx.org/client-max-body-size: "100m"
{{- range .Values.ingress.customAnnotations }}
{{ printf "%s/%s" (.prefix | default "nginx.ingress.kubernetes.io") .name }}: {{ .value | quote }}
{{- end }}
{{- end }}

{{/*
Whether the Secret has any data to render
*/}}
{{- define "vaultwarden.secretEnabled" -}}
{{- $values := list
  (include "vaultwarden.dbUrl" .)
  (ternary (include "vaultwarden.pushId" .) "" (eq (include "vaultwarden.pushEnabled" .) "true"))
  (ternary (include "vaultwarden.pushKey" .) "" (eq (include "vaultwarden.pushEnabled" .) "true"))
  (include "vaultwarden.hibpApiKey" .)
  (include "vaultwarden.adminToken" .)
  (include "vaultwarden.ssoClientSecret" .)
  (ternary (include "vaultwarden.yubicoId" .) "" (eq (include "vaultwarden.yubicoEnabled" .) "true"))
  (ternary (include "vaultwarden.yubicoKey" .) "" (eq (include "vaultwarden.yubicoEnabled" .) "true"))
  (ternary (include "vaultwarden.duoId" .) "" (eq (include "vaultwarden.duoEnabled" .) "true"))
  (ternary (include "vaultwarden.duoKey" .) "" (eq (include "vaultwarden.duoEnabled" .) "true"))
  (ternary (include "vaultwarden.smtpUser" .) "" (eq (include "vaultwarden.mailEnabled" .) "true"))
  (ternary (include "vaultwarden.smtpPassword" .) "" (eq (include "vaultwarden.mailEnabled" .) "true"))
-}}
{{- gt (len (compact $values)) 0 }}
{{- end }}

{{/*
Startup probe for the Vaultwarden container
*/}}
{{- define "vaultwarden.startupProbe" -}}
{{- $enabled := .Values.probes.vaultwarden.startup.enabled -}}
{{- $spec := .Values.probes.vaultwarden.startup.spec -}}
{{- if and $enabled $spec -}}
startupProbe:
  {{- toYaml $spec | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Liveness probe for the Vaultwarden container
*/}}
{{- define "vaultwarden.livenessProbe" -}}
{{- $enabled := .Values.probes.vaultwarden.liveness.enabled -}}
{{- $spec := .Values.probes.vaultwarden.liveness.spec -}}
{{- if $enabled -}}
livenessProbe:
  {{- if $spec }}
  {{- toYaml $spec | nindent 2 }}
  {{- else }}
  httpGet:
    path: {{ include "vaultwarden.probePath" . }}
    port: vaultwarden
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3
  successThreshold: 1
  {{- end }}
{{- end }}
{{- end }}

{{/*
Readiness probe for the Vaultwarden container
*/}}
{{- define "vaultwarden.readinessProbe" -}}
{{- $enabled := .Values.probes.vaultwarden.readiness.enabled -}}
{{- $spec := .Values.probes.vaultwarden.readiness.spec -}}
{{- if $enabled -}}
readinessProbe:
  {{- if $spec }}
  {{- toYaml $spec | nindent 2 }}
  {{- else }}
  httpGet:
    path: {{ include "vaultwarden.probePath" . }}
    port: vaultwarden
  initialDelaySeconds: 10
  periodSeconds: 5
  timeoutSeconds: 5
  failureThreshold: 6
  successThreshold: 1
  {{- end }}
{{- end }}
{{- end }}

{{/*
Path of the health endpoint
*/}}
{{- define "vaultwarden.probePath" -}}
/alive
{{- end }}
