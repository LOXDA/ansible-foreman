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

### Ansible repo to provision an instance of theforeman with custom set of parameters (deploy & provision)

Setup deployement:

Using a working python environnement, or activate a virtualenv :

```
    pip3 install -r ./requirement.txt
    export ANSIBLE_COLLECTIONS_PATH=./collections
    ansible-galaxy collection install -r roles/requirements.yml
    export ANSIBLE_ROLES_PATH=./roles
    ansible-galaxy role install -r roles/requirements.yml
```

Run examples :
```
# clean environment (ONLY IF YOU NEED SOME CLEANUP)
unset $(set | grep --line-buffered ^ANSIBLE_ | awk -F= '{print $1}')
```
```
# deploy whole
ansible-playbook -i inventory/lab playbooks/foreman_deploy.yml
```
```
# deploy only individual parts
ansible-playbook -i inventory/lab playbooks/foreman_puppet.yml --tags puppet
ansible-playbook -i inventory/lab playbooks/foreman_db.yml --tags db
ansible-playbook -i inventory/lab playbooks/foreman_app.yml --tags app
ansible-playbook -i inventory/lab playbooks/foreman_proxy.yml --tags proxy,oauth

# +fixdhcp for debian>10 with broken omapi in isc-dhcp packaging
ansible-playbook -i inventory/lab playbooks/foreman_proxy.yml --tags proxy,oauth,fixdhcp
```
```
# provisioning
ansible-playbook -i inventory/lab playbooks/foreman_deploy.yml --tags provisioning
```

Parameters are defined at inventory/group level.<br/>
Be sure to maps your instances to group in inventory files.<br/>
Rename files in host_vars accordingly.<br/>

Some macro views:

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
