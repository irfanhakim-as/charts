# [`yuzu-multiplayer`](https://github.com/yuzu-emu/yuzu-multiplayer-dedicated)

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
cp mika/yuzu-multiplayer/values.yaml .
```

Edit `values.yaml` with the appropriate values.  Please refer to the [Configurations](#configurations) section below, or the `values.yaml` file itself for details and sample values.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/yuzu-multiplayer --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

### Port forwarding

You will need to port forward the service in order to be able to access the multiplayer room on Yuzu. In order to do so, we need to determine the port that we need to forward, the port that the service is listening on (including its required protocol), and the local IP address of the node that the pod is running on.

Assuming that the namespace is `yuzu`, and the release name is `yuzu-preview-0`, run the following command to determine the Virtual Host port:

```sh
kubectl get svc -n yuzu yuzu-preview-0-yuzu-multiplayer-svc
```

Output:

```sh
NAME                                  TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)           AGE
yuzu-preview-0-yuzu-multiplayer-svc   NodePort   10.43.116.12   <none>        24872:30965/UDP   7h37m
```

Based on this particular output, we can determine that the port we need to forward is `30965`.

Irrespective of the output, the port that the service is listening on and its protocol have been set to `24872` (UDP) according to the Yuzu [documentation](https://yuzu-emu.org/help/feature/multiplayer/#port-forwarding).

To determine the node that the pod is running on, run the following command (replace `$pod_name` accordingly):

```sh
kubectl get pod -n yuzu $pod_name -o wide
```

Output:

```sh
NAME                                              READY   STATUS    RESTARTS   AGE   IP           NODE                             NOMINATED NODE   READINESS GATES
yuzu-preview-0-yuzu-multiplayer-fc455d767-tgn9p   1/1     Running   0          37m   10.42.3.52   192.168.0.23                     <none>           <none>
```

Based on this particular output, we can determine that the local IP address of the node that the pod is running on is `192.168.0.23`.

With this information, we can now port forward the service on our router. The steps involved varies between routers, but the following is an example configuration for a D-Link router:

| Enable | Name | Protocol | WAN Host Start IP | WAN Host End IP | WAN Start Port | WAN End Port | LAN Host IP | Virtual Host Port |
|--------|------|----------|-------------------|-----------------|----------------|--------------|-------------|-------------------|
| 1 | yuzu | UDP | - | - | 24872 | 24872 | 192.168.0.23 | 30965 |

After doing so, we should be able to connect to the multiplayer room through Yuzu at `192.168.0.23:30965` based on this example.

## How to upgrade

After making any necessary changes to the `values.yaml` file, upgrade the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm upgrade $release_name mika/yuzu-multiplayer --namespace $namespace --values values.yaml --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.yuzu.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the yuzu-multiplayer container image. Default: `"IfNotPresent"`. |
| image.yuzu.registry | string | `""` | The registry where the yuzu-multiplayer container image is hosted. Default: `"docker.io"`. |
| image.yuzu.repository | string | `""` | The name of the repository that contains the yuzu-multiplayer container image used. Default: `"yuzuemu/yuzu-multiplayer-dedicated"`. |
| image.yuzu.tag | string | `""` | The tag that specifies the version of the yuzu-multiplayer container image used. Default: `Chart appVersion`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| replicaCount | string | `""` | The desired number of running replicas for yuzu-multiplayer. Default: `"1"`. |
| resources.limits.cpu | string | `"300m"` | The maximum amount of CPU resources allowed for yuzu-multiplayer. |
| resources.limits.memory | string | `"300Mi"` | The maximum amount of memory allowed for yuzu-multiplayer. |
| resources.requests.cpu | string | `"50m"` | The minimum amount of CPU resources required by yuzu-multiplayer. |
| resources.requests.memory | string | `"50Mi"` | The minimum amount of memory required by yuzu-multiplayer. |
| yuzu.api | string | `""` | The API endpoint for the Yuzu emulator. Default: `"https://api.yuzu-emu.org"`. |
| yuzu.country | string | `""` | The Alpha-2 code of the country where the multiplayer server is hosted. Default: `"US"`. |
| yuzu.game.id | string | `""` | The Title ID of the preferred game to be hosted on the multiplayer room. |
| yuzu.game.name | string | `""` | The name of the preferred game to be hosted on the multiplayer room. |
| yuzu.mods | bool | `false` | Specify whether to allow Yuzu Community Moderators to moderate on your room. |
| yuzu.port | string | `""` | The port number that the multiplayer server will be hosted on (0-65535). Default: `24872`. |
| yuzu.region | string | `""` | The name of the region where the multiplayer server is hosted. |
| yuzu.room.description | string | `""` | An optional description of the multiplayer room. |
| yuzu.room.limit | string | `""` | The maximum number of players allowed in the multiplayer room (2-16). Default: `"2"`. |
| yuzu.room.name | string | `""` | The name of the multiplayer room. Default: `"$country $region - $game_name"`. |
| yuzu.room.password | string | `""` | An optional password to restrict access to the multiplayer room. |
| yuzu.token | string | `""` | The Yuzu Community user token required to host the multiplayer server. |
