# [Syncthing](https://github.com/syncthing/syncthing)

Syncthing is a continuous file synchronization program. It synchronizes files between two or more computers.

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

1. Get the values file of the Syncthing chart or an existing installation (release).

    Get the latest Syncthing chart values file for a new installation:

    ```sh
    helm show values mika/syncthing > values.yaml
    ```

    Alternatively, get the values file of an existing Syncthing release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Syncthing values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Syncthing or upgrade an existing Syncthing release:

    ```sh
    helm upgrade --install ${releaseName} mika/syncthing --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Syncthing release has been installed:

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
| image.syncthing.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Syncthing container image. Default: `"IfNotPresent"`. |
| image.syncthing.registry | string | `""` | The registry where the Syncthing container image is hosted. Default: `"lscr.io"`. |
| image.syncthing.repository | string | `""` | The name of the repository that contains the Syncthing container image used. Default: `"linuxserver/syncthing"`. |
| image.syncthing.tag | string | `""` | The tag that specifies the version of the Syncthing container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Syncthing services. |
| replicaCount | string | `""` | The desired number of running replicas for Syncthing. Default: `"1"`. |
| resources.syncthing | object | `{}` | Syncthing container resources. |
| service.type | string | `""` | The type of service used for Syncthing services. Default: `"ClusterIP"`. |
| smb.enabled | bool | `false` | Specifies whether to enable persistent storage to be provisioned in the form of an SMB share. |
| smb.mountOptions | list | `[]` | The additional mount options used to mount the SMB share volume. |
| smb.pvStorage | string | `""` | The amount of persistent storage available on the SMB share volume. Default: `"100Gi"`. |
| smb.pvcStorage | string | `""` | The amount of persistent storage allocated for the SMB share storage. Default: `"1Gi"`. |
| smb.secretName | string | `""` | The name of the existing secret containing the credentials used to authenticate with the SMB share. Default: `"smbcreds"`. |
| smb.secretNamespace | string | `""` | The namespace where the secret containing the credentials used to authenticate with the SMB share is located. Default: `"default"`. |
| smb.share | string | `""` | The SMB share address and name to mount as a persistent volume. |
| smb.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the SMB share storage. Default: `"smb"`. |
| storage.config.enabled | bool | `true` | Specifies whether persistent storage should be provisioned for config storage. |
| storage.config.mountPath | string | `""` | The path where the config storage should be mounted on the container. Default: `"/config"`. |
| storage.config.storage | string | `""` | The default amount of persistent storage allocated for the config storage. Default: `"1Gi"`. |
| storage.config.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the config storage. Default: `"longhorn"`. |
| storage.config.subPath | string | `""` | The subpath within the config storage to mount to the container. Leave empty if not required. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/data"`. |
| storage.data.smb | bool | `false` | Specifies whether to use an SMB share for the data storage. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |
| syncthing.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Syncthing container. |
| syncthing.domain | string | `""` | The ingress domain name that hosts the Syncthing server. |
| syncthing.gid | string | `""` | The group ID used to run the Syncthing containers. Default: `"1000"`. |
| syncthing.uid | string | `""` | The user ID used to run the Syncthing containers. Default: `"1000"`. |