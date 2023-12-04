# Mika Chart Library for Kubernetes

Applications, developed or curated by [mika](https://github.com/irfanhakim-as), ready to install using [Helm](https://helm.sh).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Chart Directory

| Chart Name | Description | Support | Access |
| ---------- | ----------- | ------- | ------ |
| [clog](https://github.com/irfanhakim-as/charts/tree/master/mika/clog) | Creative blog, Career blog, Coin blog, you name it. | ✅ | 🔒 |
| [cloudflared](https://github.com/irfanhakim-as/charts/tree/master/mika/cloudflared) | Cloudflare Tunnel is a tunneling software that lets you quickly secure and encrypt application traffic to any type of infrastructure. | ✅ | ✅ |
| [cloudflareddns](https://github.com/irfanhakim-as/charts/tree/master/mika/cloudflareddns) | Access your home network remotely via a custom domain name without a static IP! | ✅ | ✅ |
| [grocy](https://github.com/irfanhakim-as/charts/tree/master/mika/grocy) | Grocy is a web-based self-hosted groceries & household management solution for your home. | ✅ | ✅ |
| [mango](https://github.com/irfanhakim-as/charts/tree/master/mika/mango) | Mango is an easy to use Mastodon bot framework built on top of Django. | ✅ | 🔒 |
| [mariadb-agent](https://github.com/irfanhakim-as/charts/tree/master/mika/mariadb-agent) | Easily deploy a database and create a user, or delete a database in a remote MariaDB instance. | ✅ | ✅ |
| [postgres](https://github.com/irfanhakim-as/charts/tree/master/mika/postgres) | Easy tool to deploy a PostgreSQL instance on Kubernetes. | ✅ | ✅ |
| [postgres-agent](https://github.com/irfanhakim-as/charts/tree/master/mika/postgres-agent) | Easily deploy a database and create a user, or delete a database in a remote PostgreSQL instance. | ✅ | ✅ |
| [rizz](https://github.com/irfanhakim-as/charts/tree/master/mika/rizz) | Rizz is a simple web application that tracks and posts content from RSS Feeds to Mastodon. | ✅ | 🔒 |
| [telego](https://github.com/irfanhakim-as/charts/tree/master/mika/telego) | Telego is an easy to use Telegram bot framework built on top of Django. | ✅ | 🔒 |
| [vpbot](https://github.com/irfanhakim-as/charts/tree/master/mika/vpbot) | Vpbot is a Telegram bot with support for a number of useful features such as prayer time notifications, COVID-19 statistics, and more. | ✅ | 🔒 |
| [waktusolat](https://github.com/irfanhakim-as/charts/tree/master/mika/waktusolat) | Waktu Solat is a simple web application that posts local prayer times on Mastodon. | ✅ | 🔒 |
| [yuzu-multiplayer](https://github.com/irfanhakim-as/charts/tree/master/mika/yuzu-multiplayer) | Quickly stand up new dedicated multiplayer lobbies that will be broadcasted on yuzu. | ✅ | ✅ |

## How to add repo

Add the repo to your local helm client.

```sh
helm repo add mika https://irfanhakim-as.github.io/charts
```

Update the repo to retrieve the latest versions of the packages.

```sh
helm repo update
```

## How to install a chart

### Prepare chart values

Copy `values.yaml` from the chart you would like to install. Replace `$helm_chart` accordingly.

```sh
cp mika/$helm_chart/values.yaml .
```

Edit `values.yaml` with the appropriate values.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name`, `$helm_chart` and `$namespace` accordingly.

```sh
helm install $release_name mika/$helm_chart --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

## How to upgrade a chart

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name`, `$helm_chart` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/$helm_chart --namespace $namespace --values values.yaml --wait
```

## How to uninstall a chart

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```