# [Vaultwarden](https://github.com/dani-garcia/vaultwarden)

An alternative server implementation of the Bitwarden Client API written in Rust and compatible with official Bitwarden clients.

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

### Generate admin token

A unique, secure admin token (password) is required for each Vaultwarden installation to allow access to the admin panel.

1. Generate an admin password using the following command:

    ```sh
    python -c 'import random; print("".join([random.choice("abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)") for i in range(50)]))'
    ```

    Sample value:

    ```
      6bkw1l_+4u^&sinqb2dmpt-u&rnhlmi*@u=j7z^@(a0k^ys=h4
    ```

2. Secure the generated password with a hash using Argon2:

    ```sh
    echo -n '<admin-token>' | argon2 "$(openssl rand -base64 32)" -e -id -k 65540 -t 3 -p 4
    ```

    Replace `<admin-token>` with the secure password you have generated. For example:

    ```sh
    echo -n '6bkw1l_+4u^&sinqb2dmpt-u&rnhlmi*@u=j7z^@(a0k^ys=h4' | argon2 "$(openssl rand -base64 32)" -e -id -k 65540 -t 3 -p 4
    ```

    Sample hash value:

    ```
      $argon2id$v=19$m=65540,t=3,p=4$K1ZEaDRCbTdGdUwrT3RuV3VodE9FVFFmYmhQNThaNUF3dWgvejV6R0VkRT0$RGdC5jEqxf661ayok4F8gK+7HuFESqPEUaEi1tO9LrI
    ```

2. Set the admin token that has been secured as the value of the `vaultwarden.adminToken` setting in your installation's values file:

    ```yaml
    adminToken: "<secure-admin-token>"
    ```

    Replace `<secure-admin-token>` with the admin token that has been hashed using Argon2. For example:

    ```sh
    adminToken: "$argon2id$v=19$m=65540,t=3,p=4$K1ZEaDRCbTdGdUwrT3RuV3VodE9FVFFmYmhQNThaNUF3dWgvejV6R0VkRT0$RGdC5jEqxf661ayok4F8gK+7HuFESqPEUaEi1tO9LrI"
    ```

### Decide on the database

Vaultwarden supports SQLite, MySQL, and Postgres. Only one Vaultwarden instance may use a SQLite database at a time.

SQLite is the default and requires persistent storage to keep the database across restarts:

```yaml
db:
  type: "sqlite"
storage:
  data:
    enabled: true
```

**Alternatively**, use an external MySQL or Postgres database. This chart does not bundle one.

1. Provision a database and user for Vaultwarden on your database server.

2. Set the connection details as the `db.*` settings in your installation's values file:

    ```yaml
    db:
      type: "postgresql"
      host: "postgres.example.com"
      port: "5432"
      name: "vaultwarden"
      user: "vaultwarden"
      password: "<password>"
    ```

    Set `db.type` to `mysql` to use MySQL. The port defaults to `5432` for Postgres and `3306` for MySQL.

### Decide on the domain

Bitwarden clients require Vaultwarden to be served over HTTPS. Enable the ingress and set the domain that Vaultwarden is served from:

```yaml
vaultwarden:
  domain: "vault.example.com"
ingress:
  enabled: true
```

Links in emails and the SSO redirect address are built from this domain.

---

## Recommended configurations

> [!NOTE]  
> The following configuration recommendations might not be the default settings for this chart but are **highly recommended**. Please carefully consider them before configuring your installation.

### Update strategy

When using SQLite or a `ReadWriteOnce` data storage, keep `replicaCount` at `1` and set the update strategy to `Recreate`, so that two Pods never use the same database or storage during an upgrade:

```yaml
updateStrategy:
  type: "Recreate"
```

### Reverse proxy

Vaultwarden uses the IP address of each client for its rate limits. Behind an ingress controller in the cluster, the default settings take the address from the `X-Real-IP` header. If your proxy sends another header or connects from a public address, set `network.ipHeader` and `network.ipHeaderTrustedProxies` accordingly:

```yaml
network:
  ipHeader: "X-Forwarded-For"
  ipHeaderTrustedProxies: "10.42.0.0/16"
```

### Security context

