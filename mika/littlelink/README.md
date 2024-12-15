# [LittleLink](https://github.com/sethcottle/littlelink)

The DIY self-hosted LinkTree alternative.

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

1. Get the values file of the LittleLink chart or an existing installation (release).

    Get the latest LittleLink chart values file for a new installation:

    ```sh
    helm show values mika/littlelink > values.yaml
    ```

    Alternatively, get the values file of an existing LittleLink release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your LittleLink values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for LittleLink or upgrade an existing LittleLink release:

    ```sh
    helm upgrade --install ${releaseName} mika/littlelink --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your LittleLink release has been installed:

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
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| image.littlelink.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the LittleLink container image. Default: `"IfNotPresent"`. |
| image.littlelink.registry | string | `""` | The registry where the LittleLink container image is hosted. Default: `"ghcr.io"`. |
| image.littlelink.repository | string | `""` | The name of the repository that contains the LittleLink container image used. Default: `"techno-tim/littlelink-server"`. |
| image.littlelink.tag | string | `""` | The tag that specifies the version of the LittleLink container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting LittleLink services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| littlelink.author | string | `""` | The author of the LittleLink page, used for meta tags and general attribution. |
| littlelink.avatar.alt | string | `""` | The accessible alternate text for the avatar image. Default: `${.name}`. |
| littlelink.avatar.file | string | `""` | The file of the avatar image to display on the LittleLink page. |
| littlelink.avatar.height | string | `""` | The height of the avatar image in pixels. Default: `"400"`. |
| littlelink.avatar.url | string | `""` | The URL of the avatar image to display on the LittleLink page. |
| littlelink.avatar.width | string | `""` | The width of the avatar image in pixels. Default: `"400"`. |
| littlelink.biography | string | `""` | A short description or biography about the owner of the LittleLink page. |
| littlelink.domain | string | `""` | The ingress domain name that hosts the LittleLink server. |
| littlelink.favicon.file | string | `""` | The file of the favicon representing the LittleLink page. |
| littlelink.favicon.url | string | `""` | The URL of the favicon representing the LittleLink page. |
| littlelink.footer | string | `""` | The text to display at the bottom of the LittleLink page. |
| littlelink.initScript | string | `""` | Custom init script to run before the LittleLink container starts. |
| littlelink.links | list | `[]` | The list of links to be displayed on the LittleLink interface. Items: `.name`, `.url`, `.custom`. |
| littlelink.name | string | `""` | The display name to be shown prominently as the LittleLink page header. Default: `"LittleLink"`. |
| littlelink.theme | string | `""` | The selected LittleLink theme which features a predefined visual style, colors, and layouts. Default: `"dark"`. |
| littlelink.title | string | `""` | The title displayed in the browser tab of the LittleLink page. Default: `"LittleLink"`. |
| replicaCount | string | `""` | The desired number of running replicas for LittleLink. Default: `"1"`. |
| resources.littlelink | object | `{}` | LittleLink container resources. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the LittleLink server should listen for connections. Default: `"8080"`. |
| service.type | string | `""` | The type of service used to expose LittleLink services. Default: `"ClusterIP"`. |