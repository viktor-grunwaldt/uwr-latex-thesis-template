#!/usr/bin/env bash
set -euo pipefail

cd /home/ubuntu/praca-inz

echo "=== start ==="
START=$(date +%s)

echo "=== Installing TeXLive ==="
sudo apt update
sudo apt install -y texlive-full latexmk

echo "=== Build start ==="
latexmk -pdf -lualatex paper.tex

echo "=== end ==="
END=$(date +%s)

echo "BUILD_TIME=$((END-START))" | tee /home/ubuntu/apt-time.txt
