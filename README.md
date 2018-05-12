# Block Producer Ansible Playbook

This playbook is designed to make remote management of EOS nodes a breeze.

Currently `deploy_bp.yml` will install system dependencies, create a docker container running nodeos, and put an nginx TLS reverse proxy in front of it.

Tested using Ansible 2.3.2.0 deploying to Ubuntu 16.04.

## Pre-reqs
1) Ansible >=2.3.2 
2) An Ubuntu install you can access over the internet (VM, VPS, etc).

## To Use
1) Define an inventory e.g. "dev.nodes". (NOTE: your inventory group "dev" must match `/group_vars/dev/`)
```
[dev]
hacktildawn ansible_host=19.210.57.102 ansible_connection=ssh ansible_user=ubuntu
```

2) Create `group_vars/dev/vault.yml` and put secrets (e.g. producer keypair) into it. (NOTE: This example vault file has throwaway keys. Always encrypt and never put your vault in version control.)
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

5) Run the deploy_bp.yml playbook.

 - --ask-vault-pass [prompts for vault password]
 - -i INVENTORY_FILE [defines inventory of servers]
 - -e EXTRAS [override any playbook vars by passing space delimited key=value]
 - --key-file [required if using ssh key authentication]

```
ansible-playbook --ask-vault-pass -vvv -i dev.nodes -e "target=hacktildawn" --key-file ~/.ssh/hacktildawn.pem deploy_bp.yml
```

## Playbook vars (Can be passed to -e)
 - host_data_dir [defaults to: /data] the volume to be mounted on the host system.
 - eosio_container_data_dir [defaults to: /opt/eosio/bin/data-dir] the data directory to be mounted on the container. Contains config.ini and genesis.json.
 - container_http_port [defaults to: 8888] The port to expose to the host system for http requests.
 - container_p2p_port [defaults to: 9876] The port to expose to the host system for p2p requests.
 - docker_hub_image [defaults to: eosio/eos] The docker image to use for the container.
 - image_tag [defaults to: dawn-v4.0.0] The docker image tag or version to use.
 - eosio_network_name [defaults to: hacktildawn] A nickname for the network. Used to retrieve the appropriate genesis.json file.
 - agent_name [defaults to: EOS Detroit] A nickname for your nodeos.
 - producer_name [defaults to: eosiodetroit] The name of your producer account.
 - p2p_server_address [defaults to: hacktildawn.eosdetroit.com] The domain name for your node p2p connection. Should be kept secret on main nets.
 - domain_name [defaults to: hacktildawn.eosdetroit.com] The domain name for your https connection (API node).
 - letsencrypt_email [defaults to: rob@eosdetroit.com] The email address to use for letsencrypt.
 - p2p_peers [] A list of peers to connect to.

## TODO
 - Allow a node "type" to be specified (producer, api, storage, etc.)
