#! /usr/bin/env bash

set -euo pipefail

erika_path="dotfiles/erika/.ssh/authorized_keys"
primary_path="dotfiles/primary/.ssh/authorized_keys"

files=$(ls rsa)

echo -n "" > $erika_path
echo -n "" > $primary_path

for file in $files; do
  echo "#$file" >> $erika_path
  cat rsa/$file >> $erika_path
done

for file in $files ; do
  if [ "$file" = "umaru" ] ; then
    continue
  fi
  echo "#$file" >> $primary_path
  cat rsa/$file >> $primary_path
done

jq_input=""
for file in $files ; do
  if [ "$file" = "umaru" ] ; then
    continue
  fi

  jq_input+=$(echo "$file|$(cat rsa/$file)\n")
done

echo -en $jq_input | jq -R 'split("|") | {id: .[0], key: .[1]}' | jq -s > ssh.json
