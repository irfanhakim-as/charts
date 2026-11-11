{{/*
The desired number of running replicas for Pocket ID.
*/}}
{{- define "pocket-id.replicaCount" -}}
{{- .Values.replicaCount | default "1" | toString }}
{{- end }}

{{/*
Annotations to be applied to Pocket ID pods.
*/}}
{{- define "pocket-id.podAnnotations" -}}
{{- with .Values.podAnnotations -}}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Security context applied at the pod level for Pocket ID.
*/}}
{{- define "pocket-id.podSecurityContext" -}}
{{- with .Values.podSecurityContext -}}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Security context applied at the Pocket ID container level.
*/}}
{{- define "pocket-id.containerSecurityContext" -}}
{{- with .Values.containerSecurityContext -}}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Container images used for Pocket ID.
*/}}
{{- define "pocket-id.imageRegistry" -}}
{{- .Values.image.pocketid.registry | default "ghcr.io" | toString }}
{{- end }}

{{- define "pocket-id.imageRepository" -}}
{{- .Values.image.pocketid.repository | default "pocket-id/pocket-id" | toString }}
{{- end }}

{{- define "pocket-id.imageTag" -}}
{{- .Values.image.pocketid.tag | default .Chart.AppVersion | toString }}
{{- end }}

{{- define "pocket-id.imagePullPolicy" -}}
{{- .Values.image.pocketid.pullPolicy | default "IfNotPresent" | toString }}
{{- end }}

{{- define "pocket-id.initImageRegistry" -}}
{{- .Values.image.init.registry | default "docker.io" | toString }}
{{- end }}

{{- define "pocket-id.initImageRepository" -}}
{{- .Values.image.init.repository | default "busybox" | toString }}
{{- end }}

{{- define "pocket-id.initImageTag" -}}
{{- .Values.image.init.tag | default "1.36.1" | toString }}
{{- end }}

{{- define "pocket-id.initImagePullPolicy" -}}
{{- .Values.image.init.pullPolicy | default "IfNotPresent" | toString }}
{{- end }}

{{/*
Credentials used to securely authenticate and authorise the pulling of container images from private registries.
*/}}
{{- define "pocket-id.imagePullSecrets" -}}
{{- with .Values.imagePullSecrets -}}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Service account configurations for Pocket ID pods.
*/}}
{{- define "pocket-id.serviceAccountCreate" -}}
{{- .Values.serviceAccount.create }}
{{- end }}

{{- define "pocket-id.serviceAccountName" -}}
{{- $default := ternary (printf "%s-pocket-id" .Release.Name) "default" .Values.serviceAccount.create }}
{{- .Values.serviceAccount.name | default $default | toString }}
{{- end }}

{{- define "pocket-id.serviceAccountAnnotations" -}}
{{- with .Values.serviceAccount.annotations -}}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The node labels a node must have for Pocket ID pods to be scheduled onto it.
*/}}
{{- define "pocket-id.nodeSelector" -}}
{{- with .Values.nodeSelector -}}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The tolerations that allow Pocket ID pods to be scheduled onto tainted nodes.
*/}}
{{- define "pocket-id.tolerations" -}}
{{- with .Values.tolerations -}}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The scheduling constraints applied to Pocket ID pods.
*/}}
{{- define "pocket-id.affinity" -}}
{{- with .Values.affinity -}}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Additional environment variables to be set on the Pocket ID container.
*/}}
{{- define "pocket-id.extraEnv" -}}
{{- with .Values.extraEnv -}}
env:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Additional volumes to be added to Pocket ID pods.
*/}}
{{- define "pocket-id.extraVolumes" -}}
{{- with .Values.extraVolumes -}}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Additional volume mounts to be added to the Pocket ID container.
*/}}
{{- define "pocket-id.extraVolumeMounts" -}}
{{- with .Values.extraVolumeMounts -}}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Pocket ID configurations.
*/}}
{{- define "pocket-id.domain" -}}
{{- .Values.pocketid.domain | toString }}
{{- end }}

{{- define "pocket-id.appUrl" -}}
{{- $domain := include "pocket-id.domain" . -}}
{{- .Values.pocketid.appUrl | default (ternary (printf "https://%s" $domain) "" (ne $domain "")) | toString }}
{{- end }}

{{- define "pocket-id.internalAppUrl" -}}
{{- .Values.pocketid.internalAppUrl | toString }}
{{- end }}

