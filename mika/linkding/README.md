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

1. Get the values file of the Linkding chart or an existing installation (release).

    Get the latest Linkding chart values file for a new installation:

    ```sh
    helm show values mika/linkding > values.yaml
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
    helm upgrade --install ${releaseName} mika/linkding --namespace ${namespace} --create-namespace --values values.yaml --wait
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
| db.host | string | `""` | The hostname or IP address of the Linkding database server. |
| db.name | string | `""` | The name of the database being used by Linkding. |
| db.password | string | `""` | The password associated with the Linkding database user. |
| db.port | string | `""` | The port number the Linkding database server is listening for connections. |
| db.type | string | `""` | The database engine or backend being used by Linkding. Default: `"sqlite"`. |
| db.user | string | `""` | The username or user account for accessing the Linkding database. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| image.linkding.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Linkding container image. Default: `"IfNotPresent"`. |
| image.linkding.registry | string | `""` | The registry where the Linkding container image is hosted. Default: `"docker.io"`. |
| image.linkding.repository | string | `""` | The name of the repository that contains the Linkding container image used. Default: `"sissbruecker/linkding"`. |
| image.linkding.tag | string | `""` | The tag that specifies the version of the Linkding container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Linkding services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| linkding.admin.password | string | `""` | The password associated with the initial admin user. |
| linkding.admin.user | string | `""` | The username of the initial admin user for accessing the Linkding portal. |
| linkding.csrfTrustedOrigins | list | `[]` | A list of trusted origins that will be accepted during CSRF verification even if their headers do not match. |
| linkding.disableBackgroundTasks | string | `""` | Specifies whether to disable background tasks and task scheduling. Default: `"false"`. |
| linkding.disableUrlValidation | string | `""` | Specifies whether to disable URL validation for added bookmarks. Default: `"false"`. |
| linkding.domain | string | `""` | The ingress domain name that hosts the Linkding server. |
| linkding.initScript | string | `""` | Custom init script to run before the Linkding container starts. |
| replicaCount | string | `""` | The desired number of running replicas for Linkding. Default: `"1"`. |
| resources.linkding | object | `{}` | Linkding container resources. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the Linkding server should listen for connections. Default: `"9090"`. |
| service.type | string | `""` | The type of service used to expose Linkding services. Default: `"ClusterIP"`. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/etc/linkding/data"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |