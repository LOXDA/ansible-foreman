# clone repo

git clone --recurse-submodules --shallow-submodules 

# Debian 12 (bookworm) install :

you need python3, pip, virtualenv

    bash
    apt-get -qy install python3 python3-pip virtualenv

create virtualenv

    bash
    virtualenv -p python3 .venv
    .venv/bin/pip3 install -r requirement.txt

### psycopg2 require package libpq-dev for "pg_config"

# create instance for group tfm
.venv/bin/ansible-playbook -i inventory/opn playbooks/create_instance.yml --limit tfm

# deploy foreman on hosts in inventory opn
.venv/bin/ansible-playbook -i inventory/opn playbooks/deploy_foreman.yml
