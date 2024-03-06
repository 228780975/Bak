#!/bin/bash

## Define your Cloudflare API key and email
CLOUDFLARE_API_KEY=your_api_key
CLOUDFLARE_EMAIL=your_email

## Define the domain and record you want to update
RECORD=your_record
ZONEID=your_zoneid
RECORDID=your_recordid

## Get the current public IP address
IP=$(curl -s https://api.ipify.org)

## Get the current IP address on Cloudflare
CF_IP=$(curl -s https://api.cloudflare.com/client/v4/zones/$ZONEID/dns_records/$RECORDID \
  -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
  -H "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  -H "Content-Type: application/json" \
  | jq '.result.content' \
  | tr -d \")

## Update the IP address on Cloudflare if it has changed
if [ "$IP" != "$CF_IP" ]; then
  curl -s https://api.cloudflare.com/client/v4/zones/$ZONEID/dns_records/$RECORDID \
    -X PATCH \
    -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
    -H "Authorization: Bearer $CLOUDFLARE_API_KEY" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$RECORD\",\"content\":\"$IP\"}"
fi
