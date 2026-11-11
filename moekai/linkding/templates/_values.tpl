{{/*
The desired number of running replicas for Linkding.
*/}}
{{- define "linkding.replicaCount" -}}
{{- .Values.replicaCount | default "1" | toString }}
{{- end }}

{{/*
Annotations to be applied to Linkding pods.
*/}}
{{- define "linkding.podAnnotations" -}}
{{- with .Values.podAnnotations -}}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Security context applied at the pod level for Linkding.
*/}}
{{- define "linkding.podSecurityContext" -}}
{{- with .Values.podSecurityContext -}}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Security context applied at the Linkding container level.
*/}}
{{- define "linkding.containerSecurityContext" -}}
{{- with .Values.containerSecurityContext -}}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Container images used for Linkding.
*/}}
{{- define "linkding.imageRegistry" -}}
{{- .Values.image.linkding.registry | default "docker.io" | toString }}
{{- end }}

{{- define "linkding.imageRepository" -}}
{{- .Values.image.linkding.repository | default "sissbruecker/linkding" | toString }}
{{- end }}

{{- define "linkding.imageTag" -}}
{{- .Values.image.linkding.tag | default .Chart.AppVersion | toString }}
{{- end }}

{{- define "linkding.imagePullPolicy" -}}
{{- .Values.image.linkding.pullPolicy | default "IfNotPresent" | toString }}
{{- end }}

{{- define "linkding.initImageRegistry" -}}
{{- .Values.image.init.registry | default "docker.io" | toString }}
{{- end }}

{{- define "linkding.initImageRepository" -}}
{{- .Values.image.init.repository | default "busybox" | toString }}
{{- end }}

{{- define "linkding.initImageTag" -}}
{{- .Values.image.init.tag | default "1.36.1" | toString }}
{{- end }}

{{- define "linkding.initImagePullPolicy" -}}
{{- .Values.image.init.pullPolicy | default "IfNotPresent" | toString }}
{{- end }}

{{/*
Credentials used to securely authenticate and authorise the pulling of container images from private registries.
*/}}
{{- define "linkding.imagePullSecrets" -}}
{{- with .Values.imagePullSecrets -}}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Service account configurations for Linkding pods.
*/}}
{{- define "linkding.serviceAccountCreate" -}}
{{- .Values.serviceAccount.create }}
{{- end }}

{{- define "linkding.serviceAccountName" -}}
{{- $default := ternary (printf "%s-linkding" .Release.Name) "default" .Values.serviceAccount.create }}
{{- .Values.serviceAccount.name | default $default | toString }}
{{- end }}

{{- define "linkding.serviceAccountAnnotations" -}}
{{- with .Values.serviceAccount.annotations -}}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The node labels a node must have for Linkding pods to be scheduled onto it.
*/}}
{{- define "linkding.nodeSelector" -}}
{{- with .Values.nodeSelector -}}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The tolerations that allow Linkding pods to be scheduled onto tainted nodes.
*/}}
{{- define "linkding.tolerations" -}}
{{- with .Values.tolerations -}}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
The scheduling constraints applied to Linkding pods.
*/}}
{{- define "linkding.affinity" -}}
{{- with .Values.affinity -}}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Additional environment variables to be set on the Linkding container.
*/}}
{{- define "linkding.extraEnv" -}}
{{- with .Values.extraEnv -}}
env:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Additional volumes to be added to Linkding pods.
*/}}
{{- define "linkding.extraVolumes" -}}
{{- with .Values.extraVolumes -}}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Additional volume mounts to be added to the Linkding container.
*/}}
{{- define "linkding.extraVolumeMounts" -}}
{{- with .Values.extraVolumeMounts -}}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Linkding configurations.
*/}}
{{- define "linkding.disableBackgroundTasks" -}}
{{- .Values.linkding.disableBackgroundTasks | default "false" | toString | title }}
{{- end }}

{{- define "linkding.disableUrlValidation" -}}
{{- .Values.linkding.disableUrlValidation | default "false" | toString | title }}
{{- end }}

{{- define "linkding.domain" -}}
{{- .Values.linkding.domain | toString }}
{{- end }}

{{- define "linkding.csrfTrustedOrigins" -}}
{{- .Values.linkding.csrfTrustedOrigins | join "," | toString }}
{{- end }}

{{- define "linkding.timezone" -}}
{{- .Values.linkding.timezone | toString }}
{{- end }}

{{- define "linkding.disableLoginForm" -}}
{{- $v := .Values.linkding.disableLoginForm | toString }}
{{- if $v }}{{ $v | title }}{{ end }}
{{- end }}

{{- define "linkding.existingSecret" -}}
{{- .Values.linkding.existingSecret | toString }}
{{- end }}

{{- define "linkding.initScript" -}}
{{- .Values.linkding.initScript | toString }}
{{- end }}

