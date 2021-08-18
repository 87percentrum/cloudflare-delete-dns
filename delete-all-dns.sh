#!/bin/bash
# delete all DNS records for a domain on cloudflare

API_KEY="YOUR_KEY"
TOKEN="YOUR_TOKEN"
DOMAIN_NAME="DOMAIN_YOU_WANT_TO_DELETE_DNS_ENTRIES_FOR"

CURL_STRING="https://api.cloudflare.com/client/v4/zones?name=${DOMAIN_NAME}&status=active&account.id=92c14fb0261d4c0651801e5fa56c7818&match=all"

ZONE_ID=$(curl -s -X GET "${CURL_STRING}" -H 'X-Auth-Email: umut@yalcinkaya.ninja' -H 'X-Auth-Key: bd346a54174ddf4ae538aaa85f900a54dff66' -H 'Content-Type: application/json' --stderr - | jq -r ".result[0].id")

curl -s -X GET https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?per_page=500 \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" | jq .result[].id |  tr -d '"' | (
  while read id; do
    curl -s -X DELETE https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${id} \
      -H "Authorization: Bearer ${TOKEN}" \
      -H "Content-Type: application/json"
  done
  )
