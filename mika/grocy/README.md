# `grocy`

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

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
cp mika/grocy/values.yaml .
```

Edit `values.yaml` with the appropriate values.  Please refer to the [Configurations](#configurations) section below, or the `values.yaml` file itself for details and sample values.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/grocy --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/grocy --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| grocy.culture | string | `""` | The localisation of the Grocy application. Default: `"en_GB"`. |
| grocy.currency | string | `""` | The currency used to format all monetary values in Grocy. Default: `"MYR"`. |
| grocy.data.storage | string | `""` | The amount of persistent storage allocated for the Grocy instance. Default: `"500Mi"`. |
| grocy.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the Grocy storage. Default: `"longhorn"`. |
| grocy.energy | string | `""` | The preferred unit for displaying energy values in Grocy. Default: `"kcal"`. |
| grocy.mode | string | `""` | The mode to deploy grocy in which determines whether to enable user authentication. Default: `"production"`. |
| grocy.php.file_limit | string | `""` | Sets the maximum number of files that can be uploaded simultaneously through PHP. Default: `"200"`. |
| grocy.php.memory_limit | string | `""` | Determines the maximum amount of memory that PHP can allocate for executing scripts. Default: `"512M"`. |
| grocy.php.post_limit | string | `""` | Defines the maximum size of the entire HTTP POST request that PHP can handle. Default: `"100M"`. |
| grocy.php.upload_limit | string | `""` | Specifies the maximum size of an individual file that can be uploaded through PHP. Default: `"50M"`. |
| image.backend.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the backend container image. Default: `"IfNotPresent"`. |
| image.backend.registry | string | `""` | The registry where the backend container image is hosted. Default: `"docker.io"`. |
| image.backend.repository | string | `""` | The name of the repository that contains the backend container image used. Default: `"grocy/backend"`. |
| image.backend.tag | string | `""` | The tag that specifies the version of the backend container image used. Default: `Chart appVersion`. |
| image.frontend.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the frontend container image. Default: `"IfNotPresent"`. |
| image.frontend.registry | string | `""` | The registry where the frontend container image is hosted. Default: `"docker.io"`. |
| image.frontend.repository | string | `""` | The name of the repository that contains the frontend container image used. Default: `"grocy/frontend"`. |
| image.frontend.tag | string | `""` | The tag that specifies the version of the frontend container image used. Default: `Chart appVersion`. |
| replicaCount | string | `""` | The desired number of running replicas for Grocy. |
| resources.backend.limits.cpu | string | `"100m"` | The maximum amount of CPU resources allowed for the backend. |
| resources.backend.limits.memory | string | `"100Mi"` | The maximum amount of memory allowed for the backend. |
| resources.backend.requests.cpu | string | `"50m"` | The minimum amount of CPU resources required by the backend. |
| resources.backend.requests.memory | string | `"50Mi"` | The minimum amount of memory required by the backend. |
| resources.frontend.limits.cpu | string | `"100m"` | The maximum amount of CPU resources allowed for the frontend. |
| resources.frontend.limits.memory | string | `"50Mi"` | The maximum amount of memory allowed for the frontend. |
| resources.frontend.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by the frontend. |
| resources.frontend.requests.memory | string | `"10Mi"` | The minimum amount of memory required by the frontend. |
