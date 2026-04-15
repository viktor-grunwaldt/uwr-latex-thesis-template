# this is example run for vm-nix, for vm-apt replace nix with apt everythere here
# get base image
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img -O ~/images/ubuntu.img
qemu-img create -f qcow2 -F qcow2 -b ~/images/ubuntu.img vm-nix.qcow2 20G
# use cloyd-init locally to set up vm with ssh runnig
cloud-localds seed.img user-data.yaml meta-data.yaml

qemu-system-x86_64 \
    -m 4096 \
    -smp 4 \
    -nographic \
    -drive file=vm-nix.qcow2,format=qcow2 \
    -drive file=seed.img,format=raw \
    -net nic -net user,hostfwd=tcp::2222-:22

# note: /tmp should not contain qcow2 images
scp -P 2222 -r /tmp/praca-inz/ ubuntu@127.0.0.1:/home/ubuntu/
ssh -p 2222 ubuntu@127.0.0.1

# now run the benchmark script ~/praca-inz/nix-setup.sh
