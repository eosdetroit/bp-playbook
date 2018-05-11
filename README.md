# Block Producer Ansible Playbook

This playbook is designed to make remote management of EOS nodes a breeze.

Tested using Ansible 2.3.2.0 deploying to Ubuntu 16.04.

## Pre-reqs
1) Ansible >=2.3.2 
2) An Ubuntu install you can access over the internet (VM, VPS, etc).

## To Use
1) Define an inventory "dev.nodes". e.g. (NOTE: This inventory group maps to `/group_vars/dev/`)
```
[dev]
hacktildawn ansible_host=19.210.57.102 ansible_connection=ssh ansible_user=ubuntu
```

2) Create `group_vars/dev/vault.yml and put secrets (e.g. producer keypair) into it. (NOTE: This example vault file has throwaway keys. Always encrypt and never put your vault in version control.)
```
---
vault_public_block_signing_key: EOS5EYm5qF42P9nvGi6Hej7ouDtEz2WRwxvgbSWE1RZM6kCbGryac
vault_private_block_signing_key: 5HyUavRk3QLcD2uyjNpzQpS4DaZgyVHgm7pwiUoBxQDUBowZsXM
```

3) Encrypt your vault file with a high entropy passphrase. 
```
ansible-vault encrypt group_vars/dev/vault.yml
```

4) Save your vault passphrase somewhere safe like a password manager.

5) Run the deploy_bp.yml playbook. Example:

 -i INVENTORY_FILE
 -e EXTRAS (override any vars in group_vars/all by passing key=value)
 --key-file required if using ssh key authentication

```
ansible-playbook --ask-vault-pass -vvv -i dev.nodes -e "target=hacktildawn" --key-file ~/.ssh/hacktildawn.pem deploy_bp.yml
```

## TODO
 - Allow a container image to be updated to a new version while preserving chain data.
   - specify whether to preserve or destroy chain data.
 - Allow a node "type" to be specified (producer, api, storage, etc.)
