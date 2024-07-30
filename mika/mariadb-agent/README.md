# [`mariadb-agent`](https://github.com/mariadb/mariadb)

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

### Prepare MariaDB host

Install [`bitnami/mariadb`](https://github.com/bitnami/charts/tree/main/bitnami/mariadb). This step can be skipped if you have an existing MariaDB server.

### Prepare chart values

Copy `values.yaml` from the chart you would like to install. Refer to the [Configurations](#configurations) section for more information.

```sh
cp mika/mariadb-agent/values.yaml .
```

Edit `values.yaml` with the appropriate values. Refer to the [Configurations](#Configurations) section for available options.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/mariadb-agent --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/mariadb-agent --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.mariadb.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the MariaDB container image. Default: `"IfNotPresent"`. |
| image.mariadb.registry | string | `""` | The registry where the MariaDB container image is hosted. Default: `"docker.io"`. |
| image.mariadb.repository | string | `""` | The name of the repository that contains the MariaDB container image used. Default: `"bitnami/mariadb"`. |
| image.mariadb.tag | string | `""` | The tag that specifies the version of the MariaDB container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| mariadb.databases | list | `[]` | Database configurations array. Elements: `.name`, `.user`, `.password`, `.create`, `.drop`, `.custom`, `.custom_command`. |
| mariadb.host | string | `""` | The hostname or IP address of the MariaDB database server. |
| mariadb.root.password | string | `""` | The password associated with the MariaDB database server root user. |
| mariadb.root.user | string | `""` | The username or user account for accessing the MariaDB database server as root. Default: `"root"`. |
