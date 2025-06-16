# [Snipe-IT](https://github.com/grokability/snipe-it)

Snipe-IT was made for IT asset management, to enable IT departments to track who has which laptop, when it was purchased, which software licenses and accessories are available, and so on.

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

### Generate secret key

A unique, secure secret key is required for each Snipe-IT installation.

1. Generate a secret key using the following command:

    ```sh
    docker run --rm docker.io/snipe/snipe-it php artisan key:generate --show
    ```

2. Set the generated secret key as the value of the `snipeit.secret` setting in your installation's values file:

    ```yaml
    secret: "<generated-secret>"
    ```

---

## Recommended configurations

> [!NOTE]  
> The following configuration recommendations might not be the default settings for this chart but are **highly recommended**. Please carefully consider them before configuring your installation.

**This section does not apply to this chart.**

---

## Application configurations

> [!NOTE]  
> The following configurations are expected or recommended to be set up from within the application after completing the installation.

**This section does not apply to this chart.**

---

## How to add the chart repo

1. Add the repo to your local helm client:

    ```sh
    helm repo add mika https://irfanhakim-as.github.io/charts
    ```

2. Update the repo to retrieve the latest versions of the packages:

    ```sh
    helm repo update
    ```

---

## How to install or upgrade a chart release

1. Get the values file of the Snipe-IT chart or an existing installation (release).

    Get the latest Snipe-IT chart values file for a new installation:

    ```sh
    helm show values mika/snipe-it > values.yaml
    ```

    **Alternatively**, get the values file of an existing Snipe-IT release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Snipe-IT values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Snipe-IT or upgrade an existing Snipe-IT release:

    ```sh
    helm upgrade --install ${releaseName} mika/snipe-it --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Snipe-IT release has been installed:

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
| db.host | string | `""` | The hostname or IP address of the Snipe-IT database server. |
| db.name | string | `""` | The name of the database being used by Snipe-IT. |
| db.password | string | `""` | The password associated with the Snipe-IT database user. |
| db.port | string | `""` | The port number the Snipe-IT database server is listening for connections. Default: `"3306"`. |
| db.type | string | `""` | The database engine or backend being used by Snipe-IT. Default: `"mysql"`. |
| db.user | string | `""` | The username or user account for accessing the Snipe-IT database. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| image.snipeit.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Snipe-IT container image. Default: `"IfNotPresent"`. |
| image.snipeit.registry | string | `""` | The registry where the Snipe-IT container image is hosted. Default: `"docker.io"`. |
| image.snipeit.repository | string | `""` | The name of the repository that contains the Snipe-IT container image used. Default: `"snipe/snipe-it"`. |
| image.snipeit.tag | string | `""` | The tag that specifies the version of the Snipe-IT container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Snipe-IT services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| log.level | string | `""` | The verbosity level of the Snipe-IT logs. Default: `"warning"`. |
| log.maxFiles | string | `""` | The number of daily log files to retain before older ones are removed. Default: `"10"`. |
| log.mode | string | `""` | Sets whether to log to one file or create a new file each day. Default: `"single"`. |
| mail.fromEmail | string | `""` | The email address used in the "from" address for sent emails. Default: `"${.smtp.user}"`. |
| mail.fromName | string | `""` | The display name used in the "from" address for sent emails. Default: `"Snipe-IT"`. |
| mail.smtp.host | string | `""` | The hostname or IP address of the SMTP server for sending emails. |
| mail.smtp.password | string | `""` | The password for authenticating with the SMTP server. |
| mail.smtp.port | string | `""` | The port number on the SMTP server used for sending emails. Default: `"587"`. |
| mail.smtp.secure | string | `""` | Specifies whether Snipe-IT should use a secure TLS connection when sending emails. Default: `"true"`. |
| mail.smtp.user | string | `""` | The username for authenticating with the SMTP server. |
| replicaCount | string | `""` | The desired number of running replicas for Snipe-IT. Default: `"1"`. |
| resources.snipeit | object | `{}` | Snipe-IT container resources. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the Snipe-IT server should listen for connections. Default: `"8000"`. |
| service.type | string | `""` | The type of service used to expose Snipe-IT services. Default: `"ClusterIP"`. |
| snipeit.allowInsecureHosts | string | `""` | Specifies whether to ignore URL mismatches in case of a secure hosting environment. Default: `"false"`. |
| snipeit.debug | string | `""` | Specifies whether Snipe-IT should run in debug mode. Default: `"false"`. |
| snipeit.domain | string | `""` | The ingress domain name that hosts the Snipe-IT server. |
| snipeit.environment | string | `""` | The runtime environment for the Snipe-IT server. Default: `"production"`. |
| snipeit.initScript | string | `""` | Custom init script to run before the Snipe-IT container starts. |
| snipeit.locale | string | `""` | The default language used in the Snipe-IT server. Default: `"en-US"`. |
| snipeit.maxResults | string | `""` | The maximum page size for paginated results. Default: `"500"`. |
| snipeit.secret | string | `""` | A secret key used for secure session management and cryptographic operations within the Snipe-IT service. |
| snipeit.secure | string | `""` | Specifies whether to force all connections to use the secure HTTPS protocol. Default: `"false"`. |
| snipeit.timezone | string | `""` | The timezone used by the Snipe-IT server for time-based operations. Default: `"Etc/UTC"`. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/var/lib/snipeit"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |
| storage.log.accessMode | string | `""` | The access mode defining how the log storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.log.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for log storage. |
| storage.log.mountPath | string | `""` | The path where the log storage should be mounted on the container. Default: `"/var/www/html/storage/logs"`. |
| storage.log.storage | string | `""` | The default amount of persistent storage allocated for the log storage. Default: `"1Gi"`. |
| storage.log.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the log storage. Default: `"longhorn"`. |
| storage.log.subPath | string | `""` | The subpath within the log storage to mount to the container. Leave empty if not required. |