# Mika Chart Library for Kubernetes

Applications, developed or curated by [mika](https://github.com/irfanhakim-as), ready to install using [Helm](https://helm.sh).

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