To run Vaultwarden as a non-root user, set a port of 1024 or higher and an `fsGroup` so the data storage is writable:

```yaml
network:
  port: "8080"
podSecurityContext:
  fsGroup: 1000
containerSecurityContext:
  runAsUser: 1000
  runAsGroup: 1000
  runAsNonRoot: true
```

### Managing secrets separately

To keep sensitive values out of the values file, set `vaultwarden.existingSecret` to the name of a Secret you manage yourself. Its keys must be the environment variable names listed here, and any key it sets takes precedence over the same setting in the values file:

- `ADMIN_TOKEN`
- `DATABASE_URL`
- `HIBP_API_KEY`
- `PUSH_INSTALLATION_ID`
- `PUSH_INSTALLATION_KEY`
- `SMTP_USERNAME`
- `SMTP_PASSWORD`
- `SSO_CLIENT_SECRET`
- `YUBICO_CLIENT_ID`
- `YUBICO_SECRET_KEY`
- `DUO_IKEY`
- `DUO_SKEY`

For Postgres and MySQL, `DATABASE_URL` takes the form `postgresql://user:password@host:5432/name`, with reserved characters in the user and password percent-encoded.

### Email

Set `mail.fromEmail` and `mail.smtp.host` to send emails such as verification links, invitations, and new device notifications. The SMTP port defaults to the standard port of the chosen `mail.smtp.security` type.

---

## Application configurations

> [!NOTE]  
> The following configurations are expected or recommended to be set up from within the application after completing the installation.

### Create the first account

User registration is closed by default. Set `signup.enabled` to `"true"` to register the first account, then set it back to `"false"` once done. Invitations from the admin panel and organizations remain available when `invitation.enabled` is `"true"`.

### Access the admin panel

