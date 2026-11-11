# [Linkding](https://github.com/sissbruecker/linkding)

Linkding is a bookmark manager that you can host yourself. It's designed to be minimal, fast, and easy to set up using Docker.

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

### Decide on the database

Linkding supports SQLite and Postgres. Only one Linkding instance may use a SQLite database at a time.

SQLite is the default and requires persistent storage to keep the database across restarts:

```yaml
db:
  type: "sqlite"
storage:
  data:
    enabled: true
```

**Alternatively**, use an external Postgres database. This chart does not bundle one.

1. Provision a database and user for Linkding on your Postgres server.

2. Set the connection details as the `db.*` settings in your installation's values file:

    ```yaml
    db:
      type: "postgres"
      host: "postgres.example.com"
      port: "5432"
      name: "linkding"
      user: "linkding"
      password: "<password>"
    ```

    Any other database option can be set as `db.options` (e.g. `sslmode: "require"`).

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

Behind an ingress controller or another reverse proxy, set `linkding.csrfTrustedOrigins` to the public address of Linkding, otherwise logging in and other form submissions may fail:

```yaml
linkding:
  csrfTrustedOrigins:
    - "https://linkding.example.com"
```

If the proxy does not forward the original `Host` header, set `network.useXForwardedHost` to `"true"` so Linkding uses the `X-Forwarded-Host` header instead. Set `network.logXForwardedFor` to `"true"` to record client addresses in the request logs.

### Bookmarking internal URLs

Linkding refuses to load data from hosts on internal networks, such as other cluster services or devices on a local network. To bookmark such URLs with their titles and previews, list the hosts in `network.allowedInternalHosts`:

```yaml
network:
  allowedInternalHosts:
    - "nas.local"
    - "192.168.1.0/24"
    - ".home.arpa"
```

A host name that starts with a dot allows the domain and all of its subdomains. A single `*` allows all hosts and turns the protection off.

### Security context

Linkding must start as root, so `runAsUser` and `runAsNonRoot` must not be set in `containerSecurityContext`.

### Managing secrets separately

To keep sensitive values out of the values file, set `linkding.existingSecret` to the name of a Secret you manage yourself. Its keys must be the environment variable names listed here, and any key it sets takes precedence over the same setting in the values file:

- `LD_SUPERUSER_NAME`
- `LD_SUPERUSER_PASSWORD`
- `LD_DB_USER`
- `LD_DB_PASSWORD`
- `OIDC_RP_CLIENT_SECRET`

### Archiving web pages

Linkding creates HTML snapshots of bookmarks only with an image variant that includes Chromium (e.g. a tag ending in `-plus-alpine`). Set `image.linkding.tag` to such a tag and `snapshots.enabled` to `"true"`.

---

## Application configurations

> [!NOTE]  
> The following configurations are expected or recommended to be set up from within the application after completing the installation.

### Create the admin user

Set `linkding.admin.user` and `linkding.admin.password` to have an admin user created when Linkding starts. Nothing happens if a user with that name already exists. Leaving the password empty creates a user that cannot log in with a password.

**Alternatively**, create the admin user with a command that also sets its email address:

```sh
kubectl exec --namespace ${namespace} --stdin --tty deploy/${releaseName}-linkding -- python manage.py createsuperuser --username=${username} --email=${email}
```

Replace `${namespace}`, `${releaseName}`, `${username}`, and `${email}` accordingly. The command prompts for a password.

### Sign in with OpenID Connect

Set `oidc.enabled` to `"true"` along with the endpoints, `oidc.clientId`, and `oidc.clientSecret` of the provider to show a single sign-on button on the login page. Register `https://<domain>/oidc/callback/` as the redirect URI of the client in the provider.

Linkding matches users to existing accounts by email address, which is also the default username of a new account. Set `oidc.usernameClaim` to use another claim (e.g. `preferred_username`) as the username of new accounts. A user that does not exist yet is created on the first sign-in.

