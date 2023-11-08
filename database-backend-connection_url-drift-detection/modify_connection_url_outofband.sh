#!/usr/bin/env bash

set -euo pipefail

vault read -format=json db/config/postgres | jq .data.connection_details.connection_url

curl "${VAULT_ADDR}/v1/db/config/postgres" \
  -X POST \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-US,en;q=0.5' \
  -H 'Accept-Encoding: gzip, deflate, br' \
  -H "X-Vault-Token: ${VAULT_TOKEN}" \
  -H 'content-type: application/json; charset=utf-8' \
  --data-raw '{"connection_url":"postgres://{{username}}:{{password}}@postgres/postgres"}'

vault read -format=json db/config/postgres | jq .data.connection_details.connection_url
