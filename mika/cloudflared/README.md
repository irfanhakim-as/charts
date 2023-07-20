# [`cloudflared`](https://github.com/cloudflare/cloudflared)

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Preflight checklist

### Login to Cloudflare

```sh
cloudflared tunnel login
```

### Create Cloudflare tunnel

Replace `$tunnel` accordingly.

```sh
cloudflared tunnel create $tunnel
```

### Associate Cloudflare tunnel with a DNS record

Replace `$tunnel` and `$hostname` accordingly.

```sh
cloudflared tunnel route dns $tunnel $hostname
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
cp mika/cloudflared/values.yaml .
```

Edit `values.yaml` with the appropriate values. Refer to the [Configurations](#Configurations) section for available options.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name`, `$namespace` and `$credentials.json` accordingly.

```sh
helm install $release_name \
--namespace $namespace \
--create-namespace \
--set-file tunnel.file=$credentials.json \
--values values.yaml \
--wait mika/cloudflared
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name`, `$namespace` and `$credentials.json` accordingly.

```sh
helm upgrade $release_name \
--namespace $namespace \
--set-file tunnel.file=$credentials.json \
--values values.yaml \
--wait mika/cloudflared
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.cloudflared.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Cloudflared container image. Default: `"IfNotPresent"`. |
| image.cloudflared.registry | string | `""` | The registry where the Cloudflared container image is hosted. Default: `"docker.io"`. |
| image.cloudflared.repository | string | `""` | The name of the repository that contains the Cloudflared container image used. Default: `"cloudflare/cloudflared"`. |
| image.cloudflared.tag | string | `""` | The tag that specifies the version of the Cloudflared container image used. Default: `Chart appVersion`. |
| ingress | list | `[]` | Cloudflare ingress configurations. |
| replicaCount | string | `""` | The desired number of running replicas for Cloudflared. Default: `"1"`. |
| resources.limits.cpu | string | `"500m"` | The maximum amount of CPU resources allowed for Cloudflared. |
| resources.limits.memory | string | `"500Mi"` | The maximum amount of memory allowed for Cloudflared. |
| resources.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by Cloudflared. |
| resources.requests.memory | string | `"10Mi"` | The minimum amount of memory required by Cloudflared. |
| tunnel.file | file | `""` | The Cloudflare tunnel's credentials JSON file. |
| tunnel.name | string | `""` | The name of the Cloudflare tunnel. |
