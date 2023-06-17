# [`vpbot`](https://github.com/irfanhakim-as/quarantine-bot)

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Preflight checklist

### Create image pull secret

Replace `$github-username`, `$github-pass`, `$github-email` and `$namespace` accordingly.

```sh
kubectl create secret docker-registry ghcr-token-secret --docker-server=https://ghcr.io --docker-username="$github-username" --docker-password="$github-pass" --docker-email="$github-email" -n $namespace
```

### Generate secret key for [`vpbot.secret`](values.yaml)

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

Install [`mika/postgres-createdb`](../postgres-createdb/). This step can be skipped if you have an existing PostgreSQL database.

### Prepare chart values

Copy `values.yaml` from the chart you would like to install.

```sh
cp mika/vpbot/values.yaml .
```

Edit `values.yaml` with the appropriate values. Refer to the [Configurations](#Configurations) section for the available options.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/vpbot --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/vpbot --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

### Delete database

Install [`mika/postgres-dropdb`](../postgres-dropdb/).

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| db.host | string | `""` | The hostname or IP address of the Vpbot database server. |
| db.name | string | `""` | The name of the database used by Vpbot. |
| db.password | string | `""` | The password associated with the Vpbot database's user. |
| db.port | string | `""` | The port number on which the Vpbot database server is listening. Default: `"5432"`. |
| db.type | string | `""` | The type of the database used by Vpbot. Default: `"postgresql"`. |
| db.user | string | `""` | The username or user account for accessing the Vpbot database. |
| image.ngrok.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Ngrok container image. Default: `"IfNotPresent"`. |
| image.ngrok.registry | string | `""` | The registry where the Ngrok container image is hosted. Default: `"docker.io"`. |
| image.ngrok.repository | string | `""` | The name of the repository that contains the Ngrok container image used. Default: `"wernight/ngrok"`. |
| image.ngrok.tag | string | `""` | The tag that specifies the version of the Ngrok container image used. Default: `"latest"`. |
| image.redis.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Redis container image. Default: `"IfNotPresent"`. |
| image.redis.registry | string | `""` | The registry where the Redis container image is hosted. Default: `"docker.io"`. |
| image.redis.repository | string | `""` | The name of the repository that contains the Redis container image used. Default: `"redis"`. |
| image.redis.tag | string | `""` | The tag that specifies the version of the Redis container image used. Default: `"alpine"`. |
| image.vpbot.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Vpbot container image. Default: `"IfNotPresent"`. |
| image.vpbot.registry | string | `""` | The registry where the Vpbot container image is hosted. Default: `"ghcr.io"`. |
| image.vpbot.repository | string | `""` | The name of the repository that contains the Vpbot container image used. Default: `"irfanhakim-as/vpbot"`. |
| image.vpbot.tag | string | `""` | The tag that specifies the version of the Vpbot container image used. Default: `"Chart appVersion"`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| replicaCount | string | `""` | The desired number of running replicas for Vpbot. Default: `"1"`. |
| resources.redis.limits.cpu | string | `"15m"` | The maximum amount of CPU resources allowed for Redis. |
| resources.redis.limits.memory | string | `"60Mi"` | The maximum amount of memory allowed for Redis. |
| resources.redis.requests.cpu | string | `"5m"` | The minimum amount of CPU resources required by Redis. |
| resources.redis.requests.memory | string | `"30Mi"` | The minimum amount of memory required by Redis. |
| resources.vpbot.limits.cpu | string | `"50m"` | The maximum amount of CPU resources allowed for Vpbot. |
| resources.vpbot.limits.memory | string | `"500Mi"` | The maximum amount of memory allowed for Vpbot. |
| resources.vpbot.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by Vpbot. |
| resources.vpbot.requests.memory | string | `"250Mi"` | The minimum amount of memory required by Vpbot. |
| telegram.admin_id | string | `""` | The unique Telegram chat ID of the Vpbot administrator. |
| telegram.devel_id | string | `""` | The unique Telegram chat ID of the Vpbot developer. |
| telegram.token | string | `""` | The Telegram bot token used by Vpbot to communicate with Telegram. |
| telegram.webhook | string | `""` | The Telegram bot webhook path used by Vpbot to communicate with Telegram. Default: `"telegram/webhooks/"`. |
| vpbot.celery_timezone | string | `""` | The timezone for the task scheduler used by Vpbot to schedule time-dependent operations. Default: `"Asia/Kuala_Lumpur"`. |
| vpbot.cloudflared.domain | string | `""` | Registered domain name on Cloudflare used for Vpbot. |
| vpbot.cloudflared.enabled | bool | `false` | Specifies whether Vpbot should run using a Cloudflare tunnel. |
| vpbot.debug | string | `""` | Specifies whether Vpbot should run in debug mode. Default: `false`. |
| vpbot.log_size_limit | string | `""` | The log file size limit in megabytes. Default: `"4"`. |
| vpbot.name | string | `""` | The name of the Vpbot service. Default: `"Vpbot"`. |
| vpbot.ngrok.enabled | bool | `false` | Specifies whether Vpbot should run using an Ngrok tunnel. |
| vpbot.ngrok.token | string | `""` | Ngrok authentication token. |
| vpbot.persistence.enabled | bool | `false` | Specifies whether Vpbot should persist its storage. |
| vpbot.persistence.logs.storage | string | `""` | The amount of persistent storage allocated for Vpbot logs. Default: `"50Mi"`. |
| vpbot.persistence.migrations.storage | string | `""` | The amount of persistent storage allocated for Vpbot migration files. Default: `"50Mi"`. |
| vpbot.persistence.static.storage | string | `""` | The amount of persistent storage allocated for Vpbot static files. Default: `"50Mi"`. |
| vpbot.persistence.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the Vpbot storage. Default: `"longhorn"`. |
| vpbot.secret | string | `""` | A 50-character secret key used for secure session management and cryptographic operations within the Vpbot service. |
| vpbot.user_pass | string | `""` | The default user password for users created by Vpbot. |