{{- define "pocket-id.existingSecret" -}}
{{- .Values.pocketid.existingSecret | toString }}
{{- end }}

{{- define "pocket-id.encryptionKey" -}}
{{- .Values.pocketid.encryptionKey | toString }}
{{- end }}

{{- define "pocket-id.staticApiKey" -}}
{{- .Values.pocketid.staticApiKey | toString }}
{{- end }}

{{- define "pocket-id.timezone" -}}
{{- .Values.pocketid.timezone | toString }}
{{- end }}

{{- define "pocket-id.puid" -}}
{{- .Values.pocketid.puid | toString }}
{{- end }}

{{- define "pocket-id.pgid" -}}
{{- .Values.pocketid.pgid | toString }}
{{- end }}

{{- define "pocket-id.allowDowngrade" -}}
{{- .Values.pocketid.allowDowngrade | toString }}
{{- end }}

{{- define "pocket-id.analyticsDisabled" -}}
{{- .Values.pocketid.analyticsDisabled | toString }}
{{- end }}

{{- define "pocket-id.versionCheckDisabled" -}}
{{- .Values.pocketid.versionCheckDisabled | toString }}
{{- end }}

{{- define "pocket-id.iconLibraryUrl" -}}
{{- .Values.pocketid.iconLibraryUrl | toString }}
{{- end }}

{{- define "pocket-id.initScript" -}}
{{- .Values.pocketid.initScript | toString }}
{{- end }}

{{/*
File storage configurations.
*/}}
{{- define "pocket-id.filesBackend" -}}
{{- .Values.files.backend | toString }}
{{- end }}

{{- define "pocket-id.filesUploadPath" -}}
{{- $backend := include "pocket-id.filesBackend" . -}}
{{- $default := ternary (printf "%s/uploads" (include "pocket-id.dataMountPath" .)) "" (or (eq $backend "") (eq $backend "filesystem")) -}}
{{- .Values.files.uploadPath | default $default | toString }}
{{- end }}

{{/*
LDAP configurations.
*/}}
{{- define "pocket-id.ldapEnabled" -}}
{{- .Values.ldap.enabled | toString }}
{{- end }}

{{- define "pocket-id.ldapUrl" -}}
{{- .Values.ldap.url | toString }}
{{- end }}

{{- define "pocket-id.ldapBindDn" -}}
{{- .Values.ldap.bindDn | toString }}
{{- end }}

{{- define "pocket-id.ldapBindPassword" -}}
{{- .Values.ldap.bindPassword | toString }}
{{- end }}

{{- define "pocket-id.ldapBase" -}}
{{- .Values.ldap.base | toString }}
{{- end }}

{{- define "pocket-id.ldapUserSearchFilter" -}}
{{- .Values.ldap.userSearchFilter | toString }}
{{- end }}

{{- define "pocket-id.ldapUserGroupSearchFilter" -}}
{{- .Values.ldap.userGroupSearchFilter | toString }}
{{- end }}

{{- define "pocket-id.ldapSkipCertVerify" -}}
{{- .Values.ldap.skipCertVerify | toString }}
{{- end }}

{{- define "pocket-id.ldapSoftDeleteUsers" -}}
{{- .Values.ldap.softDeleteUsers | toString }}
{{- end }}

{{- define "pocket-id.ldapAdminGroupName" -}}
{{- .Values.ldap.adminGroupName | toString }}
{{- end }}

{{- define "pocket-id.ldapAttributeUserUniqueIdentifier" -}}
{{- .Values.ldap.attributes.userUniqueIdentifier | toString }}
{{- end }}

{{- define "pocket-id.ldapAttributeUserUsername" -}}
{{- .Values.ldap.attributes.userUsername | toString }}
{{- end }}

{{- define "pocket-id.ldapAttributeUserEmail" -}}
{{- .Values.ldap.attributes.userEmail | toString }}
{{- end }}

{{- define "pocket-id.ldapAttributeUserFirstName" -}}
{{- .Values.ldap.attributes.userFirstName | toString }}
{{- end }}

{{- define "pocket-id.ldapAttributeUserLastName" -}}
{{- .Values.ldap.attributes.userLastName | toString }}
{{- end }}

{{- define "pocket-id.ldapAttributeUserDisplayName" -}}
{{- .Values.ldap.attributes.userDisplayName | toString }}
{{- end }}

