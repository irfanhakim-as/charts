# [`kutt`](https://github.com/thedevs-network/kutt)

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
cp mika/kutt/values.yaml .
```

Edit `values.yaml` with the appropriate values.  Please refer to the [Configurations](#configurations) section below, or the `values.yaml` file itself for details and sample values.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/kutt --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/kutt --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| data.accessMode | string | `""` | The access mode that defines how the volume can be accessed by one or many nodes. Default: `"ReadWriteOnce"`. |
| data.storage | string | `""` | The amount of persistent storage allocated for the Kutt instance. Default: `"100Mi"`. |
| data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the Kutt storage. Default: "longhorn". |
| db.host | string | `""` | The hostname or IP address of the Kutt database server. |
| db.name | string | `""` | The name of the database used by Kutt. |
| db.password | string | `""` | The password associated with the Kutt database's user. |
| db.port | string | `""` | The port number on which the Kutt database server is listening. Default: `"5432"`. |
| db.ssl | bool | `false` | Specifies whether the Kutt database server should use SSL. |
| db.user | string | `""` | The username or user account for accessing the Kutt database. |
| image.kutt.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the kutt container image. Default: `"IfNotPresent"`. |
| image.kutt.registry | string | `""` | The registry where the kutt container image is hosted. Default: `"docker.io"`. |
| image.kutt.repository | string | `""` | The name of the repository that contains the kutt container image used. Default: `"kutt/kutt"`. |
| image.kutt.tag | string | `""` | The tag that specifies the version of the kutt container image used. Default: `Chart appVersion`. |
| image.redis.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the redis container image. Default: `"IfNotPresent"`. |
| image.redis.registry | string | `""` | The registry where the redis container image is hosted. Default: `"docker.io"`. |
| image.redis.repository | string | `""` | The name of the repository that contains the redis container image used. Default: `"redis"`. |
| image.redis.tag | string | `""` | The tag that specifies the version of the redis container image used. Default: `"6.0-alpine"`. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.enabled | bool | `false` | Specifies whether Kutt should be hosted using an Ingress.. |
| kutt.administration.dailyUserLimit | string | `""` | The maximum number of links that can be created by a user in a day. Default: `"50"`. |
| kutt.administration.disableAnonLinks | bool | `false` | Specifies whether Kutt should disallow creating links without an account. |
| kutt.administration.disableRegistration | bool | `false` | Specifies whether Kutt should disallow user registrations. |
| kutt.administration.maxStatsPerLink | string | `""` | The maximum number of visits for a link to have detailed statistics. Default: `"5000"`. |
| kutt.administration.nonUserCooldown | string | `""` | The number of minutes an anonymous user must wait before creating another link. Default: `"0"`. |
| kutt.admins | list | `[]` | Email addresses of the administrators of the Kutt application so they can access admin actions. |
| kutt.domain | string | `""` | The domain name that is hosting the Kutt application. Default: `"localhost:$service.kutt.port"` if `ingress` is disabled. |
| kutt.google.recaptchaSecretKey | string | `""` | The Google reCAPTCHA secret key used for preventing spam. Refer to https://developers.google.com/recaptcha/intro. |
| kutt.google.recaptchaSiteKey | string | `""` | The Google reCAPTCHA site key used for preventing spam. Refer to https://developers.google.com/recaptcha/intro. |
| kutt.google.safeBrowsingKey | string | `""` | The Google API key used for Google Safe Browsing to prevent malicious links. Refer to https://developers.google.com/safe-browsing/v4/get-started. |
| kutt.link_length | string | `""` | The length of the generated short links. Default: `"6"`. |
| kutt.mail.contact_email | string | `""` | The email address to be displayed as the contact email in the application. |
| kutt.mail.from_email | string | `""` | The email address used as the "from" address for sent emails. Default: `"$name <$mail.user>"`. |
| kutt.mail.host | string | `""` | The hostname or IP address of the SMTP server for sending emails. Default: `"smtp.gmail.com"`. |
| kutt.mail.password | string | `""` | The password for authenticating with the SMTP server. |
| kutt.mail.port | string | `""` | The port number on the SMTP server used for sending emails. Default: `"465"`. |
| kutt.mail.report_email | string | `""` | The email address that will receive submitted reports. |
| kutt.mail.secure | bool | `true` | Specifies whether Kutt should use a secure TLS connection when sending emails. |
| kutt.mail.user | string | `""` | The username for authenticating with the SMTP server. |
| kutt.name | string | `""` | The name of the site where Kutt is hosted. Default: `"Kutt"`. |
| kutt.secret | string | `""` | A 50-character secret key used for encrypting JSON Web Tokens (JWTs). |
| kutt.useHttps | bool | `true` | Specifies whether Kutt should use HTTPS for custom domains. |
| redis.external | bool | `false` | Specifies whether Kutt should use an external Redis server. |
| redis.host | string | `""` | The hostname or IP address of the Redis server. Default: `"localhost"`. |
| redis.password | string | `""` | The password for authenticating with the Redis server. |
| redis.port | string | `""` | The port number on which the EXTERNAL Redis server is listening. Default: `"6379"`. |
| replicaCount | string | `""` | The desired number of running replicas for Kutt. Default: `"1"`. |
| resources.kutt.limits.cpu | string | `"150m"` | The maximum amount of CPU resources allowed for the kutt. |
| resources.kutt.limits.memory | string | `"400Mi"` | The maximum amount of memory allowed for the kutt. |
| resources.kutt.requests.cpu | string | `"100m"` | The minimum amount of CPU resources required by the kutt. |
| resources.kutt.requests.memory | string | `"200Mi"` | The minimum amount of memory required by the kutt. |
| resources.redis.limits.cpu | string | `"20m"` | The maximum amount of CPU resources allowed for the redis. |
| resources.redis.limits.memory | string | `"50Mi"` | The maximum amount of memory allowed for the redis. |
| resources.redis.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by the redis. |
| resources.redis.requests.memory | string | `"20Mi"` | The minimum amount of memory required by the redis. |
| service.kutt.port | string | `""` | The port number on which the Kutt service is listening. Default: `"3000"`. |
| service.kutt.protocol | string | `""` | The protocol used by the Kutt service. Default: `"TCP"`. |
| service.type | string | `""` | The type of service used for Kutt. Default: `"ClusterIP"`. |
