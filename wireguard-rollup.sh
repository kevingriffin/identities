#! /usr/bin/env bash

set -euo pipefail

rollup_path="wireguard-hosts.json"

files=$(ls wireguard)

jq_input=""
for file in $files ; do
  host=$(echo $file | cut -d . -f1)
  ordinal=$(echo $file | cut -d . -f2)
  jq_input+=$(echo "$ordinal|$host|$(cat wireguard/$file)\n")
done

echo -en $jq_input | jq -R 'split("|") | {(.[1]): {ordinal: .[0] | tonumber,  publicKey: .[2] }}' | jq -s add > wireguard-hosts.json
