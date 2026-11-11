{{/*
Expand the name of the chart.
*/}}
{{- define "linkding.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "linkding.fullname" -}}
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
{{- define "linkding.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "linkding.labels" -}}
helm.sh/chart: {{ include "linkding.chart" . }}
{{ include "linkding.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "linkding.selectorLabels" -}}
app.kubernetes.io/name: {{ include "linkding.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Volume mounts for the storage volumes
*/}}
{{- define "linkding.volumeMounts" -}}
{{- $dataPersistence := eq (include "linkding.dataPersistence" .) "true" -}}
{{- $dataSubPath := include "linkding.dataSubPath" . -}}
{{- $extraVolumeMounts := include "linkding.extraVolumeMounts" . -}}
{{- if or $dataPersistence $extraVolumeMounts -}}
volumeMounts:
  {{- if $dataPersistence }}
  - name: {{ .Release.Name }}-linkding-data
    mountPath: {{ include "linkding.dataMountPath" . | quote }}
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
{{- define "linkding.volumes" -}}
{{- $dataPersistence := eq (include "linkding.dataPersistence" .) "true" -}}
{{- $extraVolumes := include "linkding.extraVolumes" . -}}
{{- if or $dataPersistence $extraVolumes -}}
volumes:
  {{- if $dataPersistence }}
  - name: {{ .Release.Name }}-linkding-data
    persistentVolumeClaim:
      claimName: {{ .Release.Name }}-linkding-data-pvc
  {{- end }}
  {{- with $extraVolumes }}
  {{- . | nindent 2 }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Ingress annotations
*/}}
{{- define "linkding.ingressAnnotations" -}}
cert-manager.io/cluster-issuer: {{ include "linkding.clusterIssuer" . | quote }}
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
{{- define "linkding.secretEnabled" -}}
{{- $values := list
  (include "linkding.adminUser" .)
  (include "linkding.adminPassword" .)
  (ternary (include "linkding.dbUser" .) "" (eq (include "linkding.dbType" .) "postgres"))
  (ternary (include "linkding.dbPassword" .) "" (eq (include "linkding.dbType" .) "postgres"))
-}}
{{- gt (len (compact $values)) 0 }}
{{- end }}
