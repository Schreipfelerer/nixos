#!/usr/bin/env bash

set -euo pipefail

# Default to "switch" if no argument given
subcommand="${1:-switch}"

host=$(uname -n)

# Show git diff
echo "==> Showing Git diff:"
git diff || true # Non interactice

# Confirm with user
read -rp "Proceed with nixos-rebuild $subcommand? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || exit 1

# Run nixos-rebuild
echo "==> Running nixos-rebuild $subcommand..."
if sudo nixos-rebuild "$subcommand"; then
    # Get the latest generation name if subcommand affects the system
    if [[ "$subcommand" == "switch" || "$subcommand" == "boot" ]]; then
        gen_name=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -n 1 | awk '{print $1}')

        # Commit the change
        echo "==> Committing changes..."
        git add . > /dev/null
        git commit -m "[$host] Generation: $gen_name" > /dev/null
        git push > /dev/null

        echo "✅ Successfully rebuilt and committed: $gen_name"
    else
        echo "✅ nixos-rebuild $subcommand succeeded (no commit made)."
    fi
else
    echo "❌ nixos-rebuild $subcommand failed."
    exit 1
fi