{{- define "pocket-id.ldapAttributeUserProfilePicture" -}}
{{- .Values.ldap.attributes.userProfilePicture | toString }}
{{- end }}

{{- define "pocket-id.ldapAttributeGroupMember" -}}
{{- .Values.ldap.attributes.groupMember | toString }}
{{- end }}

{{- define "pocket-id.ldapAttributeGroupUniqueIdentifier" -}}
{{- .Values.ldap.attributes.groupUniqueIdentifier | toString }}
{{- end }}

{{- define "pocket-id.ldapAttributeGroupName" -}}
{{- .Values.ldap.attributes.groupName | toString }}
{{- end }}

{{/*
Location configurations.
*/}}
{{- define "pocket-id.maxmindLicenseKey" -}}
{{- .Values.location.maxmindLicenseKey | toString }}
{{- end }}

{{- define "pocket-id.geoliteDbPath" -}}
{{- .Values.location.geoliteDbPath | default (printf "%s/GeoLite2-City.mmdb" (include "pocket-id.dataMountPath" .)) | toString }}
{{- end }}

{{- define "pocket-id.geoliteDbUrl" -}}
{{- .Values.location.geoliteDbUrl | toString }}
{{- end }}

{{- define "pocket-id.cloudflareHeaders" -}}
{{- .Values.location.cloudflareHeaders | toString }}
{{- end }}

{{/*
Logging configurations.
*/}}
{{- define "pocket-id.logLevel" -}}
{{- .Values.logging.level | toString }}
{{- end }}

{{- define "pocket-id.logJson" -}}
{{- .Values.logging.json | toString }}
{{- end }}

{{- define "pocket-id.logQueryArgs" -}}
{{- .Values.logging.queryArgs | toString }}
{{- end }}

{{/*
Mail configurations.
*/}}
{{- define "pocket-id.smtpHost" -}}
{{- .Values.mail.smtp.host | toString }}
{{- end }}

{{- define "pocket-id.smtpPort" -}}
{{- .Values.mail.smtp.port | toString }}
{{- end }}

{{- define "pocket-id.smtpUser" -}}
{{- .Values.mail.smtp.user | toString }}
{{- end }}

{{- define "pocket-id.smtpPassword" -}}
{{- .Values.mail.smtp.password | toString }}
{{- end }}

{{- define "pocket-id.smtpTls" -}}
{{- .Values.mail.smtp.tls | toString }}
{{- end }}

{{- define "pocket-id.smtpSkipCertVerify" -}}
{{- .Values.mail.smtp.skipCertVerify | toString }}
{{- end }}

{{- define "pocket-id.mailFrom" -}}
{{- .Values.mail.from | toString }}
{{- end }}

{{- define "pocket-id.mailLoginNotificationEnabled" -}}
{{- .Values.mail.loginNotificationEnabled | toString }}
{{- end }}

{{- define "pocket-id.mailOneTimeAccessAsAdminEnabled" -}}
{{- .Values.mail.oneTimeAccessAsAdminEnabled | toString }}
{{- end }}

{{- define "pocket-id.mailOneTimeAccessAsUnauthenticatedEnabled" -}}
{{- .Values.mail.oneTimeAccessAsUnauthenticatedEnabled | toString }}
{{- end }}

{{- define "pocket-id.mailApiKeyExpirationEnabled" -}}
{{- .Values.mail.apiKeyExpirationEnabled | toString }}
{{- end }}

{{- define "pocket-id.mailVerificationEnabled" -}}
{{- .Values.mail.verificationEnabled | toString }}
{{- end }}

{{/*
Network configurations.
*/}}
{{- define "pocket-id.networkPort" -}}
{{- .Values.network.port | default "1411" | toString }}
{{- end }}

{{- define "pocket-id.networkHost" -}}
{{- .Values.network.host | toString }}
{{- end }}

{{- define "pocket-id.trustProxy" -}}
{{- .Values.network.trustProxy | toString }}
{{- end }}

{{- define "pocket-id.trustedPlatform" -}}
{{- .Values.network.trustedPlatform | toString }}
{{- end }}

{{- define "pocket-id.proxyProtocol" -}}
{{- .Values.network.proxyProtocol | toString }}
{{- end }}

{{- define "pocket-id.localIpv6Ranges" -}}
{{- .Values.network.localIpv6Ranges | toString }}
{{- end }}

