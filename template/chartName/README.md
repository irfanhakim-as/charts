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
| chartName.bar | string | `""` | The secret value of the ChartName bar. Default: `"bar"`. |
| chartName.domain | string | `""` | The ingress domain name that hosts the ChartName server. |
| chartName.foo | string | `""` | The value of the ChartName foo. Default: `"foo"`. |
| image.chartName.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the ChartName container image. Default: `"IfNotPresent"`. |
| image.chartName.registry | string | `""` | The registry where the ChartName container image is hosted. Default: `"docker.io"`. |
| image.chartName.repository | string | `""` | The name of the repository that contains the ChartName container image used. Default: `"chartName"`. |
| image.chartName.tag | string | `""` | The tag that specifies the version of the ChartName container image used. Default: `Chart appVersion`. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting ChartName services. |
| replicaCount | string | `""` | The desired number of running replicas for ChartName. Default: `"1"`. |
| resources.chartName | object | `{}` | ChartName container resources. |
| service.type | string | `""` | The type of service used for ChartName services. Default: `"ClusterIP"`. |
| storage.data.enabled | bool | `true` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/config"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |