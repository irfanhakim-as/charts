{{/*
Resolve the public-facing domain, empty unless Ingress is enabled with a real domain configured.
*/}}
{{- define "mattermost.siteDomain" -}}
{{- $domain := .Values.mattermost.domain | toString }}
{{- ternary $domain "" (and .Values.ingress.enabled (ne $domain "") (ne $domain "localhost")) }}
{{- end }}

{{/*
The mount path for the data storage volume.
*/}}
{{- define "mattermost.dataMountPath" -}}
{{- .Values.storage.data.mountPath | default "/mattermost/data" | toString }}
{{- end }}

{{/*
The mount path for the log storage volume.
*/}}
{{- define "mattermost.logMountPath" -}}
{{- .Values.storage.log.mountPath | default "/mattermost/logs" | toString }}
{{- end }}

{{/*
Specifies whether persistent storage is enabled for the data storage volume.
*/}}
{{- define "mattermost.dataPersistence" -}}
{{- .Values.storage.data.enabled }}
{{- end }}

{{/*
Specifies whether persistent storage is enabled for the log storage volume.
*/}}
{{- define "mattermost.logPersistence" -}}
{{- .Values.storage.log.enabled }}
{{- end }}
