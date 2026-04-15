# Microbenchmark: Nix vs apt for LaTeX builds

This directory contains scripts used to benchmark two approaches for building the thesis PDF:

- **Nix** (`nix build`) — uses the project's `flake.nix`
- **apt** (`apt install texlive-full`) — installs the full TeX Live distribution from Ubuntu packages

## Results

|                          | `apt install texlive-full` | `nix build`  |
|--------------------------|:--------------------------:|:------------:|
| Install + build time (s) | 2083                       | **179**      |
| VM disk usage (GiB)      | 14.70                      | **1.99**     |

Nix is ~**11× faster** to set up and build, and uses ~**7× less disk space**.

## How the Benchmark Was Run

Each approach was tested in a fresh, isolated Ubuntu 24.04 (Noble) QEMU virtual machine to avoid any caching or pre-installed software influencing the results.

### 1. Provision a VM

`vm-orchestration.sh` shows the full sequence:

1. Download the Ubuntu Noble cloud image.
2. Create a copy-on-write disk with `qemu-img`.
3. Build a `cloud-init` seed image from `user-data.yaml` and `meta-data.yaml`.
4. Boot the VM with QEMU (4 GiB RAM, 4 vCPUs), forwarding port 2222 → guest SSH.
5. Copy the repo into the VM with `scp` and SSH in.

Repeat for two separate VMs — one for the Nix run, one for the apt run.

### 2. Run the benchmark

Inside the VM, execute the appropriate setup script:

| Approach | Script        | Output file           |
|----------|---------------|-----------------------|
| apt      | `apt-setup.sh`  | `~/apt-time.txt`    |
| Nix      | `nix-setup.sh`  | `~/nix-time.txt`    |

Both scripts measure wall-clock time from start to a finished PDF and write `BUILD_TIME=<seconds>` to a file.

**`apt-setup.sh`** runs:
```sh
sudo apt update && sudo apt install -y texlive-full latexmk
latexmk -pdf -lualatex paper.tex
```

**`nix-setup.sh`** runs:
```sh
# Install Nix + enable flakes
curl -L https://nixos.org/nix/install | sh -s -- --yes --daemon --no-channel-add
nix build
```

### 3. Cloud-init configuration

`user-data.yaml` configures the VM's `ubuntu` user with passwordless sudo and your SSH public key (replace `YOUR KEY HERE` before use). `meta-data.yaml` sets the hostname to `vm`.