Visit the `/admin` page of your Vaultwarden domain (e.g. `https://vault.example.com/admin`) and enter the admin token generated in the [preflight checklist](#generate-admin-token). The panel is unavailable when no admin token is set.

### Sign in with SSO

Set `sso.enabled` to `"true"` along with `sso.authority`, `sso.clientId`, and `sso.clientSecret` of the OpenID Connect (OIDC) provider. Register `https://<domain>/identity/connect/oidc-signin` as the redirect URI of the client in the provider.

By default, a new SSO user is linked to an existing account with the same email address, and an account is created when none exists. Set `sso.signupsAllowed` to `"false"` to prevent the creation of accounts through SSO.

Set `sso.only` to `"true"` only after confirming that signing in with SSO works, since email and master password login is no longer available afterwards.

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

1. Get the values file of the Vaultwarden chart or an existing installation (release).

    Get the latest Vaultwarden chart values file for a new installation:

    ```sh
    helm show values moekai/vaultwarden > values.yaml
    ```

    **Alternatively**, get the values file of an existing Vaultwarden release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Vaultwarden values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Vaultwarden or upgrade an existing Vaultwarden release:

    ```sh
    helm upgrade --install ${releaseName} moekai/vaultwarden --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Vaultwarden release has been installed:

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
| admin.disableToken | string | `""` | Specifies whether to bypass the security of the admin panel. |
| admin.sessionLifetime | string | `""` | The number of minutes an admin session lasts for. |
| affinity | object | `{}` | The scheduling constraints applied to Vaultwarden pods. |
| containerSecurityContext | object | `{}` | Security context applied at the Vaultwarden container level. |
| db.connectionInit | string | `""` | The SQL statements to run whenever a new database connection is created. |
| db.connectionRetries | string | `""` | The number of times to retry the database connection at startup. |
| db.host | string | `""` | The hostname or IP address of the Vaultwarden database server. |
| db.idleTimeout | string | `""` | The number of seconds before an idle database connection is closed. |
| db.maxConnections | string | `""` | The maximum size of the database connection pool. |
| db.minConnections | string | `""` | The minimum size of the database connection pool. |
| db.name | string | `""` | The name of the database being used by Vaultwarden. |
| db.password | string | `""` | The password associated with the Vaultwarden database user. |
| db.port | string | `""` | The port number the Vaultwarden database server is listening for connections. Default: `"5432" for postgresql, "3306" for mysql`. |
| db.timeout | string | `""` | The number of seconds to wait when acquiring a database connection. |
| db.type | string | `""` | The database engine or backend being used by Vaultwarden. Default: `"sqlite"`. |
| db.user | string | `""` | The username or user account for accessing the Vaultwarden database. |
| db.wal | string | `""` | Specifies whether Vaultwarden enables write-ahead logging (WAL) on the SQLite database at startup. |
| duo.enabled | string | `""` | Specifies whether to enable Duo 2FA integration for all users. Default: `"false"`. |
| duo.host | string | `""` | The API hostname of the Duo application. |
| duo.id | string | `""` | The integration key (client ID) of the Duo application. |
| duo.key | string | `""` | The secret key (client secret) of the Duo application. |
| extraEnv | list | `[]` | Additional environment variables to be set on the Vaultwarden container. |
| extraVolumeMounts | list | `[]` | Additional volume mounts to be added to the Vaultwarden container. |
| extraVolumes | list | `[]` | Additional volumes to be added to Vaultwarden pods. |
| icons.cacheNegativeTtl | string | `""` | The number of seconds before retrying an icon that was not available. |
| icons.cacheTtl | string | `""` | The number of seconds a downloaded icon is considered fresh. |
| icons.disableDownload | string | `""` | Specifies whether to stop downloading icons and only serve the ones already cached. |
| icons.downloadTimeout | string | `""` | The number of seconds before giving up on downloading an icon. |
| icons.redirectCode | string | `""` | The HTTP status code used to redirect to an external icon service. |
| icons.service | string | `""` | The service that provides website icons. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| image.vaultwarden.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Vaultwarden container image. Default: `"IfNotPresent"`. |
| image.vaultwarden.registry | string | `""` | The registry where the Vaultwarden container image is hosted. Default: `"ghcr.io"`. |
| image.vaultwarden.repository | string | `""` | The name of the repository that contains the Vaultwarden container image used. Default: `"dani-garcia/vaultwarden"`. |
| image.vaultwarden.tag | string | `""` | The tag that specifies the version of the Vaultwarden container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.className | string | `""` | The class of the ingress controller that handles the Ingress. Default: `"nginx"`. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Vaultwarden services. |
| ingress.tlsSecretName | string | `""` | The name of the Secret that stores the TLS certificate of the Ingress. Default: `"${.Release.Name}-vaultwarden-tls-cert"`. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| invitation.enabled | string | `""` | Specifies whether to allow organisation admins to send user invitations. Default: `"false"`. |
| invitation.expiry | string | `""` | The number of hours after which an invitation token expires. Default: `"120"`. |
| invitation.organisation | string | `""` | The default organisation display name shown in invitation emails. Default: `"Vaultwarden"`. |
| jobs.pollInterval | string | `""` | The number of milliseconds between checks for jobs that need to run. |
| jobs.schedules.authRequestPurge | string | `""` | The cron schedule of the job that deletes old authentication requests. |
| jobs.schedules.duoContextPurge | string | `""` | The cron schedule of the job that deletes expired Duo contexts. |
| jobs.schedules.emergencyNotificationReminder | string | `""` | The cron schedule of the job that sends expiration reminders to emergency access grantors. |
| jobs.schedules.emergencyRequestTimeout | string | `""` | The cron schedule of the job that grants emergency access requests that have met the required wait time. |
| jobs.schedules.eventCleanup | string | `""` | The cron schedule of the job that deletes old events. |
| jobs.schedules.incomplete2fa | string | `""` | The cron schedule of the job that checks for incomplete two-factor authentication logins. |
| jobs.schedules.incompleteSsoPurge | string | `""` | The cron schedule of the job that deletes leftovers of incomplete SSO logins. |
| jobs.schedules.sendPurge | string | `""` | The cron schedule of the job that deletes Sends past their deletion date. |
| jobs.schedules.trashPurge | string | `""` | The cron schedule of the job that permanently deletes trashed items. |
| limits.increaseNoteSize | string | `""` | Specifies whether to raise the secure note size limit from 10,000 to 100,000 characters. |
| limits.organizationAttachment | string | `""` | The maximum attachment storage in kilobytes allowed per organization. |
| limits.userAttachment | string | `""` | The maximum attachment storage in kilobytes allowed per user. |
| limits.userSend | string | `""` | The maximum Send storage in kilobytes allowed per user. |
| logging.extended | string | `""` | Specifies whether to show timestamps and targets in the logs. |
| logging.file | string | `""` | The path of a file to write the logs to. |
| logging.syslog | string | `""` | Specifies whether to send the logs to Syslog. |
| logging.timestampFormat | string | `""` | The timestamp format used in extended logging. |
| mail.fromEmail | string | `""` | The email address used in the "from" address for sent emails. Default: `"${.smtp.user}"`. |
| mail.fromName | string | `""` | The display name used in the "from" address for sent emails. Default: `"Vaultwarden"`. |
| mail.sendmail.command | string | `""` | The path of the "sendmail" command. |
| mail.sendmail.enabled | string | `""` | Specifies whether to send emails with the "sendmail" command. |
| mail.smtp.acceptInvalidCerts | string | `""` | Specifies whether to accept invalid TLS certificates of the SMTP server. |
| mail.smtp.acceptInvalidHostnames | string | `""` | Specifies whether to accept TLS certificates of the SMTP server that do not match its host name. |
| mail.smtp.authMechanism | string | `""` | The authentication mechanisms to use with the SMTP server, separated by commas. |
| mail.smtp.debug | string | `""` | Specifies whether to log detailed SMTP messages. |
| mail.smtp.embedImages | string | `""` | Specifies whether to embed images in emails as attachments. |
| mail.smtp.heloName | string | `""` | The server name sent to the SMTP server during HELO. |
| mail.smtp.host | string | `""` | The hostname or IP address of the SMTP server for sending emails. |
| mail.smtp.password | string | `""` | The password for authenticating with the SMTP server. |
| mail.smtp.port | string | `""` | The port number on the SMTP server used for sending emails. Default: `"587" for starttls, "465" for force_tls, "25" for off`. |
| mail.smtp.security | string | `""` | The SMTP security protocol used for securing email communication. Default: `"starttls"`. |
| mail.smtp.timeout | string | `""` | The number of seconds before giving up on connecting to the SMTP server. |
| mail.smtp.user | string | `""` | The username for authenticating with the SMTP server. |
| network.address | string | `""` | The address Vaultwarden binds to inside the container. |
| network.allowedConnectSrc | list | `[]` | The additional HTTPS domains that scripts in the web vault may connect to (e.g. email alias services). |
| network.allowedIframeAncestors | list | `[]` | The domains allowed to embed the web vault in an iframe. |
| network.dnsPreferIpv6 | string | `""` | Specifies whether to resolve IPv6 addresses first and fall back to IPv4. |
| network.ipHeader | string | `""` | The request header that carries the IP address of the client. |
| network.ipHeaderTrustedProxies | string | `""` | The addresses the client IP header is accepted from. |
| network.port | string | `""` | The port on which Vaultwarden listens inside the container. Default: `"80"`. |
| network.websocket | string | `""` | Specifies whether to enable websocket notifications. |
| nodeSelector | object | `{}` | The node labels a node must have for Vaultwarden pods to be scheduled onto it. |
| organization.creationUsers | list | `[]` | The users allowed to create organizations. |
| organization.enforceSingleOrgWithResetPasswordPolicy | string | `""` | Specifies whether the Single Org policy must be enabled before the Reset Password policy. |
| organization.eventsEnabled | string | `""` | Specifies whether to log events of organizations. |
| organization.eventsRetainDays | string | `""` | The number of days events are kept in the database. |
| organization.groupsEnabled | string | `""` | Specifies whether to enable groups for organizations. |
| outbound.blockNonGlobalIps | string | `""` | Specifies whether to refuse connecting to non-global IP addresses. |
| outbound.blockRegex | string | `""` | A regular expression matching the domains and IP addresses that must not be fetched. |
| password.hintsAllowed | string | `""` | Specifies whether users can set and view password hints. |
| password.iterations | string | `""` | The number of server-side hashing iterations for the password hash of new users. |
| password.showHint | string | `""` | Specifies whether a password hint is shown in the web page when email is not configured and hints are allowed. |
| podAnnotations | object | `{}` | Annotations to be applied to Vaultwarden pods. |
| podSecurityContext | object | `{}` | Security context applied at the pod level for Vaultwarden. |
| probes.vaultwarden.liveness.enabled | bool | `false` | Specifies whether to enable the liveness probe for the Vaultwarden container. |
| probes.vaultwarden.liveness.spec | object | `{}` | The specification defining how the liveness probe checks the Vaultwarden container health. |
| probes.vaultwarden.readiness.enabled | bool | `false` | Specifies whether to enable the readiness probe for the Vaultwarden container. |
| probes.vaultwarden.readiness.spec | object | `{}` | The specification defining how the readiness probe checks the Vaultwarden container health. |
| probes.vaultwarden.startup.enabled | bool | `false` | Specifies whether to enable the startup probe for the Vaultwarden container. |
| probes.vaultwarden.startup.spec | object | `{}` | The specification defining how the startup probe checks the Vaultwarden container health. |
| push.enabled | string | `""` | Specifies whether to enable automatic vault sync in all clients using push notifications. Default: `"false"`. |
| push.id | string | `""` | The private installation ID for self-hosting or unlocking certain Bitwarden features. |
| push.identityUri | string | `""` | The URI of the Bitwarden push identity server. |
| push.key | string | `""` | The private installation key for self-hosting or unlocking certain Bitwarden features. |
| push.relayUri | string | `""` | The URI of the Bitwarden push relay. |
| rateLimit.admin.maxBurst | string | `""` | The size of the burst of requests allowed on top of the average. |
| rateLimit.admin.seconds | string | `""` | The average number of seconds between requests before rate limiting starts. |
| rateLimit.login.maxBurst | string | `""` | The size of the burst of requests allowed on top of the average. |
| rateLimit.login.seconds | string | `""` | The average number of seconds between requests before rate limiting starts. |
| rateLimit.unauthenticated.maxBurst | string | `""` | The size of the burst of requests allowed on top of the average. |
| rateLimit.unauthenticated.seconds | string | `""` | The average number of seconds between requests before rate limiting starts. |
| replicaCount | string | `""` | The desired number of running replicas for Vaultwarden. Default: `"1"`. |
| resources.vaultwarden | object | `{}` | Vaultwarden container resources. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the Vaultwarden server should listen for connections. Default: `"80"`. |
| service.type | string | `""` | The type of service used to expose Vaultwarden services. Default: `"ClusterIP"`. |
| serviceAccount.annotations | object | `{}` | Annotations to be applied to the created service account. |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created for Vaultwarden. |
| serviceAccount.name | string | `""` | The name of the service account used by Vaultwarden pods. Default: `"${.Release.Name}-vaultwarden"`. |
| signup.domainWhitelist | list | `[]` | A list of domains allowed for user account registration. |
| signup.enabled | string | `""` | Specifies whether to open up the Vaultwarden instance to new user account registrations. Default: `"false"`. |
| signup.resendInterval | string | `""` | The number of seconds before a verification email can be resent. Default: `"3600"`. |
| signup.resendLimit | string | `""` | The maximum number of times a verification email can be resent. Default: `"6"`. |
| signup.verification | string | `""` | Specifies whether to require email verification for new user registrations. Default: `"false"`. |
| sso.allowUnknownEmailVerification | string | `""` | Specifies whether to accept users whose email verification status is unknown to the provider. |
| sso.audienceTrusted | string | `""` | A regular expression matching additional audiences trusted in the ID token. |
| sso.authOnlyNotSession | string | `""` | Specifies whether to use SSO only for authentication and keep the default Vaultwarden session lifecycle. |
| sso.authority | string | `""` | The base URL of the OIDC provider. |
| sso.authorizeExtraParams | string | `""` | The additional parameters added to the authorization request. |
| sso.clientCacheExpiration | string | `""` | The number of seconds the OIDC discovery document is cached for. |
| sso.clientId | string | `""` | The client ID of the application registered with the OIDC provider. |
| sso.clientSecret | string | `""` | The client secret of the application registered with the OIDC provider. |
| sso.debugTokens | string | `""` | Specifies whether to log all tokens. |
| sso.enabled | string | `""` | Specifies whether users can log in through an OIDC provider. |
| sso.masterPasswordPolicy | object | `{}` | The master password policy applied to users signing in with SSO. |
| sso.only | string | `""` | Specifies whether to prevent users from logging in with their email and master password. |
| sso.pkce | string | `""` | Specifies whether to use PKCE for the authorization code flow. |
| sso.scopes | string | `""` | The space-separated scopes requested from the OIDC provider. |
| sso.signupsAllowed | string | `""` | Specifies whether the SSO login flow can create new accounts. |
| sso.signupsMatchEmail | string | `""` | Specifies whether a new SSO user is linked to an existing account with the same email address. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteOnce"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/data"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |
| tfa.allowTimeDrift | string | `""` | Specifies whether to allow small time discrepancies for TOTP code validation. Default: `"true"`. |
| tfa.emailEnforce | string | `""` | Specifies whether to setup email 2FA upon registration. Default: `"false"`. |
| tfa.emailExpiry | string | `""` | The number of seconds after which a 2FA email token expires. Default: `"600"`. |
| tfa.emailFallback | string | `""` | Specifies whether to automatically use email as a fallback 2FA method. Default: `"false"`. |
| tfa.emailLimit | string | `""` | The maximum number of attempts after which the 2FA email token is reset. Default: `"3"`. |
| tfa.emailTokenSize | string | `""` | The length of the secret 2FA email token. Default: `"6"`. |
| tfa.expiry | string | `""` | The number of minutes before a pending 2FA-enabled login is considered incomplete. Default: `"3"`. |
| tfa.rememberDays | string | `""` | The number of days before a remembered 2FA login expires. |
| tfa.rememberDevice | string | `""` | Specifies whether to allow users to remember their device for 2FA sessions. Default: `"true"`. |
| tolerations | list | `[]` | The tolerations that allow Vaultwarden pods to be scheduled onto tainted nodes. |
| updateStrategy | object | `{}` | The update strategy used to replace existing pods with new ones. |
| vaultwarden.adminToken | string | `""` | The secret password for accessing the Vaultwarden admin panel. |
| vaultwarden.clearTrash | string | `""` | The number of days to retain trashed items before permanent deletion. |
| vaultwarden.domain | string | `""` | The ingress domain name that hosts the Vaultwarden server. |
| vaultwarden.emailUpdate | string | `""` | Specifies whether to allow users to change their account email address. Default: `"true"`. |
| vaultwarden.emergencyAccess | string | `""` | Specifies whether to allow enabling emergency access to user accounts. Default: `"true"`. |
| vaultwarden.existingSecret | string | `""` | The name of an existing Secret to load sensitive environment variables from. |
| vaultwarden.expFeatures | list | `[]` | A list of experimental client feature flags to enable certain experimental functionality. |
| vaultwarden.fillAssistRulesUrl | string | `""` | The base URL of the feed that provides the Fill Assist rules to the clients. |
| vaultwarden.hibpApiKey | string | `""` | The Have I Been Pwned API key for password breach checks. |
| vaultwarden.initScript | string | `""` | Custom init script to run before the Vaultwarden container starts. |
| vaultwarden.logLevel | string | `""` | The verbosity level of the Vaultwarden logs. Default: `"info"`. |
| vaultwarden.notifyNewDevice | string | `""` | Specifies whether to require notifying users when a new device logs into their account. Default: `"false"`. |
| vaultwarden.send | string | `""` | Specifies whether to allow users to use the Bitwarden Send feature. Default: `"true"`. |
| vaultwarden.suppressOnboarding | string | `""` | Specifies whether to hide the onboarding dialogs, extension install prompts, and premium upsell modals shown by the clients. |
| vaultwarden.webVaultEnabled | string | `""` | Specifies whether to serve the web vault. |
| yubico.enabled | string | `""` | Specifies whether to enable Yubico 2FA integration. Default: `"false"`. |
| yubico.id | string | `""` | The API client ID for enabling YubiKey OTP authentication. |
| yubico.key | string | `""` | The API secret key for enabling YubiKey OTP authentication. |
| yubico.server | string | `""` | The URL of the Yubico API server for 2FA verification. |
