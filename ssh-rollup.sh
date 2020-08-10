#! /usr/bin/env bash

set -euo pipefail

authorized_keys_path="dotfiles/.ssh/authorized_keys"
backup_authorized_keys_path="backup-dotfiles/.ssh/authorized_keys"

files=$(ls rsa)

echo -n "" > $authorized_keys_path

for file in $files; do
  echo "#$file" >> $authorized_keys_path
  cat rsa/$file >> $authorized_keys_path
done

cp $authorized_keys_path $backup_authorized_keys_path

for file in $(ls rsa-backup); do
  echo "#$file" >> $backup_authorized_keys_path
  cat rsa-backup/$file >> $backup_authorized_keys_path
done

jq_input=""
for file in $files ; do
  jq_input+=$(echo "$file|$(cat rsa/$file)\n")
done

echo -en $jq_input | jq -R 'split("|") | {id: .[0], key: .[1]}' | jq -s > ssh.json