{{/*
Observability configurations.
*/}}
{{- define "pocket-id.logsExporter" -}}
{{- .Values.observability.logsExporter | toString }}
{{- end }}

{{- define "pocket-id.metricsExporter" -}}
{{- $exporters := splitList "," (.Values.observability.metricsExporter | toString) | compact -}}
{{- if and (eq (include "pocket-id.prometheusEnabled" .) "true") (not (has "prometheus" $exporters)) -}}
{{- $exporters = append $exporters "prometheus" -}}
{{- end }}
{{- join "," $exporters }}
{{- end }}

{{- define "pocket-id.tracesExporter" -}}
{{- .Values.observability.tracesExporter | toString }}
{{- end }}

{{- define "pocket-id.otlpEndpoint" -}}
{{- .Values.observability.otlpEndpoint | toString }}
{{- end }}

{{- define "pocket-id.prometheusEnabled" -}}
{{- .Values.observability.prometheus.enabled }}
{{- end }}

{{- define "pocket-id.prometheusHost" -}}
{{- ternary "0.0.0.0" "" (eq (include "pocket-id.prometheusEnabled" .) "true") }}
{{- end }}

{{- define "pocket-id.prometheusPort" -}}
{{- .Values.observability.prometheus.port | default "9464" | toString }}
{{- end }}

{{- define "pocket-id.serviceMonitorEnabled" -}}
{{- and (eq (include "pocket-id.prometheusEnabled" .) "true") .Values.observability.prometheus.serviceMonitor.enabled }}
{{- end }}

{{- define "pocket-id.serviceMonitorNamespace" -}}
{{- .Values.observability.prometheus.serviceMonitor.namespace | default .Release.Namespace | toString }}
{{- end }}

{{- define "pocket-id.serviceMonitorInterval" -}}
{{- .Values.observability.prometheus.serviceMonitor.interval | default "30s" | toString }}
{{- end }}

{{- define "pocket-id.serviceMonitorScrapeTimeout" -}}
{{- .Values.observability.prometheus.serviceMonitor.scrapeTimeout | default "10s" | toString }}
{{- end }}

{{- define "pocket-id.serviceMonitorLabels" -}}
{{- with .Values.observability.prometheus.serviceMonitor.labels -}}
labels:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
S3-compatible file storage configurations.
*/}}
{{- define "pocket-id.s3AccessKeyId" -}}
{{- .Values.s3.accessKeyId | toString }}
{{- end }}

{{- define "pocket-id.s3SecretAccessKey" -}}
{{- .Values.s3.secretAccessKey | toString }}
{{- end }}

{{- define "pocket-id.s3Bucket" -}}
{{- .Values.s3.bucket | toString }}
{{- end }}

{{- define "pocket-id.s3Endpoint" -}}
{{- .Values.s3.endpoint | toString }}
{{- end }}

{{- define "pocket-id.s3Region" -}}
{{- .Values.s3.region | toString }}
{{- end }}

{{- define "pocket-id.s3ForcePathStyle" -}}
{{- .Values.s3.forcePathStyle | toString }}
{{- end }}

{{- define "pocket-id.s3DisableDefaultIntegrityChecks" -}}
{{- .Values.s3.disableDefaultIntegrityChecks | toString }}
{{- end }}

{{/*
Security configurations.
*/}}
{{- define "pocket-id.allowInsecureCallbackUrls" -}}
{{- .Values.security.allowInsecureCallbackUrls | toString }}
{{- end }}

{{- define "pocket-id.disableRateLimiting" -}}
{{- .Values.security.disableRateLimiting | toString }}
{{- end }}

{{- define "pocket-id.auditLogRetentionDays" -}}
{{- .Values.security.auditLogRetentionDays | toString }}
{{- end }}

{{- define "pocket-id.outboundAllowedHostsScim" -}}
{{- .Values.security.outboundAllowedHosts.scim | toString }}
{{- end }}

{{- define "pocket-id.outboundAllowedHostsBackchannelLogout" -}}
{{- .Values.security.outboundAllowedHosts.backchannelLogout | toString }}
{{- end }}

{{- define "pocket-id.outboundAllowedHostsFederatedJwks" -}}
{{- .Values.security.outboundAllowedHosts.federatedJwks | toString }}
{{- end }}

