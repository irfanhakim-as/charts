# `postgres`

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## How to add repo

Add the repo to your local helm client.

```sh
helm repo add mika https://irfanhakim-as.github.io/charts
```

Update the repo to retrieve the latest versions of the packages.

```sh
helm repo update
```

## How to install

### Prepare chart values

Copy `values.yaml` from the chart you would like to install.

```sh
cp mika/postgres/values.yaml .
```

Edit `values.yaml` with the appropriate values. Please refer to the [Configuration](#configuration) section below for more details.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/postgres --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/postgres --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the PostgreSQL container image. Default: `"IfNotPresent"`. |
| image.registry | string | `""` | The registry where the PostgreSQL container image is hosted. Default: `"docker.io"`. |
| image.repository | string | `""` | The name of the repository that contains the PostgreSQL container image used. Default: `"postgres"`. |
| image.tag | string | `""` | The tag that specifies the version of the PostgreSQL container image used. Default: `Chart appVersion`. |
| postgres.data.storage | string | `"1Gi"` | The amount of persistent storage allocated for the PostgreSQL instance. Default: `"1Gi"`. |
| postgres.data.storageClassName | string | `"longhorn"` | The storage class name used for dynamically provisioning a persistent volume for the PostgreSQL storage. Default: `"longhorn"`. |
| postgres.name | string | `""` | The name of the default PostgreSQL database. Default: `"default"`. |
| postgres.pass | string | `""` | The password for accessing the PostgreSQL instance. |
| postgres.user | string | `""` | The username for accessing the PostgreSQL instance. Default: `"root"`. |
| replicaCount | int | `""` | The desired number of running replicas for PostgreSQL. Default: `"1"`. |
| resources.limits.cpu | string | `"250m"` | The maximum amount of CPU resources allowed for PostgreSQL. |
| resources.limits.memory | string | `"250Mi"` | The maximum amount of memory allowed for PostgreSQL. |
| resources.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by PostgreSQL. |
| resources.requests.memory | string | `"10Mi"` | The minimum amount of memory required by PostgreSQL. |
