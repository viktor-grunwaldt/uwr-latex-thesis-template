#!/usr/bin/env bash
set -euo pipefail

export HOME=/home/ubuntu
cd /home/ubuntu/praca-inz

echo "=== Start ==="

START=$(date +%s)

echo "=== Installing Nix ==="
sudo install -d -m755 -o $(id -u) -g $(id -g) /nix
curl -L https://nixos.org/nix/install | sh -s -- --yes --daemon --no-channel-add
. /etc/profile.d/nix.sh
nix --version

echo "=== Enable flakes ==="
mkdir -p /home/ubuntu/.config/nix
echo "experimental-features = nix-command flakes" >> /home/ubuntu/.config/nix/nix.conf

echo "=== Build ==="

nix build

echo "=== End ==="
END=$(date +%s)

echo "BUILD_TIME=$((END-START))" | tee /home/ubuntu/nix-time.txt
