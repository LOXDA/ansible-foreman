#!/bin/bash

git pull --rebase

# prepare
# export ANSIBLE_VAULT_PASSWORD_FILE=.vaultpass
# ansible-playbook -i inventory/lab playbooks/dns.yml

# deploy whole
ansible-playbook -i inventory/lab playbooks/foreman_deploy.yml --tags tfm,fixdhcp

# deploy individual parts
# ansible-playbook -i inventory/lab playbooks/foreman_puppet.yml --tags tfm,puppet
# ansible-playbook -i inventory/lab playbooks/foreman_db.yml --tags tfm,db
# ansible-playbook -i inventory/lab playbooks/foreman_app.yml --tags tfm,app
# ansible-playbook -i inventory/lab playbooks/foreman_proxy.yml --tags tfm,proxy

# provisioning
# ansible-playbook -i inventory/lab playbooks/foreman_deploy.yml --tags provisioning
