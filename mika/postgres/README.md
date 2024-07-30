# [PostgreSQL](https://github.com/postgres/postgres)

Easy tool to deploy a PostgreSQL instance on Kubernetes.

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

1. Get the values file of the PostgreSQL chart or an existing installation (release).

    Get the latest PostgreSQL chart values file for a new installation:

    ```sh
    helm show values mika/postgres > values.yaml
    ```

    Alternatively, get the values file of an existing PostgreSQL release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your PostgreSQL values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for PostgreSQL or upgrade an existing PostgreSQL release:

    ```sh
    helm upgrade --install ${releaseName} mika/postgres --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your PostgreSQL release has been installed:

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
| image.postgres.repository | string | `""` | The name of the repository that contains the PostgreSQL container image used. Default: `"postgres"`. |
| image.postgres.tag | string | `""` | The tag that specifies the version of the PostgreSQL container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting PostgreSQL services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| postgres.domain | string | `""` | The ingress domain name that hosts the PostgreSQL server. |
| postgres.name | string | `""` | The name of the default database of the root PostgreSQL database user. Default: `"default"`. |
| postgres.password | string | `""` | The password associated with the root PostgreSQL database user. |
| postgres.user | string | `""` | The root username or user account of the PostgreSQL database server. Default: `"root"`. |
| replicaCount | string | `""` | The desired number of running replicas for PostgreSQL. Default: `"1"`. |
| resources.postgres | object | `{}` | PostgreSQL container resources. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the PostgreSQL server should listen for connections. Default: `"5432"`. |
| service.type | string | `""` | The type of service used to expose PostgreSQL services. Default: `"ClusterIP"`. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/var/lib/postgresql/data"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |