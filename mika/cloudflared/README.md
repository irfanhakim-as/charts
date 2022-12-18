# `cloudflared`

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Preflight checklist

### Login to Cloudflare

```sh
cloudflared tunnel login
```

### Create Cloudflare tunnel

```sh
cloudflared tunnel create <tunnel>
```

### Associate Cloudflare tunnel with a DNS record

```sh
cloudflared tunnel route dns <tunnel> <hostname>
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

Edit `values.yaml` with the appropriate values.

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

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.cloudflared.pullPolicy | string | `"IfNotPresent"` | Cloudflared image pull policy |
| image.cloudflared.registry | string | `"docker.io"` | Cloudflared image registry |
| image.cloudflared.repository | string | `"cloudflare/cloudflared"` | Cloudflared image repository |
| image.cloudflared.tag | string | `""` | Cloudflared image version |
| ingress | list | `[]` | Cloudflare ingress rules |
| replicaCount | int | `1` | Cloudflared replica count |
| resources.limits.cpu | string | `"500m"` | Maximum cpu allocation |
| resources.limits.memory | string | `"500Mi"` | Maximum ram allocation |
| resources.requests.cpu | string | `"10m"` | Minimum cpu allocation |
| resources.requests.memory | string | `"10Mi"` | Minimum ram allocation |
| tunnel.file | file | `""` | Cloudflare tunnel credentials file |
| tunnel.name | string | `""` | Cloudflare tunnel name |