# Wallabag

A Helm chart for deploying Wallabag.

## Prerequisites

> [!NOTE]  
> You may refer to [Orked](https://github.com/irfanhakim-as/orked) for help with setting up a Kubernetes cluster that meets all the following prerequisites.

- Kubernetes 1.19+
- Helm 3.2.0+
- Longhorn 1.4.1+
- csi-driver-smb 1.14.0+

---

## External dependencies

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

1. Get the values file of the Wallabag chart or an existing installation (release).

    Get the latest Wallabag chart values file for a new installation:

    ```sh
    helm show values mika/wallabag > values.yaml
    ```

    Alternatively, get the values file of an existing Wallabag release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Wallabag values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Wallabag or upgrade an existing Wallabag release:

    ```sh
    helm upgrade --install ${releaseName} mika/wallabag --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Wallabag release has been installed:

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
| wallabag.bar | string | `""` | The secret value of the Wallabag bar. Default: `"bar"`. |
| wallabag.domain | string | `""` | The ingress domain name that hosts the Wallabag server. |
| wallabag.foo | string | `""` | The value of the Wallabag foo. Default: `"foo"`. |
| wallabag.initScript | string | `""` | Custom init script to run before the Wallabag container starts. |
| image.wallabag.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Wallabag container image. Default: `"IfNotPresent"`. |
| image.wallabag.registry | string | `""` | The registry where the Wallabag container image is hosted. Default: `"ghcr.io"`. |
| image.wallabag.repository | string | `""` | The name of the repository that contains the Wallabag container image used. Default: `"wallabag"`. |
| image.wallabag.tag | string | `""` | The tag that specifies the version of the Wallabag container image used. Default: `Chart appVersion`. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Wallabag services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| replicaCount | string | `""` | The desired number of running replicas for Wallabag. Default: `"1"`. |
| resources.wallabag | object | `{}` | Wallabag container resources. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the Wallabag server should listen. Default: `"80"`. |
| service.type | string | `""` | The type of service used for Wallabag services. Default: `"ClusterIP"`. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/config"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |