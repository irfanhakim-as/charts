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

### Generate secret key for [`secret.telego.SECRET_KEY`](values.yaml)

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

Install [`mika/postgres-createdb`](../postgres-createdb/). This step can be skipped if you have an existing PostgreSQL database.

### Prepare chart values

Copy `values.yaml` from the chart you would like to install.

```sh
cp mika/telego/values.yaml .
```

Edit `values.yaml` with the appropriate values. Refer to the [Configuration](#Configuration) section for the available options.

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
"""
Commands repository for the telego project.
Telegram commands for the telego module should be placed and called from here.
"""
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
            'test': {
                'description': 'simple debug command returning your input',
                'emoji': '🤵‍♂️',
                'method': self.test,
            },
            'menu': {
                'description': 'returns a menu of command prompts to choose from',
                'emoji': '🔮',
                'method': self.menu,
            },
        })

    # add command methods
    def test(self, **kwargs):
        msg = None
        inline_keyboard = None
        sender = kwargs.get('sender')
        first_name = kwargs.get('first_name')
        command = kwargs.get('command')
        param = kwargs.get('param')
        
        msg = message('TEST_COMMAND', chat_id=sender, first_name=first_name, command=command, param=param)
        return msg,inline_keyboard

    def menu(self, **kwargs):
        msg = None
        inline_keyboard = None
        command_dict = {}
        
        for command in self.commands.keys():
            emoji = self.commands.get(command).get('emoji')
            command_dict[command] = '%s %s' % (emoji, command.title())
        msg=message('MENU_COMMAND')
        inline_keyboard=gen_inline_keyboard(command_dict)
        return msg,inline_keyboard
```

To add additional Telegram messages, create a custom `messages.py` file with both `messages` and `icons` dict.

```python
"""
Messages for the telego project.
Messages for the telego module should be placed and called from here.
"""


# messages dict
messages = {
    "TEST_COMMAND" : '🤵‍♂️ Chat ID: {chat_id}' \
                    '\n📛 First name: {first_name}' \
                    '\n🎤 Command: {command}' \
                    '\n💬 Param: {param}',
    "MENU_COMMAND" : '🔮 Please select a command',
}

# icons dict
icons = {
    'OK' : '✅',
    'ATTENTION' : '🛎',
    'USER' : '🙋🏻‍♂️',
    'EXPIRE' : '⌛️',
    'ACTIVE' : '⏳',
    'WARNING' : '⚠️',
    'DELETE' : '🗑',
    'TOKEN' : '🔐',
    'KEY' : '🔑',
    'GLOBE' : '🌐',
    'APP' : '🧑🏼‍💻',
}
```

Upgrade (or install) the chart while adding the `commands.py` and `messages.py files with the `--set-file` flag.

```sh
helm upgrade $release_name mika/telego --namespace $namespace --create-namespace --values values.yaml --set-file configmap.telego.CUSTOM_COMMANDS=commands.py --set-file configmap.telego.CUSTOM_MESSAGES=messages.py --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

### Delete database

Install [`mika/postgres-dropdb`](../postgres-dropdb/).

## Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| db.host | string | `"postgres.default.svc.cluster.local"` | Database server |
| db.name | string | `""` | Database name |
| db.password | string | `""` | Database user password |
| db.port | string | `"5432"` | Database port |
| db.type | string | `"postgresql"` | Database type |
| db.user | string | `""` | Database user |
| image.ngrok.pullPolicy | string | `"IfNotPresent"` | Ngrok image pull policy |
| image.ngrok.registry | string | `"docker.io"` | Ngrok image registry |
| image.ngrok.repository | string | `"wernight/ngrok"` | Ngrok image repository |
| image.ngrok.tag | string | `"latest"` | Ngrok image version |
| image.telego.pullPolicy | string | `"IfNotPresent"` | Telego image pull policy |
| image.telego.registry | string | `"ghcr.io"` | Telego image registry |
| image.telego.repository | string | `"irfanhakim-as/telego"` | Telego image repository |
| image.telego.tag | string | `""` | Telego image version |
| imagePullSecrets[0].name | string | `"ghcr-token-secret"` | Name of the image pull secret |
| pvc.logs.storage | string | `"10Mi"` | Log files storage size |
| pvc.logs.storageClassName | string | `"longhorn"` | Log files storage class name |
| resources.limits.cpu | string | `"100m"` | Maximum CPU allocation |
| resources.limits.memory | string | `"100Mi"` | Maximum memory allocation |
| resources.requests.cpu | string | `"10m"` | Minimum CPU allocation |
| resources.requests.memory | string | `"10Mi"` | Minimum memory allocation |
| telego.cloudflared.domain | string | `""` | Telego domain |
| telego.cloudflared.enabled | bool | `false` | Enable cloudflare tunnel |
| telego.commands | file | `""` | Custom `commands.py` file |
| telego.debug | bool | `false` | Enable debug mode |
| telego.messages | file | `""` | Custom `messages.py` file |
| telego.name | string | `"Telego"` | Telego application name |
| telego.ngrok.enabled | bool | `true` | Enable ngrok tunnel |
| telego.ngrok.token | string | `""` | Ngrok authentication token |
| telego.secret | string | `""` | Telego secret key |
| telego.telegram.token | string | `""` | Telegram bot token |
| telego.telegram.webhook | string | `"telegram/webhooks/"` | Telegram webhook path |
