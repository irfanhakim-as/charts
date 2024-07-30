# [Grocy](https://github.com/grocy/grocy)

Grocy is a web-based self-hosted groceries & household management solution for your home.

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

1. Get the values file of the Grocy chart or an existing installation (release).

    Get the latest Grocy chart values file for a new installation:

    ```sh
    helm show values mika/grocy > values.yaml
    ```

    Alternatively, get the values file of an existing Grocy release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Grocy values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Grocy or upgrade an existing Grocy release:

    ```sh
    helm upgrade --install ${releaseName} mika/grocy --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Grocy release has been installed:

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
| grocy.culture | string | `""` | The localisation of the Grocy application. Default: `"en_GB"`. |
| grocy.currency | string | `""` | The currency used to format all monetary values in Grocy. Default: `"MYR"`. |
| grocy.domain | string | `""` | The ingress domain name that hosts the Grocy server. |
| grocy.energy | string | `""` | The preferred unit for displaying energy values in Grocy. Default: `"kcal"`. |
| grocy.initScript | string | `""` | Custom init script to run before the Grocy container starts. |
| grocy.mode | string | `""` | The mode to deploy grocy in which determines whether to enable user authentication. Default: `"production"`. |
| grocy.php.file_limit | string | `""` | Sets the maximum number of files that can be uploaded simultaneously through PHP. Default: `"200"`. |
| grocy.php.memory_limit | string | `""` | Determines the maximum amount of memory that PHP can allocate for executing scripts. Default: `"512M"`. |
| grocy.php.post_limit | string | `""` | Defines the maximum size of the entire HTTP POST request that PHP can handle. Default: `"100M"`. |
| grocy.php.upload_limit | string | `""` | Specifies the maximum size of an individual file that can be uploaded through PHP. Default: `"50M"`. |
| image.backend.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Backend container image. Default: `"IfNotPresent"`. |
| image.backend.registry | string | `""` | The registry where the Backend container image is hosted. Default: `"docker.io"`. |
| image.backend.repository | string | `""` | The name of the repository that contains the Backend container image used. Default: `"grocy/backend"`. |
| image.backend.tag | string | `""` | The tag that specifies the version of the Backend container image used. Default: `Chart appVersion`. |
| image.frontend.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Frontend container image. Default: `"IfNotPresent"`. |
| image.frontend.registry | string | `""` | The registry where the Frontend container image is hosted. Default: `"docker.io"`. |
| image.frontend.repository | string | `""` | The name of the repository that contains the Frontend container image used. Default: `"grocy/frontend"`. |
| image.frontend.tag | string | `""` | The tag that specifies the version of the Frontend container image used. Default: `Chart appVersion`. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Grocy services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| replicaCount | string | `""` | The desired number of running replicas for Grocy. Default: `"1"`. |
| resources.backend | object | `{}` | Backend container resources. |
| resources.frontend | object | `{}` | Frontend container resources. |
| service.backend.nodePort | string | `""` | The optional node port to expose for backend when the service type is NodePort. |
| service.backend.port | string | `""` | The backend port on which the Grocy server should listen. Default: `"9000"`. |
| service.frontend.nodePort | string | `""` | The optional node port to expose for frontend when the service type is NodePort. |
| service.frontend.port | string | `""` | The frontend port on which the Grocy server should listen. Default: `"8080"`. |
| service.type | string | `""` | The type of service used for Grocy services. Default: `"ClusterIP"`. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/var/www/data"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"500Mi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |