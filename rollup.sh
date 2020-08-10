#! /usr/bin/env bash

set -euo pipefail

./ssh-rollup.sh
./wireguard-rollup.sh
