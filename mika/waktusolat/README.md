# `waktusolat`

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

Edit `values.yaml` with the appropriate values. Refer to the [Configuration](#Configuration) section for available options.

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

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| db.host | string | `"postgres.default.svc.cluster.local"` | Database server |
| db.name | string | `""` | Database name |
| db.password | string | `""` | Database user password |
| db.port | string | `"5432"` | Database port |
| db.type | string | `"postgresql"` | Database type |
| db.user | string | `""` | Database user |
| image.redis.pullPolicy | string | `"IfNotPresent"` | Redis image pull policy |
| image.redis.registry | string | `"docker.io"` | Redis image registry |
| image.redis.repository | string | `"redis"` | Redis image repository |
| image.redis.tag | string | `"alpine"` | Redis image version |
| image.waktusolat.pullPolicy | string | `"IfNotPresent"` | Waktu Solat image pull policy |
| image.waktusolat.registry | string | `"ghcr.io"` | Waktu Solat image registry |
| image.waktusolat.repository | string | `"irfanhakim-as/waktusolat"` | Waktu Solat image repository |
| image.waktusolat.tag | string | `""` | Waktu Solat image version |
| imagePullSecrets[0].name | string | `"ghcr-token-secret"` | Image pull secret name |
| replicaCount | int | `1` | Waktu Solat replica count |
| resources.redis.limits.cpu | string | `"15m"` | Redis maximum cpu allocation |
| resources.redis.limits.memory | string | `"50Mi"` | Redis maximum memory allocation |
| resources.redis.requests.cpu | string | `"5m"` | Redis minimum cpu allocation |
| resources.redis.requests.memory | string | `"30Mi"` | Redis minimum memory allocation |
| resources.waktusolat.limits.cpu | string | `"50m"` | Waktu Solat maximum cpu allocation |
| resources.waktusolat.limits.memory | string | `"450Mi"` | Waktu Solat maximum memory allocation |
| resources.waktusolat.requests.cpu | string | `"20m"` | Waktu Solat minimum cpu allocation |
| resources.waktusolat.requests.memory | string | `"250Mi"` | Waktu Solat minimum memory allocation |
| waktusolat.celery_timezone | string | `"Asia/Kuala_Lumpur"` | Timezone of the background scheduler |
| waktusolat.debug | bool | `false` | Waktu Solat debug mode |
| waktusolat.location | string | `"wlp-0"` | Default location code |
| waktusolat.mastodon.api | string | `"https://botsin.space/"` | Mastodon base API URL |
| waktusolat.mastodon.token | string | `""` | Mastodon token secret |
| waktusolat.secret | string | `""` | Waktu Solat secret key |
