# [MariaDB-Agent](https://github.com/MariaDB/server)

Easily create or delete multiple pairs of databases and users in a remote MariaDB instance.

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

1. Get the values file of the MariaDB-Agent chart or an existing installation (release).

    Get the latest MariaDB-Agent chart values file for a new installation:

    ```sh
    helm show values mika/mariadb-agent > values.yaml
    ```

    Alternatively, get the values file of an existing MariaDB-Agent release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your MariaDB-Agent values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for MariaDB-Agent or upgrade an existing MariaDB-Agent release:

    ```sh
    helm upgrade --install ${releaseName} mika/mariadb-agent --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your MariaDB-Agent release has been installed:

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
| image.mariadb.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the MariaDB container image. Default: `"IfNotPresent"`. |
| image.mariadb.registry | string | `""` | The registry where the MariaDB container image is hosted. Default: `"docker.io"`. |
| image.mariadb.repository | string | `""` | The name of the repository that contains the MariaDB container image used. Default: `"bitnami/mariadb"`. |
| image.mariadb.tag | string | `""` | The tag that specifies the version of the MariaDB container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| mariadb.databases | list | `[]` | Database configurations array. Items: `.name`, `.user`, `.password`, `.create`, `.drop`, `.custom`, `.custom_command`. |
| mariadb.host | string | `""` | The hostname or IP address of the MariaDB database server. |
| mariadb.port | string | `""` | The port number the MariaDB database server is listening for connections. Default: `"3306"`. |
| mariadb.root.password | string | `""` | The password associated with the MariaDB database server root user. |
| mariadb.root.user | string | `""` | The username or user account for accessing the MariaDB database server as root. Default: `"root"`. |
| resources.mariadb | object | `{}` | MariaDB container resources. |
