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

Edit `values.yaml` with the appropriate values. Refer to the [Configuration](#Configuration) section for the available options.

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

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

### Delete database

Install [`mika/postgres-dropdb`](../postgres-dropdb/).

## Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| db.host | string | `"postgres.default.svc.cluster.local"` | Database server |
| db.name | string | `""` | Database name |
| db.pass | string | `""` | Database user password |
| db.port | string | `"5432"` | Database port |
| db.type | string | `"postgresql"` | Database type |
| db.user | string | `""` | Database user |
| image.ngrok.pullPolicy | string | `"IfNotPresent"` | Ngrok image pull policy |
| image.ngrok.registry | string | `"docker.io"` | Ngrok image registry |
| image.ngrok.repository | string | `"wernight/ngrok"` | Ngrok image repository |
| image.ngrok.tag | string | `"latest"` | Ngrok image version |
| image.redis.pullPolicy | string | `"IfNotPresent"` | Redis image pull policy |
| image.redis.registry | string | `"docker.io"` | Redis image registry |
| image.redis.repository | string | `"redis"` | Redis image repository |
| image.redis.tag | string | `"alpine"` | Redis image version |
| image.vpbot.pullPolicy | string | `"IfNotPresent"` | Vpbot image pull policy |
| image.vpbot.registry | string | `"ghcr.io"` | Vpbot image registry |
| image.vpbot.repository | string | `"irfanhakim-as/quarantine-bot"` | Vpbot image repository |
| image.vpbot.tag | string | `""` | Vpbot image version |
| imagePullSecrets[0].name | string | `"ghcr-token-secret"` | Name of the image pull secret |
| pvc.logs.storage | string | `"50Mi"` | Logs storage size |
| pvc.logs.storageClassName | string | `"longhorn"` | Logs storage class name |
| pvc.migrations.storage | string | `"50Mi"` | Migrations storage size |
| pvc.migrations.storageClassName | string | `"longhorn"` | Migrations storage class name |
| pvc.static.storage | string | `"50Mi"` | Static files storage size |
| pvc.static.storageClassName | string | `"longhorn"` | Static files storage class name |
| resources.redis.limits.cpu | string | `"50m"` | Redis maximum CPU allocation |
| resources.redis.limits.memory | string | `"50Mi"` | Redis maximum memory allocation |
| resources.redis.requests.cpu | string | `"10m"` | Redis minimum CPU allocation |
| resources.redis.requests.memory | string | `"10Mi"` | Redis minimum memory allocation |
| resources.vpbot.limits.cpu | string | `"1"` | Vpbot maximum CPU allocation |
| resources.vpbot.limits.memory | string | `"1Gi"` | Vpbot maximum memory allocation |
| resources.vpbot.requests.cpu | string | `"10m"` | Vpbot minimum CPU allocation |
| resources.vpbot.requests.memory | string | `"10Mi"` | Vpbot minimum memory allocation |
| telegram.admin_id | string | `""` | Telegram admin Chat ID |
| telegram.devel_id | string | `""` | Telegram developer Chat ID |
| telegram.token | string | `""` | Telegram bot token |
| telegram.webhook | string | `"telegram/webhooks/"` | Telegram webhook path |
| vpbot.celery_timezone | string | `"Asia/Kuala_Lumpur"` | Background scheduler timezone |
| vpbot.cloudflared.domain | string | `""` | Vpbot domain |
| vpbot.cloudflared.enabled | bool | `true` | Enable cloudflare tunnel |
| vpbot.debug | bool | `false` | Enable debug mode |
| vpbot.log_size_limit | string | `"4"` | Individual log file size limit |
| vpbot.name | string | `"Vpbot"` | Application name |
| vpbot.ngrok.auth_token | string | `""` | Ngrok authentication token |
| vpbot.ngrok.enabled | bool | `false` | Enable ngrok tunnel |
| vpbot.secret | string | `""` | Vpbot secret key |
| vpbot.user_pass | string | `""` | Vpbot default user password |
