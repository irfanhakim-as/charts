# [Mattermost](https://github.com/mattermost/mattermost)

Mattermost is an open source platform for secure collaboration across the entire software development lifecycle.

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

### Decide on the database connection

Mattermost requires an external Postgres (or MySQL) database - this chart does not bundle one.

1. Provision a database and user for Mattermost on your Postgres server.

2. Set the connection details as the `db.*` settings in your installation's values file:

    ```yaml
    db:
      host: "postgres.example.com"
      port: "5432"
      name: "mattermost"
      user: "mattermost"
      password: "<password>"
    ```

---

## Recommended configurations

> [!NOTE]  
> The following configuration recommendations might not be the default settings for this chart but are **highly recommended**. Please carefully consider them before configuring your installation.

### Websocket ingress timeouts

Mattermost relies on long-lived websocket connections for real-time messaging. This chart's Ingress template already raises `nginx.ingress.kubernetes.io/proxy-read-timeout` and `proxy-send-timeout` to `600` seconds to prevent the default nginx proxy timeouts from silently dropping these connections - no additional configuration is required, but be aware of this deviation if you override Ingress annotations.

### Setting the site URL

Setting `ingress.enabled` with a non-empty `mattermost.domain` makes Mattermost's own config bootstrap treat the install as an existing one being updated rather than a fresh one, which silently defaults `push.sendPushNotifications` to `"false"` and `push.pushNotificationServer` to empty. Explicitly set both `push.*` settings whenever a domain is configured.

---

## Application configurations

> [!NOTE]  
> The following configurations are expected or recommended to be set up from within the application after completing the installation.

**This section does not apply to this chart.**

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

1. Get the values file of the Mattermost chart or an existing installation (release).

    Get the latest Mattermost chart values file for a new installation:

    ```sh
    helm show values moekai/mattermost > values.yaml
    ```

    **Alternatively**, get the values file of an existing Mattermost release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Mattermost values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Mattermost or upgrade an existing Mattermost release:

    ```sh
    helm upgrade --install ${releaseName} moekai/mattermost --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Mattermost release has been installed:

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
| containerSecurityContext | object | `{}` | Security context applied at the Mattermost container level. |
| db.charset | string | `""` | The character set used for the database connection. Default: `"utf8mb4"`. |
| db.connectTimeout | string | `""` | The number of seconds to wait before timing out when connecting to the database. Default: `"10"`. |
| db.host | string | `""` | The hostname or IP address of the Mattermost database server. |
| db.name | string | `""` | The name of the database being used by Mattermost. |
| db.password | string | `""` | The password associated with the Mattermost database user. |
| db.port | string | `""` | The port number the Mattermost database server is listening for connections. Default: `"5432"` for postgres, `"3306"` for mysql. |
| db.sslMode | string | `""` | Specifies whether to use a secure TLS connection when connecting to the database. Default: `"disable"`. |
| db.type | string | `""` | The database engine or backend being used by Mattermost. Default: `"postgres"`. |
| db.user | string | `""` | The username or user account for accessing the Mattermost database. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| image.mattermost.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Mattermost container image. Default: `"IfNotPresent"`. |
| image.mattermost.registry | string | `""` | The registry where the Mattermost container image is hosted. Default: `"docker.io"`. |
| image.mattermost.repository | string | `""` | The name of the repository that contains the Mattermost container image used. Default: `"mattermost/mattermost-team-edition"`. |
| image.mattermost.tag | string | `""` | The tag that specifies the version of the Mattermost container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Mattermost services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| mail.feedbackEmail | string | `""` | The email address used in the "from" and "reply-to" address for sent emails. Default: `"${.smtp.user}"`. |
| mail.smtp.host | string | `""` | The hostname or IP address of the SMTP server for sending emails. |
| mail.smtp.password | string | `""` | The password for authenticating with the SMTP server. |
| mail.smtp.port | string | `""` | The port number on the SMTP server used for sending emails. Default: `"587"`. |
| mail.smtp.user | string | `""` | The username for authenticating with the SMTP server. |
| mattermost.domain | string | `""` | The ingress domain name that hosts the Mattermost server. |
| mattermost.initScript | string | `""` | Custom init script to run before the Mattermost container starts. |
| mattermost.timezone | string | `""` | The timezone used by the Mattermost server for time-based operations. |
| podAnnotations | object | `{}` | Annotations to be applied to Mattermost pods. |
| podSecurityContext | object | `{}` | Security context applied at the pod level for Mattermost. Default: `{"fsGroup": 2000}`. |
| probes.mattermost.liveness.enabled | bool | `false` | Specifies whether to enable the liveness probe for the Mattermost container. |
| probes.mattermost.liveness.spec | object | `{}` | The specification defining how the liveness probe checks the Mattermost container health. |
| probes.mattermost.readiness.enabled | bool | `false` | Specifies whether to enable the readiness probe for the Mattermost container. |
| probes.mattermost.readiness.spec | object | `{}` | The specification defining how the readiness probe checks the Mattermost container health. |
| probes.mattermost.startup.enabled | bool | `false` | Specifies whether to enable the startup probe for the Mattermost container. |
| probes.mattermost.startup.spec | object | `{}` | The specification defining how the startup probe checks the Mattermost container health. |
| push.pushNotificationServer | string | `""` | The push notification server used to relay push notifications to mobile clients. |
| push.sendPushNotifications | string | `""` | Specifies whether to enable push notifications to mobile clients. Default: `"false"`. |
| replicaCount | string | `""` | The desired number of running replicas for Mattermost. Default: `"1"`. |
| resources.mattermost | object | `{}` | Mattermost container resources. |
| s3.accessKeyId | string | `""` | The access key ID used to authenticate with the S3-compatible file storage. |
| s3.bucket | string | `""` | The name of the bucket used for storing Mattermost files. |
| s3.endpoint | string | `""` | The bare hostname of the S3-compatible file storage endpoint. |
| s3.region | string | `""` | The region of the S3-compatible file storage. |
| s3.secretAccessKey | string | `""` | The secret access key used to authenticate with the S3-compatible file storage. |
| s3.ssl | string | `""` | Specifies whether to use a secure TLS connection when connecting to the S3-compatible file storage. Default: `"true"`. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the Mattermost server should listen for connections. Default: `"8065"`. |
| service.type | string | `""` | The type of service used to expose Mattermost services. Default: `"ClusterIP"`. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteOnce"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/mattermost/data"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |
| storage.log.accessMode | string | `""` | The access mode defining how the log storage can be mounted. Default: `"ReadWriteOnce"`. |
| storage.log.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for log storage. |
| storage.log.mountPath | string | `""` | The path where the log storage should be mounted on the container. Default: `"/mattermost/logs"`. |
| storage.log.storage | string | `""` | The default amount of persistent storage allocated for the log storage. Default: `"1Gi"`. |
| storage.log.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the log storage. Default: `"longhorn"`. |
| storage.log.subPath | string | `""` | The subpath within the log storage to mount to the container. Leave empty if not required. |
