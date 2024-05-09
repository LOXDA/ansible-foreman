#!/bin/bash

OS_TOKEN=$(curl -k -si \
  -H "Content-Type: application/json" \
  -d '{"auth":{"identity":{"methods":["password"],"password":{"user":{"domain":{"id":"default"},"name":"tomm","password":"papillon"}}}}}' \
  "https://192.168.83.135:5000/v3/auth/tokens" | awk '/x-subject-token/ {print $2}')

# curl -k -s \
#  -H "X-Auth-Token: $OS_TOKEN" \
#  "https://192.168.83.135:5000/v3/domains" | jq '[ .domains[] | { (.name|tostring): .id } ]'

# curl -k -s \
#  -H "X-Auth-Token: $OS_TOKEN" \
#  "https://192.168.83.135:5000/v3/projects" | jq '[ .projects[] | { (.name|tostring): .id } ]'

OPN_IMAGES=$(curl -k -s \
 -H "X-Auth-Token: $OS_TOKEN" \
 "https://192.168.83.135:8774/v2.1/images" | jq -c '.images[] | select( .name == "Debian-11") | .id')
echo "OPN_IMAGES=$OPN_IMAGES"

OPN_FLAVORS=$(curl -k -s \
 -H "X-Auth-Token: $OS_TOKEN" \
 "https://192.168.83.135:8774/v2.1/flavors" | jq -c '.flavors[] | select( .name == "m1.small") | .id')
echo "OPN_FLAVORS=$OPN_FLAVORS"

# curl -k -s -u "admin:papillon" \
#  -H "Accept: version=2,application/json" \
#  -H "Content-Type: application/json" \
#  https://192.168.1.81/api/compute_attributes | jq '.results[]'

curl -k -s -u "admin:papillon" \
 -H "Accept: version=2,application/json" \
 -H "Content-Type: application/json" \
 https://192.168.1.81/api/compute_resources | jq '.results[]'
