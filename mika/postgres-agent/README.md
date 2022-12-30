# `postgres-agent`

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Preflight checklist

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

### Prepare PostgreSQL host

Install [`mika/postgres`](../postgres/). This step can be skipped if you have an existing PostgreSQL server.

### Prepare chart values

Copy `values.yaml` from the chart you would like to install. Refer to the [Configuration](#configuration) section for more information.

```sh
cp mika/postgres-agent/values.yaml .
```

Edit `values.yaml` with the appropriate values.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/postgres-agent --namespace $namespace --create-namespace --values values.yaml --wait
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
| postgres.host | string | `"postgres.default.svc.cluster.local"` | Postgres server |
| postgres.mode.create | bool | `true` | Enable create database and user mode |
| postgres.mode.drop | bool | `false` | Enable drop database mode |
| postgres.name | string | `""` | Database name |
| postgres.pass | string | `""` | Database user password. Only required in create mode. |
| postgres.root | string | `""` | Database root user |
| postgres.root_pass | string | `""` | Database root user password |
| postgres.user | string | `""` | Database user. Only required in create mode. |
