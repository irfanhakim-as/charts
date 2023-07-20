# [`waktusolat`](https://github.com/irfanhakim-as/waktusolat) 🔒

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Preflight checklist

### Create image pull secret

Replace `$github-username`, `$github-pass`, `$github-email` and `$namespace` accordingly.

```sh
kubectl create secret docker-registry ghcr-token-secret --docker-server=https://ghcr.io --docker-username="$github-username" --docker-password="$github-pass" --docker-email="$github-email" -n $namespace
```

### Generate secret key for `waktusolat.secret`

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
cp mika/waktusolat/values.yaml .
```

Edit `values.yaml` with the appropriate values. Refer to the [Configurations](#Configurations) section for available options.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/waktusolat --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/waktusolat --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| db.host | string | `""` | The hostname or IP address of the WaktuSolat database server. |
| db.name | string | `""` | The name of the database used by WaktuSolat. |
| db.password | string | `""` | The password associated with the WaktuSolat database's user. |
| db.port | string | `""` | The port number on which the WaktuSolat database server is listening. Default: `"5432"`. |
| db.type | string | `""` | The type of the database used by WaktuSolat. Default: `"postgresql"`. |
| db.user | string | `""` | The username or user account for accessing the WaktuSolat database. |
| image.redis.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Redis container image. Default: `"alpine"`. |
| image.redis.registry | string | `""` | The registry where the Redis container image is hosted. Default: `"docker.io"`. |
| image.redis.repository | string | `""` | The name of the repository that contains the Redis container image used. Default: `"redis"`. |
| image.redis.tag | string | `""` | The tag that specifies the version of the Redis container image used. Default: `"alpine"`. |
| image.waktusolat.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the WaktuSolat container image. Default: `"IfNotPresent"`. |
| image.waktusolat.registry | string | `""` | The registry where the WaktuSolat container image is hosted. Default: `"ghcr.io"`. |
| image.waktusolat.repository | string | `""` | The name of the repository that contains the WaktuSolat container image used. Default: `"irfanhakim-as/waktusolat"`. |
| image.waktusolat.tag | string | `""` | The tag that specifies the version of the WaktuSolat container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| replicaCount | string | `""` | The desired number of running replicas for WaktuSolat. Default: `"1"`. |
| resources.scheduler.limits.cpu | string | `"20m"` | The maximum amount of CPU resources allowed for Scheduler. |
| resources.scheduler.limits.memory | string | `"200Mi"` | The maximum amount of memory allowed for Scheduler. |
| resources.scheduler.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by Scheduler. |
| resources.scheduler.requests.memory | string | `"100Mi"` | The minimum amount of memory required by Scheduler. |
| resources.waktusolat.limits.cpu | string | `"50m"` | The maximum amount of CPU resources allowed for WaktuSolat. |
| resources.waktusolat.limits.memory | string | `"120Mi"` | The maximum amount of memory allowed for WaktuSolat. |
| resources.waktusolat.requests.cpu | string | `"30m"` | The minimum amount of CPU resources required by WaktuSolat. |
| resources.waktusolat.requests.memory | string | `"60Mi"` | The minimum amount of memory required by WaktuSolat. |
| waktusolat.debug | bool | `false` | Specifies whether WaktuSolat should run in debug mode. Default: `false`. |
| waktusolat.domain | string | `""` | The domain name of the WaktuSolat service. Default: `"localhost"`. |
| waktusolat.location | string | `""` | The default location code used by WaktuSolat and its services. Default: `"wlp-0"`. |
| waktusolat.mastodon.api | string | `""` | API endpoint or URL for the Mastodon instance of the WaktuSolat bot. |
| waktusolat.mastodon.bot | string | `""` | The username or user account for the Mastodon instance of the WaktuSolat bot. |
| waktusolat.mastodon.token | string | `""` | A secure token required to authenticate the WaktuSolat service with the Mastodon instance's API. |
| waktusolat.persistence.enabled | bool | `false` | Specifies whether WaktuSolat should persist its storage. |
| waktusolat.persistence.logs.storage | string | `""` | The amount of persistent storage allocated for WaktuSolat logs. Default: `"20Mi"`. |
| waktusolat.persistence.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the WaktuSolat storage. Default: `"longhorn"`. |
| waktusolat.scheduler.apscheduler | bool | `true` | Specifies whether APScheduler should be used by WaktuSolat as the task scheduler. |
| waktusolat.scheduler.celery | bool | `false` | Specifies whether Celery should be used by WaktuSolat as the task scheduler. |
| waktusolat.scheduler.timezone | string | `""` | The timezone for the task scheduler used by WaktuSolat to schedule time-dependent operations. Default: `"Asia/Kuala_Lumpur"`. |
| waktusolat.secret | string | `""` | A 50-character secret key used for secure session management and cryptographic operations within the WaktuSolat service. |