To have an existing admin account matched, create it with the command in [creating the admin user](#create-the-admin-user), since `linkding.admin.user` sets only a username and no email address. Create the account before the first sign-in with OIDC.

API clients (e.g. the browser extension and mobile apps) sign in with an API token. When using an authentication proxy, let API requests that carry an `Authorization` header bypass it.

Set `linkding.disableLoginForm` to `"true"` only after confirming that signing in with OIDC works, since the login form is no longer available afterwards.

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

1. Get the values file of the Linkding chart or an existing installation (release).

    Get the latest Linkding chart values file for a new installation:

    ```sh
    helm show values moekai/linkding > values.yaml
    ```

    Alternatively, get the values file of an existing Linkding release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Linkding values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Linkding or upgrade an existing Linkding release:

    ```sh
    helm upgrade --install ${releaseName} moekai/linkding --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Linkding release has been installed:

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
| affinity | object | `{}` | The scheduling constraints applied to Linkding pods. |
| authProxy.enabled | string | `""` | Specifies whether to authenticate users through a header set by an authentication proxy. |
| authProxy.logoutUrl | string | `""` | The URL users are redirected to after logging out. |
| authProxy.usernameHeader | string | `""` | The name of the request header that carries the username set by the authentication proxy. |
| containerSecurityContext | object | `{}` | Security context applied at the Linkding container level. |
| db.host | string | `""` | The hostname or IP address of the Linkding database server. |
| db.name | string | `""` | The name of the database being used by Linkding. |
| db.options | object | `{}` | Additional database options passed to the database connection. |
| db.password | string | `""` | The password associated with the Linkding database user. |
| db.port | string | `""` | The port number the Linkding database server is listening for connections. Default: `"5432"`. |
| db.type | string | `""` | The database engine or backend being used by Linkding. Default: `"sqlite"`. |
| db.user | string | `""` | The username or user account for accessing the Linkding database. |
| extraEnv | list | `[]` | Additional environment variables to be set on the Linkding container. |
| extraVolumeMounts | list | `[]` | Additional volume mounts to be added to the Linkding container. |
| extraVolumes | list | `[]` | Additional volumes to be added to Linkding pods. |
| favicon.provider | string | `""` | The URL used to download website favicons. |
| favicon.refreshEnabled | string | `""` | Specifies whether favicons are refreshed daily by a background task. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| image.linkding.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Linkding container image. Default: `"IfNotPresent"`. |
| image.linkding.registry | string | `""` | The registry where the Linkding container image is hosted. Default: `"docker.io"`. |
| image.linkding.repository | string | `""` | The name of the repository that contains the Linkding container image used. Default: `"sissbruecker/linkding"`. |
| image.linkding.tag | string | `""` | The tag that specifies the version of the Linkding container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.className | string | `""` | The class of the ingress controller that handles the Ingress. Default: `"nginx"`. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Linkding services. |
| ingress.tlsSecretName | string | `""` | The name of the Secret that stores the TLS certificate of the Ingress. Default: `"${.Release.Name}-linkding-tls-cert"`. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| linkding.admin.password | string | `""` | The password associated with the initial admin user. |
| linkding.admin.user | string | `""` | The username of the initial admin user for accessing the Linkding portal. |
| linkding.csrfTrustedOrigins | list | `[]` | A list of trusted origins that will be accepted during CSRF verification even if their headers do not match. |
| linkding.disableBackgroundTasks | string | `""` | Specifies whether to disable background tasks and task scheduling. Default: `"false"`. |
| linkding.disableLoginForm | string | `""` | Specifies whether to hide the username and password login form. |
| linkding.disableUrlValidation | string | `""` | Specifies whether to disable URL validation for added bookmarks. Default: `"false"`. |
| linkding.domain | string | `""` | The ingress domain name that hosts the Linkding server. |
| linkding.existingSecret | string | `""` | The name of an existing Secret to load sensitive environment variables from. |
| linkding.initScript | string | `""` | Custom init script to run before the Linkding container starts. |
| linkding.sessionCookieAge | string | `""` | The number of seconds a user stays logged in to the web interface. |
| linkding.timezone | string | `""` | The timezone used by Linkding for time-based operations. |
| logging.disableRequestLogs | string | `""` | Specifies whether to disable request logs, except for requests with a client or server error response. |
| network.allowedHost | string | `""` | The only host name Linkding accepts requests for. |
| network.allowedInternalHosts | list | `[]` | The hosts Linkding may load data from even though they are on an internal network. |
| network.contextPath | string | `""` | The context path that Linkding is served from. |
| network.corsAllowedOrigins | list | `[]` | The origins that are allowed to call the REST API from a browser. |
| network.host | string | `""` | The address the Linkding server binds to inside the container. |
| network.logXForwardedFor | string | `""` | Specifies whether to log the client address from the "X-Forwarded-For" header in request logs. |
| network.port | string | `""` | The port on which the Linkding server listens inside the container. Default: `"9090"`. |
| network.requestMaxContentLength | string | `""` | The maximum size in bytes of a POST request. |
| network.requestTimeout | string | `""` | The number of seconds before a request times out. |
| network.useXForwardedHost | string | `""` | Specifies whether to use the "X-Forwarded-Host" header sent by the reverse proxy. |
| nodeSelector | object | `{}` | The node labels a node must have for Linkding pods to be scheduled onto it. |
| oidc.authorizationEndpoint | string | `""` | The authorization endpoint of the OIDC provider. |
| oidc.clientId | string | `""` | The client ID of the application registered with the OIDC provider. |
| oidc.clientSecret | string | `""` | The client secret of the application registered with the OIDC provider. |
| oidc.enabled | string | `""` | Specifies whether to enable single sign-on through an OIDC provider. |
| oidc.jwksEndpoint | string | `""` | The JWKS endpoint of the OIDC provider. |
| oidc.scopes | string | `""` | The space-separated scopes requested from the OIDC provider. |
| oidc.signAlgo | string | `""` | The algorithm the OIDC provider uses to sign ID tokens. |
| oidc.tokenEndpoint | string | `""` | The token endpoint of the OIDC provider. |
| oidc.usePkce | string | `""` | Specifies whether to use PKCE for the OIDC flow. |
| oidc.userEndpoint | string | `""` | The user info endpoint of the OIDC provider. |
| oidc.usernameClaim | string | `""` | The claim used as the username of newly created users. |
| oidc.verifySsl | string | `""` | Specifies whether to verify the TLS certificate of the OIDC provider. |
| podAnnotations | object | `{}` | Annotations to be applied to Linkding pods. |
| podSecurityContext | object | `{}` | Security context applied at the pod level for Linkding. |
| preview.maxSize | string | `""` | The maximum size in bytes of a downloaded preview image. |
| probes.linkding.liveness.enabled | bool | `false` | Specifies whether to enable the liveness probe for the Linkding container. |
| probes.linkding.liveness.spec | object | `{}` | The specification defining how the liveness probe checks the Linkding container health. |
| probes.linkding.readiness.enabled | bool | `false` | Specifies whether to enable the readiness probe for the Linkding container. |
| probes.linkding.readiness.spec | object | `{}` | The specification defining how the readiness probe checks the Linkding container health. |
| probes.linkding.startup.enabled | bool | `false` | Specifies whether to enable the startup probe for the Linkding container. |
| probes.linkding.startup.spec | object | `{}` | The specification defining how the startup probe checks the Linkding container health. |
| replicaCount | string | `""` | The desired number of running replicas for Linkding. Default: `"1"`. |
| resources.linkding | object | `{}` | Linkding container resources. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the Linkding server should listen for connections. Default: `"9090"`. |
| service.type | string | `""` | The type of service used to expose Linkding services. Default: `"ClusterIP"`. |
| serviceAccount.annotations | object | `{}` | Annotations to be applied to the created service account. |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created for Linkding. |
| serviceAccount.name | string | `""` | The name of the service account used by Linkding pods. Default: `"${.Release.Name}-linkding"`. |
| snapshots.disableAssetUpload | string | `""` | Specifies whether to disable uploading files to bookmarks. |
| snapshots.enabled | string | `""` | Specifies whether to create local HTML snapshots of bookmarks. |
| snapshots.pdfMaxSize | string | `""` | The maximum size in bytes of a PDF snapshot. |
| snapshots.singlefile.options | string | `""` | Additional options passed to single-file when creating snapshots. |
| snapshots.singlefile.path | string | `""` | The path of the single-file executable. |
| snapshots.singlefile.timeout | string | `""` | The number of seconds to wait for a snapshot to complete. |
| snapshots.singlefile.ublockOptions | string | `""` | The options passed to single-file to run the uBlock Origin Lite extension. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/etc/linkding/data"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |
| tolerations | list | `[]` | The tolerations that allow Linkding pods to be scheduled onto tainted nodes. |
| updateStrategy | object | `{}` | The update strategy used to replace existing pods with new ones. |
