# [Uptime Kuma](https://github.com/louislam/uptime-kuma)

Uptime Kuma is an easy-to-use self-hosted monitoring tool.

## Prerequisites

> [!NOTE]  
> You may refer to [Orked](https://github.com/irfanhakim-as/orked) for help with setting up a Kubernetes cluster that meets all the following prerequisites.

- Kubernetes 1.19+
- Helm 3.2.0+
- Longhorn 1.4.1+

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

1. Get the values file of the Uptime Kuma chart or an existing installation (release).

    Get the latest Uptime Kuma chart values file for a new installation:

    ```sh
    helm show values mika/uptimekuma > values.yaml
    ```

    Alternatively, get the values file of an existing Uptime Kuma release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Uptime Kuma values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Uptime Kuma or upgrade an existing Uptime Kuma release:

    ```sh
    helm upgrade --install ${releaseName} mika/uptimekuma --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Uptime Kuma release has been installed:

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
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| image.uptimekuma.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Uptime Kuma container image. Default: `"IfNotPresent"`. |
| image.uptimekuma.registry | string | `""` | The registry where the Uptime Kuma container image is hosted. Default: `"docker.io"`. |
| image.uptimekuma.repository | string | `""` | The name of the repository that contains the Uptime Kuma container image used. Default: `"louislam/uptime-kuma"`. |
| image.uptimekuma.tag | string | `""` | The tag that specifies the version of the Uptime Kuma container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Uptime Kuma services. |
| replicaCount | string | `""` | The desired number of running replicas for Uptime Kuma. Default: `"1"`. |
| resources.uptimekuma | object | `{}` | Resource requirements and limits for Uptime Kuma containers. |
| service.port | string | `""` | The port on which the Uptime Kuma server should listen. Default: `"3001"`. |
| service.type | string | `""` | The type of service used for Uptime Kuma services. Default: `"ClusterIP"`. |
| storage.data.enabled | bool | `true` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/app/data"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |
| uptimekuma.domain | string | `""` | The ingress domain name that hosts the Uptime Kuma server. |
| uptimekuma.initScript | string | `""` | Custom init script to run before the Uptime Kuma container starts. |