{{- define "linkding.adminUser" -}}
{{- .Values.linkding.admin.user | toString }}
{{- end }}

{{- define "linkding.adminPassword" -}}
{{- .Values.linkding.admin.password | toString }}
{{- end }}

{{/*
Authentication proxy configurations.
*/}}
{{- define "linkding.authProxyEnabled" -}}
{{- $v := .Values.authProxy.enabled | toString }}
{{- if $v }}{{ $v | title }}{{ end }}
{{- end }}

{{- define "linkding.authProxyUsernameHeader" -}}
{{- .Values.authProxy.usernameHeader | toString }}
{{- end }}

{{- define "linkding.authProxyLogoutUrl" -}}
{{- .Values.authProxy.logoutUrl | toString }}
{{- end }}

{{/*
Favicon configurations.
*/}}
{{- define "linkding.faviconProvider" -}}
{{- .Values.favicon.provider | toString }}
{{- end }}

{{- define "linkding.faviconRefreshEnabled" -}}
{{- $v := .Values.favicon.refreshEnabled | toString }}
{{- if $v }}{{ $v | title }}{{ end }}
{{- end }}

{{/*
Logging configurations.
*/}}
{{- define "linkding.loggingDisableRequestLogs" -}}
{{- $v := .Values.logging.disableRequestLogs | toString }}
{{- if $v }}{{ $v | lower }}{{ end }}
{{- end }}

{{/*
Network configurations.
*/}}
{{- define "linkding.networkPort" -}}
{{- .Values.network.port | toString }}
{{- end }}

{{- define "linkding.networkHost" -}}
{{- .Values.network.host | toString }}
{{- end }}

{{- define "linkding.networkContextPath" -}}
{{- .Values.network.contextPath | toString }}
{{- end }}

{{- define "linkding.networkAllowedHost" -}}
{{- .Values.network.allowedHost | toString }}
{{- end }}

{{- define "linkding.networkUseXForwardedHost" -}}
{{- $v := .Values.network.useXForwardedHost | toString }}
{{- if $v }}{{ $v | title }}{{ end }}
{{- end }}

{{- define "linkding.networkLogXForwardedFor" -}}
{{- ternary "true" "" (eq (.Values.network.logXForwardedFor | toString | lower) "true") }}
{{- end }}

{{- define "linkding.networkRequestTimeout" -}}
{{- .Values.network.requestTimeout | toString }}
{{- end }}

{{- define "linkding.networkRequestMaxContentLength" -}}
{{- .Values.network.requestMaxContentLength | toString }}
{{- end }}

{{/*
OpenID Connect configurations.
*/}}
{{- define "linkding.oidcEnabled" -}}
{{- $v := .Values.oidc.enabled | toString }}
{{- if $v }}{{ $v | title }}{{ end }}
{{- end }}

{{- define "linkding.oidcAuthorizationEndpoint" -}}
{{- .Values.oidc.authorizationEndpoint | toString }}
{{- end }}

{{- define "linkding.oidcTokenEndpoint" -}}
{{- .Values.oidc.tokenEndpoint | toString }}
{{- end }}

{{- define "linkding.oidcUserEndpoint" -}}
{{- .Values.oidc.userEndpoint | toString }}
{{- end }}

{{- define "linkding.oidcJwksEndpoint" -}}
{{- .Values.oidc.jwksEndpoint | toString }}
{{- end }}

{{- define "linkding.oidcClientId" -}}
{{- .Values.oidc.clientId | toString }}
{{- end }}

{{- define "linkding.oidcClientSecret" -}}
{{- .Values.oidc.clientSecret | toString }}
{{- end }}

{{- define "linkding.oidcSignAlgo" -}}
{{- .Values.oidc.signAlgo | toString }}
{{- end }}

{{- define "linkding.oidcScopes" -}}
{{- .Values.oidc.scopes | toString }}
{{- end }}

{{- define "linkding.oidcUsePkce" -}}
{{- $v := .Values.oidc.usePkce | toString }}
{{- if $v }}{{ $v | title }}{{ end }}
{{- end }}

{{- define "linkding.oidcVerifySsl" -}}
{{- $v := .Values.oidc.verifySsl | toString }}
{{- if $v }}{{ $v | title }}{{ end }}
{{- end }}

{{- define "linkding.oidcUsernameClaim" -}}
{{- .Values.oidc.usernameClaim | toString }}
{{- end }}

{{/*
Preview configurations.
*/}}
{{- define "linkding.previewMaxSize" -}}
{{- .Values.preview.maxSize | toString }}
{{- end }}

{{/*
Snapshot configurations.
*/}}
{{- define "linkding.snapshotsEnabled" -}}
{{- $v := .Values.snapshots.enabled | toString }}
{{- if $v }}{{ $v | title }}{{ end }}
{{- end }}

