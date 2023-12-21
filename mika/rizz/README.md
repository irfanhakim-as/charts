# [`rizz`](https://github.com/irfanhakim-as/rizz) 🔒

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Preflight checklist

### Create image pull secret

Replace `$github-username`, `$github-pass`, `$github-email` and `$namespace` accordingly.

```sh
kubectl create secret docker-registry ghcr-token-secret --docker-server=https://ghcr.io --docker-username="$github-username" --docker-password="$github-pass" --docker-email="$github-email" -n $namespace
```

### Generate secret key for `rizz.secret`

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

### Prepare chart values

Copy `values.yaml` from the chart you would like to install.

```sh
cp mika/rizz/values.yaml .
```

Edit `values.yaml` with the appropriate values. Refer to the [Configurations](#Configurations) section for available options.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/rizz --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/rizz --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| db.host | string | `""` | The hostname or IP address of the Rizz database server. |
| db.name | string | `""` | The name of the database used by Rizz. |
| db.password | string | `""` | The password associated with the Rizz database's user. |
| db.port | string | `""` | The port number on which the Rizz database server is listening. Default: `"5432"`. |
| db.type | string | `""` | The type of the database used by Rizz. Default: `"postgresql"`. |
| db.user | string | `""` | The username or user account for accessing the Rizz database. |
| image.redis.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Redis container image. Default: `"IfNotPresent"`. |
| image.redis.registry | string | `""` | The registry where the Redis container image is hosted. Default: `"docker.io"`. |
| image.redis.repository | string | `""` | The name of the repository that contains the Redis container image used. Default: `"redis"`. |
| image.redis.tag | string | `""` | The tag that specifies the version of the Redis container image used. Default: `"alpine"`. |
| image.rizz.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Rizz container image. Default: `"IfNotPresent"`. |
| image.rizz.registry | string | `""` | The registry where the Rizz container image is hosted. Default: `"ghcr.io"`. |
| image.rizz.repository | string | `""` | The name of the repository that contains the Rizz container image used. Default: `"irfanhakim-as/rizz"`. |
| image.rizz.tag | string | `""` | The tag that specifies the version of the Rizz container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| replicaCount | string | `""` | The desired number of running replicas for Rizz. Default: `"1"`. |
| resources.scheduler.limits.cpu | string | `"20m"` | The maximum amount of CPU resources allowed for Scheduler. |
| resources.scheduler.limits.memory | string | `"200Mi"` | The maximum amount of memory allowed for Scheduler. |
| resources.scheduler.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by Scheduler. |
| resources.scheduler.requests.memory | string | `"100Mi"` | The minimum amount of memory required by Scheduler. |
| resources.rizz.limits.cpu | string | `"50m"` | The maximum amount of CPU resources allowed for Rizz. |
| resources.rizz.limits.memory | string | `"120Mi"` | The maximum amount of memory allowed for Rizz. |
| resources.rizz.requests.cpu | string | `"30m"` | The minimum amount of CPU resources required by Rizz. |
| resources.rizz.requests.memory | string | `"60Mi"` | The minimum amount of memory required by Rizz. |
| rizz.debug | bool | `false` | Specifies whether Rizz should run in debug mode. Default: `false`. |
| rizz.domain | string | `""` | The domain name of the Rizz service. Default: `"localhost"`. |
| rizz.mastodon.api | string | `""` | API endpoint or URL for the Mastodon instance of the Rizz bot. |
| rizz.mastodon.bot | string | `""` | The username or user account for the Mastodon instance of the Rizz bot. |
| rizz.mastodon.token | string | `""` | A secure token required to authenticate the Rizz service with the Mastodon instance's API. |
| rizz.organic | bool | `true` | Specifies whether to enable posting in organic numbers. Default: `true`. |
| rizz.persistence.enabled | bool | `false` | Specifies whether Rizz should persist its storage. |
| rizz.persistence.logs.storage | string | `""` | The amount of persistent storage allocated for Rizz logs. Default: `"20Mi"`. |
| rizz.persistence.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the Rizz storage. Default: `"longhorn"`. |
| rizz.rss.feed | string | `""` | The URL of the RSS feed to be tracked by Rizz. |
| rizz.rss.post_limit | string | `""` | The limit number of posts to be scheduled for posting by Rizz per run. Default: `"3"`. |
| rizz.rss.pubdate_format | string | `""` | The publishing date format of the RSS feed entry. Default: `"%a, %d %b %Y %H:%M:%S %z"`. |
| rizz.scheduler.apscheduler | bool | `true` | Specifies whether APScheduler should be used by Rizz as the task scheduler. |
| rizz.scheduler.celery | bool | `false` | Specifies whether Celery should be used by Rizz as the task scheduler. |
| rizz.scheduler.schedule.clean_data | string | `""` | The hours at which the task scheduler cleans up the database. Default: `"0"`. |
| rizz.scheduler.schedule.post_scheduler | string | `""` | The hours at which the task scheduler posts scheduled posts. Default: `"8-23/3"`. |
| rizz.scheduler.schedule.update_data | string | `""` | The hours at which the task scheduler updates the database. Default: `"7-22/3"`. |
| rizz.scheduler.timezone | string | `""` | The timezone for the task scheduler used by Rizz to schedule time-dependent operations. Default: `"Asia/Kuala_Lumpur"`. |
| rizz.secret | string | `""` | A 50-character secret key used for secure session management and cryptographic operations within the Rizz service. |
| rizz.visibility | string | `""` | The default visibility of posts made by the Rizz service. Default: `"public"`. |
