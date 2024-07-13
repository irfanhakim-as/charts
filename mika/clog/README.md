# Clog

> [!WARNING]  
> This chart requires access to a private image registry. Please request access from the owner of the image repository.

Creative blog, Career blog, Coin blog, you name it.

## Prerequisites

> [!NOTE]  
> You may refer to [Orked](https://github.com/irfanhakim-as/orked) for help with setting up a Kubernetes cluster that meets all the following prerequisites.

- Kubernetes 1.19+
- Helm 3.2.0+
- Longhorn 1.4.1+

---

## Preflight checklist

> [!IMPORTANT]  
> The following items are required to be set up prior to installing this chart.

### Image pull secret

An image pull secret is required to access the private image registry that hosts the required image.

1. If you have the necessary credentials, create a named image pull secret (i.e. `ghcr-token-secret`) in the `default` namespace:

    ```sh
    kubectl create secret docker-registry ghcr-token-secret --docker-server=<container-registry> --docker-username=<registry-username> --docker-password=<registry-token> --docker-email=<registry-email> -n default
    ```

2. Copy the image pull secret from the `default` namespace to the destination namespace:

    ```sh
    kubectl get secret ghcr-token-secret -n default -o yaml | sed "s/namespace: .*/namespace: <destination-namespace>/" | kubectl apply -f -
    ```

3. Add the name of the image pull secret to the `imagePullSecrets` array in your installation's values file:

    ```yaml
    imagePullSecrets:
      - name: "ghcr-token-secret"
    ```

### Generate secret key

A unique, secure secret key is required for each Clog installation.

1. Generate a secret key using the following command:

    ```sh
    python -c 'import random; print("".join([random.choice("abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)") for i in range(50)]))'
    ```

2. Set the generated secret key as the value of the `clog.secret` setting in your installation's values file:

    ```yaml
    secret: "<generated-secret>"
    ```

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

1. Get the values file of the Clog chart or an existing installation (release).

    Get the latest Clog chart values file for a new installation:

    ```sh
    helm show values mika/clog > values.yaml
    ```

    Alternatively, get the values file of an existing Clog release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Clog values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Clog or upgrade an existing Clog release:

    ```sh
    helm upgrade --install ${releaseName} mika/clog --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Clog release has been installed:

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
| clog.cloudflared.enabled | bool | `false` | Specifies whether Cloudflare Tunnel should be enabled for hosting Clog services. |
| clog.debug | string | `""` | Specifies whether Clog should run in debug mode. Default: `false`. |
| clog.domain | string | `""` | The ingress domain name that hosts the Clog server. Default: `"localhost"`. |
| clog.name | string | `""` | The full name of the Clog web application. Default: `"Clog"`. |
| clog.ngrok.enabled | bool | `false` | Specifies whether Ngrok should be enabled for hosting Clog services. |
| clog.ngrok.token | string | `""` | The authentication token used to authenticate with Ngrok. |
| clog.secret | string | `""` | A 50-character secret key used for secure session management and cryptographic operations within the Clog service. |
| clog.serverAdmin | string | `""` | The email address displayed by Apache for server administration contact. Default: `"admin@example.com"`. |
| db.host | string | `""` | The hostname or IP address of the Clog database server. |
| db.name | string | `""` | The name of the database being used by Clog. |
| db.password | string | `""` | The password associated with the Clog database user. |
| db.port | string | `""` | The port number the Clog database server is listening for connections. Default: `"5432"`. |
| db.type | string | `""` | The database engine or backend being used by Clog. Default: `"postgresql"`. |
| db.user | string | `""` | The username or user account for accessing the Clog database. |
| image.clog.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Clog container image. Default: `"IfNotPresent"`. |
| image.clog.registry | string | `""` | The registry where the Clog container image is hosted. Default: `"ghcr.io"`. |
| image.clog.repository | string | `""` | The name of the repository that contains the Clog container image used. Default: `"irfanhakim-as/clog"`. |
| image.clog.tag | string | `""` | The tag that specifies the version of the Clog container image used. Default: `Chart appVersion`. |
| image.ngrok.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Ngrok container image. Default: `"IfNotPresent"`. |
| image.ngrok.registry | string | `""` | The registry where the Ngrok container image is hosted. Default: `"docker.io"`. |
| image.ngrok.repository | string | `""` | The name of the repository that contains the Ngrok container image used. Default: `"wernight/ngrok"`. |
| image.ngrok.tag | string | `""` | The tag that specifies the version of the Ngrok container image used. Default: `"latest"`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Clog services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| replicaCount | string | `""` | The desired number of running replicas for Clog. |
| resources.clog | object | `{}` | Resource requirements and limits for Clog containers. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the Clog server should listen for connections. Default: `"80"`. |
| service.type | string | `""` | The type of service used to expose Clog services. Default: `"ClusterIP"`. |
| storage.log.accessMode | string | `""` | The access mode defining how the log storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.log.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for log storage. |
| storage.log.mountPath | string | `""` | The path where the log storage should be mounted on the container. Default: `"/var/log/apache2"`. |
| storage.log.storage | string | `""` | The default amount of persistent storage allocated for the log storage. Default: `"50Mi"`. |
| storage.log.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the log storage. Default: `"longhorn"`. |
| storage.log.subPath | string | `""` | The subpath within the log storage to mount to the container. Leave empty if not required. |
| storage.media.accessMode | string | `""` | The access mode defining how the media storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.media.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for media storage. |
| storage.media.mountPath | string | `""` | The path where the media storage should be mounted on the container. Default: `"/clog/media"`. |
| storage.media.storage | string | `""` | The default amount of persistent storage allocated for the media storage. Default: `"100Mi"`. |
| storage.media.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the media storage. Default: `"longhorn"`. |
| storage.media.subPath | string | `""` | The subpath within the media storage to mount to the container. Leave empty if not required. |
| storage.migration.accessMode | string | `""` | The access mode defining how the migration storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.migration.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for migration storage. |
| storage.migration.mountPath | string | `""` | The path where the migration storage should be mounted on the container. Default: `"/clog/%s/migrations"`. |
| storage.migration.storage | string | `""` | The default amount of persistent storage allocated for the migration storage. Default: `"20Mi"`. |
| storage.migration.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the migration storage. Default: `"longhorn"`. |
| storage.migration.subPath | string | `""` | The subpath within the migration storage to mount to the container. Leave empty if not required. |
| storage.static.accessMode | string | `""` | The access mode defining how the static storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.static.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for static storage. |
| storage.static.mountPath | string | `""` | The path where the static storage should be mounted on the container. Default: `"/static"`. |
| storage.static.storage | string | `""` | The default amount of persistent storage allocated for the static storage. Default: `"50Mi"`. |
| storage.static.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the static storage. Default: `"longhorn"`. |
| storage.static.subPath | string | `""` | The subpath within the static storage to mount to the container. Leave empty if not required. |