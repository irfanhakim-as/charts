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

### qBittorrent

- Log into the qBittorrent web interface using the temporary password provided in the logs.

- Click the **Options** button (gear cog icon).

- In the newly opened **Options** window, navigate to the **Web UI** tab:

  - Under the **Authentication** section, set a new **Username** and **Password** accordingly.

- Navigate to the **Downloads** tab:

  - Use Subcategories: `Enabled`.
  - Default Save Path: `/downloads`.
  - Keep incomplete torrents in: `/downloads/incomplete`.
  - Run external program on torrent finished: `/usr/bin/unrar x -r -y "%D*.rar" "%D"`

- Navigate to the **BitTorrent** tab:

  - Torrent Queueing: `Enabled`.
  - When ratio reaches: `1`.
  - When total seeding time reaches: `1440 minutes`.
  - then: `Remove torrent and its files`.

- Click the **Save** button to apply the changes.

### Sonarr

- TODO.

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
| image.jackett.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Jackett container image. Default: `"IfNotPresent"`. |
| image.jackett.registry | string | `""` | The registry where the Jackett container image is hosted. Default: `"lscr.io"`. |
| image.jackett.repository | string | `""` | The name of the repository that contains the Jackett container image used. Default: `"linuxserver/jackett"`. |
| image.jackett.tag | string | `""` | The tag that specifies the version of the Jackett container image used. Default: `"0.21.1700"`. |
| image.plex.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Plex container image. Default: `"IfNotPresent"`. |
| image.plex.registry | string | `""` | The registry where the Plex container image is hosted. Default: `"index.docker.io"`. |
| image.plex.repository | string | `""` | The name of the repository that contains the Plex container image used. Default: `"plexinc/pms-docker"`. |
| image.plex.tag | string | `""` | The tag that specifies the version of the Plex container image used. Default: `Chart appVersion`. |
| image.qbt.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the qBittorrent container image. Default: `"IfNotPresent"`. |
| image.qbt.registry | string | `""` | The registry where the qBittorrent container image is hosted. Default: `"lscr.io"`. |
| image.qbt.repository | string | `""` | The name of the repository that contains the qBittorrent container image used. Default: `"linuxserver/qbittorrent"`. |
| image.qbt.tag | string | `""` | The tag that specifies the version of the qBittorrent container image used. Default: `4.6.3-r0-ls310`. |
| image.sonarr.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Sonarr container image. Default: `"IfNotPresent"`. |
| image.sonarr.registry | string | `""` | The registry where the Sonarr container image is hosted. Default: `"lscr.io"`. |
| image.sonarr.repository | string | `""` | The name of the repository that contains the Sonarr container image used. Default: `"linuxserver/sonarr"`. |
| image.sonarr.tag | string | `""` | The tag that specifies the version of the Sonarr container image used. Default: `4.0.1.929-ls224`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting plexmaster services. |
| jackett.autoUpdate | bool | `true` | Specifies whether to allow Jackett to automatically update itself inside the container. |
| jackett.domain | string | `""` | The ingress domain name that hosts the Jackett server. |
| jackett.ingress | bool | `false` | Specifies whether Jackett should be hosted using an Ingress. |
| plex.claim | string | `""` | The secret claim token used to claim ownership of the Plex server. Get it from https://www.plex.tv/claim. |
| plex.domain | string | `""` | The ingress domain name that hosts the Plex server. |
| plex.ingress | bool | `false` | Specifies whether Plex should be hosted using an Ingress. |
| qbt.domain | string | `""` | The ingress domain name that hosts the qBittorrent server. |
| qbt.ingress | bool | `false` | Specifies whether qBittorrent should be hosted using an Ingress. |
| replicaCount | string | `""` | The desired number of running replicas for plexmaster. Default: `"1"`. |
| resources.jackett | object | `{}` | Jackett container resources. |
| resources.plex | object | `{}` | Plex container resources. |
| resources.qbt | object | `{}` | qBittorrent container resources. |
| resources.sonarr | object | `{}` | Sonarr container resources. |
| service.type | string | `""` | The type of service used for plexmaster services. Default: `"ClusterIP"`. |
| smb.enabled | bool | `false` | Specifies whether to enable persistent storage to be provisioned in the form of an SMB share. |
| smb.mountOptions | list | `[]` | The additional mount options used to mount the SMB share volume. |
| smb.pvStorage | string | `""` | The amount of persistent storage available on the SMB share volume. Default: `"100Gi"`. |
| smb.pvcStorage | string | `""` | The amount of persistent storage allocated for the SMB share storage. Default: `"1Gi"`. |
| smb.secretName | string | `""` | The name of the existing secret containing the credentials used to authenticate with the SMB share. Default: `"smbcreds"`. |
| smb.secretNamespace | string | `""` | The namespace where the secret containing the credentials used to authenticate with the SMB share is located. Default: `"default"`. |
| smb.share | string | `""` | The SMB share address and name to mount as a persistent volume. |
| smb.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the SMB share storage. Default: `"smb"`. |
| sonarr.domain | string | `""` | The ingress domain name that hosts the Sonarr server. |
| sonarr.ingress | bool | `false` | Specifies whether Sonarr should be hosted using an Ingress. |
| storage.data.enabled | bool | `true` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/config"`. |
| storage.data.smb | bool | `false` | Specifies whether to use an SMB share for the data storage. |
| storage.data.storage | string | `""` | The amount of persistent storage allocated for the data storage. This setting is ignored if SMB is enabled for said storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. This setting is ignored if SMB is enabled for said storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The sub-path within the data storage to mount for the container. |
| storage.downloads.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for downloads storage. |
| storage.downloads.mountPath | string | `""` | The path where the downloads storage should be mounted on the container. Default: `"/downloads"`. |
| storage.downloads.smb | bool | `false` | Specifies whether to use an SMB share for the downloads storage. |
| storage.downloads.storage | string | `""` | The amount of persistent storage allocated for the downloads storage. This setting is ignored if SMB is enabled for said storage. Default: `"1Gi"`. |
| storage.downloads.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the downloads storage. This setting is ignored if SMB is enabled for said storage. Default: `"longhorn"`. |
| storage.downloads.subPath | string | `""` | The sub-path within the downloads storage to mount for the container. |
| storage.media.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for media storage. |
| storage.media.mountPath | string | `""` | The path where the media storage should be mounted on the container. Default: `"/data"`. |
| storage.media.smb | bool | `false` | Specifies whether to use an SMB share for the media storage. |
| storage.media.storage | string | `""` | The amount of persistent storage allocated for the media storage. This setting is ignored if SMB is enabled for said storage. Default: `"1Gi"`. |
| storage.media.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the media storage. This setting is ignored if SMB is enabled for said storage. Default: `"longhorn"`. |
| storage.media.subPath | string | `""` | The sub-path within the media storage to mount for the container. |
