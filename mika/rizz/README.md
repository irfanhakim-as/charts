# [Rizz](https://github.com/irfanhakim-as/rizz)

> [!WARNING]  
> This chart requires access to a private image registry, please request access from the owner of the repository.

Rizz is a simple web application that tracks and posts content from RSS Feeds to Mastodon.

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

A unique, secure secret key is required for each Rizz installation.

1. Generate a secret key using the following command:

    ```sh
    python -c 'import random; print("".join([random.choice("abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)") for i in range(50)]))'
    ```

2. Set the generated secret key as the value of the `rizz.secret` setting in your installation's values file:

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

1. Get the values file of the Rizz chart or an existing installation (release).

    Get the latest Rizz chart values file for a new installation:

    ```sh
    helm show values mika/rizz > values.yaml
    ```

    Alternatively, get the values file of an existing Rizz release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Rizz values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Rizz or upgrade an existing Rizz release:

    ```sh
    helm upgrade --install ${releaseName} mika/rizz --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Rizz release has been installed:

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
| db.host | string | `""` | The hostname or IP address of the Rizz database server. |
| db.name | string | `""` | The name of the database being used by Rizz. |
| db.password | string | `""` | The password associated with the Rizz database user. |
| db.port | string | `""` | The port number the Rizz database server is listening for connections. Default: `"5432"`. |
| db.type | string | `""` | The database engine or backend being used by Rizz. Default: `"postgresql"`. |
| db.user | string | `""` | The username or user account for accessing the Rizz database. |
| image.redis.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Redis container image. Default: `"IfNotPresent"`. |
| image.redis.registry | string | `""` | The registry where the Redis container image is hosted. Default: `"docker.io"`. |
| image.redis.repository | string | `""` | The name of the repository that contains the Redis container image used. Default: `"redis"`. |
| image.redis.tag | string | `""` | The tag that specifies the version of the Redis container image used. Default: `"alpine"`. |
| image.rizz.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Rizz container image. Default: `"IfNotPresent"`. |
| image.rizz.registry | string | `""` | The registry where the Rizz container image is hosted. Default: `"ghcr.io"`. |
| image.rizz.repository | string | `""` | The name of the repository that contains the Rizz container image used. Default: `"irfanhakim-as/rizz"`. |
| image.rizz.tag | string | `""` | The tag that specifies the version of the Rizz container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Rizz services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| replicaCount | string | `""` | The desired number of running replicas for Rizz. Default: `"1"`. |
| resources.rizz | object | `{}` | Rizz container resources. |
| resources.scheduler | object | `{}` | Scheduler container resources. |
| rizz.debug | string | `""` | Specifies whether Rizz should run in debug mode. Default: `"false"`. |
| rizz.domain | string | `""` | The ingress domain name that hosts the Rizz server. Default: `"localhost"`. |
| rizz.feed | list | `[]` | RSS feed configurations. Items: `.endpoint`, `.pubdate_format`, `.id`, `.enabled`. |
| rizz.mastodon | list | `[]` | Mastodon configurations. Items: `.api`, `.id`, `.token`, `.bot`, `.discoverable`, `.enabled`, `.display_name`, `.fields`, `.locked`, `.note`. |
| rizz.organic | string | `""` | Specifies whether to enable posting in organic numbers. Default: `"true"`. |
| rizz.post_limit | string | `""` | The limit number of posts to be scheduled for posting per run. Default: `"3"`. |
| rizz.retry_post | string | `""` | Specifies whether to retry posting if the post fails to be sent. Default: `"true"`. |
| rizz.secret | string | `""` | A 50-character secret key used for secure session management and cryptographic operations within the Rizz service. |
| rizz.serverAdmin | string | `""` | The email address displayed by Apache for server administration contact. Default: `"admin@example.com"`. |
| rizz.visibility | string | `""` | The default visibility of posts made by the Rizz service. Default: `"public"`. |
| scheduler.apscheduler | bool | `true` | Specifies whether APScheduler should be used by Rizz as the task scheduler. |
| scheduler.celery | bool | `false` | Specifies whether Celery should be used by Rizz as the task scheduler. |
| scheduler.schedule.clean_data.hour | string | `""` | The hours at which the task scheduler cleans up the database. Default: `"0"`. |
| scheduler.schedule.clean_data.minute | string | `""` | The minutes at which the task scheduler cleans up the database. Default: `"0"`. |
| scheduler.schedule.clean_data.second | string | `""` | The seconds at which the task scheduler cleans up the database. Default: `"0"` (`apscheduler`). |
| scheduler.schedule.post_scheduler.hour | string | `""` | The hours at which the task scheduler posts scheduled posts. Default: `"8-23/3"`. |
| scheduler.schedule.post_scheduler.minute | string | `""` | The minutes at which the task scheduler posts scheduled posts. Default: `"0"`. |
| scheduler.schedule.post_scheduler.second | string | `""` | The seconds at which the task scheduler posts scheduled posts. Default: `"0"` (`apscheduler`). |
| scheduler.schedule.update_data.hour | string | `""` | The hours at which the task scheduler updates the database. Default: `"7-22/3"`. |
| scheduler.schedule.update_data.minute | string | `""` | The minutes at which the task scheduler updates the database. Default: `"0"`. |
| scheduler.schedule.update_data.second | string | `""` | The seconds at which the task scheduler updates the database. Default: `"0"` (`apscheduler`). |
| scheduler.timezone | string | `""` | The timezone for the task scheduler used by Rizz to schedule time-dependent operations. Default: `"Asia/Kuala_Lumpur"`. |
| service.redis.nodePort | string | `""` | The optional node port to expose for Redis when the service type is NodePort. |
| service.redis.port | string | `""` | The Redis port on which the Rizz server should listen for connections. Default: `"6379"`. |
| service.rizz.nodePort | string | `""` | The optional node port to expose for Rizz when the service type is NodePort. |
| service.rizz.port | string | `""` | The Rizz port on which the Rizz server should listen for connections. Default: `"80"`. |
| service.type | string | `""` | The type of service used to expose Rizz services. Default: `"ClusterIP"`. |
| storage.log.accessMode | string | `""` | The access mode defining how the log storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.log.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for log storage. |
| storage.log.mountPath | string | `""` | The path where the log storage should be mounted on the container. Default: `"/var/log/apache2"`. |
| storage.log.storage | string | `""` | The default amount of persistent storage allocated for the log storage. Default: `"50Mi"`. |
| storage.log.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the log storage. Default: `"longhorn"`. |
| storage.log.subPath | string | `""` | The subpath within the log storage to mount to the container. Leave empty if not required. |