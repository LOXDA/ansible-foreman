# TFM FOREMAN

One tool to deploy the stack

      +---------------------+
      |      App (code)     |
    ~~+---------------------+~~
      |  Operating System   |
      +---------------------+
      |      (Virtual)      |
    ~~+---------------------+~~
      |      Physical       |
      +---------------------+

### Ansible repo to provision an instance of theforeman with predefined set of parameters

Example:

    ansible-playbook -i inventory/lab playbooks/foreman_deploy.yml

Parameters are defined at inventory/group level.
Be sure to maps your instances to group in inventory

Some visuals

    ansible-playbook-grapher -vvvvvv --include-role-tasks -i inventory/mgmt playbooks/foreman_db.yml

<img src="files/foreman_db.svg" alt="foreman_db svg" width="1200"/><br>

    ansible-playbook-grapher -vvvvvv --include-role-tasks -i inventory/mgmt playbooks/foreman_puppet.yml

<img src="files/foreman_puppet.svg" alt="foreman_puppet svg" width="1200"/><br>

    ansible-playbook-grapher -vvvvvv --include-role-tasks -i inventory/mgmt playbooks/foreman_app.yml

<img src="files/foreman_app.svg" alt="foreman_app svg" width="1200"/><br>

    ansible-playbook-grapher -vvvvvv --include-role-tasks -i inventory/mgmt playbooks/foreman_proxy.yml --tags fixdhcp

<img src="files/foreman_proxy.svg" alt="foreman_proxy svg" width="1200"/><br>

    ansible-playbook-grapher -vvvvvv --include-role-tasks -i inventory/mgmt playbooks/foreman_provisioning.yml --tags provisioning

<img src="files/foreman_provisioning.svg" alt="foreman_provisioning svg" width="1200"/><br>

    ansible-playbook-grapher -vvvvvv --include-role-tasks -i inventory/mgmt playbooks/foreman_deploy.yml --tags tfm,fixdhcp,provisioning

<img src="files/foreman_deploy.svg" alt="foreman_deploy svg" width="1200"/><br>

## Requirements

see requirement.txt