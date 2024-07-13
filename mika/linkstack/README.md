# [LinkStack](https://github.com/LinkStackOrg/LinkStack)

LinkStack is a highly customizable link sharing platform with an intuitive, easy to use user interface.

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

1. Get the values file of the LinkStack chart or an existing installation (release).

    Get the latest LinkStack chart values file for a new installation:

    ```sh
    helm show values mika/linkstack > values.yaml
    ```

    Alternatively, get the values file of an existing LinkStack release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your LinkStack values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for LinkStack or upgrade an existing LinkStack release:

    ```sh
    helm upgrade --install ${releaseName} mika/linkstack --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your LinkStack release has been installed:

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
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"linkstackorg/linkstack"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `Chart appVersion`. |
| image.linkstack.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the LinkStack container image. Default: `"IfNotPresent"`. |
| image.linkstack.registry | string | `""` | The registry where the LinkStack container image is hosted. Default: `"docker.io"`. |
| image.linkstack.repository | string | `""` | The name of the repository that contains the LinkStack container image used. Default: `"linkstackorg/linkstack"`. |
| image.linkstack.tag | string | `""` | The tag that specifies the version of the LinkStack container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting LinkStack services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| linkstack.domain | string | `""` | The ingress domain name that hosts the LinkStack server. Default: `"localhost"`. |
| linkstack.initScript | string | `""` | Custom init script to run before the LinkStack container starts. |
| linkstack.logLevel | string | `""` | The level of verbosity of the messages recorded in the error log. Default: `"info"`. |
| linkstack.phpMemLimit | string | `""` | The maximum amount of memory PHP scripts are allowed to allocate. Default: `"256M"`. |
| linkstack.serverAdmin | string | `""` | The Apache server administrator email address. Default: `"admin@example.com"`. |
| linkstack.timezone | string | `""` | The timezone of the LinkStack server. Default: `"UTC"`. |
| linkstack.uploadMaxFilesize | string | `""` | The maximum allowed file size for uploaded files. Default: `"8M"`. |
| replicaCount | string | `""` | The desired number of running replicas for LinkStack. Default: `"1"`. |
| resources.linkstack | object | `{}` | LinkStack container resources. |
| service.http.nodePort | string | `""` | The optional node port to expose for http when the service type is NodePort. |
| service.http.port | string | `""` | The http port on which the LinkStack server should listen. Default: `"80"`. |
| service.https.nodePort | string | `""` | The optional node port to expose for https when the service type is NodePort. |
| service.https.port | string | `""` | The https port on which the LinkStack server should listen. Default: `"443"`. |
| service.type | string | `""` | The type of service used for LinkStack services. Default: `"ClusterIP"`. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteOnce"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/htdocs"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |