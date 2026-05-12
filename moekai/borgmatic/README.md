# [borgmatic](https://github.com/borgmatic-collective/borgmatic)

Simple, configuration-driven backup software for servers and workstations.

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

### Set up SSH key

An SSH key pair is required for authenticating with the remote Borg server. The public key must be authorised on the remote server, and the private key content should be provided as the value of `borgmatic.global.sshPrivateKey` (shared across all jobs) or `borgmatic.configs.<name>.sshPrivateKey` (per job) in your values file.

1. Generate an SSH key pair:

    ```sh
    ssh-keygen -t ed25519 -C "borgmatic" -f ./borgmatic_ed25519
    ```

2. Authorise the public key on the remote Borg server:

    ```sh
    ssh-copy-id -i ./borgmatic_ed25519.pub <user>@<backuphost>
    ```

    Replace `<user>` and `<backuphost>` accordingly.

3. Copy the private key content for use as the value of `borgmatic.global.sshPrivateKey` or `borgmatic.configs.<name>.sshPrivateKey` in your values file:

    ```sh
    cat ./borgmatic_ed25519
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

### Initialise the Borg repository

Each Borg repository must be initialised once before borgmatic can perform backups.

1. Create a one-off shell job for the borgmatic config:

    ```sh
    kubectl create job --namespace ${namespace} borgmatic-shell --from=cronjob/${releaseName}-borgmatic-<name>-shell
    ```

    Replace `${namespace}`, `${releaseName}`, and `<name>` with the config name (e.g. `databases`, `files`) accordingly.

2. Once the pod is running, get the pod name and exec into it to initialise the repository:

    ```sh
    kubectl get pod --namespace ${namespace} -l job-name=borgmatic-shell
    kubectl exec --namespace ${namespace} -it <pod-name> -- \
      borgmatic init --encryption repokey-blake2 --config /etc/borgmatic.d/<name>.yaml
    ```

    Replace `${namespace}`, `<pod-name>`, and `<name>` accordingly.

3. Delete the job once initialisation is complete:

    ```sh
    kubectl delete job --namespace ${namespace} borgmatic-shell
    ```

    Replace `${namespace}` accordingly.

---

## How to add the chart repo

1. Add the repo to your local helm client:

    ```sh
    helm repo add moekai https://charts.moekai.com
    ```

2. Update the repo to retrieve the latest versions of the packages:

    ```sh
    helm repo update
    ```

---

## How to install or upgrade a chart release

1. Get the values file of the borgmatic chart or an existing installation (release).

    Get the latest borgmatic chart values file for a new installation:

    ```sh
    helm show values moekai/borgmatic > values.yaml
    ```

    **Alternatively**, get the values file of an existing borgmatic release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

2. Edit your borgmatic values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for borgmatic or upgrade an existing borgmatic release:

    ```sh
    helm upgrade --install ${releaseName} moekai/borgmatic --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}` and `${namespace}` accordingly.

4. Verify that your borgmatic release has been installed:

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
| borgmatic.configs | object | `{}` | A map of borgmatic configuration jobs, each generating a dedicated CronJob with its own schedule. Items: `.schedule`, `.passphrase`, `.sshPrivateKey`, `.secrets`, `.volumes`, `.content`. |
| borgmatic.global.passphrase | string | `""` | The passphrase used to encrypt and decrypt the Borg repository, shared across all borgmatic jobs. |
| borgmatic.global.secrets | object | `{}` | Secret environment variables shared across all borgmatic jobs. |
| borgmatic.global.sshPrivateKey | string | `""` | SSH private key content shared across all borgmatic jobs. |
| borgmatic.timezone | string | `""` | The timezone used for the borgmatic CronJob schedule and log timestamps. Default: `"UTC"`. |
| image.borgmatic.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the borgmatic container image. Default: `"IfNotPresent"`. |
| image.borgmatic.registry | string | `""` | The registry where the borgmatic container image is hosted. Default: `"ghcr.io"`. |
| image.borgmatic.repository | string | `""` | The name of the repository that contains the borgmatic container image used. Default: `"borgmatic-collective/borgmatic"`. |
| image.borgmatic.tag | string | `""` | The tag that specifies the version of the borgmatic container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| resources.borgmatic | object | `{}` | borgmatic container resources. |
| storage.data.accessMode | string | `""` | The access mode defining how the data storage can be mounted. Default: `"ReadWriteMany"`. |
| storage.data.enabled | bool | `false` | Specifies whether persistent storage should be provisioned for data storage. |
| storage.data.storage | string | `""` | The default amount of persistent storage allocated for the data storage. Default: `"1Gi"`. |
| storage.data.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the data storage. Default: `"longhorn"`. |
