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

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.postgres.pullPolicy | string | `"IfNotPresent"` | Postgres image pull policy |
| image.postgres.registry | string | `"docker.io"` | Postgres image registry |
| image.postgres.repository | string | `"postgres"` | Postgres image repository |
| image.postgres.tag | string | `""` | Postgres image version |
| postgres.name | string | `"default"` | Default database name |
| postgres.pass | string | `""` | Root postgres password |
| postgres.user | string | `"root"` | Root postgres user |
| pvc.data.storage | string | `"1Gi"` | Data storage size |
| pvc.data.storageClassName | string | `"longhorn"` | Data storage class name |
| resources.limits.cpu | string | `"250m"` | Maximum cpu allocation |
| resources.limits.memory | string | `"250Mi"` | Maximum memory allocation |
| resources.requests.cpu | string | `"10m"` | Minimum cpu allocation |
| resources.requests.memory | string | `"10Mi"` | Minimum memory allocation |
