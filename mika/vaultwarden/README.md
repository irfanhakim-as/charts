# [Vaultwarden](https://github.com/dani-garcia/vaultwarden)

An alternative server implementation of the Bitwarden Client API written in Rust and compatible with official Bitwarden clients.

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

### Generate admin token

A unique, secure admin token (password) is required for each Vaultwarden installation to allow access to the admin panel.

1. Generate an admin password using the following command:

    ```sh
    python -c 'import random; print("".join([random.choice("abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)") for i in range(50)]))'
    ```

    Sample value:

    ```
      6bkw1l_+4u^&sinqb2dmpt-u&rnhlmi*@u=j7z^@(a0k^ys=h4
    ```

2. Secure the generated password with a hash using Argon2:

    ```sh
    echo -n '<admin-token>' | argon2 "$(openssl rand -base64 32)" -e -id -k 65540 -t 3 -p 4
    ```

    Replace `<admin-token>` with the secure password you have generated. For example:

    ```sh
    echo -n '6bkw1l_+4u^&sinqb2dmpt-u&rnhlmi*@u=j7z^@(a0k^ys=h4' | argon2 "$(openssl rand -base64 32)" -e -id -k 65540 -t 3 -p 4
    ```

    Sample hash value:

    ```
      $argon2id$v=19$m=65540,t=3,p=4$K1ZEaDRCbTdGdUwrT3RuV3VodE9FVFFmYmhQNThaNUF3dWgvejV6R0VkRT0$RGdC5jEqxf661ayok4F8gK+7HuFESqPEUaEi1tO9LrI
    ```

