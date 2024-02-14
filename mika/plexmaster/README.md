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
  - Blackhole directory: `/downloads/`.
  - Click the **Apply server settings** button.

- Add indexers to the Jackett server:

  - From the dashboard, click the **Add Indexer** button.
  - In the **Select an indexer to setup** popup, expand the **Type** dropdown and select **Public**.
  - Expand the **Categories** dropdown and select the **TV** category.
  - Select the checkbox corresponding to the desired indexers, and click the **Add Selected** button at the bottom of the list.
  - Repeat these steps for the **Movies** category.

- Test the indexers by clicking the **Test All** button on the dashboard.

- Remove any indexer that consistently fails the test by clicking the **Delete** (trash can) button corresponding to the indexer.

### Overseerr

> [!NOTE]  
> The following steps require you to have set up and configured [Plex](#plex), [Radarr, and Sonarr](#radarr-and-sonarr) before proceeding.

- Launch the Overseerr web interface and login using your Plex account.

- In the **Configure Plex** page:
  - Configure **Plex Settings**:
    - Server: `Manual configuration`.
    - Hostname or IP Address: `localhost`.
    - Port: `32400`.
    - Use SSL: `Disabled`.
    - Web App URL: Enter the domain name of the Plex server i.e. `https://plex.example.com`.
    - Click the **Save Changes** button.
  - Configure **Plex Libraries**:
    - Click the **Sync Libraries** button.
    - Toggle each library's (i.e. **Movies** and **TV Shows**) corresponding switch to enable them.
  - Click the **Continue** button.

- In the **Configure Services** page:

  - **Radarr Settings**:
    - Click the **Add Radarr Server** button.
    - Default Server: `Enabled`.
    - 4K Server: `Disabled`.
    - Server Name: `Radarr`.
    - Hostname or IP Address: `localhost`.
    - Port: `7878`.
    - Use SSL: `Disabled`.
    - API Key: Get the API key from the Radarr web interface at `Settings > General > Security > API Key` and paste it in this field.
    - Click the **Test** button to verify the settings and for it to load some data from the Radarr server.
    - Quality Profile: Expand the dropdown and select the desired quality profile i.e. `HD-1080p`.
    - Root Folder: Expand the dropdown and select the folder where your Movie media is stored i.e. `/data/Movies`.
    - Minimum Availability: `Announced`.
    - Enable Scan: `Enabled`.
    - Enable Automatic Search: `Enabled`.
    - Click the **Add Server** button.

  - **Sonarr Settings**:
    - Click the **Add Sonarr Server** button.
    - Default Server: `Enabled`.
    - 4K Server: `Disabled`.
    - Server Name: `Sonarr`.
    - Hostname or IP Address: `localhost`.
    - Port: `8989`.
    - Use SSL: `Disabled`.
    - API Key: Get the API key from the Sonarr web interface at `Settings > General > Security > API Key` and paste it in this field.
    - Click the **Test** button to verify the settings and for it to load some data from the Sonarr server.
    - Quality Profile: Expand the dropdown and select the desired quality profile i.e. `HD-1080p`.
    - Root Folder: Expand the dropdown and select the folder where your TV media is stored i.e. `/data/TV`.
    - Language Profile: `Deprecated`.
    - Anime Quality Profile: Expand the dropdown and select the desired quality profile i.e. `HD-1080p`.
    - Anime Root Folder: Expand the dropdown and select the folder where your TV media is stored i.e. `/data/TV`.
    - Anime Language Profile: `Deprecated`.
    - Season Folders: `Enabled`.
    - Enable Scan: `Enabled`.
    - Enable Automatic Search: `Enabled`.
    - Click the **Add Server** button.

  - Click the **Finish Setup** button.

- To request a Movie or TV series to be added to your Plex server:

  - In the **Discover** page of the Overseerr web interface, search for the Movie or TV series.
  - From the **Search Results**, locate and click the Movie or TV series.
  - In the selected media's details page, click the **Request** button.
  - Click the **Request** button in the confirmation modal.

### Plex

- Log in and acquire the secret Claim Token from [Plex](https://www.plex.tv/claim). This token is required to authenticate the server with your Plex account, and is only valid for 4 minutes.

- Launch the Plex web interface.

- Go through the initial server setup, and disable the **Allow me to access my media outside my home** option.

- Head to **Settings > Server > Network** and configure the following:

  - Enable Relay: `Disabled`.

  - Custom server access URLs: Enter the domain name of the Plex server i.e. `https://plex.example.com`.

  - Click the **Save Changes** button.

- Head to **Settings > Server > Libraries** and configure the following:

  - Click the **Add Library** button.

  - Select type:
    - Library type: `Movies`.
    - Name: `Movies`.
    - Language: `English`.
    - Click the **Next** button.

  - Add folders:
    - Click the **Browse for Media Folder** button.
    - Navigate to the folder where your movie media is stored i.e. `/data/Movies`.
    - Click the **Add** button.
    - Click the **Add Library** button.

  - Repeat the same steps for the **TV Shows** library.

### qBittorrent

> [!NOTE]  
> Even if you are using an external qBittorrent server, follow these steps to ensure said server is properly configured.

- Log into the qBittorrent web interface using the temporary password provided in the logs.

- Click the **Options** button (gear cog icon).

- In the newly opened **Options** window, navigate to the **Web UI** tab:

  - Under the **Authentication** section, set a new **Username** and **Password** accordingly.

- Navigate to the **Downloads** tab:

  - Use Subcategories: `Enabled`.
  - Default Save Path: `/downloads/complete`.
  - Keep incomplete torrents in: `/downloads/incomplete`.
  - Run external program on torrent finished: `/usr/bin/unrar x -r -y "%D*.rar" "%D"`

- Navigate to the **BitTorrent** tab:

  - Torrent Queueing: `Enabled`.
  - When ratio reaches: `1`.
  - When total seeding time reaches: `1440 minutes`.
  - then: `Pause torrent`.

- Click the **Save** button to apply the changes.

### Radarr and Sonarr

> [!NOTE]  
> The following steps require you to have set up and configured [Jackett](#jackett), [qBittorrent](#qbittorrent), and [Plex](#plex) before proceeding.

- Launch the Sonarr web interface.

- In the **Authentication Required** form:

  - Authentication Method: `Forms (Login Page)`.

  - Authentication Required: `Enabled`.

  - Username: Fill in the desired username.

  - Password: Fill in a secure password.

  - Password Confirmation: Repeat the password for confirmation.

  - Click the **Save** button.

- Click the **Settings** menu item on the left, and then click the **Indexers** link.

- Under the **Indexers** section, click the **+** button to add a new indexer.

- Under **Torrents**, click **Torznab**.

- In the **Add Indexer - Torznab** form:

  - Name: Pick an indexer you have added to Jackett and add its name to this field.

  - URL: Pick an indexer you have added to Jackett and paste the URL acquired from the indexer's corresponding **Copy Torznab Feed** button here.

    > [!TIP]  
    > If your Jackett service runs on a domain i.e. through Ingress, you may replace the domain name (i.e. `https://jackett.example.com`) with localhost and Jackett's service port (i.e. `http://localhost:9117`).

  - API Key: Copy the API key from Jackett and paste it in this field.

  - Categories: Expand the dropdown and select all **Movie** (Radarr) or **TV** and **Anime** (Sonarr) related categories.

  - Anime Categories (Sonarr): Expand the dropdown and select all **Anime** related categories.

  - Anime Standard Format Search (Sonarr): `Enabled` if the indexer has Anime related categories selected.

  - Leave the rest of the fields as default.

  - Click the **Test** button to verify the settings and wait for a green checkmark indicating that the test was successful.

  - Click the **Save** button.

- Repeat the last step for each indexer you wish to add from Jackett.

- Click the **Settings** menu item on the left, and then click the **Download Clients** link.

- Under the **Download Clients** section, click the **+** button to add a new download client.

- Under **Torrents**, click **qBittorrent**.

- In the **Add Download Client - qBittorrent** form:

  - Username: Fill in the username you set for qBittorrent.

  - Password: Fill in the password you set for qBittorrent.

  - Leave the rest of the fields as default.

  - Click the **Test** button to verify the settings and wait for a green checkmark indicating that the test was successful.

  - Click the **Save** button.

- Click the **Settings** menu item on the left, and then click the **Connect** link.

- Under the **Connections** section, click the **+** button to add a new connection.

- Under **Add Connection**, click **Plex Media Server**.

- In the **Add Connection - Plex Media Server** form:

  - Host: `localhost`.

  - Authenticate with Plex.tv: Click the corresponding button and log in with your Plex account.

  - Click the **Test** button to verify the settings and wait for a green checkmark indicating that the test was successful.

  - Click the **Save** button.

- Click the **Settings** menu item on the left, and then click the **Media Management** link.

- Click the **Add Root Folder** button to add a folder.

- In the **File Browser** form, locate and select the folder where your Movie media (Radarr) or TV media (Sonarr) is stored (same as the one used for Plex i.e. `/data/Movies` or `/data/TV`), and click the **Ok** button.

- Under the **Movie Naming** (Radarr) or **Episode Naming** (Sonarr) section, set the **Rename Movies/Episodes** option to `Enabled`.

- Click the **Save Changes** button.

- Click the **Settings** menu item on the left, and then click the **Profiles** link.

- Under the **Quality Profiles** section, delete any profiles you may not want i.e. `Any`, `HD - 720p/1080p`, `HD-720p`, `SD`, and `Ultra-HD` by opening said profile and clicking the **Delete** button.

  > [!TIP]  
  > You may also configure any existing profiles or add new ones to better suit your preferences, make sure to click the **Save** button after making any changes.

- Click the **Movies** (Radarr) or **Series** (Sonarr) menu item on the left, and then click the **Add New** link.

- In the provided search bar, search for a Movie (Radarr) or TV series (Sonarr) you wish to add to Plex, and select it from the search results.

- In the show's details modal, leave the form as default or configure accordingly, and click the **Add Movie/{Show Name}** button.

  > [!TIP]  
  > If you'd like it to start searching and downloading, click the **Start search for missing movie/episodes** button in the form.

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
| image.overseerr.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Overseerr container image. Default: `"IfNotPresent"`. |
| image.overseerr.registry | string | `""` | The registry where the Overseerr container image is hosted. Default: `"lscr.io"`. |
| image.overseerr.repository | string | `""` | The name of the repository that contains the Overseerr container image used. Default: `"linuxserver/overseerr"`. |
| image.overseerr.tag | string | `""` | The tag that specifies the version of the Overseerr container image used. Default: `"v1.33.2-ls95"`. |
| image.plex.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Plex container image. Default: `"IfNotPresent"`. |
| image.plex.registry | string | `""` | The registry where the Plex container image is hosted. Default: `"index.docker.io"`. |
| image.plex.repository | string | `""` | The name of the repository that contains the Plex container image used. Default: `"plexinc/pms-docker"`. |
| image.plex.tag | string | `""` | The tag that specifies the version of the Plex container image used. Default: `Chart appVersion`. |
| image.qbt.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the qBittorrent container image. Default: `"IfNotPresent"`. |
| image.qbt.registry | string | `""` | The registry where the qBittorrent container image is hosted. Default: `"lscr.io"`. |
| image.qbt.repository | string | `""` | The name of the repository that contains the qBittorrent container image used. Default: `"linuxserver/qbittorrent"`. |
| image.qbt.tag | string | `""` | The tag that specifies the version of the qBittorrent container image used. Default: `4.6.3-r0-ls310`. |
| image.radarr.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Radarr container image. Default: `"IfNotPresent"`. |
| image.radarr.registry | string | `""` | The registry where the Radarr container image is hosted. Default: `"lscr.io"`. |
| image.radarr.repository | string | `""` | The name of the repository that contains the Radarr container image used. Default: `"linuxserver/radarr"`. |
| image.radarr.tag | string | `""` | The tag that specifies the version of the Radarr container image used. Default: `5.2.6.8376-ls202`. |
| image.sonarr.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Sonarr container image. Default: `"IfNotPresent"`. |
| image.sonarr.registry | string | `""` | The registry where the Sonarr container image is hosted. Default: `"lscr.io"`. |
| image.sonarr.repository | string | `""` | The name of the repository that contains the Sonarr container image used. Default: `"linuxserver/sonarr"`. |
| image.sonarr.tag | string | `""` | The tag that specifies the version of the Sonarr container image used. Default: `4.0.1.929-ls224`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting plexmaster services. |
| jackett.autoUpdate | bool | `true` | Specifies whether to allow Jackett to automatically update itself inside the container. |
| jackett.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Jackett container. |
| jackett.domain | string | `""` | The ingress domain name that hosts the Jackett server. |
| jackett.ingress | bool | `false` | Specifies whether Jackett should be hosted using an Ingress. |
| overseerr.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Overseerr container. |
| overseerr.domain | string | `""` | The ingress domain name that hosts the Overseerr server. |
| overseerr.ingress | bool | `false` | Specifies whether Overseerr should be hosted using an Ingress. |
| plex.claim | string | `""` | The secret claim token used to claim ownership of the Plex server. Get it from https://www.plex.tv/claim. |
| plex.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Plex container. |
| plex.domain | string | `""` | The ingress domain name that hosts the Plex server. |
| plex.ingress | bool | `false` | Specifies whether Plex should be hosted using an Ingress. |
| qbt.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the qBittorrent container. |
| qbt.domain | string | `""` | The ingress domain name that hosts the qBittorrent server. |
| qbt.enabled | bool | `true` | Specifies whether qBittorrent should be deployed or excluded in case an external qBittorrent server is used. |
| qbt.ingress | bool | `false` | Specifies whether qBittorrent should be hosted using an Ingress. |
| radarr.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Radarr container. |
| radarr.domain | string | `""` | The ingress domain name that hosts the Radarr server. |
| radarr.ingress | bool | `false` | Specifies whether Radarr should be hosted using an Ingress. |
| replicaCount | string | `""` | The desired number of running replicas for plexmaster. Default: `"1"`. |
| resources.jackett | object | `{}` | Jackett container resources. |
| resources.overseerr | object | `{}` | Overseerr container resources. |
| resources.plex | object | `{}` | Plex container resources. |
| resources.qbt | object | `{}` | qBittorrent container resources. |
| resources.radarr | object | `{}` | Radarr container resources. |
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
| sonarr.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Sonarr container. |
| sonarr.domain | string | `""` | The ingress domain name that hosts the Sonarr server. |
| sonarr.ingress | bool | `false` | Specifies whether Sonarr should be hosted using an Ingress. |
| storage.data.enabled | bool | `true` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/config"`. |
| storage.data.storage | string | `""` | The amount of persistent storage allocated for each data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The sub-path within the data storage to mount for the container. |
| storage.downloads.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for downloads storage. |
| storage.downloads.mountPath | string | `""` | The path where the downloads storage should be mounted on the container. Default: `"/downloads"`. |
| storage.downloads.smb | bool | `false` | Specifies whether to use an SMB share for the downloads storage. |
| storage.downloads.storage | string | `""` | The amount of persistent storage allocated for the downloads storage. This setting is ignored if SMB is enabled for said storage. Default: `"1Gi"`. |
| storage.downloads.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the downloads storage. This setting is ignored if SMB is enabled for said storage. Default: `"longhorn"`. |
| storage.downloads.subPath | string | `""` | The sub-path within the downloads storage to mount for the container. |
| storage.global.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for global storage. This storage will override the downloads and media storage. |
| storage.global.mountPath | string | `""` | The path where the global storage should be mounted on the container. Default: `"/plexmaster"`. |
| storage.global.smb | bool | `false` | Specifies whether to use an SMB share for the global storage. |
| storage.global.storage | string | `""` | The amount of persistent storage allocated for the global storage. This setting is ignored if SMB is enabled for said storage. Default: `"1Gi"`. |
| storage.global.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the global storage. This setting is ignored if SMB is enabled for said storage. Default: `"longhorn"`. |
| storage.global.subPath | string | `""` | The sub-path within the global storage to mount for the container. |
| storage.media.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for media storage. |
| storage.media.mountPath | string | `""` | The path where the media storage should be mounted on the container. Default: `"/data"`. |
| storage.media.smb | bool | `false` | Specifies whether to use an SMB share for the media storage. |
| storage.media.storage | string | `""` | The amount of persistent storage allocated for the media storage. This setting is ignored if SMB is enabled for said storage. Default: `"1Gi"`. |
| storage.media.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the media storage. This setting is ignored if SMB is enabled for said storage. Default: `"longhorn"`. |
| storage.media.subPath | string | `""` | The sub-path within the media storage to mount for the container. |