{{- define "pocket-id.outboundAllowedHostsClientLogo" -}}
{{- .Values.security.outboundAllowedHosts.clientLogo | toString }}
{{- end }}

{{- define "pocket-id.outboundAllowedHostsClientMetadata" -}}
{{- .Values.security.outboundAllowedHosts.clientMetadata | toString }}
{{- end }}

{{- define "pocket-id.outboundAllowedHostsLdapPicture" -}}
{{- .Values.security.outboundAllowedHosts.ldapPicture | toString }}
{{- end }}

{{/*
TLS configurations for serving HTTPS directly from Pocket ID.
*/}}
{{- define "pocket-id.tlsCert" -}}
{{- .Values.tls.cert | toString }}
{{- end }}

{{- define "pocket-id.tlsKey" -}}
{{- .Values.tls.key | toString }}
{{- end }}

{{- define "pocket-id.tlsEnabled" -}}
{{- ne (include "pocket-id.tlsCert" .) "" }}
{{- end }}

{{/*
Admin UI configurations that replace the settings stored in the database.
*/}}
{{- define "pocket-id.uiConfigDisabled" -}}
{{- .Values.ui.configDisabled | toString }}
{{- end }}

{{- define "pocket-id.uiAppName" -}}
{{- .Values.ui.appName | toString }}
{{- end }}

{{- define "pocket-id.uiSessionDuration" -}}
{{- .Values.ui.sessionDuration | toString }}
{{- end }}

{{- define "pocket-id.uiHomePageUrl" -}}
{{- .Values.ui.homePageUrl | toString }}
{{- end }}

{{- define "pocket-id.uiAccentColor" -}}
{{- .Values.ui.accentColor | toString }}
{{- end }}

{{- define "pocket-id.uiDisableAnimations" -}}
{{- .Values.ui.disableAnimations | toString }}
{{- end }}

{{- define "pocket-id.uiAllowOwnAccountEdit" -}}
{{- .Values.ui.allowOwnAccountEdit | toString }}
{{- end }}

{{- define "pocket-id.uiAutoCreateOidcClientSecret" -}}
{{- .Values.ui.autoCreateOidcClientSecret | toString }}
{{- end }}

{{- define "pocket-id.uiCimdUrlAllowlist" -}}
{{- .Values.ui.cimdUrlAllowlist | toString }}
{{- end }}

{{- define "pocket-id.uiRequireUserEmail" -}}
{{- .Values.ui.users.requireUserEmail | toString }}
{{- end }}

{{- define "pocket-id.uiEmailsVerified" -}}
{{- .Values.ui.users.emailsVerified | toString }}
{{- end }}

{{- define "pocket-id.uiAllowUserSignups" -}}
{{- .Values.ui.users.allowUserSignups | toString }}
{{- end }}

{{- define "pocket-id.uiSignupDefaultUserGroupIds" -}}
{{- .Values.ui.users.signupDefaultUserGroupIds | toString }}
{{- end }}

{{- define "pocket-id.uiSignupDefaultCustomClaims" -}}
{{- .Values.ui.users.signupDefaultCustomClaims | toString }}
{{- end }}

{{- define "pocket-id.uiPasskeysUserVerification" -}}
{{- .Values.ui.passkeys.userVerification | toString }}
{{- end }}

{{- define "pocket-id.uiPasskeysAllowSyncedPasskeys" -}}
{{- .Values.ui.passkeys.allowSyncedPasskeys | toString }}
{{- end }}

{{- define "pocket-id.uiPasskeysAuthenticatorAttachment" -}}
{{- .Values.ui.passkeys.authenticatorAttachment | toString }}
{{- end }}

{{/*
Database configurations.
*/}}
{{- define "pocket-id.dbType" -}}
{{- $type := .Values.db.type | default "sqlite" | toString -}}
{{- if not (has $type (list "sqlite" "postgres")) -}}
{{- fail (printf "db.type must be \"sqlite\" or \"postgres\", got %q" $type) }}
{{- end }}
{{- $type }}
{{- end }}

{{- define "pocket-id.dbHost" -}}
{{- .Values.db.host | toString }}
{{- end }}

{{- define "pocket-id.dbPort" -}}
{{- .Values.db.port | default "5432" | toString }}
{{- end }}

{{- define "pocket-id.dbName" -}}
{{- .Values.db.name | toString }}
{{- end }}

