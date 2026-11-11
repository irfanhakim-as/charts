{{/*
Expand the name of the chart.
*/}}
{{- define "pocket-id.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pocket-id.fullname" -}}
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
{{- define "pocket-id.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pocket-id.labels" -}}
helm.sh/chart: {{ include "pocket-id.chart" . }}
{{ include "pocket-id.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pocket-id.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pocket-id.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Whether the Secret has any data to render
*/}}
{{- define "pocket-id.secretEnabled" -}}
{{- $values := list
  (include "pocket-id.encryptionKey" .)
  (include "pocket-id.staticApiKey" .)
  (include "pocket-id.ldapBindDn" .)
  (include "pocket-id.ldapBindPassword" .)
  (include "pocket-id.maxmindLicenseKey" .)
  (include "pocket-id.smtpUser" .)
  (include "pocket-id.smtpPassword" .)
  (include "pocket-id.s3AccessKeyId" .)
  (include "pocket-id.s3SecretAccessKey" .)
  (include "pocket-id.tlsKey" .)
  (include "pocket-id.dbUrl" .)
-}}
{{- gt (len (compact $values)) 0 }}
{{- end }}

{{/*
Volume mounts for the storage volumes
*/}}
{{- define "pocket-id.volumeMounts" -}}
{{- $dataPersistence := eq (include "pocket-id.dataPersistence" .) "true" -}}
{{- $dataSubPath := include "pocket-id.dataSubPath" . -}}
{{- $extraVolumeMounts := include "pocket-id.extraVolumeMounts" . -}}
{{- if or $dataPersistence $extraVolumeMounts -}}
volumeMounts:
  {{- if $dataPersistence }}
  - name: {{ .Release.Name }}-pocket-id-data
    mountPath: {{ include "pocket-id.dataMountPath" . | quote }}
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
{{- define "pocket-id.volumes" -}}
{{- $dataPersistence := eq (include "pocket-id.dataPersistence" .) "true" -}}
{{- $extraVolumes := include "pocket-id.extraVolumes" . -}}
{{- if or $dataPersistence $extraVolumes -}}
volumes:
  {{- if $dataPersistence }}
  - name: {{ .Release.Name }}-pocket-id-data
    persistentVolumeClaim:
      claimName: {{ .Release.Name }}-pocket-id-data-pvc
  {{- end }}
  {{- with $extraVolumes }}
  {{- . | nindent 2 }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Startup probe for the Pocket ID container
*/}}
{{- define "pocket-id.startupProbe" -}}
{{- $enabled := .Values.probes.pocketid.startup.enabled -}}
{{- $spec := .Values.probes.pocketid.startup.spec -}}
{{- if and $enabled $spec -}}
startupProbe:
  {{- toYaml $spec | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Liveness probe for the Pocket ID container
*/}}
{{- define "pocket-id.livenessProbe" -}}
{{- $enabled := .Values.probes.pocketid.liveness.enabled -}}
{{- $spec := .Values.probes.pocketid.liveness.spec -}}
{{- if $enabled -}}
livenessProbe:
  {{- if $spec }}
  {{- toYaml $spec | nindent 2 }}
  {{- else }}
  httpGet:
    path: /healthz
    port: http
    {{- if eq (include "pocket-id.tlsEnabled" .) "true" }}
    scheme: HTTPS
    {{- end }}
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3
  successThreshold: 1
  {{- end }}
{{- end }}
{{- end }}

{{/*
Readiness probe for the Pocket ID container
*/}}
{{- define "pocket-id.readinessProbe" -}}
{{- $enabled := .Values.probes.pocketid.readiness.enabled -}}
{{- $spec := .Values.probes.pocketid.readiness.spec -}}
{{- if $enabled -}}
readinessProbe:
  {{- if $spec }}
  {{- toYaml $spec | nindent 2 }}
  {{- else }}
  httpGet:
    path: /healthz
    port: http
    {{- if eq (include "pocket-id.tlsEnabled" .) "true" }}
    scheme: HTTPS
    {{- end }}
  initialDelaySeconds: 10
  periodSeconds: 5
  timeoutSeconds: 5
  failureThreshold: 6
  successThreshold: 1
  {{- end }}
{{- end }}
{{- end }}

{{/*
Ingress annotations
*/}}
{{- define "pocket-id.ingressAnnotations" -}}
cert-manager.io/cluster-issuer: {{ include "pocket-id.clusterIssuer" . | quote }}
cert-manager.io/private-key-algorithm: "ECDSA"
nginx.ingress.kubernetes.io/affinity: "cookie"
nginx.ingress.kubernetes.io/affinity-mode: "persistent"
nginx.ingress.kubernetes.io/proxy-body-size: "100m"
# Pocket ID sends response headers larger than the default nginx buffers
nginx.ingress.kubernetes.io/proxy-buffer-size: "256k"
nginx.ingress.kubernetes.io/proxy-buffers-number: "4"
nginx.ingress.kubernetes.io/proxy-busy-buffers-size: "512k"
nginx.ingress.kubernetes.io/session-cookie-expires: "172800"
nginx.ingress.kubernetes.io/session-cookie-max-age: "172800"
nginx.ingress.kubernetes.io/session-cookie-name: "route"
nginx.org/client-max-body-size: "100m"
{{- range .Values.ingress.customAnnotations }}
{{ printf "%s/%s" (.prefix | default "nginx.ingress.kubernetes.io") .name }}: {{ .value | quote }}
{{- end }}
{{- end }}
