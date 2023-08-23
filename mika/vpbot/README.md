# [`vpbot`](https://github.com/irfanhakim-as/vpbot) 🔒

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

Deploy [`mika/postgres-agent`](../postgres-agent/) with `postgres.mode.create` set to `true`. This step can be skipped if you have an existing PostgreSQL database.

### Prepare chart values

Copy `values.yaml` from the chart you would like to install.

```sh
cp mika/vpbot/values.yaml .
```

Edit `values.yaml` with the appropriate values. Refer to the [Configurations](#Configurations) section for available options.

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

### Add custom files

To implement additional Telegram commands, create a custom `commands.py` file with a `Commands` class inheriting from `lib.telegram.BaseCommand`. Refer to `/base/lib/commands.py` from the container for more information.

To add additional Telegram messages, create a custom `messages.py` file with both `MESSAGES` and `ICONS` dict. Refer to `/base/lib/messages.py` from the container for more information.

Upgrade (or install) the chart while adding the `commands.py` and `messages.py files with the `--set-file` flag.

```sh
helm upgrade --install $release_name mika/vpbot \
--namespace $namespace \
--values values.yaml \
--set-file vpbot.commands=commands.py \
--set-file vpbot.messages=messages.py \
--wait
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
| image.vpbot.tag | string | `""` | The tag that specifies the version of the Vpbot container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| replicaCount | string | `""` | The desired number of running replicas for Vpbot. Default: `"1"`. |
| resources.ngrok.limits.cpu | string | `"20m"` | The maximum amount of CPU resources allowed for Ngrok. |
| resources.ngrok.limits.memory | string | `"50Mi"` | The maximum amount of memory allowed for Ngrok. |
| resources.ngrok.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by Ngrok. |
| resources.ngrok.requests.memory | string | `"20Mi"` | The minimum amount of memory required by Ngrok. |
| resources.scheduler.limits.cpu | string | `"20m"` | The maximum amount of CPU resources allowed for Scheduler. |
| resources.scheduler.limits.memory | string | `"200Mi"` | The maximum amount of memory allowed for Scheduler. |
| resources.scheduler.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by Scheduler. |
| resources.scheduler.requests.memory | string | `"100Mi"` | The minimum amount of memory required by Scheduler. |
| resources.vpbot.limits.cpu | string | `"200m"` | The maximum amount of CPU resources allowed for Vpbot. |
| resources.vpbot.limits.memory | string | `"500Mi"` | The maximum amount of memory allowed for Vpbot. |
| resources.vpbot.requests.cpu | string | `"50m"` | The minimum amount of CPU resources required by Vpbot. |
| resources.vpbot.requests.memory | string | `"300Mi"` | The minimum amount of memory required by Vpbot. |
| vpbot.cloudflared.domain | string | `""` | Registered domain name on Cloudflare used for Vpbot. |
| vpbot.cloudflared.enabled | bool | `false` | Specifies whether Vpbot should run using a Cloudflare tunnel. |
| vpbot.commands | file | `""` | Custom Telegram `commands.py` file for Vpbot. |
| vpbot.debug | string | `""` | Specifies whether Vpbot should run in debug mode. Default: `false`. |
| vpbot.messages | file | `""` | Custom Telegram `messages.py` file for Vpbot. |
| vpbot.name | string | `""` | The name of the Vpbot service. Default: `"Vpbot"`. |
| vpbot.ngrok.enabled | bool | `false` | Specifies whether Vpbot should run using an Ngrok tunnel. |
| vpbot.ngrok.token | string | `""` | Ngrok authentication token. |
| vpbot.persistence.enabled | bool | `false` | Specifies whether Vpbot should persist its logs. |
| vpbot.persistence.storage | string | `""` | The amount of persistent storage allocated for Vpbot logs. Default: `"10Mi"`. |
| vpbot.persistence.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the Vpbot logs storage. Default: `"longhorn"`. |
| vpbot.scheduler.apscheduler | bool | `true` | Specifies whether APScheduler should be used by Vpbot as the task scheduler. |
| vpbot.scheduler.celery | bool | `false` | Specifies whether Celery should be used by Vpbot as the task scheduler. |
| vpbot.scheduler.schedule.clean_model | string | `""` | The hours at which the task scheduler cleans up the database. Default: `"0"`. |
| vpbot.scheduler.schedule.object_scheduler | string | `""` | The second intervals at which the task scheduler sends scheduled messages. Default: `"2"`. |
| vpbot.scheduler.timezone | string | `""` | The timezone for the task scheduler used by Vpbot to schedule time-dependent operations. Default: `"Asia/Kuala_Lumpur"`. |
| vpbot.secret | string | `""` | A 50-character secret key used for secure session management and cryptographic operations within the Vpbot service. |
| vpbot.telegram.api | string | `""` | API endpoint or URL for the Telegram bot. Default: `"https://api.telegram.org/bot"`. |
| vpbot.telegram.token | string | `""` | The Telegram bot token used by Vpbot to communicate with Telegram. |
| vpbot.telegram.webhook | string | `""` | The Telegram bot webhook path used by Vpbot to communicate with Telegram. Must contain a trailing slash. Default: `"webhook/telegram/"`. |
