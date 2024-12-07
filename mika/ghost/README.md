# Ghost

Ghost is an independent platform for publishing online by web and email newsletter.

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

**This section does not apply to this chart.**

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

1. Get the values file of the Ghost chart or an existing installation (release).

    Get the latest Ghost chart values file for a new installation:

    ```sh
    helm show values mika/ghost > values.yaml
    ```

    Alternatively, get the values file of an existing Ghost release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Ghost values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Ghost or upgrade an existing Ghost release:

    ```sh
    helm upgrade --install ${releaseName} mika/ghost --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Ghost release has been installed:

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
| db.host | string | `""` | The hostname or IP address of the Ghost database server. |
| db.name | string | `""` | The name of the database being used by Ghost. |
| db.password | string | `""` | The password associated with the Ghost database user. |
| db.port | string | `""` | The port number the Ghost database server is listening for connections. Default: `"3306"`. |
| db.type | string | `""` | The database engine or backend being used by Ghost. Default: `"mysql"`. |
| db.user | string | `""` | The username or user account for accessing the Ghost database. |
| ghost.debug | string | `""` | Specifies whether Ghost should run in debug mode. Default: `"false"`. |
| ghost.domain | string | `""` | The ingress domain name that hosts the Ghost server. Default: `"localhost"`. |
| ghost.environment | string | `""` | The runtime environment for the Ghost server. Default: `"production"`. |
| ghost.initScript | string | `""` | Custom init script to run before the Ghost container starts. |
| ghost.install_dir | string | `""` | The directory where Ghost is installed on the container. Default: `"/home/nonroot/app/ghost"`. |
| image.ghost.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Ghost container image. Default: `"IfNotPresent"`. |
| image.ghost.registry | string | `""` | The registry where the Ghost container image is hosted. Default: `"ghcr.io"`. |
| image.ghost.repository | string | `""` | The name of the repository that contains the Ghost container image used. Default: `"sredevopsorg/ghost-on-kubernetes"`. |
| image.ghost.tag | string | `""` | The tag that specifies the version of the Ghost container image used. Default: `Chart appVersion`. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"stable-musl"`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Ghost services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| mail.enabled | bool | `false` | Specifies whether email support should be enabled for Ghost. |
| mail.from_email | string | `""` | The email address used as the "from" address for sent emails. Default: `"${.smtp.user}"`. |
| mail.secure | string | `""` | Specifies whether Ghost should use a secure TLS connection when sending emails. Default: `"true"`. |
| mail.service | string | `""` | The email service provider used for sending emails. Default: `"Google"`. |
| mail.smtp.host | string | `""` | The hostname or IP address of the SMTP server for sending emails. Default: `"smtp.gmail.com"`. |
| mail.smtp.password | string | `""` | The password for authenticating with the SMTP server. |
| mail.smtp.port | string | `""` | The port number on the SMTP server used for sending emails. Default: `"465"`. |
| mail.smtp.user | string | `""` | The username for authenticating with the SMTP server. |
| replicaCount | string | `""` | The desired number of running replicas for Ghost. Default: `"1"`. |
| resources.ghost | object | `{}` | Ghost container resources. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the Ghost server should listen for connections. Default: `"80"`. |
| service.type | string | `""` | The type of service used to expose Ghost services. Default: `"ClusterIP"`. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"${ghost.install_dir}/content"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |