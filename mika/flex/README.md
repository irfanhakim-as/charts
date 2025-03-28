# Flex

Flex is a collection of curated services that aims to provide a complete home media server solution.

## Prerequisites

> [!NOTE]  
> You may refer to [Orked](https://github.com/irfanhakim-as/orked) for help with setting up a Kubernetes cluster that meets all the following prerequisites.

- Kubernetes 1.19+
- Helm 3.2.0+
- Longhorn 1.4.1+
- csi-driver-smb 1.14.0+

---

## Preflight checklist

> [!IMPORTANT]  
> The following items are required to be set up prior to installing this chart.

**This section does not apply to this chart.**

---

## Recommended configurations

> [!NOTE]  
> The following configuration recommendations might not be the default settings for this chart but are **highly recommended**. Please carefully consider them before configuring your installation.

1. Disable qBittorrent and use an external qBittorrent server.

   - Set up an external qBittorrent server. Refer to [this](https://github.com/qbittorrent/qBittorrent/wiki/Running-qBittorrent-without-X-server-(WebUI-only,-systemd-service-set-up,-Ubuntu-15.04-or-newer)) guide on how to do so.

   - Exclude qBittorrent from the Flex installation by setting `qbt.enabled: false` in the chart values file.

      > [!IMPORTANT]  
      > Using an external qBittorrent server will require you to use SMB for either the global storage (**Preferred**) or alternatively, the downloads storage. Otherwise, you will encounter issues with Flex services such as Radarr and Sonarr not being able to access the downloaded media from the external qBittorrent server.

   - Using an external qBittorrent server helps avoid potential throttling issues with download/upload speeds.

2. Use the global storage instead of the downloads and media storage combo.

   - Enable the global storage by setting `storage.global.enabled: true` in the chart values file.

      > [!NOTE]  
      > Using the global storage will automatically override the downloads and media storage settings and their roles.

   - Using the global storage is highly recommended to ensure that features such as hard linking (in Radarr and Sonarr) work as intended. Otherwise, downloaded media from the downloads storage will be copied over to the media storage, consuming more storage space and time.

3. Use SMB with the global storage.

   - Going this route will require you to set up an external SMB share on your network or use an existing one. This SMB storage will be used as the primary storage for your media files.

   - Prepare a directory layout such as this on the root of your SMB share for your media files and downloads:

      ```sh
      Flex
      ├── Downloads
      │  ├── complete
      │  └── incomplete
      └── Media
         ├── Movies
         └── TV
      ```

      > [!IMPORTANT]  
      > Using SMB with a Flex storage means that the SMB share must be available and accessible on your network at all times for the Flex services to function properly.

   - Enable SMB for the Flex installation by setting `smb.enabled: true` in the chart values file.

   - Enable SMB for the global storage by setting `storage.global.smb: true` in the chart values file.

   - Configure the `smb` settings in the chart values file accordingly.

   - Update the `storage.global.subPath` setting in the chart values file to point to the root of your _Flex_ directory on the SMB share.

      > [!TIP]  
      > From the sample directory layout above, the `storage.global.subPath` value should be set to `"Flex"`.

   - Using SMB (for the global storage) is highly recommended (and in some cases, required) for several benefits:

     - Access and interact with your media files easily from any devices on your network.

     - Manage your storage space more effectively i.e. expanding and using the SMB share for other purposes, rather than allocating that storage space solely for the Flex installation.

     - Using SMB is **required** for Flex services to be able to access media files and downloads they need for their tasks when relying on an external server i.e. Plex or qBittorrent.

4. **(Optional)** Use Ingress for serving Flex services outside of your network.

   - Enable Ingress for the Flex installation by setting `ingress.enabled: true` in the chart values file.

   - Enable Ingress and specify the registered domain name for each Flex service by setting their corresponding `ingress` and `domain` settings in the chart values file:

      > [!IMPORTANT]  
      > Replace the sample domain names with your actual domain names that have been registered to your DNS provider and pointed to your Kubernetes cluster.

     - Jackett: `jackett.ingress: true` and `jackett.domain: "jackett.example.com"`.

     - Overseerr: `overseerr.ingress: true` and `overseerr.domain: "overseerr.example.com"`.

     - Plex: `plex.ingress: true` and `plex.domain: "plex.example.com"`.

     - qBittorrent: `qbt.ingress: true` and `qbt.domain: "qbt.example.com"`.

     - Radarr: `radarr.ingress: true` and `radarr.domain: "radarr.example.com"`.

     - Sonarr: `sonarr.ingress: true` and `sonarr.domain: "sonarr.example.com"`.

      If any of these services were deployed externally, you may exclude them from these configuration options.

   - Configure the rest of the `ingress` settings (i.e. `ingress.clusterIssuer`) in the chart values file as required by your cluster environment.

5. **(Optional)** Use NodePort for serving Flex services exclusively within your network.

   - Set the service type of the Flex installation to NodePort by setting `service.type: "NodePort"` in the chart values file.

   - **(Optional)** Explicitly set the node port for each Flex service by updating their corresponding `service.nodePort` setting in the chart values file (i.e. `service.bazarr.nodePort: "30000"`). Otherwise, a random, available port will be allocated for each service.

   - Access any of the deployed Flex service from any device within your network by using the node IP and node port assigned to the corresponding service (i.e. `http://<node_ip>:<node_port>`).

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

> [!IMPORTANT]  
> To prevent a potential issue with attaching/mounting volumes to multiple nodes, you may need to set the value of `replicaCount` to `"0"` in the release values file before upgrading. After the upgrade is complete, revert the value back to its previous setting and upgrade the chart once again to complete the upgrade process.

1. Get the values file of the Flex chart or an existing installation (release).

    Get the latest Flex chart values file for a new installation:

    ```sh
    helm show values mika/flex > values.yaml
    ```

    **Alternatively**, get the values file of an existing Flex release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Flex values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Flex or upgrade an existing Flex release:

    ```sh
    helm upgrade --install ${releaseName} mika/flex --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Flex release has been installed:

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

## Application configurations

### [Bazarr](https://www.bazarr.media)

> [!NOTE]  
> The following steps require you to have set up and configured [Radarr and Sonarr](#radarr-and-sonarr) before proceeding.

1. Launch the Bazarr web interface.

2. In the **General** page under the **Settings** section, configure the following:

   - Authentication: `Form`.

   - Username: Fill in the desired username.

   - Password: Fill in a secure password.

   - Leave the rest of the settings as default.

   - Click the **Save** button.

3. Configure Radarr/Sonarr:

   - Click the **Radarr** or **Sonarr** menu item under the **Settings** section.

   - Use Radarr/Sonarr: Toggle the **Enabled** switch to enable Radarr/Sonarr.

   - API Key: Get the API key from the Radarr/Sonarr web interface at `Settings > General > Security > API Key` and paste it in this field.

   - Click the **Test** button to verify the settings.

   - Click the **Save** button.

   - If you are using an external server for Bazarr and have different paths to your media with Radarr/Sonarr, configure the Path Mapping settings:

     - Under the **Path Mappings** section, click the **Add** button.
     - Under **Radarr**/**Sonarr**, add the path to the folder where your Movie (Radarr) or TV (Sonarr) media is stored on Radarr/Sonarr i.e. `/flex/Media/Movie` or `/flex/Media/TV`.
     - Under **Bazarr**, add the path to the folder where your Movie (Radarr) or TV (Sonarr) media is stored on Bazarr i.e. `/movie` or `/tv`.
     - Click the **Save** button.

4. Configure the subtitle languages:

   - Click the **Languages** menu item under the **Settings** section.

   - Languages Filter: Type and select the desired language(s) for your subtitles i.e. `English`.

   - Languages Profiles: Click the **Add New Profile** button to add a new profile.

   - In the **Edit Languages Profile** form:

     - Name: Fill in the desired name for the profile i.e. `Master`.
     - Click the **Add Language** button to add the desired language(s) we've added earlier to the profile.
     - Configure the **Subtitles Type** and **Exclude If Matching Audio** settings for each language(s) accordingly.
     - (Optional) Cutoff: Set one of the language(s) you have set as the cutoff language (don't download more subtitles when one of this language is already found) i.e. `English`.
     - Click the **Save** button.

   - Under the **Default Settings** section:

     - Toggle the **Series** switch.
     - Expand the Series **Profile** dropdown and select the profile you've just created i.e. `Master`.
     - Toggle the **Movies** switch.
     - Expand the Movies **Profile** dropdown and select the profile you've just created i.e. `Master`.

   - Click the **Save** button.

5. Configure the subtitle providers:

   - Click the **Providers** menu item under the **Settings** section.

   - Under the **Providers** section, click the **+** button to add a new provider.

   - In the **Provider** form:

     - Select the desired provider from the dropdown and fill in the required fields accordingly (if any).

         > [!TIP]  
         > Recommended providers include `OpenSubtitles.com`, `Subscenter`, `Supersubtitles`, `TVSubtitles`, `Wizdom`, and `YIFY Subtitles`.

     - Click the **Save** button.

   - Click the **Save** button.

6. Configure the subtitles:

   - Click the **Subtitles** menu item under the **Settings** section.

   - Under the **Basic Options** section, configure the following:

     - Hearing-impaired subtitles extension: `.sdh`.

   - Under the **Subzero Modifications** section, configure the following:

     - Common Fixes: Toggle the corresponding switch to enable it.

   - Under the **Synchronizarion / Alignement** section, configure the following:

     - Automatic Subtitles Synchronization: Toggle the corresponding switch to enable it.

   - Leave the rest of the settings as default.

   - Click the **Save** button.

7. Configure the scheduler settings:

   - Click the **Scheduler** menu item under the **Settings** section.

   - Under the **Disk Indexing** section, configure the following:

     - Update All Episode Subtitles from Disk: `Daily`.
     - Time of The Day (Episode): `4:00`
     - Use cached embedded subtitles parser results (Episode): Toggle the corresponding switch to enable it.
     - Update All Movie Subtitles from Disk: `Daily`.
     - Time of The Day (Movie): `5:00`
     - Use cached embedded subtitles parser results (Movie): Toggle the corresponding switch to enable it.

   - Leave the rest of the settings as default.

   - Click the **Save** button.

8. Create a backup of the Bazarr configuration:

   - Click the **System** menu item on the left, and then click the **Backups** link.

   - Click the **Backup Now** button.

   - Wait for the backup to be created, then click the name (link) of the newly created backup file to download it.

   - Store the backup file in a safe location.

---

### [Jackett](https://github.com/Jackett/Jackett) (and [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr))

1. Launch the Jackett web interface.

2. Configure the following in the **Jackett Configuration** section:

   - Admin password: Add a secure password and click the **Set Password** button.

   - Blackhole directory: `/downloads/` or `/flex/Downloads/`.

   - FlareSolverr API URL: `http://localhost:8191`.

      > [!IMPORTANT]  
      > The FlareSolverr API URL value assumes that you include the built-in FlareSolverr server (`flaresolverr.enabled: true`) in your installation. If you are using an external FlareSolverr server, replace the value with the actual address to the FlareSolverr server. If neither is the case, you may leave said field empty.

   - Click the **Apply server settings** button.

3. Add indexers to the Jackett server:

   - From the dashboard, click the **Add Indexer** button.

   - In the **Select an indexer to setup** popup, expand the **Type** dropdown and select **Public**.

   - Expand the **Categories** dropdown and select the **TV** category.

   - Select the checkbox corresponding to the desired indexers, and click the **Add Selected** button at the bottom of the list.

   - Repeat these steps for the **Movies** category.

4. Test the indexers by clicking the **Test All** button on the dashboard.

5. Remove any indexer that consistently fails the test by clicking the **Delete** (trash can) button corresponding to the indexer.

---

### [Overseerr](https://overseerr.dev)

> [!NOTE]  
> The following steps require you to have set up and configured [Plex](#plex), [Radarr, and Sonarr](#radarr-and-sonarr) before proceeding.

1. Launch the Overseerr web interface and login using your Plex account.

2. In the **Configure Plex** page:

   - Configure **Plex Settings**:

     - Server: `Manual configuration`.

     - Hostname or IP Address: `localhost`.

         > [!NOTE]  
         > If you are using an external Plex server, replace the value with the actual address to the Plex server.

     - Port: `32400`.

     - Use SSL: `Disabled`.

     - Web App URL: Enter the domain name of the Plex server i.e. `https://plex.example.com`.

         > [!NOTE]  
         > You may skip this setting if your Plex server does not have a domain name set up.

     - Click the **Save Changes** button.

   - Configure **Plex Libraries**:

     - Click the **Sync Libraries** button.
     - Toggle each library's (i.e. **Movies** and **TV Shows**) corresponding switch to enable them.

   - Click the **Continue** button.

3. In the **Configure Services** page:

   - **Radarr Settings**:

      Click the **Add Radarr Server** button and configure the following:

     - Default Server: `Enabled`.
     - 4K Server: `Disabled`.
     - Server Name: `Radarr`.
     - Hostname or IP Address: `localhost`.
     - Port: `7878`.
     - Use SSL: `Disabled`.
     - API Key: Get the API key from the Radarr web interface at `Settings > General > Security > API Key` and paste it in this field.

      Click the **Test** button to verify and load some data from the Radarr server based on the current settings, then continue:

     - Quality Profile: Expand the dropdown and select the desired quality profile i.e. `HD-1080p`.
     - Root Folder: Expand the dropdown and select the folder where your Movie media is stored i.e. `/data/Movies` or `/flex/Media/Movies`.
     - Minimum Availability: `Announced`.
     - Enable Scan: `Enabled`.
     - Enable Automatic Search: `Enabled`.

      Click the **Add Server** button to complete the Radarr server configuration.

   - **Sonarr Settings**:

      Click the **Add Sonarr Server** button and configure the following:

     - Default Server: `Enabled`.
     - 4K Server: `Disabled`.
     - Server Name: `Sonarr`.
     - Hostname or IP Address: `localhost`.
     - Port: `8989`.
     - Use SSL: `Disabled`.
     - API Key: Get the API key from the Sonarr web interface at `Settings > General > Security > API Key` and paste it in this field.

      Click the **Test** button to verify and load some data from the Sonarr server based on the current settings, then continue:

     - Quality Profile: Expand the dropdown and select the desired quality profile i.e. `HD-1080p`.
     - Root Folder: Expand the dropdown and select the folder where your TV media is stored i.e. `/data/TV` or `/flex/Media/TV`.
     - Language Profile: `Deprecated`.
     - Anime Quality Profile: Expand the dropdown and select the desired quality profile i.e. `HD-1080p`.
     - Anime Root Folder: Expand the dropdown and select the folder where your TV media is stored i.e. `/data/TV` or `/flex/Media/TV`.
     - Anime Language Profile: `Deprecated`.
     - Season Folders: `Enabled`.
     - Enable Scan: `Enabled`.
     - Enable Automatic Search: `Enabled`.

      Click the **Add Server** button to complete the Sonarr server configuration.

   - Click the **Finish Setup** button.

4. To request a Movie or TV series to be added to your Plex server:

   - In the **Discover** page of the Overseerr web interface, search for the Movie or TV series.

   - From the **Search Results**, locate and click the Movie or TV series.

   - In the selected media's details page, click the **Request** button.

   - Click the **Request** button in the confirmation modal.

---

### [Plex](https://www.plex.tv)

> [!IMPORTANT]  
> Some of the following steps can be skipped or modified if you are using an external Plex server.

1. Log in and [acquire the secret Claim Token from Plex](https://www.plex.tv/claim). This token is required to authenticate the server with your Plex account, and is only valid for 4 minutes. Use this token for the `plex.claim` setting in your installation.

   > [!NOTE]  
   > Skip this step if you are using an external Plex server.

2. Launch the Plex web interface.

3. Go through the initial server setup, and disable the **Allow me to access my media outside my home** option.

4. Head to **Settings > Server > Network** and configure the following:

   - Enable Relay: `Disabled`.

   - Custom server access URLs: Enter the domain name of the Plex server i.e. `https://plex.example.com`.

      > [!NOTE]  
      > You may skip this setting if your Plex server does not have a domain name set up.

   - Click the **Save Changes** button.

5. Head to **Settings > Server > Libraries** and configure the following:

   - Click the **Add Library** button.

   - Select type:

     - Library type: `Movies`.
     - Name: `Movies`.
     - Language: `English`.
     - Click the **Next** button.

   - Add folders:

     - Click the **Browse for Media Folder** button.
     - Navigate to the folder where your movie media is stored i.e. `/data/Movies` or `/flex/Media/Movies`.
     - Click the **Add** button.
     - Click the **Add Library** button.

   - Repeat the same steps for the **TV Shows** library with the corresponding folder where your TV media is stored i.e. `/data/TV` or `/flex/Media/TV`.

---

### [qBittorrent](https://www.qbittorrent.org)

> [!NOTE]  
> Even if you are using an external qBittorrent server, follow these steps to ensure said server is properly configured.

1. Log into the qBittorrent web interface using the temporary password provided in the logs.

2. Click the **Options** button (gear cog icon).

3. In the newly opened **Options** window, navigate to the **Web UI** tab:

   - Under the **Authentication** section, set a new **Username** and **Password** accordingly.

4. Navigate to the **Downloads** tab and configure the following:

   - Default Torrent Management Mode: `Automatic`.

   - When Torrent Category changed: `Relocate torrent`.

   - When Default Save Path changed: `Relocate affected torrents`.

   - When Category Save Path changed: `Relocate affected torrents`.

   - Use Subcategories: `Enabled`.

   - Default Save Path: `/downloads/complete` or `/flex/Downloads/complete`.

   - Keep incomplete torrents in: `/downloads/incomplete` or `/flex/Downloads/incomplete`.

   - Run external program on torrent finished: `/usr/bin/unrar x -r -y "%D*.rar" "%D"`

      > [!IMPORTANT]  
      > If you are using an external qBittorrent server, ensure that `unrar` is installed on the server.

5. Navigate to the **BitTorrent** tab and configure the following:

   - Torrent Queueing: `Enabled`.

   - Maximum active downloads: `5`.

   - Maximum active uploads: `5`.

   - Maximum active torrents: `10`.

   - Do not count slow torrents in these limits: `Enabled`.

   - When ratio reaches: `1` (the higher the better for other peers).

   - When total seeding time reaches: `1440 minutes` (the higher the better for other peers).

   - then: `Pause torrent`.

6. Click the **Save** button to apply the changes.

---

### [Radarr](https://radarr.video) and [Sonarr](https://sonarr.tv)

> [!NOTE]  
> The following steps require you to have set up and configured [Jackett](#jackett-and-flaresolverr), [Plex](#plex), and [qBittorrent](#qbittorrent) before proceeding.

1. Launch the Radarr/Sonarr web interface.

2. In the **Authentication Required** form:

   - Authentication Method: `Forms (Login Page)`.

   - Authentication Required: `Enabled`.

   - Username: Fill in the desired username.

   - Password: Fill in a secure password.

   - Password Confirmation: Repeat the password for confirmation.

   - Click the **Save** button.

3. Add indexers to Radarr/Sonarr:

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

4. Add a download client to Radarr/Sonarr:

   - Click the **Settings** menu item on the left, and then click the **Download Clients** link.

   - Under the **Download Clients** section, click the **+** button to add a new download client.

   - Under **Torrents**, click **qBittorrent**.

   - In the **Add Download Client - qBittorrent** form:

     - Host: The address of the qBittorrent server i.e. `localhost` (if `qbt.enabled: true`) or the address of the external qBittorrent server.

     - Port: The port of the qBittorrent server i.e. `8080`.

     - Username: Fill in the username you set for qBittorrent.

     - Password: Fill in the password you set for qBittorrent.

     - Remove Completed: `Enabled`.

     - Leave the rest of the fields as default.

     - Click the **Test** button to verify the settings and wait for a green checkmark indicating that the test was successful.

     - Click the **Save** button.

   - If you're using an external qBittorrent server and require path mapping, locate the **Remote Path Mappings** section in the **Download Clients** page:

     - Click the **+** button to add a new path mapping.

     - In the **Add Remote Path Mapping** form:

       - Host: Expand the dropdown and select the qBittorrent server.

       - Remote Path: Set the parent folder where your Movie media (Radarr) or TV media (Sonarr) is downloaded to on the qBittorrent server i.e. `/downloads/`.

       - Local Path: Set the path to the same parent folder where it is mounted on the Radarr/Sonarr container i.e. `/flex/Downloads/`.

       - Click the **Save** button.

5. Add a connection to Plex from Radarr/Sonarr:

   - Click the **Settings** menu item on the left, and then click the **Connect** link.

   - Under the **Connections** section, click the **+** button to add a new connection.

   - Under **Add Connection**, click **Plex Media Server**.

   - In the **Add Connection - Plex Media Server** form:

     - Host: `localhost`.

         > [!NOTE]  
         > If you are using an external Plex server, replace the value with the actual address to the Plex server.

     - Authenticate with Plex.tv: Click the corresponding button and log in with your Plex account.

     - Click the **Test** button to verify the settings and wait for a green checkmark indicating that the test was successful.

     - If you're using an external Plex server and require path mapping:

       - Map Paths From: Add the path to the parent folder where your Movie media (Radarr) and TV media (Sonarr) are stored on Flex i.e. `/flex/Media`.

       - Map Paths To: Add the path to the parent folder where your Movie media (Radarr) and TV media (Sonarr) are stored on the external Plex server i.e. `/data`.

     - Click the **Save** button.

6. Configure the media management settings on Radarr/Sonarr:

   - Click the **Settings** menu item on the left, and then click the **Media Management** link.

   - Under the **Importing** section:

     - Import Extra Files: Toggle the corresponding checkbox to enable it.

     - Import Extra Files: Add a comma-separated list of file extensions you wish to include in the import i.e. `srt`.

   - Click the **Add Root Folder** button to add a folder.

   - In the **File Browser** form, locate and select the folder where your Movie media (Radarr) (i.e. `/data/Movies` or `/flex/Media/Movies`) or TV media (Sonarr) (i.e. `/data/TV` or `/flex/Media/TV`) is stored (same as the one used for Plex), and click the **Ok** button.

   - Under the **Movie Naming** (Radarr) or **Episode Naming** (Sonarr) section, set the **Rename Movies/Episodes** option to `Enabled`.

   - Click the **Save Changes** button.

7. Configure quality profiles on Radarr/Sonarr:

   - Click the **Settings** menu item on the left, and then click the **Profiles** link.

   - Under the **Quality Profiles** section, delete any profiles you may not want i.e. `Any`, `HD - 720p/1080p`, `HD-720p`, `SD`, and `Ultra-HD` by opening said profile and clicking the **Delete** button.

      > [!TIP]  
      > You may also configure any existing profiles or add new ones to better suit your preferences, make sure to click the **Save** button after making any changes.

8. Create a backup of the Radarr/Sonarr configuration:

   - Click the **System** menu item on the left, and then click the **Backup** link.

   - In the **Backup** page, click the **Backup Now** button.

   - Wait for the backup to be created, then click the name (link) of the newly created backup file to download it.

   - Store the backup file in a safe location.

9. Add a Movie (Radarr) or TV series (Sonarr) for download (i.e. using qBittorrent) and streaming (i.e. using Plex):

   - Click the **Movies** (Radarr) or **Series** (Sonarr) menu item on the left, and then click the **Add New** link.

   - In the provided search bar, search for a Movie (Radarr) or TV series (Sonarr) you wish to download and add to Plex, and select it from the search results.

   - In the show's details modal, leave the form as default or configure accordingly, and click the **Add Movie/{Show Name}** button.

      > [!TIP]  
      > If you'd like it to start searching and downloading, click the **Start search for missing movie/episodes** button in the form.

   - **Alternatively**, the recommended method of adding Movies (Radarr) or TV series (Sonarr) is to use [Overseerr](#overseerr) to request them.

---

## Chart configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| bazarr.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Bazarr container. Items: `.mountPath`, `.subPath`, `.config`. |
| bazarr.dataStorage | string | `""` | The amount of persistent storage allocated for the Bazarr data storage. |
| bazarr.domain | string | `""` | The ingress domain name that hosts the Bazarr server. |
| bazarr.enabled | bool | `true` | Specifies whether Bazarr should be deployed or excluded in case an external Bazarr server is used. |
| bazarr.ingress | bool | `false` | Specifies whether the Bazarr service should be served publicly using an Ingress. |
| flaresolverr.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the FlareSolverr container. Items: `.mountPath`, `.subPath`, `.config`. |
| flaresolverr.enabled | bool | `true` | Specifies whether FlareSolverr should be deployed or excluded in case an external FlareSolverr server is used. |
| flaresolverr.logHtml | string | `""` | Specifies whether to log all HTML that passes through the proxy. Default: `"false"`. |
| flaresolverr.logLevel | string | `""` | The verbosity level of the FlareSolverr logs. Default: `"info"`. |
| flaresolverr.timezone | string | `""` | The timezone used in the FlareSolverr logs and web browser. Default: `"UTC"`. |
| global.gid | string | `""` | The group ID used to run the Flex containers. Default: `"1000"`. |
| global.uid | string | `""` | The user ID used to run the Flex containers. Default: `"1000"`. |
| image.bazarr.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Bazarr container image. Default: `"IfNotPresent"`. |
| image.bazarr.registry | string | `""` | The registry where the Bazarr container image is hosted. Default: `"lscr.io"`. |
| image.bazarr.repository | string | `""` | The name of the repository that contains the Bazarr container image used. Default: `"linuxserver/bazarr"`. |
| image.bazarr.tag | string | `""` | The tag that specifies the version of the Bazarr container image used. Default: `"v1.4.2-ls239"`. |
| image.flaresolverr.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the FlareSolverr container image. Default: `"IfNotPresent"`. |
| image.flaresolverr.registry | string | `""` | The registry where the FlareSolverr container image is hosted. Default: `"ghcr.io"`. |
| image.flaresolverr.repository | string | `""` | The name of the repository that contains the FlareSolverr container image used. Default: `"flaresolverr/flaresolverr"`. |
| image.flaresolverr.tag | string | `""` | The tag that specifies the version of the FlareSolverr container image used. Default: `"v3.3.13"`. |
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
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Flex services. |
| jackett.autoUpdate | string | `""` | Specifies whether to allow Jackett to automatically update itself inside the container. Default: `"true"`. |
| jackett.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Jackett container. Items: `.mountPath`, `.subPath`, `.config`. |
| jackett.dataStorage | string | `""` | The amount of persistent storage allocated for the Jackett data storage. |
| jackett.domain | string | `""` | The ingress domain name that hosts the Jackett server. |
| jackett.ingress | bool | `false` | Specifies whether the Jackett service should be served publicly using an Ingress. |
| overseerr.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Overseerr container. Items: `.mountPath`, `.subPath`, `.config`. |
| overseerr.dataStorage | string | `""` | The amount of persistent storage allocated for the Overseerr data storage. |
| overseerr.domain | string | `""` | The ingress domain name that hosts the Overseerr server. |
| overseerr.ingress | bool | `false` | Specifies whether the Overseerr service should be served publicly using an Ingress. |
| plex.claim | string | `""` | The secret claim token used to claim ownership of the Plex server. Get it from https://www.plex.tv/claim. |
| plex.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Plex container. Items: `.mountPath`, `.subPath`, `.config`. |
| plex.dataStorage | string | `""` | The amount of persistent storage allocated for the Plex data storage. |
| plex.domain | string | `""` | The ingress domain name that hosts the Plex server. |
| plex.enabled | bool | `true` | Specifies whether Plex should be deployed or excluded in case an external Plex server is used. |
| plex.ingress | bool | `false` | Specifies whether the Plex service should be served publicly using an Ingress. |
| qbt.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the qBittorrent container. Items: `.mountPath`, `.subPath`, `.config`. |
| qbt.dataStorage | string | `""` | The amount of persistent storage allocated for the qBittorrent data storage. |
| qbt.domain | string | `""` | The ingress domain name that hosts the qBittorrent server. |
| qbt.enabled | bool | `true` | Specifies whether qBittorrent should be deployed or excluded in case an external qBittorrent server is used. |
| qbt.ingress | bool | `false` | Specifies whether the qBittorrent service should be served publicly using an Ingress. |
| radarr.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Radarr container. Items: `.mountPath`, `.subPath`, `.config`. |
| radarr.dataStorage | string | `""` | The amount of persistent storage allocated for the Radarr data storage. |
| radarr.domain | string | `""` | The ingress domain name that hosts the Radarr server. |
| radarr.ingress | bool | `false` | Specifies whether the Radarr service should be served publicly using an Ingress. |
| replicaCount | string | `""` | The desired number of running replicas for Flex. Default: `"1"`. |
| resources.bazarr | object | `{}` | Bazarr container resources. |
| resources.flaresolverr | object | `{}` | FlareSolverr container resources. |
| resources.jackett | object | `{}` | Jackett container resources. |
| resources.overseerr | object | `{}` | Overseerr container resources. |
| resources.plex | object | `{}` | Plex container resources. |
| resources.qbt | object | `{}` | qBittorrent container resources. |
| resources.radarr | object | `{}` | Radarr container resources. |
| resources.sonarr | object | `{}` | Sonarr container resources. |
| service.bazarr.nodePort | string | `""` | The optional node port to expose for Bazarr when the service type is NodePort. |
| service.bazarr.port | string | `""` | The Bazarr port on which the Bazarr server should listen for connections. Default: `"6767"`. |
| service.flaresolverr.nodePort | string | `""` | The optional node port to expose for FlareSolverr when the service type is NodePort. |
| service.flaresolverr.port | string | `""` | The FlareSolverr port on which the FlareSolverr server should listen for connections. Default: `"8191"`. |
| service.jackett.nodePort | string | `""` | The optional node port to expose for Jackett when the service type is NodePort. |
| service.jackett.port | string | `""` | The Jackett port on which the Jackett server should listen for connections. Default: `"9117"`. |
| service.overseerr.nodePort | string | `""` | The optional node port to expose for Overseerr when the service type is NodePort. |
| service.overseerr.port | string | `""` | The Overseerr port on which the Overseerr server should listen for connections. Default: `"5055"`. |
| service.plex.nodePort | string | `""` | The optional node port to expose for Plex when the service type is NodePort. |
| service.plex.port | string | `""` | The Plex port on which the Plex server should listen for connections. Default: `"32400"`. |
| service.qbt.nodePort | string | `""` | The optional node port to expose for qBittorrent when the service type is NodePort. |
| service.qbt.port | string | `""` | The qBittorrent port on which the qBittorrent server should listen for connections. Default: `"8080"`. |
| service.radarr.nodePort | string | `""` | The optional node port to expose for Radarr when the service type is NodePort. |
| service.radarr.port | string | `""` | The Radarr port on which the Radarr server should listen for connections. Default: `"7878"`. |
| service.sonarr.nodePort | string | `""` | The optional node port to expose for Sonarr when the service type is NodePort. |
| service.sonarr.port | string | `""` | The Sonarr port on which the Sonarr server should listen for connections. Default: `"8989"`. |
| service.type | string | `""` | The type of service used to expose Flex services. Default: `"ClusterIP"`. |
| smb.accessMode | string | `""` | The access mode defining how the SMB share storage can be mounted. Default: `"ReadWriteMany"`. |
| smb.enabled | bool | `false` | Specifies whether to enable persistent storage to be provisioned in the form of an SMB share. |
| smb.mountOptions | list | `[]` | The additional mount options used to mount the SMB share volume. |
| smb.pvStorage | string | `""` | The amount of persistent storage available on the SMB share volume. Default: `"100Gi"`. |
| smb.pvcStorage | string | `""` | The amount of persistent storage allocated for the SMB share storage. Default: `"1Gi"`. |
| smb.secretName | string | `""` | The name of the existing secret containing the credentials used to authenticate with the SMB share. Default: `"smbcreds"`. |
| smb.secretNamespace | string | `""` | The namespace where the secret containing the credentials used to authenticate with the SMB share is located. Default: `"default"`. |
| smb.share | string | `""` | The SMB share address and name to mount as a persistent volume. |
| smb.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the SMB share storage. Default: `"smb"`. |
| sonarr.customConfigs | list | `[]` | Optional custom configurations to be mounted as a file inside the Sonarr container. Items: `.mountPath`, `.subPath`, `.config`. |
| sonarr.dataStorage | string | `""` | The amount of persistent storage allocated for the Sonarr data storage. |
| sonarr.domain | string | `""` | The ingress domain name that hosts the Sonarr server. |
| sonarr.ingress | bool | `false` | Specifies whether the Sonarr service should be served publicly using an Ingress. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteOnce"`. |
| storage.data.enabled | bool | `true` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/config"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for each data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |
| storage.downloads.accessMode | string | `""` | The access mode defining how the downloads storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.downloads.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for downloads storage. |
| storage.downloads.mountPath | string | `""` | The path where the downloads storage should be mounted on the container. Default: `"/downloads"`. |
| storage.downloads.smb | bool | `false` | Specifies whether to use an SMB share for the downloads storage. |
| storage.downloads.storage | string | `""` | The amount of persistent storage allocated for the downloads storage. This setting is ignored if SMB is enabled for said storage. Default: `"1Gi"`. |
| storage.downloads.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the downloads storage. This setting is ignored if SMB is enabled for said storage. Default: `"longhorn"`. |
| storage.downloads.subPath | string | `""` | The subpath within the downloads storage to mount to the container. Leave empty if not required. |
| storage.global.accessMode | string | `""` | The access mode defining how the global storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.global.enabled | bool | `true` | Specifies whether persistent storage should be provisioned for global storage. This storage will override the downloads and media storage. |
| storage.global.mountPath | string | `""` | The path where the global storage should be mounted on the container. Default: `"/flex"`. |
| storage.global.smb | bool | `false` | Specifies whether to use an SMB share for the global storage. |
| storage.global.storage | string | `""` | The amount of persistent storage allocated for the global storage. This setting is ignored if SMB is enabled for said storage. Default: `"1Gi"`. |
| storage.global.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the global storage. This setting is ignored if SMB is enabled for said storage. Default: `"longhorn"`. |
| storage.global.subPath | string | `""` | The subpath within the global storage to mount to the container. Leave empty if not required. |
| storage.media.accessMode | string | `""` | The access mode defining how the media storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.media.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for media storage. |
| storage.media.mountPath | string | `""` | The path where the media storage should be mounted on the container. Default: `"/data"`. |
| storage.media.smb | bool | `false` | Specifies whether to use an SMB share for the media storage. |
| storage.media.storage | string | `""` | The amount of persistent storage allocated for the media storage. This setting is ignored if SMB is enabled for said storage. Default: `"1Gi"`. |
| storage.media.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the media storage. This setting is ignored if SMB is enabled for said storage. Default: `"longhorn"`. |
| storage.media.subPath | string | `""` | The subpath within the media storage to mount to the container. Leave empty if not required. |
