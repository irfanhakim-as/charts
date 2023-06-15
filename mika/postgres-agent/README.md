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

Copy `values.yaml` from the chart you would like to install. Refer to the [Configurations](#configurations) section for more information.

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

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/postgres-agent --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.postgres.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the PostgreSQL container image. Default: `"IfNotPresent"`. |
| image.postgres.registry | string | `""` | The registry where the PostgreSQL container image is hosted. Default: `"docker.io"`. |
| image.postgres.repository | string | `""` | The name of the repository that contains the PostgreSQL container image used. Default: `"postgres"`. |
| image.postgres.tag | string | `""` | The tag that specifies the version of the PostgreSQL container image used. Default: `Chart appVersion`. |
| postgres.host | string | `""` | The hostname or IP address of the PostgreSQL database server. |
| postgres.mode.create | bool | `true` | Specifies whether to create a database and user in a remote PostgreSQL instance. |
| postgres.mode.drop | bool | `false` | Specifies whether to delete a database in a remote PostgreSQL instance. |
| postgres.name | string | `""` | The name of the intended PostgreSQL database. |
| postgres.password | string | `""` | The password associated with the intended PostgreSQL database user. |
| postgres.root.password | string | `""` | The password associated with the PostgreSQL database server root user. |
| postgres.root.user | string | `""` | The username or user account for accessing the PostgreSQL database server as root. Default: `"root"`. |
| postgres.user | string | `""` | The username or user account for accessing the intended PostgreSQL database. |
