# [`telego`](https://github.com/irfanhakim-as/telego)

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Preflight checklist

### Create image pull secret

Replace `$github-username`, `$github-pass`, `$github-email` and `$namespace` accordingly.

```sh
kubectl create secret docker-registry ghcr-token-secret --docker-server=https://ghcr.io --docker-username="$github-username" --docker-password="$github-pass" --docker-email="$github-email" -n $namespace
```

### Generate secret key for [`telego.secret`](values.yaml)

```sh
python -c 'import random; print("".join([random.choice("abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)") for i in range(50)]))'
```

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

### Create database

Deploy [`mika/postgres-agent`](../postgres-agent/) with `postgres.mode.create` set to `true`. This step can be skipped if you have an existing PostgreSQL database.

### Prepare chart values

Copy `values.yaml` from the chart you would like to install.

```sh
cp mika/telego/values.yaml .
```

Edit `values.yaml` with the appropriate values. Refer to the [Configurations](#Configurations) section for available options.

```sh
nano values.yaml
```

### Perform installation

Install the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm install $release_name mika/telego --namespace $namespace --create-namespace --values values.yaml --wait
```

Verify that your chart has been installed. Replace `$namespace` and `$release_name` accordingly.

```sh
helm ls --namespace $namespace | grep "$release_name"
```

### Add custom files

To implement additional Telegram commands, create a custom `commands.py` file with a `Commands` class inheriting from `telego.methods.BaseCommand`.

```python
from telego.methods import (
    BaseCommand,
    gen_inline_keyboard,
    icon,
    message,
)

# these variables must always be returned by the command methods
msg = None
inline_keyboard = None


class Commands(BaseCommand):
    def __init__(self):
        super().__init__()

# ================= DO NOT EDIT BEFORE THIS LINE =================

        # add command details
        self.commands.update({
            "test" : {
                "description" : "simple debug command returning your input",
                "emoji" : "🤵‍♂️",
                "method" : self.test,
                "admin" : True,
            },
            "menu" : {
                "description" : "returns a menu of command prompts to choose from",
                "emoji" : "🔮",
                "method" : self.menu,
            },
        })

    # add command methods
    def test(self, **kwargs):
        user = kwargs.get("user")
        command = kwargs.get("command")
        command_obj = self.commands.get(command)
        param = kwargs.get("param")

        if param and (param.lower() == "help" or param.lower() == "?"):
            msg = message("TEST_HELP", emoji=command_obj.get("emoji"), command=command)
        else:
            msg = message("TEST_COMMAND", emoji=command_obj.get("emoji"), chat_id=user.chat_id, first_name=user.first_name, command=command, param=param)
        return msg, inline_keyboard

    def menu(self, **kwargs):
        command_prompts = dict()
        user = kwargs.get("user")
        command = kwargs.get("command")
        commands = self.commands
        command_obj = commands.get(command)

        for key, command_dict in commands.items():
            emoji = command_dict.get("emoji")
            if not command_dict.get("admin") or is_admin(user):
                command_prompts[key] = "%s %s" % (emoji, key.title())

        msg = message("MENU_COMMAND", emoji=command_obj.get("emoji"))
        inline_keyboard = gen_inline_keyboard(command_prompts)
        return msg, inline_keyboard
```

To add additional Telegram messages, create a custom `messages.py` file with both `messages` and `icons` dict.

```python
# messages dict
messages = {
    "TEST_COMMAND" : "{emoji} Chat ID: {chat_id}" \
                    "\n📛 First name: {first_name}" \
                    "\n🎤 Command: {command}" \
                    "\n💬 Param: {param}",
    "TEST_HELP" : "{emoji} `{command}`" \
                    "\n• Submit the command '`{command}`' as is to receive a simple response from the bot" \
                    "\n• Option: Add whatever message after the command to verify that the bot receives your message correctly" \
                    "\n• Example: '`{command} abc 123`' to test if the bot receives '`abc 123`' as a parameter correctly",
    "MENU_COMMAND" : "{emoji} Please select a command",
}

# icons dict
icons = {
    "MENU" : "crystal_ball",
    "TEST" : "man_in_tuxedo",
}
```

Upgrade (or install) the chart while adding the `commands.py` and `messages.py files with the `--set-file` flag.

```sh
helm upgrade --install $release_name mika/telego \
--namespace $namespace \
--values values.yaml \
--set-file telego.commands=commands.py \
--set-file telego.messages=messages.py \
--wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

### Delete database

Deploy [`mika/postgres-agent`](../postgres-agent/) with `postgres.mode.drop` set to `true`.

## Configurations

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| db.host | string | `""` | The hostname or IP address of the Telego database server. |
| db.name | string | `""` | The name of the database used by Telego. |
| db.password | string | `""` | The password associated with the Telego database's user. |
| db.port | string | `""` | The port number on which the Telego database server is listening. Default: `"5432"`. |
| db.type | string | `""` | The type of the database used by Telego. Default: `"postgresql"`. |
| db.user | string | `""` | The username or user account for accessing the Telego database. |
| image.ngrok.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Ngrok container image. Default: `"IfNotPresent"`. |
| image.ngrok.registry | string | `""` | The registry where the Ngrok container image is hosted. Default: `"docker.io"`. |
| image.ngrok.repository | string | `""` | The name of the repository that contains the Ngrok container image used. Default: `"wernight/ngrok"`. |
| image.ngrok.tag | string | `""` | The tag that specifies the version of the Ngrok container image used. Default: `"latest"`. |
| image.redis.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Redis container image. Default: `"IfNotPresent"`. |
| image.redis.registry | string | `""` | The registry where the Redis container image is hosted. Default: `"docker.io"`. |
| image.redis.repository | string | `""` | The name of the repository that contains the Redis container image used. Default: `"redis"`. |
| image.redis.tag | string | `""` | The tag that specifies the version of the Redis container image used. Default: `"alpine"`. |
| image.telego.pullPolicy | string | `""` | The policy that determines when Kubernetes should pull the Telego container image. Default: `"IfNotPresent"`. |
| image.telego.registry | string | `""` | The registry where the Telego container image is hosted. Default: `"ghcr.io"`. |
| image.telego.repository | string | `""` | The name of the repository that contains the Telego container image used. Default: `"irfanhakim-as/telego"`. |
| image.telego.tag | string | `""` | The tag that specifies the version of the Telego container image used. Default: `"Chart appVersion"`. |
| imagePullSecrets | list | `[]` | Credentials used to securely authenticate and authorise the pulling of container images from private registries. |
| replicaCount | string | `""` | The desired number of running replicas for Telego. Default: `"1"`. |
| resources.redis.limits.cpu | string | `"15m"` | The maximum amount of CPU resources allowed for Redis. |
| resources.redis.limits.memory | string | `"60Mi"` | The maximum amount of memory allowed for Redis. |
| resources.redis.requests.cpu | string | `"5m"` | The minimum amount of CPU resources required by Redis. |
| resources.redis.requests.memory | string | `"30Mi"` | The minimum amount of memory required by Redis. |
| resources.telego.limits.cpu | string | `"50m"` | The maximum amount of CPU resources allowed for Telego. |
| resources.telego.limits.memory | string | `"500Mi"` | The maximum amount of memory allowed for Telego. |
| resources.telego.requests.cpu | string | `"10m"` | The minimum amount of CPU resources required by Telego. |
| resources.telego.requests.memory | string | `"250Mi"` | The minimum amount of memory required by Telego. |
| telego.celery_timezone | string | `""` | The timezone for the task scheduler used by Telego to schedule time-dependent operations. Default: `"Asia/Kuala_Lumpur"`. |
| telego.cloudflared.domain | string | `""` | Registered domain name on Cloudflare used for Telego. |
| telego.cloudflared.enabled | bool | `false` | Specifies whether Telego should run using a Cloudflare tunnel. |
| telego.commands | file | `""` | Custom Telegram `commands.py` file for Telego. |
| telego.debug | string | `""` | Specifies whether Telego should run in debug mode. Default: `false`. |
| telego.messages | file | `""` | Custom Telegram `messages.py` file for Telego. |
| telego.name | string | `""` | The name of the Telego service. Default: `"Telego"`. |
| telego.ngrok.enabled | bool | `false` | Specifies whether Telego should run using an Ngrok tunnel. |
| telego.ngrok.token | string | `""` | Ngrok authentication token. |
| telego.persistence.enabled | bool | `false` | Specifies whether Telego should persist its logs. |
| telego.persistence.storage | string | `""` | The amount of persistent storage allocated for Telego logs. Default: `"10Mi"`. |
| telego.persistence.storageClassName | string | `""` | The storage class name used for dynamically provisioning a persistent volume for the Telego logs storage. Default: `"longhorn"`. |
| telego.secret | string | `""` | A 50-character secret key used for secure session management and cryptographic operations within the Telego service. |
| telego.telegram.token | string | `""` | The Telegram bot token used by Telego to communicate with Telegram. |
| telego.telegram.webhook | string | `""` | The Telegram bot webhook path used by Telego to communicate with Telegram. |
