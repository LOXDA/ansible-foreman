#!/bin/bash

ANSIBLE_GRAPHER_OPT="-i inventory/lab -vvvvvv --include-role-tasks --renderer graphviz"

ansible-playbook-grapher $ANSIBLE_GRAPHER_OPT -o files/foreman_db.svg playbooks/foreman_db.yml 
ansible-playbook-grapher $ANSIBLE_GRAPHER_OPT -o files/foreman_app.svg playbooks/foreman_app.yml
ansible-playbook-grapher $ANSIBLE_GRAPHER_OPT -o files/foreman_proxy.svg playbooks/foreman_proxy.yml
ansible-playbook-grapher $ANSIBLE_GRAPHER_OPT -o files/foreman_puppet.svg playbooks/foreman_puppet.yml
ansible-playbook-grapher $ANSIBLE_GRAPHER_OPT -o files/foreman_provisioning.svg playbooks/foreman_provisioning.yml --tags provisioning
ansible-playbook-grapher $ANSIBLE_GRAPHER_OPT -o files/foreman_deploy.svg playbooks/foreman_deploy.yml --tags tfm,fixdhcp,provisioning
