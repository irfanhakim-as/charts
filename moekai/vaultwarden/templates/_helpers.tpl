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
Create the name of the service account to use
*/}}
{{- define "vaultwarden.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "vaultwarden.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Volume mounts for the storage volumes
*/}}
{{- define "vaultwarden.volumeMounts" -}}
{{- $dataPersistence := eq (include "vaultwarden.dataPersistence" .) "true" -}}
{{- $dataSubPath := include "vaultwarden.dataSubPath" . -}}
{{- if $dataPersistence -}}
volumeMounts:
  - name: {{ .Release.Name }}-vaultwarden-data
    mountPath: {{ include "vaultwarden.dataMountPath" . | quote }}
    {{- if $dataSubPath }}
    subPath: {{ $dataSubPath | quote }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Volumes for the storage volumes
*/}}
{{- define "vaultwarden.volumes" -}}
{{- $dataPersistence := eq (include "vaultwarden.dataPersistence" .) "true" -}}
{{- if $dataPersistence -}}
volumes:
  - name: {{ .Release.Name }}-vaultwarden-data
    persistentVolumeClaim:
      claimName: {{ .Release.Name }}-vaultwarden-data-pvc
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
