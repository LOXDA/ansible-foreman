#!/bin/bash

git pull --rebase
git submodule update --remote

# prepare
# ansible-playbook -i inventory/opn playbooks/deploy_dns.yml
# ansible-playbook -i inventory/opn playbooks/deploy_ldap.yml

# deploy theforeman
ansible-playbook -i inventory/opn playbooks/create_instance.yml --limit tfm
ansible-playbook -i inventory/opn playbooks/deploy_foreman.yml

# provisioning
ansible-playbook -i inventory/opn playbooks/deploy_foreman.yml --tags provisioning