2. Set the admin token that has been secured as the value of the `vaultwarden.adminToken` setting in your installation's values file:

    ```yaml
    adminToken: "<secure-admin-token>"
    ```

    Replace `<secure-admin-token>` with the admin token that has been hashed using Argon2. For example:

    ```sh
    adminToken: "$argon2id$v=19$m=65540,t=3,p=4$K1ZEaDRCbTdGdUwrT3RuV3VodE9FVFFmYmhQNThaNUF3dWgvejV6R0VkRT0$RGdC5jEqxf661ayok4F8gK+7HuFESqPEUaEi1tO9LrI"
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

1. Get the values file of the Vaultwarden chart or an existing installation (release).

    Get the latest Vaultwarden chart values file for a new installation:

    ```sh
    helm show values mika/vaultwarden > values.yaml
    ```

    **Alternatively**, get the values file of an existing Vaultwarden release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your Vaultwarden values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for Vaultwarden or upgrade an existing Vaultwarden release:

    ```sh
    helm upgrade --install ${releaseName} mika/vaultwarden --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your Vaultwarden release has been installed:

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
| db.host | string | `""` | The hostname or IP address of the Vaultwarden database server. |
| db.name | string | `""` | The name of the database being used by Vaultwarden. |
| db.password | string | `""` | The password associated with the Vaultwarden database user. |
| db.port | string | `""` | The port number the Vaultwarden database server is listening for connections. |
| db.type | string | `""` | The database engine or backend being used by Vaultwarden. Default: `"sqlite"`. |
| db.user | string | `""` | The username or user account for accessing the Vaultwarden database. |
| image.init.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Init container image. Default: `"IfNotPresent"`. |
| image.init.registry | string | `""` | The registry where the Init container image is hosted. Default: `"docker.io"`. |
| image.init.repository | string | `""` | The name of the repository that contains the Init container image used. Default: `"busybox"`. |
| image.init.tag | string | `""` | The tag that specifies the version of the Init container image used. Default: `"1.36.1"`. |
| image.vaultwarden.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Vaultwarden container image. Default: `"IfNotPresent"`. |
| image.vaultwarden.registry | string | `""` | The registry where the Vaultwarden container image is hosted. Default: `"ghcr.io"`. |
| image.vaultwarden.repository | string | `""` | The name of the repository that contains the Vaultwarden container image used. Default: `"dani-garcia/vaultwarden"`. |
| image.vaultwarden.tag | string | `""` | The tag that specifies the version of the Vaultwarden container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| ingress.clusterIssuer | string | `""` | The name of the cluster issuer for Ingress. Default: `"letsencrypt-dns-prod"`. |
| ingress.customAnnotations | list | `[]` | Additional configuration annotations to be added to the Ingress resource. Items: `.prefix`, `.name`, `.value`. |
| ingress.enabled | bool | `false` | Specifies whether Ingress should be enabled for hosting Vaultwarden services. |
| ingress.www | bool | `false` | Specifies whether the WWW subdomain should be enabled. |
| invitation.enabled | string | `""` | Specifies whether to allow organisation admins to send user invitations. Default: `"false"`. |
| invitation.expiry | string | `""` | The number of hours after which an invitation token expires. Default: `"120"`. |
| invitation.organisation | string | `""` | The default organisation display name shown in invitation emails. Default: `"Vaultwarden"`. |
| mail.fromEmail | string | `""` | The email address used in the "from" address for sent emails. Default: `"${.smtp.user}"`. |
| mail.fromName | string | `""` | The display name used in the "from" address for sent emails. Default: `"Vaultwarden"`. |
| mail.smtp.host | string | `""` | The hostname or IP address of the SMTP server for sending emails. |
| mail.smtp.password | string | `""` | The password for authenticating with the SMTP server. |
| mail.smtp.port | string | `""` | The port number on the SMTP server used for sending emails. Default: `"587"`. |
| mail.smtp.security | string | `""` | The SMTP security protocol used for securing email communication. Default: `"starttls"`. |
| mail.smtp.user | string | `""` | The username for authenticating with the SMTP server. |
| push.enabled | string | `""` | Specifies whether to enable automatic vault sync in all clients using push notifications. Default: `"false"`. |
| push.id | string | `""` | The private installation ID for self-hosting or unlocking certain Bitwarden features. |
| push.key | string | `""` | The private installation key for self-hosting or unlocking certain Bitwarden features. |
| replicaCount | string | `""` | The desired number of running replicas for Vaultwarden. Default: `"1"`. |
| resources.vaultwarden | object | `{}` | Vaultwarden container resources. |
| service.nodePort | string | `""` | The optional node port to expose when the service type is NodePort. |
| service.port | string | `""` | The port on which the Vaultwarden server should listen for connections. Default: `"80"`. |
| service.type | string | `""` | The type of service used to expose Vaultwarden services. Default: `"ClusterIP"`. |
| signup.domainWhitelist | list | `[]` | A list of domains allowed for user account registration. |
| signup.enabled | string | `""` | Specifies whether to open up the Vaultwarden instance to new user account registrations. Default: `"false"`. |
| signup.resendInterval | string | `""` | The number of seconds before a verification email can be resent. Default: `"3600"`. |
| signup.resendLimit | string | `""` | The maximum number of times a verification email can be resent. Default: `"6"`. |
| signup.verification | string | `""` | Specifies whether to require email verification for new user registrations. Default: `"false"`. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteOnce"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.mountPath | string | `""` | The path where the data storage should be mounted on the container. Default: `"/data"`. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
| storage.data.subPath | string | `""` | The subpath within the data storage to mount to the container. Leave empty if not required. |
| tfa.allowTimeDrift | string | `""` | Specifies whether to allow small time discrepancies for TOTP code validation. Default: `"true"`. |
| tfa.emailEnforce | string | `""` | Specifies whether to setup email 2FA upon registration. Default: `"false"`. |
| tfa.emailExpiry | string | `""` | The number of seconds after which a 2FA email token expires. Default: `"600"`. |
| tfa.emailFallback | string | `""` | Specifies whether to automatically use email as a fallback 2FA method. Default: `"false"`. |
| tfa.emailLimit | string | `""` | The maximum number of attempts after which the 2FA email token is reset. Default: `"3"`. |
| tfa.emailTokenSize | string | `""` | The length of the secret 2FA email token. Default: `"6"`. |
| tfa.expiry | string | `""` | The number of minutes before a pending 2FA-enabled login is considered incomplete. Default: `"3"`. |
| tfa.rememberDevice | string | `""` | Specifies whether to allow users to remember their device for 2FA sessions. Default: `"true"`. |
| vaultwarden.adminToken | string | `""` | The secret password for accessing the Vaultwarden admin panel. |
| vaultwarden.clearTrash | string | `""` | Number of days to retain trashed items before permanent deletion. |
| vaultwarden.domain | string | `""` | The ingress domain name that hosts the Vaultwarden server. |
| vaultwarden.emailUpdate | string | `""` | Specifies whether to allow users to change their account email address. Default: `"true"`. |
| vaultwarden.emergencyAccess | string | `""` | Specifies whether to allow enabling emergency access to user accounts. Default: `"true"`. |
| vaultwarden.expFeatures | list | `[]` | A list of experimental client feature flags to enable certain experimental functionality. |
| vaultwarden.hibpApiKey | string | `""` | The Have I Been Pwned API key for password breach checks. |
| vaultwarden.initScript | string | `""` | Custom init script to run before the Vaultwarden container starts. |
| vaultwarden.logLevel | string | `""` | The verbosity level of the Vaultwarden logs. Default: `"info"`. |
| vaultwarden.notifyNewDevice | string | `""` | Specifies whether to require notifying users when a new device logs into their account. Default: `"false"`. |
| vaultwarden.send | string | `""` | Specifies whether to allow users to use the Bitwarden Send feature. Default: `"true"`. |
| yubico.enabled | string | `""` | Specifies whether to enable Yubico 2FA integration. Default: `"false"`. |
| yubico.id | string | `""` | The API client ID for enabling YubiKey OTP authentication. |
| yubico.key | string | `""` | The API secret key for enabling YubiKey OTP authentication. |
| yubico.server | string | `""` | The URL of the Yubico API server for 2FA verification. |