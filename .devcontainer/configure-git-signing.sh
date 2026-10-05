#!/usr/bin/env bash

# Configure Git to use SSH signing with the specified public key and allowed signers file.

# This workspace mounts separate public keys for commit signing and GitHub
# authentication.
#
# On each container start, Git is configured to use the corresponding private
# keys from the forwarded SSH agent. Selecting the authentication key explicitly
# is important when the host agent contains keys for multiple GitHub accounts,
# because GitHub otherwise accepts the first recognized key offered.

set -euo pipefail

signing_key="/home/vscode/.ssh/git-signing-key.pub"
github_auth_key="/home/vscode/.ssh/github-auth-key.pub"
git_config_dir="${XDG_CONFIG_HOME:-/home/vscode/.config}/git"
allowed_signers="$git_config_dir/allowed_signers"
known_hosts="$git_config_dir/known_hosts"
signing_identity="$(git config --global user.email)"

if [[ ! -r "$signing_key" ]]; then
    echo "Git signing public key is not readable: $signing_key" >&2
    exit 1
fi

if [[ ! -r "$github_auth_key" ]]; then
    echo "GitHub authentication public key is not readable: $github_auth_key" >&2
    exit 1
fi

if [[ -z "$signing_identity" ]]; then
    echo "Git user.email must be configured before SSH signing can be set up" >&2
    exit 1
fi

mkdir -p "$git_config_dir"
printf '%s %s\n' "$signing_identity" "$(cat "$signing_key")" > "$allowed_signers"
chmod 600 "$allowed_signers"

git config --global user.signingkey "$signing_key"
git config --global gpg.ssh.allowedSignersFile "$allowed_signers"
git config --global core.sshCommand "ssh -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=$known_hosts -i $github_auth_key"
