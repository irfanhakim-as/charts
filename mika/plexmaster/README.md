# `plexmaster`

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Longhorn 1.4.1+
- csi-driver-smb 1.14.0+

---

## How to add repo

Add the repo to your local helm client.

```sh
helm repo add mika https://irfanhakim-as.github.io/charts
```

Update the repo to retrieve the latest versions of the packages.

```sh
helm repo update
```

---

## How to install

### Prepare chart values

Copy `values.yaml` from the chart you would like to install.

```sh
cp mika/plexmaster/values.yaml .
```

Edit `values.yaml` with the appropriate values.  Please refer to the [Configurations](#configurations) section below, or the `values.yaml` file itself for details and sample values.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/plexmaster --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

---

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/plexmaster --namespace $namespace --values values.yaml --wait
```

---

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

---

## Application Configuration

### Jackett

- Launch the Jackett web interface.

- In the **Jackett Configuration** section:

  - Admin password: Add a secure password and click the **Set Password** button.
  - Blackhole directory: `/downloads`.
  - Click the **Apply server settings** button.

- Select and add indexers to the Jackett server.

### Plex

- Log in and acquire the secret Claim Token from [Plex](https://www.plex.tv/claim). This token is required to authenticate the server with your Plex account, and is only valid for 4 minutes.

- Settings > Server > Remote Access: `Disable Remote Access`.

- Settings > Server > Network:

    - Enable Relay: `Disabled`.
    - Custom server access URLs: Enter the domain name of the Plex server i.e. `https://plex.example.com`.

---

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.gid | string | `""` | The group ID used to run the plexmaster containers. Default: `"1000"`. |
| global.initScript | string | `""` | Custom init script to run before the plexmaster containers start. |
| global.uid | string | `""` | The user ID used to run the plexmaster containers. Default: `"1000"`. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.34"`. |
| image.jackett.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Jackett container image. Default: "IfNotPresent". |
| image.jackett.registry | string | `""` | The registry where the Jackett container image is hosted. Default: `"lscr.io"`. |
| image.jackett.repository | string | `""` | The name of the repository that contains the Jackett container image used. Default: `"linuxserver/jackett"`. |
| image.jackett.tag | string | `""` | The tag that specifies the version of the Jackett container image used. Default: `"0.21.1700"`. |
| image.plex.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Plex container image. Default: `"IfNotPresent"`. |
| image.plex.registry | string | `""` | The registry where the Plex container image is hosted. Default: `"index.docker.io"`. |
| image.plex.repository | string | `""` | The name of the repository that contains the Plex container image used. Default: `"plexinc/pms-docker"`. |
| image.plex.tag | string | `""` | The tag that specifies the version of the Plex container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.enabled | bool | `false` | Specifies whether plexmaster should be hosted using an Ingress. |
| jackett.autoUpdate | bool | `true` | Specifies whether to allow Jackett to automatically update itself inside the container. |
| jackett.domain | string | `""` | The ingress domain name that hosts the Jackett server. |
| plex.claim | string | `""` | The secret claim token used to claim ownership of the Plex server. Get it from https://www.plex.tv/claim. |
| plex.domain | string | `""` | The ingress domain name that hosts the Plex server. |
| replicaCount | string | `""` | The desired number of running replicas for plexmaster. Default: `"1"`. |
| resources.jackett | object | `{}` | Jackett container resources. |
| resources.plex | object | `{}` | Plex container resources. |
| service.type | string | `""` | The type of service used for plexmaster services. Default: `"ClusterIP"`. |
| storage.data.enabled | bool | `true` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.storage | string | `""` | The amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.downloads.enabled | bool | `true` | Specifies whether persistent storage should be provisioned for downloads storage. |
| storage.downloads.storage | string | `""` | The amount of persistent storage allocated for the downloads storage. Default: `"1Gi"`. |
| storage.downloads.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the downloads storage. Default: `"longhorn"`. |
| storage.media.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for media storage. |
| storage.media.storage | string | `""` | The amount of persistent storage allocated for the media storage. Default: `"1Gi"`. |
| storage.media.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the media storage. Default: `"longhorn"`. |
| storage.smb.enabled | bool | `false` | Specifies whether persistent storage should be provisioned in the form of an SMB share. |
| storage.smb.mountOptions | list | `[]` | The additional mount options used to mount the SMB share volume. |
| storage.smb.mountPath | string | `""` | The path where the SMB share volume should be mounted on the container. Default: `"/mnt/smb"`. |
| storage.smb.pvStorage | string | `""` | The amount of persistent storage available on the SMB share volume. Default: `"100Gi"`. |
| storage.smb.pvcStorage | string | `""` | The amount of persistent storage allocated for the SMB share storage. Default: `"1Gi"`. |
| storage.smb.secretName | string | `""` | The name of the existing secret containing the credentials used to authenticate with the SMB share. Default: `"smbcreds"`. |
| storage.smb.secretNamespace | string | `""` | The namespace where the secret containing the credentials used to authenticate with the SMB share is located. Default: `"default"`. |
| storage.smb.share | string | `""` | The SMB share address and name to mount as a persistent volume. |
| storage.smb.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the SMB share storage. Default: `"smb"`. |
| storage.smb.subPath | string | `""` | The sub-path within the SMB share volume to mount. |
