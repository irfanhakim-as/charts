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
Database configurations.
*/}}
{{- define "linkding.dbType" -}}
{{- .Values.db.type | default "sqlite" | toString }}
{{- end }}

{{- define "linkding.dbHost" -}}
{{- .Values.db.host | toString }}
{{- end }}

{{- define "linkding.dbPort" -}}
{{- .Values.db.port | toString }}
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
