# `telego`

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

Edit `values.yaml` with the appropriate values.

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
from telego.messages import telego_msg
from telego.methods import (
    BaseCommand,
    gen_inline_keyboard
)

class Commands(BaseCommand):
    def __init__(self):
        super().__init__()

        # add commands here
        self.commands.update({
            'test': {
                'description': 'simple debug command returning your input',
                'emoji': '🤵‍♂️',
                'method': self.test,
            },
        })

    # add command methods here
    def test(self, **kwargs):
        msg = None
        inline_keyboard = None
        sender = kwargs.get('sender')
        first_name = kwargs.get('first_name')
        command = kwargs.get('command')
        param = kwargs.get('param')
        
        msg = telego_msg(chat_id=sender, first_name=first_name, command=command, param=param)['TEST_COMMAND']
        return msg, inline_keyboard
```

Upgrade (or install) the chart while adding the `commands.py` file with the `--set-file` flag.

```sh
helm upgrade $release_name mika/telego --namespace $namespace --create-namespace --values values.yaml --set-file configmap.telego.CUSTOM_COMMANDS=commands.py --wait
```

## How to uninstall

Uninstall the desired chart. Replace `$release_name` and `$namespace` accordingly.

```sh
helm uninstall $release_name --namespace $namespace --wait
```

### Delete database

Install [`mika/postgres-dropdb`](../postgres-dropdb/).