{{- define "linkding.snapshotsDisableAssetUpload" -}}
{{- $v := .Values.snapshots.disableAssetUpload | toString }}
{{- if $v }}{{ $v | title }}{{ end }}
{{- end }}

{{- define "linkding.snapshotsPdfMaxSize" -}}
{{- .Values.snapshots.pdfMaxSize | toString }}
{{- end }}

{{- define "linkding.snapshotsSinglefilePath" -}}
{{- .Values.snapshots.singlefile.path | toString }}
{{- end }}

{{- define "linkding.snapshotsSinglefileOptions" -}}
{{- .Values.snapshots.singlefile.options | toString }}
{{- end }}

{{- define "linkding.snapshotsSinglefileUblockOptions" -}}
{{- .Values.snapshots.singlefile.ublockOptions | toString }}
{{- end }}

{{- define "linkding.snapshotsSinglefileTimeout" -}}
{{- .Values.snapshots.singlefile.timeout | toString }}
{{- end }}

{{/*
Database configurations.
*/}}
{{- define "linkding.dbType" -}}
{{- $type := .Values.db.type | default "sqlite" | toString -}}
{{- if not (has $type (list "sqlite" "postgres")) -}}
{{- fail (printf "db.type must be \"sqlite\" or \"postgres\", got %q" $type) }}
{{- end }}
{{- $type }}
{{- end }}

{{- define "linkding.dbHost" -}}
{{- .Values.db.host | toString }}
{{- end }}

{{- define "linkding.dbPort" -}}
{{- .Values.db.port | default "5432" | toString }}
{{- end }}

{{- define "linkding.dbName" -}}
{{- .Values.db.name | toString }}
{{- end }}

{{- define "linkding.dbUser" -}}
{{- .Values.db.user | toString }}
{{- end }}

{{- define "linkding.dbPassword" -}}
{{- .Values.db.password | toString }}
{{- end }}

{{- define "linkding.dbOptions" -}}
{{- with .Values.db.options -}}
{{- toJson . }}
{{- end }}
{{- end }}

{{/*
Ingress configurations.
*/}}
{{- define "linkding.ingressEnabled" -}}
{{- .Values.ingress.enabled }}
{{- end }}

{{- define "linkding.ingressDomain" -}}
{{- $domain := include "linkding.domain" . }}
{{- ternary $domain "" (and .Values.ingress.enabled (ne $domain "")) }}
{{- end }}

{{- define "linkding.ingressClassName" -}}
{{- .Values.ingress.className | default "nginx" | toString }}
{{- end }}

{{- define "linkding.tlsSecretName" -}}
{{- .Values.ingress.tlsSecretName | default (printf "%s-linkding-tls-cert" .Release.Name) | toString }}
{{- end }}

{{- define "linkding.clusterIssuer" -}}
{{- .Values.ingress.clusterIssuer | default "letsencrypt-dns-prod" | toString }}
{{- end }}

{{- define "linkding.ingressWww" -}}
{{- .Values.ingress.www }}
{{- end }}

{{/*
Service configurations.
*/}}
{{- define "linkding.serviceNodePort" -}}
{{- $type := .Values.service.type | default "ClusterIP" | toString }}
{{- $nodePort := .Values.service.nodePort | toString }}
{{- ternary $nodePort "" (and (eq $type "NodePort") (ne $nodePort "")) }}
{{- end }}

{{- define "linkding.servicePort" -}}
{{- .Values.service.port | default "9090" | toString }}
{{- end }}

{{- define "linkding.serviceType" -}}
{{- .Values.service.type | default "ClusterIP" | toString }}
{{- end }}

{{/*
Storage configurations.
*/}}
{{- define "linkding.dataPersistence" -}}
{{- .Values.storage.data.enabled }}
{{- end }}

{{- define "linkding.dataAccessMode" -}}
{{- .Values.storage.data.accessMode | default "ReadWriteMany" | toString }}
{{- end }}

{{- define "linkding.dataMountPath" -}}
{{- .Values.storage.data.mountPath | default "/etc/linkding/data" | toString }}
{{- end }}

{{- define "linkding.dataSubPath" -}}
{{- .Values.storage.data.subPath | toString }}
{{- end }}

{{- define "linkding.dataStorage" -}}
{{- .Values.storage.data.storage | default "1Gi" | toString }}
{{- end }}

{{- define "linkding.dataStorageClassName" -}}
{{- .Values.storage.data.storageClassName | default "longhorn" | toString }}
{{- end }}

{{/*
Resource requirements and limits for Linkding containers.
*/}}
{{- define "linkding.resources" -}}
resources:
  {{- toYaml .Values.resources.linkding | nindent 2 }}
{{- end }}