{{- define "pocket-id.dbUser" -}}
{{- .Values.db.user | toString }}
{{- end }}

{{- define "pocket-id.dbPassword" -}}
{{- .Values.db.password | toString }}
{{- end }}

{{- define "pocket-id.dbSslMode" -}}
{{- .Values.db.sslMode | default "disable" | toString }}
{{- end }}

{{- define "pocket-id.dbConnectTimeout" -}}
{{- .Values.db.connectTimeout | default "10" | toString }}
{{- end }}

{{- define "pocket-id.dbSqlitePath" -}}
{{- .Values.db.sqlitePath | default (printf "%s/pocket-id.db" (include "pocket-id.dataMountPath" .)) | toString }}
{{- end }}

{{- define "pocket-id.dbDismissSqliteStorageWarning" -}}
{{- .Values.db.dismissSqliteStorageWarning | toString }}
{{- end }}

{{- define "pocket-id.dbUrl" -}}
{{- if eq (include "pocket-id.dbType" .) "postgres" -}}
{{- $host := include "pocket-id.dbHost" . -}}
{{- if $host -}}
{{- $user := include "pocket-id.dbUser" . | urlquery | replace "+" "%20" -}}
{{- $password := include "pocket-id.dbPassword" . | urlquery | replace "+" "%20" -}}
{{- $name := include "pocket-id.dbName" . | urlquery | replace "+" "%20" -}}
{{- printf "postgres://%s:%s@%s:%s/%s?sslmode=%s&connect_timeout=%s" $user $password $host (include "pocket-id.dbPort" .) $name (include "pocket-id.dbSslMode" .) (include "pocket-id.dbConnectTimeout" .) }}
{{- end }}
{{- else -}}
{{- include "pocket-id.dbSqlitePath" . }}
{{- end }}
{{- end }}

{{/*
Ingress configurations.
*/}}
{{- define "pocket-id.ingressDomain" -}}
{{- $domain := include "pocket-id.domain" . }}
{{- ternary $domain "" (and .Values.ingress.enabled (ne $domain "") (ne $domain "localhost")) }}
{{- end }}

{{- define "pocket-id.ingressClassName" -}}
{{- .Values.ingress.className | default "nginx" | toString }}
{{- end }}

{{- define "pocket-id.clusterIssuer" -}}
{{- .Values.ingress.clusterIssuer | default "letsencrypt-dns-prod" | toString }}
{{- end }}

{{- define "pocket-id.tlsSecretName" -}}
{{- .Values.ingress.tlsSecretName | default (printf "%s-pocket-id-tls-cert" .Release.Name) | toString }}
{{- end }}

{{/*
Service configurations.
*/}}
{{- define "pocket-id.serviceNodePort" -}}
{{- $type := .Values.service.type | default "ClusterIP" | toString }}
{{- $nodePort := .Values.service.nodePort | toString }}
{{- ternary $nodePort "" (and (eq $type "NodePort") (ne $nodePort "")) }}
{{- end }}

{{- define "pocket-id.servicePort" -}}
{{- .Values.service.port | default "1411" | toString }}
{{- end }}

{{- define "pocket-id.serviceType" -}}
{{- .Values.service.type | default "ClusterIP" | toString }}
{{- end }}

{{/*
Storage configurations.
*/}}
{{- define "pocket-id.dataPersistence" -}}
{{- .Values.storage.data.enabled }}
{{- end }}

{{- define "pocket-id.dataAccessMode" -}}
{{- .Values.storage.data.accessMode | default "ReadWriteOnce" | toString }}
{{- end }}

{{- define "pocket-id.dataMountPath" -}}
{{- .Values.storage.data.mountPath | default "/app/data" | toString }}
{{- end }}

{{- define "pocket-id.dataSubPath" -}}
{{- .Values.storage.data.subPath | toString }}
{{- end }}

{{- define "pocket-id.dataStorage" -}}
{{- .Values.storage.data.storage | default "1Gi" | toString }}
{{- end }}

{{- define "pocket-id.dataStorageClassName" -}}
{{- .Values.storage.data.storageClassName | default "longhorn" | toString }}
{{- end }}

{{/*
Resource requirements and limits for Pocket ID containers.
*/}}
{{- define "pocket-id.resources" -}}
resources:
  {{- toYaml .Values.resources.pocketid | nindent 2 }}
{{- end }}
