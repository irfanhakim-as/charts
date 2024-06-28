# Postgres-Agent

Easily create or delete a database and user pair in a remote PostgreSQL instance.

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

1. Get the values file of the Postgres-Agent chart or an existing installation (release).

    Get the latest Postgres-Agent chart values file for a new installation:

    ```sh
    helm show values mika/postgres-agent > values.yaml
    ```

    Alternatively, get the values file of an existing Postgres-Agent release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Postgres-Agent values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Postgres-Agent or upgrade an existing Postgres-Agent release:

    ```sh
    helm upgrade --install ${releaseName} mika/postgres-agent --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Postgres-Agent release has been installed:

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
| image.postgres.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the PostgreSQL container image. Default: `"IfNotPresent"`. |
| image.postgres.registry | string | `""` | The registry where the PostgreSQL container image is hosted. Default: `"docker.io"`. |
| image.postgres.repository | string | `""` | The name of the repository that contains the PostgreSQL container image used. Default: `"bitnami/postgresql"`. |
| image.postgres.tag | string | `""` | The tag that specifies the version of the PostgreSQL container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| postgres.databases | list | `[]` | Database configurations array. Elements: `.name`, `.user`, `.password`, `.create`, `.drop`, `.custom`, `.custom_command`. |
| postgres.host | string | `""` | The hostname or IP address of the PostgreSQL database server. |
| postgres.root.password | string | `""` | The password associated with the PostgreSQL database server root user. |
| postgres.root.user | string | `""` | The username or user account for accessing the PostgreSQL database server as root. Default: `"postgres"`. |
| resources.postgres | object | `{}` | PostgreSQL container resources. |