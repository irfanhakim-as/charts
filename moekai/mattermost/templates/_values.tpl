{{/*
The desired number of running replicas for Mattermost.
*/}}
{{- define "mattermost.replicaCount" -}}
{{- .Values.replicaCount | default "1" | toString }}
{{- end }}

{{/*
Annotations to apply to Mattermost pods.
*/}}
{{- define "mattermost.podAnnotations" -}}
{{- with .Values.podAnnotations -}}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Pod-level security context for Mattermost.
*/}}
{{- define "mattermost.podSecurityContext" -}}
{{- toYaml (merge (dict) .Values.podSecurityContext (dict "fsGroup" 2000)) }}
{{- end }}

{{/*
Container-level security context for Mattermost.
*/}}
{{- define "mattermost.containerSecurityContext" -}}
{{- with .Values.containerSecurityContext -}}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Container images used for Mattermost.
*/}}
{{- define "mattermost.imageRegistry" -}}
{{- .Values.image.mattermost.registry | default "docker.io" | toString }}
{{- end }}

{{- define "mattermost.imageRepository" -}}
{{- .Values.image.mattermost.repository | default "mattermost/mattermost-team-edition" | toString }}
{{- end }}

{{- define "mattermost.imageTag" -}}
{{- .Values.image.mattermost.tag | default .Chart.AppVersion | toString }}
{{- end }}

{{- define "mattermost.imagePullPolicy" -}}
{{- .Values.image.mattermost.pullPolicy | default "IfNotPresent" | toString }}
{{- end }}

{{- define "mattermost.initImageRegistry" -}}
{{- .Values.image.init.registry | default "docker.io" | toString }}
{{- end }}

{{- define "mattermost.initImageRepository" -}}
{{- .Values.image.init.repository | default "busybox" | toString }}
{{- end }}

{{- define "mattermost.initImageTag" -}}
{{- .Values.image.init.tag | default "1.36.1" | toString }}
{{- end }}

{{- define "mattermost.initImagePullPolicy" -}}
{{- .Values.image.init.pullPolicy | default "IfNotPresent" | toString }}
{{- end }}

{{/*
Credentials for pulling Mattermost container images from private registries.
*/}}
{{- define "mattermost.imagePullSecrets" -}}
{{- with .Values.imagePullSecrets -}}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Mattermost configurations.
*/}}
{{- define "mattermost.siteDomain" -}}
{{- $domain := .Values.mattermost.domain | toString }}
{{- ternary $domain "" (and .Values.ingress.enabled (ne $domain "") (ne $domain "localhost")) }}
{{- end }}

{{- define "mattermost.siteUrl" -}}
{{- $domain := include "mattermost.siteDomain" . }}
{{- ternary (printf "https://%s" $domain) "" (ne $domain "") }}
{{- end }}

{{- define "mattermost.timezone" -}}
{{- .Values.mattermost.timezone | toString }}
{{- end }}

{{- define "mattermost.initScript" -}}
{{- .Values.mattermost.initScript | toString }}
{{- end }}

{{/*
Mail configurations.
*/}}
{{- define "mattermost.smtpHost" -}}
{{- .Values.mail.smtp.host | toString }}
{{- end }}

{{- define "mattermost.smtpPort" -}}
{{- .Values.mail.smtp.port | default "587" | toString }}
{{- end }}

{{- define "mattermost.smtpUser" -}}
{{- .Values.mail.smtp.user | toString }}
{{- end }}

{{- define "mattermost.smtpPassword" -}}
{{- .Values.mail.smtp.password | toString }}
{{- end }}

{{- define "mattermost.feedbackEmail" -}}
{{- .Values.mail.feedbackEmail | default (include "mattermost.smtpUser" .) | toString }}
{{- end }}

{{/*
Push notification configurations.
*/}}
{{- define "mattermost.sendPushNotifications" -}}
{{- .Values.push.sendPushNotifications | default "false" | toString }}
{{- end }}

{{- define "mattermost.pushNotificationServer" -}}
{{- .Values.push.pushNotificationServer | toString }}
{{- end }}

{{/*
S3-compatible file storage configurations.
*/}}
{{- define "mattermost.s3AccessKeyId" -}}
{{- .Values.s3.accessKeyId | toString }}
{{- end }}

{{- define "mattermost.s3SecretAccessKey" -}}
{{- .Values.s3.secretAccessKey | toString }}
{{- end }}

{{- define "mattermost.s3Bucket" -}}
{{- .Values.s3.bucket | toString }}
{{- end }}

{{- define "mattermost.s3Endpoint" -}}
{{- .Values.s3.endpoint | toString }}
{{- end }}

{{- define "mattermost.s3Region" -}}
{{- .Values.s3.region | toString }}
{{- end }}

{{- define "mattermost.s3Ssl" -}}
{{- .Values.s3.ssl | default "true" | toString }}
{{- end }}

{{/*
Database configurations.
*/}}
{{- define "mattermost.dbType" -}}
{{- .Values.db.type | default "postgres" | toString }}
{{- end }}

