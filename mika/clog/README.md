# `clog`

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Preflight checklist

### Create image pull secret

Replace `$github-username`, `$github-pass`, `$github-email` and `$namespace` accordingly.

```sh
kubectl create secret docker-registry ghcr-token-secret --docker-server=https://ghcr.io --docker-username="$github-username" --docker-password="$github-pass" --docker-email="$github-email" -n $namespace
```

### Generate secret key for [`clog.secret`](values.yaml)

```sh
python -c 'import random; print("".join([random.choice("abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)") for i in range(50)]))'
```

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

### Create database

Deploy [`mika/postgres-agent`](../postgres-agent/) with `postgres.mode.create` set to `true`. This step can be skipped if you have an existing PostgreSQL database.

### Prepare chart values

Copy `values.yaml` from the chart you would like to install.

```sh
cp mika/clog/values.yaml .
```

Edit `values.yaml` with the appropriate values. Refer to the [Configurations](#Configurations) section for available options.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/clog --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/clog --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

### Delete database

Deploy [`mika/postgres-agent`](../postgres-agent/) with `postgres.mode.drop` set to `true`.

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clog.cloudflared.domain | string | `""` | Registered domain name on Cloudflare used for Clog. |
| clog.cloudflared.enabled | bool | `false` | Specifies whether Clog should run using a Cloudflare tunnel. |
| clog.debug | string | `""` | Specifies whether Clog should run in debug mode. Default: `false`. |
| clog.name | string | `""` | The name of the Clog service. Default: `"Clog"`. |
| clog.ngrok.enabled | bool | `false` | Specifies whether Clog should run using an Ngrok tunnel. |
| clog.ngrok.token | string | `""` | Ngrok authentication token. |
| clog.persistence.enabled | bool | `false` | Specifies whether Clog should persist its storage. |
| clog.persistence.logs.storage | string | `""` | The amount of persistent storage allocated for Clog logs. Default: `"50Mi"`. |
| clog.persistence.media.storage | string | `""` | The amount of persistent storage allocated for Clog media files. Default: `"100Mi"`. |
| clog.persistence.migrations.storage | string | `""` | The amount of persistent storage allocated for Clog migration files. Default: `"20Mi"`. |
| clog.persistence.static.storage | string | `""` | The amount of persistent storage allocated for Clog static files. Default: `"50Mi"`. |
| clog.persistence.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the Clog storage. Default: `"longhorn"`. |
| clog.secret | string | `""` | A 50-character secret key used for secure session management and cryptographic operations within the Clog service. |
| db.host | string | `""` | The hostname or IP address of the Clog database server. |
| db.name | string | `""` | The name of the database used by Clog. |
| db.password | string | `""` | The password associated with the Clog database's user. |
| db.port | string | `""` | The port number on which the Clog database server is listening. Default: `"5432"`. |
| db.type | string | `""` | The type of the database used by Clog. Default: `"postgresql"`. |
| db.user | string | `""` | The username or user account for accessing the Clog database. |
| image.clog.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Clog container image. Default: `"IfNotPresent"`. |
| image.clog.registry | string | `""` | The registry where the Clog container image is hosted. Default: `"ghcr.io"`. |
| image.clog.repository | string | `""` | The name of the repository that contains the Clog container image used. Default: `"irfanhakim-as/clog"`. |
| image.clog.tag | string | `""` | The tag that specifies the version of the Clog container image used. Default: `"Chart appVersion"`. |
| image.ngrok.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Ngrok container image. Default: `"IfNotPresent"`. |
| image.ngrok.registry | string | `""` | The registry where the Ngrok container image is hosted. Default: `"docker.io"`. |
| image.ngrok.repository | string | `""` | The name of the repository that contains the Ngrok container image used. Default: `"wernight/ngrok"`. |
| image.ngrok.tag | string | `""` | The tag that specifies the version of the Ngrok container image used. Default: `"latest"`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| replicaCount | string | `""` | The desired number of running replicas for Clog. Default: `"1"`. |
| resources.clog.limits.cpu | string | `"50m"` | The maximum amount of CPU resources allowed for Clog. |
| resources.clog.limits.memory | string | `"200Mi"` | The maximum amount of memory allowed for Clog. |
| resources.clog.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by Clog. |
| resources.clog.requests.memory | string | `"100Mi"` | The minimum amount of memory required by Clog. |
