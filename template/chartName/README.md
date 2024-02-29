# ChartName

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
cp mika/chartName/values.yaml .
```

Edit `values.yaml` with the appropriate values.  Please refer to the [Configurations](#configurations) section below, or the `values.yaml` file itself for details and sample values.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/chartName --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/chartName --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| chartName.bar | string | `""` | The secret value of the chartName bar. Default: `"bar"`. |
| chartName.data.storage | string | `""` | The amount of persistent storage allocated for the chartName instance. Default: `"1Gi"`. |
| chartName.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the chartName storage. Default: `"longhorn"`. |
| chartName.foo | string | `""` | The value of the chartName foo. Default: `"foo"`. |
| image.chartName.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the chartName container image. Default: `"IfNotPresent"`. |
| image.chartName.registry | string | `""` | The registry where the chartName container image is hosted. Default: `"docker.io"`. |
| image.chartName.repository | string | `""` | The name of the repository that contains the chartName container image used. Default: `"chartName"`. |
| image.chartName.tag | string | `""` | The tag that specifies the version of the chartName container image used. Default: `Chart appVersion`. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.34"`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| replicaCount | int | `""` | The desired number of running replicas for chartName. Default: `"1"`. |
| resources.limits.cpu | string | `"250m"` | The maximum amount of CPU resources allowed for chartName. |
| resources.limits.memory | string | `"250Mi"` | The maximum amount of memory allowed for chartName. |
| resources.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by chartName. |
| resources.requests.memory | string | `"10Mi"` | The minimum amount of memory required by chartName. |