{{- define "mattermost.dbHost" -}}
{{- .Values.db.host | toString }}
{{- end }}

{{- define "mattermost.dbPort" -}}
{{- $defaultPort := ternary "3306" "5432" (eq (include "mattermost.dbType" .) "mysql") -}}
{{- .Values.db.port | default $defaultPort | toString }}
{{- end }}

{{- define "mattermost.dbName" -}}
{{- .Values.db.name | toString }}
{{- end }}

{{- define "mattermost.dbUser" -}}
{{- .Values.db.user | toString }}
{{- end }}

{{- define "mattermost.dbPassword" -}}
{{- .Values.db.password | toString }}
{{- end }}

{{- define "mattermost.dbSslMode" -}}
{{- .Values.db.sslMode | default "disable" | toString }}
{{- end }}

{{- define "mattermost.dbConnectTimeout" -}}
{{- .Values.db.connectTimeout | default "10" | toString }}
{{- end }}

{{- define "mattermost.dbCharset" -}}
{{- .Values.db.charset | default "utf8mb4" | toString }}
{{- end }}

{{- define "mattermost.dbUrl" -}}
{{- $type := include "mattermost.dbType" . -}}
{{- $user := include "mattermost.dbUser" . -}}
{{- $password := include "mattermost.dbPassword" . -}}
{{- $host := include "mattermost.dbHost" . -}}
{{- $port := include "mattermost.dbPort" . -}}
{{- $name := include "mattermost.dbName" . -}}
{{- if eq $type "mysql" -}}
{{- printf "%s:%s@tcp(%s:%s)/%s?charset=%s" $user $password $host $port $name (include "mattermost.dbCharset" .) }}
{{- else -}}
{{- printf "%s://%s:%s@%s:%s/%s?sslmode=%s&connect_timeout=%s" $type $user $password $host $port $name (include "mattermost.dbSslMode" .) (include "mattermost.dbConnectTimeout" .) }}
{{- end }}
{{- end }}

{{/*
Ingress configurations.
*/}}
{{- define "mattermost.clusterIssuer" -}}
{{- .Values.ingress.clusterIssuer | default "letsencrypt-dns-prod" | toString }}
{{- end }}

{{- define "mattermost.wwwDomain" -}}
{{- $domain := include "mattermost.siteDomain" . }}
{{- $www := and .Values.ingress.enabled .Values.ingress.www }}
{{- ternary (printf "www.%s" $domain) "" (and $www (ne $domain "")) }}
{{- end }}

{{/*
Service configurations.
*/}}
{{- define "mattermost.serviceNodePort" -}}
{{- $type := .Values.service.type | default "ClusterIP" | toString }}
{{- $nodePort := .Values.service.nodePort | toString }}
{{- ternary $nodePort "" (and (eq $type "NodePort") (ne $nodePort "")) }}
{{- end }}

{{- define "mattermost.servicePort" -}}
{{- .Values.service.port | default "8065" | toString }}
{{- end }}

{{- define "mattermost.serviceType" -}}
{{- .Values.service.type | default "ClusterIP" | toString }}
{{- end }}

{{/*
Storage configurations.
*/}}
{{- define "mattermost.dataPersistence" -}}
{{- .Values.storage.data.enabled }}
{{- end }}

{{- define "mattermost.dataAccessMode" -}}
{{- .Values.storage.data.accessMode | default "ReadWriteOnce" | toString }}
{{- end }}

{{- define "mattermost.dataMountPath" -}}
{{- .Values.storage.data.mountPath | default "/mattermost/data" | toString }}
{{- end }}

{{- define "mattermost.dataSubPath" -}}
{{- .Values.storage.data.subPath | toString }}
{{- end }}

{{- define "mattermost.dataStorage" -}}
{{- .Values.storage.data.storage | default "1Gi" | toString }}
{{- end }}

{{- define "mattermost.dataStorageClassName" -}}
{{- .Values.storage.data.storageClassName | default "longhorn" | toString }}
{{- end }}

{{- define "mattermost.logPersistence" -}}
{{- .Values.storage.log.enabled }}
{{- end }}

{{- define "mattermost.logAccessMode" -}}
{{- .Values.storage.log.accessMode | default "ReadWriteOnce" | toString }}
{{- end }}

{{- define "mattermost.logMountPath" -}}
{{- .Values.storage.log.mountPath | default "/mattermost/logs" | toString }}
{{- end }}

{{- define "mattermost.logSubPath" -}}
{{- .Values.storage.log.subPath | toString }}
{{- end }}

{{- define "mattermost.logStorage" -}}
{{- .Values.storage.log.storage | default "1Gi" | toString }}
{{- end }}

{{- define "mattermost.logStorageClassName" -}}
{{- .Values.storage.log.storageClassName | default "longhorn" | toString }}
{{- end }}

{{/*
Resource requirements and limits for the Mattermost container.
*/}}
{{- define "mattermost.resources" -}}
resources:
  {{- toYaml .Values.resources.mattermost | nindent 2 }}
{{- end }}
