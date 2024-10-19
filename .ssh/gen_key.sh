#!/usr/bin/env bash

#changing dir to the current script folder
cd "$(dirname "${BASH_SOURCE[0]}")"
ssh-keygen -t ed25519 -f ssh_key -q -N ""