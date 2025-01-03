#!/bin/bash

FOREMAN_URL="https://tfm-app.opn.lab"
alias foreman.opn='hammer -s $FOREMAN_URL'

# associative array from command output
declare -A image; while IFS=" " read -r a b; do image["$b"]="$a"; done < <(openstack image list -f value -c ID -c Name)
declare -A flavor; while IFS=" " read -r a b; do flavor["$b"]="$a"; done < <(openstack flavor list -f value -c ID -c Name)
declare -A network; while IFS=" " read -r a b; do network["$b"]="$a"; done < <(openstack network list -f value -c ID -c Name)
declare -A project; while IFS=" " read -r a b; do project["$b"]="$a"; done < <(openstack project list -f value -c ID -c Name)

# build a host
echo "creating openstack host in foreman..";
foreman.opn host create \
--name "openstack-test1" \
--organization "OPN" \
--location "OPN" \
--hostgroup-title 'opn/os/debian' \
--compute-resource-id '2' \
--provision-method image \
--architecture-id "1" \
--operatingsystem "Debian 12" \
--compute-attributes "\
security_groups=[ALLOW_ALL],\
flavor_ref=8efe6693-c78b-4e54-8371-4b032169f551,\
image_ref=${image['Debian-12']},\
tenant_id=${project['test1']},\
nics=[${network['vlan5_adm']}]"

# associative array manually
#declare -A network=([vlan5_adm]=3225e32e-fb3b-4d4b-bf08-40f69e4e6e75 [vlan5]=c34a1b56-9cba-45f4-b013-74d031184623)

# # some bash voodo to show associative array
# for ITEM_NAME in "${!hostgroup[@]}"; do
#     ITEM_VALUE="${hostgroup[$ITEM_NAME]}"
#     echo "${ITEM_NAME} => ${ITEM_VALUE}"
# done
