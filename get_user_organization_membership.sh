#!/bin/bash

# This script requires curls the admin endpoint of TFE and makes all organizations of an user available to Terraform as an external datasource.
# It has only been tested with bash on MacOS and requires the following tools:
#  - curl
#  - jq
# You have to export the BEARER Token like this: export TOKEN=asd123
# The token can be generated in the TFE UI. The user must be an admin. Ordinary users cannot access the 'api/v2/admin' endpoint.

# Exit if any of the intermediate steps fail
set -xe

# The TFE instance to query
TFE_HOST='tfe.msk.local'

# Get username from Terraform and export it as environment variable. It can then later be used by the curl command.
eval "$(jq -r '@sh "export USERNAME=\(.username)"')"

# Remove the '-k' if you have proper certificates configured.
data=$(curl -k \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://$TFE_HOST/api/v2/admin/users?q=$USERNAME" | jq '.data')

if [ $data = "[]" ]; then
  echo {}
else
  echo "$data" | jq '.[].relationships.organizations.data | map({(.id): .id}) | add'
fi
