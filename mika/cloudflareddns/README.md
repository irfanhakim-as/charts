# [`cloudflareddns`](https://github.com/timothymiller/cloudflare-ddns)

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
cp mika/cloudflareddns/values.yaml .
```

Edit `values.yaml` with the appropriate values.  Please refer to the [Configurations](#configurations) section below, or the `values.yaml` file itself for details and sample values.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/cloudflareddns --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/cloudflareddns --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cloudflareddns.configPath | string | `""` | The path to the cloudflareddns configuration directory. Default: `"/etc/cloudflare-ddns"`. |
| cloudflareddns.ipv4 | string | `""` | Specify whether to add an A record for each subdomain. Default: `"true"`. |
| cloudflareddns.ipv6 | string | `""` | Specify whether to add an AAAA record for each subdomain. Default: `"false"`. |
| cloudflareddns.subdomains | list | `[]` | The list of subdomains to be updated for a specified domain (zone). Items: `.hostname`, `.proxied`. |
| cloudflareddns.token | string | `""` | The Cloudflare API token used to authenticate with the Cloudflare API. |
| cloudflareddns.zoneID | string | `""` | The ID of the zone that will get the records. |
| image.cloudflareddns.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the cloudflareddns container image. Default: `"IfNotPresent"`. |
| image.cloudflareddns.registry | string | `""` | The registry where the cloudflareddns container image is hosted. Default: `"docker.io"`. |
| image.cloudflareddns.repository | string | `""` | The name of the repository that contains the cloudflareddns container image used. Default: `"timothyjmiller/cloudflare-ddns"`. |
| image.cloudflareddns.tag | string | `""` | The tag that specifies the version of the cloudflareddns container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| replicaCount | string | `""` | The desired number of running replicas for cloudflareddns. Default: `"1"`. |
| resources.limits.cpu | string | `"50m"` | The maximum amount of CPU resources allowed for cloudflareddns. |
| resources.limits.memory | string | `"32Mi"` | The maximum amount of memory allowed for cloudflareddns. |
| resources.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by cloudflareddns. |
| resources.requests.memory | string | `"10Mi"` | The minimum amount of memory required by cloudflareddns. |