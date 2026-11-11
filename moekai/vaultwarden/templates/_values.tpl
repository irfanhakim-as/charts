{{/*
The desired number of running replicas for Vaultwarden.
*/}}
{{- define "vaultwarden.replicaCount" -}}
{{- .Values.replicaCount | default "1" | toString }}
{{- end }}

{{/*
Annotations to be applied to Vaultwarden pods.
*/}}
{{- define "vaultwarden.podAnnotations" -}}
{{- with .Values.podAnnotations -}}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Security context applied at the pod level for Vaultwarden.
*/}}
{{- define "vaultwarden.podSecurityContext" -}}
{{- with .Values.podSecurityContext -}}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Security context applied at the Vaultwarden container level.
*/}}
{{- define "vaultwarden.containerSecurityContext" -}}
{{- with .Values.containerSecurityContext -}}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Container images used for Vaultwarden.
*/}}
{{- define "vaultwarden.imageRegistry" -}}
{{- .Values.image.vaultwarden.registry | default "ghcr.io" | toString }}
{{- end }}

{{- define "vaultwarden.imageRepository" -}}
{{- .Values.image.vaultwarden.repository | default "dani-garcia/vaultwarden" | toString }}
{{- end }}

{{- define "vaultwarden.imageTag" -}}
{{- .Values.image.vaultwarden.tag | default .Chart.AppVersion | toString }}
{{- end }}

{{- define "vaultwarden.imagePullPolicy" -}}
{{- .Values.image.vaultwarden.pullPolicy | default "IfNotPresent" | toString }}
{{- end }}

{{- define "vaultwarden.initImageRegistry" -}}
{{- .Values.image.init.registry | default "docker.io" | toString }}
{{- end }}

{{- define "vaultwarden.initImageRepository" -}}
{{- .Values.image.init.repository | default "busybox" | toString }}
{{- end }}

{{- define "vaultwarden.initImageTag" -}}
{{- .Values.image.init.tag | default "1.36.1" | toString }}
{{- end }}

{{- define "vaultwarden.initImagePullPolicy" -}}
{{- .Values.image.init.pullPolicy | default "IfNotPresent" | toString }}
{{- end }}

{{/*
Credentials used to securely authenticate and authorise the pulling of container images from private registries.
*/}}
{{- define "vaultwarden.imagePullSecrets" -}}
{{- with .Values.imagePullSecrets -}}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Service account configurations for Vaultwarden pods.
*/}}
{{- define "vaultwarden.serviceAccountCreate" -}}
{{- .Values.serviceAccount.create }}
{{- end }}

{{- define "vaultwarden.serviceAccountName" -}}
{{- $default := ternary (printf "%s-vaultwarden" .Release.Name) "default" .Values.serviceAccount.create }}
{{- .Values.serviceAccount.name | default $default | toString }}
{{- end }}

{{- define "vaultwarden.serviceAccountAnnotations" -}}
{{- with .Values.serviceAccount.annotations -}}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The node labels a node must have for Vaultwarden pods to be scheduled onto it.
*/}}
{{- define "vaultwarden.nodeSelector" -}}
{{- with .Values.nodeSelector -}}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The tolerations that allow Vaultwarden pods to be scheduled onto tainted nodes.
*/}}
{{- define "vaultwarden.tolerations" -}}
{{- with .Values.tolerations -}}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The scheduling constraints applied to Vaultwarden pods.
*/}}
{{- define "vaultwarden.affinity" -}}
{{- with .Values.affinity -}}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Additional environment variables to be set on the Vaultwarden container.
*/}}
{{- define "vaultwarden.extraEnv" -}}
{{- with .Values.extraEnv -}}
env:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Additional volumes to be added to Vaultwarden pods.
*/}}
{{- define "vaultwarden.extraVolumes" -}}
{{- with .Values.extraVolumes -}}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Additional volume mounts to be added to the Vaultwarden container.
*/}}
{{- define "vaultwarden.extraVolumeMounts" -}}
{{- with .Values.extraVolumeMounts -}}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Vaultwarden configurations.
*/}}

{{- define "vaultwarden.adminToken" -}}
{{- .Values.vaultwarden.adminToken | toString }}
{{- end }}

{{- define "vaultwarden.clearTrash" -}}
{{- .Values.vaultwarden.clearTrash | toString }}
{{- end }}

{{- define "vaultwarden.domain" -}}
{{- .Values.vaultwarden.domain | toString }}
{{- end }}

{{- define "vaultwarden.emailUpdate" -}}
{{- .Values.vaultwarden.emailUpdate | toString | replace "<nil>" "" | default "true" }}
{{- end }}

{{- define "vaultwarden.emergencyAccess" -}}
{{- .Values.vaultwarden.emergencyAccess | toString | replace "<nil>" "" | default "true" }}
{{- end }}

{{- define "vaultwarden.expFeatures" -}}
{{- .Values.vaultwarden.expFeatures | join "," | toString }}
{{- end }}

{{- define "vaultwarden.hibpApiKey" -}}
{{- .Values.vaultwarden.hibpApiKey | toString }}
{{- end }}

{{- define "vaultwarden.logLevel" -}}
{{- .Values.vaultwarden.logLevel | default "info" | toString }}
{{- end }}

{{- define "vaultwarden.notifyNewDevice" -}}
{{- .Values.vaultwarden.notifyNewDevice | default "false" | toString }}
{{- end }}

{{- define "vaultwarden.send" -}}
{{- .Values.vaultwarden.send | toString | replace "<nil>" "" | default "true" }}
{{- end }}

{{- define "vaultwarden.initScript" -}}
{{- .Values.vaultwarden.initScript | toString }}
{{- end }}


{{/*
Invitation configurations.
*/}}
{{- define "vaultwarden.invitationEnabled" -}}
{{- .Values.invitation.enabled | default "false" | toString }}
{{- end }}

{{- define "vaultwarden.invitationExpiry" -}}
{{- .Values.invitation.expiry | default "120" | toString }}
{{- end }}

{{- define "vaultwarden.invitationOrganisation" -}}
{{- .Values.invitation.organisation | default "Vaultwarden" | toString }}
{{- end }}


{{/*
Mail configurations.
*/}}
{{- define "vaultwarden.smtpHost" -}}
{{- .Values.mail.smtp.host | toString }}
{{- end }}

{{- define "vaultwarden.smtpPort" -}}
{{- .Values.mail.smtp.port | default "587" | toString }}
{{- end }}

{{- define "vaultwarden.smtpUser" -}}
{{- .Values.mail.smtp.user | toString }}
{{- end }}

{{- define "vaultwarden.smtpPassword" -}}
{{- .Values.mail.smtp.password | toString }}
{{- end }}

{{- define "vaultwarden.smtpSecurity" -}}
{{- .Values.mail.smtp.security | default "starttls" | toString }}
{{- end }}

{{- define "vaultwarden.mailFromEmail" -}}
{{- .Values.mail.fromEmail | default (include "vaultwarden.smtpUser" .) | toString }}
{{- end }}

{{- define "vaultwarden.mailFromName" -}}
{{- .Values.mail.fromName | default "Vaultwarden" | toString }}
{{- end }}

{{- define "vaultwarden.mailEnabled" -}}
{{- and (ne (include "vaultwarden.mailFromEmail" .) "") (ne (include "vaultwarden.smtpHost" .) "") }}
{{- end }}


{{/*
Push notification configurations.
*/}}
{{- define "vaultwarden.pushEnabled" -}}
{{- .Values.push.enabled | default "false" | toString }}
{{- end }}

{{- define "vaultwarden.pushId" -}}
{{- .Values.push.id | toString }}
{{- end }}

{{- define "vaultwarden.pushKey" -}}
{{- .Values.push.key | toString }}
{{- end }}


{{/*
Signup configurations.
*/}}
{{- define "vaultwarden.signupEnabled" -}}
{{- .Values.signup.enabled | default "false" | toString }}
{{- end }}

{{- define "vaultwarden.signupDomainWhitelist" -}}
{{- .Values.signup.domainWhitelist | join "," | toString }}
{{- end }}

{{- define "vaultwarden.signupVerification" -}}
{{- $restricted := or (eq (include "vaultwarden.signupEnabled" .) "true") (ne (include "vaultwarden.signupDomainWhitelist" .) "") }}
{{- ternary (.Values.signup.verification | default "false" | toString) "false" $restricted }}
{{- end }}

{{- define "vaultwarden.signupResendInterval" -}}
{{- .Values.signup.resendInterval | default "3600" | toString }}
{{- end }}

{{- define "vaultwarden.signupResendLimit" -}}
{{- .Values.signup.resendLimit | default "6" | toString }}
{{- end }}


{{/*
Two-factor authentication configurations.
*/}}
{{- define "vaultwarden.tfaExpiry" -}}
{{- .Values.tfa.expiry | default "3" | toString }}
{{- end }}

{{- define "vaultwarden.tfaEmailTokenSize" -}}
{{- .Values.tfa.emailTokenSize | default "6" | toString }}
{{- end }}

{{- define "vaultwarden.tfaEmailExpiry" -}}
{{- .Values.tfa.emailExpiry | default "600" | toString }}
{{- end }}

{{- define "vaultwarden.tfaEmailLimit" -}}
{{- .Values.tfa.emailLimit | default "3" | toString }}
{{- end }}

{{- define "vaultwarden.tfaEmailEnforce" -}}
{{- .Values.tfa.emailEnforce | default "false" | toString }}
{{- end }}

{{- define "vaultwarden.tfaEmailFallback" -}}
{{- .Values.tfa.emailFallback | default "false" | toString }}
{{- end }}

