# [Pocket ID](https://github.com/pocket-id/pocket-id)

The most user-friendly OpenID Connect Certified and OAuth 2.0 provider that lets users sign in to your applications with passkeys.

## Prerequisites

> [!NOTE]  
> You may refer to [Orked](https://github.com/irfanhakim-as/orked) for help with setting up a Kubernetes cluster that meets all the following prerequisites.

- Kubernetes 1.19+
- Helm 3.2.0+
- Longhorn 1.4.1+

---

## Preflight checklist

> [!IMPORTANT]  
> The following items are required to be set up prior to installing this chart.

### Generate an encryption key

Pocket ID requires an encryption key of at least 16 bytes to protect sensitive data (e.g. its token signing keys).

1. Generate a random key:

    ```sh
    openssl rand -base64 32
    ```

2. Set the key as `pocketid.encryptionKey` in your installation's values file:

    ```yaml
    pocketid:
      encryptionKey: "<encryption key>"
    ```

    **Alternatively**, provide the key through an existing Secret as described in [managing secrets separately](#managing-secrets-separately).

Store a backup of the key in a safe place, since data encrypted with a lost key cannot be recovered.

### Decide on the database

Pocket ID supports SQLite and Postgres. Only one Pocket ID instance may use a database at a time.

SQLite is the default and requires persistent storage to keep the database across restarts:

```yaml
db:
  type: "sqlite"
storage:
  data:
    enabled: true
```

**Alternatively**, use an external Postgres database. This chart does not bundle one.

1. Provision a database and user for Pocket ID on your Postgres server.

2. Set the connection details as the `db.*` settings in your installation's values file:

    ```yaml
    db:
      type: "postgres"
      host: "postgres.example.com"
      port: "5432"
      name: "pocketid"
      user: "pocketid"
      password: "<password>"
    ```

### Decide on the domain

Pocket ID is accessed over HTTPS at a single domain, which is also the domain every passkey is bound to. Choose it before any user registers a passkey, as changing it later invalidates existing passkeys.

```yaml
pocketid:
  domain: "id.example.com"
```

Set `ingress.enabled` to expose Pocket ID through an Ingress with a certificate from cert-manager. Alternatively, expose the `<release name>-pocket-id-svc` Service by other means (e.g. a tunnel) and keep `pocketid.domain` set to the public domain.

---

## Recommended configurations

> [!NOTE]  
> The following configuration recommendations might not be the default settings for this chart but are **highly recommended**. Please carefully consider them before configuring your installation.

### Update strategy

Keep `replicaCount` at `1` and set the update strategy to `Recreate`, so that two Pods never use the same database or storage during an upgrade:

```yaml
updateStrategy:
  type: "Recreate"
```

### Trusting the reverse proxy

Pocket ID records the IP address of each client in its audit log and rate limits. Behind an ingress controller, set `network.trustProxy` to the IP address or CIDR range of the controller Pods so the real client IP is used:

```yaml
network:
  trustProxy: "10.42.0.0/16"
```

When using Cloudflare, set `network.trustedPlatform` to `CF-Connecting-IP` instead. Rocket Loader must also be turned off for the domain in Cloudflare, as it breaks the Pocket ID interface.

### Storage for SQLite

Avoid NFS and SMB storage classes for the data storage when using SQLite, as the database may become corrupted on network shares. Pocket ID warns about this in its admin interface. If a network share cannot be avoided, back up the database regularly and set `db.dismissSqliteStorageWarning` to `i accept the risks` to hide the warning.

### Security context

The default image sets the owner of the data directory itself. When using a `-distroless` image tag, or when setting `runAsUser` or `runAsNonRoot` in `containerSecurityContext`, set `fsGroup` so the data storage is writable:

```yaml
podSecurityContext:
  fsGroup: 65532
```

### Internal URL for apps in the cluster

Apps that cannot reach Pocket ID at its public address (e.g. apps running in the same cluster) can use another address for the token, userinfo, introspection, and JWKS endpoints. Set `pocketid.internalAppUrl` only if every app that uses Pocket ID can reach that address:

```yaml
pocketid:
  internalAppUrl: "http://<release name>-pocket-id-svc.<namespace>.svc.cluster.local:1411"
```

### Managing secrets separately

To keep sensitive values out of the values file, set `pocketid.existingSecret` to the name of a Secret you manage yourself. Its keys must be the environment variable names listed here, and any key it sets takes precedence over the same setting in the values file:

- `ENCRYPTION_KEY`
- `DB_CONNECTION_STRING`
- `STATIC_API_KEY`
- `S3_ACCESS_KEY_ID`
- `S3_SECRET_ACCESS_KEY`
- `MAXMIND_LICENSE_KEY`
- `SMTP_USER`
- `SMTP_PASSWORD`
- `LDAP_BIND_DN`
- `LDAP_BIND_PASSWORD`
- `TLS_KEY`

For Postgres, `DB_CONNECTION_STRING` takes the form `postgres://user:password@host:5432/name` with reserved characters in the user and password percent-encoded.

### Collecting metrics

Set `observability.prometheus.enabled` to expose Prometheus metrics on a dedicated port of the Service. The metrics port is never exposed through the Ingress. With the Prometheus Operator installed, also set `observability.prometheus.serviceMonitor.enabled` to create a ServiceMonitor for it.

---

## Application configurations

> [!NOTE]  
> The following configurations are expected or recommended to be set up from within the application after completing the installation.

### Create the admin account

Visit the `/setup` page of your Pocket ID domain (e.g. `https://id.example.com/setup`) immediately after the installation to create the admin account and register its passkey. The first visitor to reach this page becomes the admin.

### Recover access to an account

If a user loses access to their passkeys, generate a one-time login link for them from inside the Pocket ID Pod:

```sh
kubectl exec --namespace ${namespace} deploy/${releaseName}-pocket-id -- /app/pocket-id one-time-access-token ${username}
```

Replace `${namespace}`, `${releaseName}`, and `${username}` accordingly. The link signs the user in once and is valid for one hour.

### Manage settings with environment variables

The settings under **Application Configuration** in the admin interface are stored in the database. To manage them from the values file instead, set `ui.configDisabled` to `"true"`. The `ui`, `mail`, and `ldap` settings then apply, and every setting left empty keeps its default.

---

## How to add the chart repo

1. Add the repo to your local helm client:

    ```sh
    helm repo add moekai https://charts.moekai.com
    ```

2. Update the repo to retrieve the latest versions of the packages:

    ```sh
    helm repo update
    ```

---

## How to install or upgrade a chart release

1. Get the values file of the Pocket ID chart or an existing installation (release).

    Get the latest Pocket ID chart values file for a new installation:

    ```sh
    helm show values moekai/pocket-id > values.yaml
    ```

    **Alternatively**, get the values file of an existing Pocket ID release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Pocket ID values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Pocket ID or upgrade an existing Pocket ID release:

    ```sh
    helm upgrade --install ${releaseName} moekai/pocket-id --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Pocket ID release has been installed:

    ```sh
    helm ls --namespace ${namespace} | grep "${releaseName}"
    ```

    Replace `${namespace}` and `${releaseName}` accordingly. This should return the release information if the release has been installed.

---

## How to uninstall a chart release

> [!CAUTION]  
> Uninstalling a release will irreversibly delete all the resources associated with the release, including any persistent data.

1. Uninstall the desired release:

    ```sh
    helm uninstall ${releaseName} --namespace ${namespace} --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Verify that the release has been uninstalled:

    ```sh
    helm ls --namespace ${namespace} | grep "${releaseName}"
    ```

    Replace `${namespace}` and `${releaseName}` accordingly. This should return nothing if the release has been uninstalled.

---

## Chart configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | The scheduling constraints applied to Pocket ID pods. |
| containerSecurityContext | object | `{}` | Security context applied at the Pocket ID container level. |
| db.connectTimeout | string | `""` | The number of seconds to wait before timing out when connecting to the database. Default: `"10"`. |
| db.dismissSqliteStorageWarning | string | `""` | Specifies whether to hide the admin warning about a SQLite database on a network share. |
| db.host | string | `""` | The hostname or IP address of the Pocket ID database server. |
| db.name | string | `""` | The name of the database being used by Pocket ID. |
| db.password | string | `""` | The password associated with the Pocket ID database user. |
| db.port | string | `""` | The port number the Pocket ID database server is listening for connections. Default: `"5432"`. |
| db.sqlitePath | string | `""` | The path of the SQLite database file. Default: `"${.storage.data.mountPath}/pocket-id.db"`. |
| db.sslMode | string | `""` | Specifies whether to use a secure TLS connection when connecting to the database. Default: `"disable"`. |
| db.type | string | `""` | The database engine or backend being used by Pocket ID. Default: `"sqlite"`. |
| db.user | string | `""` | The username or user account for accessing the Pocket ID database. |
| extraEnv | list | `[]` | Additional environment variables to be set on the Pocket ID container. |
| extraVolumeMounts | list | `[]` | Additional volume mounts to be added to the Pocket ID container. |
| extraVolumes | list | `[]` | Additional volumes to be added to Pocket ID pods. |
| files.backend | string | `""` | The backend where uploads are stored. Default: `"filesystem"`. |
| files.uploadPath | string | `""` | The uploads directory for the filesystem backend, or the key prefix inside the bucket for the S3 backend. Default: `"${.storage.data.mountPath}/uploads"`. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| image.pocketid.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Pocket ID container image. Default: `"IfNotPresent"`. |
| image.pocketid.registry | string | `""` | The registry where the Pocket ID container image is hosted. Default: `"ghcr.io"`. |
| image.pocketid.repository | string | `""` | The name of the repository that contains the Pocket ID container image used. Default: `"pocket-id/pocket-id"`. |
| image.pocketid.tag | string | `""` | The tag that specifies the version of the Pocket ID container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.className | string | `""` | The class of the ingress controller that handles the Ingress. Default: `"nginx"`. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Pocket ID services. |
| ingress.tlsSecretName | string | `""` | The name of the Secret that stores the TLS certificate of the Ingress. Default: `"${.Release.Name}-pocket-id-tls-cert"`. |
| ldap.adminGroupName | string | `""` | The name of the LDAP group whose members become admins. |
| ldap.attributes.groupMember | string | `""` | The attribute that lists the members of a group. Default: `"member"`. |
| ldap.attributes.groupName | string | `""` | The attribute holding the name of a group. |
| ldap.attributes.groupUniqueIdentifier | string | `""` | The attribute that identifies a group. |
| ldap.attributes.userDisplayName | string | `""` | The attribute holding the display name of a user. Default: `"cn"`. |
| ldap.attributes.userEmail | string | `""` | The attribute holding the email address of a user. |
| ldap.attributes.userFirstName | string | `""` | The attribute holding the first name of a user. |
| ldap.attributes.userLastName | string | `""` | The attribute holding the last name of a user. |
| ldap.attributes.userProfilePicture | string | `""` | The attribute holding the profile picture of a user. |
| ldap.attributes.userUniqueIdentifier | string | `""` | The attribute that identifies a user. |
| ldap.attributes.userUsername | string | `""` | The attribute holding the username of a user. |
| ldap.base | string | `""` | The base DN of the LDAP search. |
| ldap.bindDn | string | `""` | The DN of the account Pocket ID searches LDAP with. |
| ldap.bindPassword | string | `""` | The password of the account Pocket ID searches LDAP with. |
| ldap.enabled | string | `""` | Specifies whether to sync users and groups from LDAP. Default: `"false"`. |
| ldap.skipCertVerify | string | `""` | Specifies whether to accept self-signed LDAP server certificates. Default: `"false"`. |
| ldap.softDeleteUsers | string | `""` | Specifies whether to disable users who disappear from LDAP instead of deleting them. Default: `"true"`. |
| ldap.url | string | `""` | The URL of the LDAP server. |
| ldap.userGroupSearchFilter | string | `""` | The LDAP filter that selects which entries are groups. Default: `"(objectClass=groupOfNames)"`. |
| ldap.userSearchFilter | string | `""` | The LDAP filter that selects which entries are users. Default: `"(objectClass=person)"`. |
| location.cloudflareHeaders | string | `""` | Specifies whether to take locations from Cloudflare headers instead of the GeoLite2 database. Default: `"false"`. |
| location.geoliteDbPath | string | `""` | The path where the GeoLite2 database is stored. Default: `"${.storage.data.mountPath}/GeoLite2-City.mmdb"`. |
| location.geoliteDbUrl | string | `""` | The URL the GeoLite2 database is downloaded from, where "%s" stands for the license key. Default: `"https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=%s&suffix=tar.gz"`. |
| location.maxmindLicenseKey | string | `""` | The MaxMind license key that lets Pocket ID download the GeoLite2 database to show locations in the audit log. |
| logging.json | string | `""` | Specifies whether to write logs as JSON. Default: `"false"`. |
| logging.level | string | `""` | The minimum severity of the logs written by Pocket ID. Default: `"info"`. |
| logging.queryArgs | string | `""` | Specifies whether to include the values of database queries in debug logs and traces. Default: `"false"`. |
| mail.apiKeyExpirationEnabled | string | `""` | Specifies whether to email users before their API keys expire. Default: `"false"`. |
| mail.from | string | `""` | The sender address of sent emails. |
| mail.loginNotificationEnabled | string | `""` | Specifies whether to email users when they sign in from a new device. Default: `"false"`. |
| mail.oneTimeAccessAsAdminEnabled | string | `""` | Specifies whether admins may email a login code to a user. Default: `"false"`. |
| mail.oneTimeAccessAsUnauthenticatedEnabled | string | `""` | Specifies whether users may request a login code by email. Default: `"false"`. |
| mail.smtp.host | string | `""` | The hostname or IP address of the SMTP server for sending emails. |
| mail.smtp.password | string | `""` | The password for authenticating with the SMTP server. |
| mail.smtp.port | string | `""` | The port number on the SMTP server used for sending emails. |
| mail.smtp.skipCertVerify | string | `""` | Specifies whether to accept self-signed SMTP server certificates. Default: `"false"`. |
| mail.smtp.tls | string | `""` | The type of TLS used when connecting to the SMTP server. Default: `"none"`. |
| mail.smtp.user | string | `""` | The username for authenticating with the SMTP server. |
| mail.verificationEnabled | string | `""` | Specifies whether to email users a link to verify their address when they sign up or change it. Default: `"false"`. |
| network.host | string | `""` | The address Pocket ID listens on. Default: `"0.0.0.0"`. |
| network.localIpv6Ranges | string | `""` | The comma-separated IPv6 ranges treated as local network in the audit log and for outbound requests. |
| network.port | string | `""` | The port Pocket ID listens on. Default: `"1411"`. |
| network.proxyProtocol | string | `""` | The load balancers that send the PROXY protocol header, as comma-separated IP addresses or CIDR ranges. Default: `"false"`. |
| network.trustProxy | string | `""` | The reverse proxies to take the client IP from, as comma-separated IP addresses or CIDR ranges. Default: `"false"`. |
| network.trustedPlatform | string | `""` | The header that a CDN or platform sets to the client IP. |
| nodeSelector | object | `{}` | The node labels a node must have for Pocket ID pods to be scheduled onto it. |
| observability.logsExporter | string | `""` | The exporter used to send logs. |
| observability.metricsExporter | string | `""` | The exporter used to send metrics. |
| observability.otlpEndpoint | string | `""` | The endpoint of the OTLP collector that receives exported telemetry. |
| observability.prometheus.enabled | bool | `false` | Specifies whether to expose Prometheus metrics on a dedicated container and service port. |
| observability.prometheus.port | string | `""` | The port Prometheus metrics are served on. Default: `"9464"`. |
| observability.prometheus.serviceMonitor.enabled | bool | `false` | Specifies whether to create a ServiceMonitor for scraping Pocket ID metrics. |
| observability.prometheus.serviceMonitor.interval | string | `""` | The interval at which metrics are scraped. Default: `"30s"`. |
| observability.prometheus.serviceMonitor.labels | object | `{}` | Additional labels to be added to the ServiceMonitor. |
| observability.prometheus.serviceMonitor.namespace | string | `""` | The namespace to create the ServiceMonitor in. Default: `"${.Release.Namespace}"`. |
| observability.prometheus.serviceMonitor.scrapeTimeout | string | `""` | The time to wait for a scrape before it times out. Default: `"10s"`. |
| observability.tracesExporter | string | `""` | The exporter used to send traces. |
| pocketid.allowDowngrade | string | `""` | Specifies whether an older version may start on a database that a newer version already migrated. Default: `"false"`. |
| pocketid.analyticsDisabled | string | `""` | Specifies whether to turn off the daily heartbeat that counts running instances. Default: `"false"`. |
| pocketid.appUrl | string | `""` | The full public URL that Pocket ID is opened at. Default: `"https://${.domain}"`. |
| pocketid.domain | string | `""` | The domain name that Pocket ID is served from. |
| pocketid.encryptionKey | string | `""` | The key used to encrypt sensitive data. |
| pocketid.existingSecret | string | `""` | The name of an existing Secret to load sensitive environment variables from. |
| pocketid.iconLibraryUrl | string | `""` | The URL the logo picker of OIDC clients searches for icons. Default: `"https://cdn.jsdelivr.net/gh/selfhst/icons@main"`. |
| pocketid.initScript | string | `""` | Custom init script to run before the Pocket ID container starts. |
| pocketid.internalAppUrl | string | `""` | The internal URL apps use to reach the token, userinfo, introspection, and JWKS endpoints. Default: `"${.appUrl}"`. |
| pocketid.pgid | string | `""` | The group ID the default image runs Pocket ID as, and which owns the data directory. Default: `"1000"`. |
| pocketid.puid | string | `""` | The user ID the default image runs Pocket ID as, and which owns the data directory. Default: `"1000"`. |
| pocketid.staticApiKey | string | `""` | An API key with admin rights for declarative setups. |
| pocketid.timezone | string | `""` | The timezone used by Pocket ID for time-based operations. |
| pocketid.versionCheckDisabled | string | `""` | Specifies whether to turn off the check for new releases. Default: `"false"`. |
| podAnnotations | object | `{}` | Annotations to be applied to Pocket ID pods. |
| podSecurityContext | object | `{}` | Security context applied at the pod level for Pocket ID. |
| probes.pocketid.liveness.enabled | bool | `false` | Specifies whether to enable the liveness probe for the Pocket ID container. |
| probes.pocketid.liveness.spec | object | `{}` | The specification defining how the liveness probe checks the Pocket ID container health. |
| probes.pocketid.readiness.enabled | bool | `false` | Specifies whether to enable the readiness probe for the Pocket ID container. |
| probes.pocketid.readiness.spec | object | `{}` | The specification defining how the readiness probe checks the Pocket ID container health. |
| probes.pocketid.startup.enabled | bool | `false` | Specifies whether to enable the startup probe for the Pocket ID container. |
| probes.pocketid.startup.spec | object | `{}` | The specification defining how the startup probe checks the Pocket ID container health. |
| replicaCount | string | `""` | The desired number of running replicas for Pocket ID. Default: `"1"`. |
| resources.pocketid | object | `{}` | Pocket ID container resources. |
| s3.accessKeyId | string | `""` | The access key ID used to authenticate with the S3-compatible file storage. |
| s3.bucket | string | `""` | The name of the bucket used for storing Pocket ID files. |
| s3.disableDefaultIntegrityChecks | string | `""` | Specifies whether to turn off the checksums sent by newer AWS SDKs. Default: `"false"`. |
| s3.endpoint | string | `""` | The endpoint of the S3-compatible file storage, for storage other than AWS. |
| s3.forcePathStyle | string | `""` | Specifies whether to address the bucket in the path instead of the host name. Default: `"false"`. |
| s3.region | string | `""` | The region of the S3-compatible file storage. |
| s3.secretAccessKey | string | `""` | The secret access key used to authenticate with the S3-compatible file storage. |
| security.allowInsecureCallbackUrls | string | `""` | Specifies whether to allow "http://" callback URLs on hosts other than localhost. Default: `"true"`. |
| security.auditLogRetentionDays | string | `""` | The number of days the audit log keeps events. Default: `"90"`. |
| security.disableRateLimiting | string | `""` | Specifies whether to turn off the built-in rate limits. Default: `"false"`. |
| security.outboundAllowedHosts.backchannelLogout | string | `""` | The hosts the back-channel logout URL of OIDC clients may connect to. Default: `"private,loopback"`. |
| security.outboundAllowedHosts.clientLogo | string | `""` | The hosts the logo URLs of OIDC clients may connect to. Default: `"none"`. |
| security.outboundAllowedHosts.clientMetadata | string | `""` | The hosts client ID metadata documents may be fetched from. Default: `"none"`. |
| security.outboundAllowedHosts.federatedJwks | string | `""` | The hosts the JWKS URL of federated client credentials may connect to. Default: `"private,loopback"`. |
| security.outboundAllowedHosts.ldapPicture | string | `""` | The hosts profile pictures provided as a URL by LDAP may be fetched from. Default: `"none"`. |
| security.outboundAllowedHosts.scim | string | `""` | The hosts the SCIM endpoint of SCIM clients may connect to. Default: `"private,loopback"`. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the Pocket ID server should listen for connections. Default: `"1411"`. |
| service.type | string | `""` | The type of service used to expose Pocket ID services. Default: `"ClusterIP"`. |
| serviceAccount.annotations | object | `{}` | Annotations to be applied to the created service account. |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created for Pocket ID. |
| serviceAccount.name | string | `""` | The name of the service account used by Pocket ID pods. Default: `"${.Release.Name}-pocket-id"`. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteOnce"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/app/data"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |
| tls.cert | string | `""` | The PEM certificate Pocket ID serves HTTPS with. |
| tls.key | string | `""` | The PEM private key Pocket ID serves HTTPS with. |
| tolerations | list | `[]` | The tolerations that allow Pocket ID pods to be scheduled onto tainted nodes. |
| ui.accentColor | string | `""` | The accent color of the UI as a CSS color. Default: `"default"`. |
| ui.allowOwnAccountEdit | string | `""` | Specifies whether users may edit their own name and email address. Default: `"true"`. |
| ui.appName | string | `""` | The name shown in the UI and in emails. Default: `"Pocket ID"`. |
| ui.autoCreateOidcClientSecret | string | `""` | Specifies whether to create a secret that does not expire for every new confidential client. Default: `"true"`. |
| ui.cimdUrlAllowlist | string | `""` | A JSON array of the client ID metadata document URLs Pocket ID accepts. Default: `"[]"`. |
| ui.configDisabled | string | `""` | Specifies whether the settings of the admin UI are taken from environment variables. Default: `"false"`. |
| ui.disableAnimations | string | `""` | Specifies whether to turn off the animations of the UI. Default: `"false"`. |
| ui.homePageUrl | string | `""` | The page users land on after signing in to Pocket ID itself. Default: `"/settings/account"`. |
| ui.passkeys.allowSyncedPasskeys | string | `""` | Specifies whether passkeys that sync between devices are allowed. Default: `"true"`. |
| ui.passkeys.authenticatorAttachment | string | `""` | The type of authenticator allowed for passkeys. Default: `"any"`. |
| ui.passkeys.userVerification | string | `""` | The user verification level required for passkeys. Default: `"required"`. |
| ui.sessionDuration | string | `""` | The number of minutes a session lasts before users sign in again. Default: `"60"`. |
| ui.users.allowUserSignups | string | `""` | The type of user signups allowed. Default: `"disabled"`. |
| ui.users.emailsVerified | string | `""` | Specifies whether to mark email addresses as verified when users sign up or change them. Default: `"false"`. |
| ui.users.requireUserEmail | string | `""` | Specifies whether every account requires an email address. Default: `"true"`. |
| ui.users.signupDefaultCustomClaims | string | `""` | A JSON array of the custom claims given to new accounts. Default: `"[]"`. |
| ui.users.signupDefaultUserGroupIds | string | `""` | A JSON array of the group IDs new accounts join. Default: `"[]"`. |
| updateStrategy | object | `{}` | The update strategy used to replace existing pods with new ones. |
