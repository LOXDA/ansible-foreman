# very lazy way of not using user_data to accomplish the same result

.venv/bin/ansible -i inventory/opn -m shell -a 'sudo sed -i -e "s/127.0.0.1 localhost/# 127.0.0.1 localhost/" /etc/hosts' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo sed -i -e "s/127.0.1.1/127.0.0.1/" /etc/hosts' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo sed -i -e "s/openstacklocal/opn.lab/" /etc/hosts' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo sed -i -e "s/opn.lab./opn.lab/" /etc/hosts' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo sed -i -e "s/ - update_etc_hosts/#  - update_etc_hosts/" /etc/cloud/cloud.cfg' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo echo "Acquire::ForceIPv4 \"true\";" | sudo tee /etc/apt/apt.conf.d/99force-ipv4' tfm

.venv/bin/ansible -i inventory/opn -m shell -a 'sudo echo "Europe/Paris" | sudo tee /etc/timezone' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo dpkg-reconfigure -f noninteractive tzdata' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo echo "LANG=\"en_US.UTF-8\"" | sudo tee /etc/default/locale' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo dpkg-reconfigure --frontend=noninteractive locales' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo update-locale LANG=en_US.UTF-8' tfm

.venv/bin/ansible -i inventory/opn -m shell -a 'sudo DEBIAN_FRONTEND=noninteractive apt-get -qy update' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo DEBIAN_FRONTEND=noninteractive apt-get -qy upgrade' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo DEBIAN_FRONTEND=noninteractive apt-get -qy install gpg' tfm
.venv/bin/ansible -i inventory/opn -m shell -a 'sudo DEBIAN_FRONTEND=noninteractive apt-get -qy clean' tfm

# the correct way using user_data:

#cloud-config
hostname: {{ inventory_hostname_short }}
fqdn: {{ inventory_hostname }}
chpasswd:
  list: |
    debian:papillon
  expire: False
packages:
  - gpg
package_upgrade: true
manage_etc_hosts: false
runcmd:
  - echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4