{{- define "vaultwarden.tfaRememberDevice" -}}
{{- .Values.tfa.rememberDevice | toString | replace "<nil>" "" | default "true" }}
{{- end }}

{{- define "vaultwarden.tfaAllowTimeDrift" -}}
{{- .Values.tfa.allowTimeDrift | toString | replace "<nil>" "" | default "true" }}
{{- end }}


{{/*
Yubico configurations.
*/}}
{{- define "vaultwarden.yubicoEnabled" -}}
{{- .Values.yubico.enabled | default "false" | toString }}
{{- end }}

{{- define "vaultwarden.yubicoId" -}}
{{- .Values.yubico.id | toString }}
{{- end }}

{{- define "vaultwarden.yubicoKey" -}}
{{- .Values.yubico.key | toString }}
{{- end }}

{{- define "vaultwarden.yubicoServer" -}}
{{- .Values.yubico.server | toString }}
{{- end }}


{{/*
Database configurations.
*/}}
{{- define "vaultwarden.dbType" -}}
{{- .Values.db.type | default "sqlite" | toString }}
{{- end }}

{{- define "vaultwarden.dbHost" -}}
{{- .Values.db.host | toString }}
{{- end }}

{{- define "vaultwarden.dbPort" -}}
{{- .Values.db.port | toString }}
{{- end }}

{{- define "vaultwarden.dbName" -}}
{{- .Values.db.name | toString }}
{{- end }}

{{- define "vaultwarden.dbUser" -}}
{{- .Values.db.user | toString }}
{{- end }}

{{- define "vaultwarden.dbPassword" -}}
{{- .Values.db.password | toString }}
{{- end }}

{{- define "vaultwarden.dbUrl" -}}
{{- $type := include "vaultwarden.dbType" . }}
{{- if eq $type "sqlite" }}
{{- printf "%s/db.sqlite3" (include "vaultwarden.dataMountPath" . | trimPrefix "/") }}
{{- else }}
{{- printf "%s://%s:%s@%s:%s/%s" $type (include "vaultwarden.dbUser" .) (include "vaultwarden.dbPassword" .) (include "vaultwarden.dbHost" .) (include "vaultwarden.dbPort" .) (include "vaultwarden.dbName" .) }}
{{- end }}
{{- end }}


{{/*
Ingress configurations.
*/}}
{{- define "vaultwarden.ingressEnabled" -}}
{{- .Values.ingress.enabled }}
{{- end }}

{{- define "vaultwarden.ingressDomain" -}}
{{- $domain := include "vaultwarden.domain" . }}
{{- ternary $domain "" (and .Values.ingress.enabled (ne $domain "") (ne $domain "localhost")) }}
{{- end }}

{{- define "vaultwarden.ingressWwwDomain" -}}
{{- $domain := include "vaultwarden.ingressDomain" . }}
{{- $www := and .Values.ingress.enabled .Values.ingress.www }}
{{- ternary (printf "www.%s" $domain) "" (and $www (ne $domain "")) }}
{{- end }}

{{- define "vaultwarden.clusterIssuer" -}}
{{- .Values.ingress.clusterIssuer | default "letsencrypt-dns-prod" | toString }}
{{- end }}


{{/*
Service configurations.
*/}}
{{- define "vaultwarden.serviceNodePort" -}}
{{- $type := include "vaultwarden.serviceType" . }}
{{- $nodePort := .Values.service.nodePort | toString }}
{{- ternary $nodePort "" (and (eq $type "NodePort") (ne $nodePort "")) }}
{{- end }}

{{- define "vaultwarden.servicePort" -}}
{{- .Values.service.port | default "80" | toString }}
{{- end }}

{{- define "vaultwarden.serviceType" -}}
{{- .Values.service.type | default "ClusterIP" | toString }}
{{- end }}


{{/*
Storage configurations.
*/}}
{{- define "vaultwarden.dataPersistence" -}}
{{- .Values.storage.data.enabled }}
{{- end }}

{{- define "vaultwarden.dataAccessMode" -}}
{{- .Values.storage.data.accessMode | default "ReadWriteOnce" | toString }}
{{- end }}

{{- define "vaultwarden.dataMountPath" -}}
{{- .Values.storage.data.mountPath | default "/data" | toString }}
{{- end }}

{{- define "vaultwarden.dataSubPath" -}}
{{- .Values.storage.data.subPath | toString }}
{{- end }}

{{- define "vaultwarden.dataStorage" -}}
{{- .Values.storage.data.storage | default "1Gi" | toString }}
{{- end }}

{{- define "vaultwarden.dataStorageClassName" -}}
{{- .Values.storage.data.storageClassName | default "longhorn" | toString }}
{{- end }}


{{/*
Resource requirements and limits for Vaultwarden containers.
*/}}
{{- define "vaultwarden.resources" -}}
resources:
  {{- toYaml .Values.resources.vaultwarden | nindent 2 }}
{{- end }}
