# [Cloudflare DDNS](https://github.com/timothymiller/cloudflare-ddns)

Access your home network remotely via a custom domain name without a static IP!

## Prerequisites

> [!NOTE]  
> You may refer to [Orked](https://github.com/irfanhakim-as/orked) for help with setting up a Kubernetes cluster that meets all the following prerequisites.

- Kubernetes 1.19+
- Helm 3.2.0+

---

## Preflight checklist

> [!IMPORTANT]  
> The following items are required to be set up prior to installing this chart.

**This section does not apply to this chart.**

---

## Recommended configurations

> [!NOTE]  
> The following configuration recommendations might not be the default settings for this chart but are **highly recommended**. Please carefully consider them before configuring your installation.

**This section does not apply to this chart.**

---

## Application configurations

> [!NOTE]  
> The following configurations are expected or recommended to be set up from within the application after completing the installation.

**This section does not apply to this chart.**

---

## How to add the chart repo

1. Add the repo to your local helm client:

    ```sh
    helm repo add mika https://irfanhakim-as.github.io/charts
    ```

2. Update the repo to retrieve the latest versions of the packages:

    ```sh
    helm repo update
    ```

---

## How to install or upgrade a chart release

1. Get the values file of the Cloudflare DDNS chart or an existing installation (release).

    Get the latest Cloudflare DDNS chart values file for a new installation:

    ```sh
    helm show values mika/cloudflareddns > values.yaml
    ```

    Alternatively, get the values file of an existing Cloudflare DDNS release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Cloudflare DDNS values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Cloudflare DDNS or upgrade an existing Cloudflare DDNS release:

    ```sh
    helm upgrade --install ${releaseName} mika/cloudflareddns --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Cloudflare DDNS release has been installed:

    ```sh
    helm ls --namespace ${namespace} | grep "${releaseName}"
    ```

    Replace `${namespace}` and `${releaseName}` accordingly. This should return the release information if the release has been installed.

---

## How to uninstall a chart release

> [!CAUTION]  
> Uninstalling a release will irreversibly delete all the resources associated with the release, including any persistent data.

1. Uninstall the desired release:

    ```sh
    helm uninstall ${releaseName} --namespace ${namespace} --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Verify that the release has been uninstalled:

    ```sh
    helm ls --namespace ${namespace} | grep "${releaseName}"
    ```

    Replace `${namespace}` and `${releaseName}` accordingly. This should return nothing if the release has been uninstalled.

---

## Chart configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cloudflareddns.configPath | string | `""` | The path to the Cloudflare DDNS configuration directory. Default: `"/etc/cloudflare-ddns"`. |
| cloudflareddns.ipv4 | string | `""` | Specify whether to add an A record for each subdomain. Default: `"true"`. |
| cloudflareddns.ipv6 | string | `""` | Specify whether to add an AAAA record for each subdomain. Default: `"false"`. |
| cloudflareddns.purge | string | `""` | Specify whether to purge stale DNS records not defined in the configuration. Default: `"false"`. |
| cloudflareddns.subdomains | list | `[]` | The list of subdomains to be updated for a specified domain (zone). Items: `.hostname`, `.proxied`. |
| cloudflareddns.token | string | `""` | The Cloudflare API token used to authenticate with the Cloudflare API. |
| cloudflareddns.ttl | string | `""` | The Time-To-Live (TTL) duration defining how long DNS records are cached in seconds. Default: `"300"`. |
| cloudflareddns.zoneID | string | `""` | The ID of the zone that will get the records. |
| image.cloudflareddns.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Cloudflare DDNS container image. Default: `"IfNotPresent"`. |
| image.cloudflareddns.registry | string | `""` | The registry where the Cloudflare DDNS container image is hosted. Default: `"docker.io"`. |
| image.cloudflareddns.repository | string | `""` | The name of the repository that contains the Cloudflare DDNS container image used. Default: `"timothyjmiller/cloudflare-ddns"`. |
| image.cloudflareddns.tag | string | `""` | The tag that specifies the version of the Cloudflare DDNS container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| replicaCount | string | `""` | The desired number of running replicas for Cloudflare DDNS. Default: `"1"`. |
| resources.cloudflareddns | object | `{}` | Resource requirements and limits for Cloudflare DDNS containers. |