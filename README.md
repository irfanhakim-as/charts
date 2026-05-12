# Moekai Chart Library for Kubernetes

Applications, developed or curated by [Moekai](https://github.com/irfanhakim-as), ready to install using [Helm](https://helm.sh).

## Prerequisites

> [!NOTE]  
> You may refer to [Orked](https://github.com/irfanhakim-as/orked) for help with setting up a Kubernetes cluster that meets all the following prerequisites.

- Kubernetes 1.19+
- Helm 3.2.0+
- Longhorn 1.4.1+
- csi-driver-smb 1.14.0+

---

## Chart Directory

| Chart Name | Description | Support | Access |
| ---------- | ----------- | ------- | ------ |
| [borgmatic](moekai/borgmatic) | Simple, configuration-driven backup software for servers and workstations. | ✅ | ✅ |
| [clog](moekai/clog) | Creative blog, Career blog, Coin blog, you name it. | ✅ | 🔒 |
| [cloudflared](moekai/cloudflared) | Cloudflare Tunnel is a tunneling software that lets you quickly secure and encrypt application traffic to any type of infrastructure. | ✅ | ✅ |
| [cloudflareddns](moekai/cloudflareddns) | Access your home network remotely via a custom domain name without a static IP! | ✅ | ✅ |
| [external-svc](moekai/external-svc) | Seamlessly connect external services to your Kubernetes environment. | ✅ | ✅ |
| [flex](moekai/flex) | Flex is a collection of curated services that aims to provide a complete home media server solution. | ✅ | ✅ |
| [ghost](moekai/ghost) | Ghost is an independent platform for publishing online by web and email newsletter. | ✅ | ✅ |
| [grocy](moekai/grocy) | Grocy is a web-based self-hosted groceries & household management solution for your home. | ✅ | ✅ |
| [kutt](moekai/kutt) | Kutt is a modern URL shortener with support for custom domains. Shorten URLs, manage your links and view the click rate statistics. | ✅ | ✅ |
| [linkding](moekai/linkding) | Linkding is a bookmark manager that you can host yourself. It's designed to be minimal, fast, and easy to set up using Docker. | ✅ | ✅ |
| [linkstack](moekai/linkstack) | LinkStack is a highly customizable link sharing platform with an intuitive, easy to use user interface. | ✅ | ✅ |
| [littlelink](moekai/littlelink) | The DIY self-hosted LinkTree alternative. | ✅ | ✅ |
| [mariadb-agent](moekai/mariadb-agent) | Easily create or delete multiple pairs of databases and users in a remote MariaDB or MySQL instance. | ✅ | ✅ |
| [postgres](moekai/postgres) | Easy tool to deploy a PostgreSQL instance on Kubernetes. | ❌ | ✅ |
| [postgres-agent](moekai/postgres-agent) | Easily create or delete a database and user pair in a remote PostgreSQL instance. | ✅ | ✅ |
| [rizz](moekai/rizz) | Rizz is a simple web application that tracks and posts content from RSS Feeds to federated social network. | ✅ | 🔒 |
| [snipe-it](moekai/snipe-it) | Snipe-IT was made for IT asset management, to enable IT departments to track who has which laptop, when it was purchased, which software licenses and accessories are available, and so on. | ✅ | ✅ |
| [syncthing](moekai/syncthing) | Syncthing is a continuous file synchronization program. It synchronizes files between two or more computers. | ✅ | ✅ |
| [telego](moekai/telego) | Telego is an easy to use Telegram bot framework built on top of Django. | ✅ | 🔒 |
| [uptimekuma](moekai/uptimekuma) | Uptime Kuma is an easy-to-use self-hosted monitoring tool. | ✅ | ✅ |
| [vaultwarden](moekai/vaultwarden) | An alternative server implementation of the Bitwarden Client API written in Rust and compatible with official Bitwarden clients. | ✅ | ✅ |
| [vpbot](moekai/vpbot) | Vpbot is a Telegram bot with support for a number of useful features such as prayer time notifications, COVID-19 statistics, and more. | ✅ | 🔒 |
| [waktusolat](moekai/waktusolat) | Waktu Solat is a simple web application that posts local prayer times to federated social network. | ✅ | 🔒 |
| [yuzu-multiplayer](moekai/yuzu-multiplayer) | Quickly stand up new dedicated multiplayer lobbies that will be broadcasted on yuzu. | ❌ | ✅ |

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

1. Get the values file of the chart you wish to install or an existing installation (release).

    Get the latest chart values file for a new installation:

    ```sh
    helm show values moekai/${helmChart} > values.yaml
    ```

    Alternatively, get the values file of an existing release:

    ```sh
    helm get values ${releaseName} --namespace ${namespace} > values.yaml
    ```

    Replace `${helmChart}`, `${releaseName}`, and `${namespace}` accordingly.

2. Edit your chart values file with the intended configurations:

    ```sh
    nano values.yaml
    ```

    Pay extra attention to the descriptions and sample values provided in the chart values file.

3. Install a new release for the desired chart or upgrade an existing release:

    ```sh
    helm upgrade --install ${releaseName} moekai/${helmChart} --namespace ${namespace} --create-namespace --values values.yaml --wait
    ```

    Replace `${releaseName}`, `${helmChart}`, and `${namespace}` accordingly.

4. Verify that your chart release has been installed:

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

## License

This project is licensed under the [AGPL-3.0-only](https://choosealicense.com/licenses/agpl-3.0) license. Please refer to the [LICENSE](LICENSE) file for more information.
