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
| db.name | string | `""` | The name of the database being used by WaktuSolat. |
| db.password | string | `""` | The password associated with the WaktuSolat database user. |
| db.port | string | `""` | The port number the WaktuSolat database server is listening for connections. Default: `"5432"`. |
| db.type | string | `""` | The database engine or backend being used by WaktuSolat. Default: `"postgresql"`. |
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
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting WaktuSolat services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| replicaCount | string | `""` | The desired number of running replicas for WaktuSolat. Default: `"1"`. |
| resources.scheduler | object | `{}` | WaktuSolat container resources. |
| resources.waktusolat | object | `{}` | Scheduler container resources. |
| scheduler.apscheduler | bool | `true` | Specifies whether APScheduler should be used by WaktuSolat as the task scheduler. |
| scheduler.celery | bool | `false` | Specifies whether Celery should be used by WaktuSolat as the task scheduler. |
| scheduler.schedule.clean_db.hour | string | `""` | The hours at which the task scheduler cleans up the database. Default: `"0"`. |
| scheduler.schedule.clean_db.minute | string | `""` | The minutes at which the task scheduler cleans up the database. Default: `"0"`. |
| scheduler.schedule.clean_db.second | string | `""` | The seconds at which the task scheduler cleans up the database. Default: `"0"` for `apscheduler`. |
| scheduler.schedule.notify_solat_schedule.hour | string | `""` | The hours at which the task scheduler schedules the daily prayer time post. Default: `"5"`. |
| scheduler.schedule.notify_solat_schedule.minute | string | `""` | The minutes at which the task scheduler schedules the daily prayer time post. Default: `"0"`. |
| scheduler.schedule.notify_solat_schedule.second | string | `""` | The seconds at which the task scheduler schedules the daily prayer time post. Default: `"0"` for `apscheduler`. |
| scheduler.schedule.notify_solat_times.hour | string | `""` | The hours at which the task scheduler schedules the daily prayer time notifications. Default: `"*"`. |
| scheduler.schedule.notify_solat_times.minute | string | `""` | The minutes at which the task scheduler schedules the daily prayer time notifications. Default: `"*/1"`. |
| scheduler.schedule.notify_solat_times.second | string | `""` | The seconds at which the task scheduler schedules the daily prayer time notifications. Default: `"0"` for `apscheduler`. |
| scheduler.schedule.post_scheduler.hour | string | `""` | The hours at which the task scheduler posts scheduled posts. Default: `"*"`. |
| scheduler.schedule.post_scheduler.minute | string | `""` | The minutes at which the task scheduler posts scheduled posts. Default: `"*"`. |
| scheduler.schedule.post_scheduler.second | string | `""` | The seconds at which the task scheduler posts scheduled posts. Default: `"*/1"`. |
| scheduler.timezone | string | `""` | The timezone for the task scheduler used by WaktuSolat to schedule time-dependent operations. Default: `"Etc/UTC"`. |
| service.redis.nodePort | string | `""` | The optional node port to expose for Redis when the service type is NodePort. |
| service.redis.port | string | `""` | The Redis port on which the WaktuSolat server should listen for connections. Default: `"6379"`. |
| service.type | string | `""` | The type of service used to expose WaktuSolat services. Default: `"ClusterIP"`. |
| service.waktusolat.nodePort | string | `""` | The optional node port to expose for Redis when the service type is NodePort. |
| service.waktusolat.port | string | `""` | The Redis port on which the WaktuSolat server should listen for connections. Default: `"6379"`. |
| storage.log.accessMode | string | `""` | The access mode defining how the log storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.log.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for log storage. |
| storage.log.mountPath | string | `""` | The path where the log storage should be mounted on the container. Default: `"/var/log/apache2"`. |
| storage.log.storage | string | `""` | The default amount of persistent storage allocated for the log storage. Default: `"50Mi"`. |
| storage.log.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the log storage. Default: `"longhorn"`. |
| storage.log.subPath | string | `""` | The subpath within the log storage to mount to the container. Leave empty if not required. |
| waktusolat.account | list | `[]` | Account configurations. Items: `.api`, `.id`, `.host`, `.token`, `.bot`, `.discoverable`, `.enabled`, `.display_name`, `.fields`, `.locked`, `.note`. |
| waktusolat.debug | bool | `false` | Specifies whether WaktuSolat should run in debug mode. Default: `false`. |
| waktusolat.domain | string | `""` | The ingress domain name that hosts the WaktuSolat server. Default: `"localhost"`. |
| waktusolat.feed | list | `[]` | WaktuSolat feed configurations. Items: `.endpoint`, `.id`, `.enabled`. |
| waktusolat.location | list | `[]` | The code of locations WaktuSolat should fetch and update prayer times for. Default: `"wlp-0"`. |
| waktusolat.post_limit | string | `""` | The limit number of posts to be scheduled for posting per run. Default: `"0"` (Unlimited). |
| waktusolat.retry_post | string | `""` | Specifies whether to retry posting if the post fails to be sent. Default: `"false"`. |
| waktusolat.secret | string | `""` | A 50-character secret key used for secure session management and cryptographic operations within the WaktuSolat service. |
| waktusolat.serverAdmin | string | `""` | The email address displayed by Apache for server administration contact. Default: "admin@example.com". |
| waktusolat.visibility | string | `""` | The default visibility of posts made by the WaktuSolat service. Default: `"public"`. |
