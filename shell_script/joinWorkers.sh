#!/bin/bash
set -e
echo "hostname "$(hostname)
echo "============================================"
uname -a

sudo kubeadm join 10.0.0.251:6443 --token jkpqi7.tf6h0ezgh9gd8m3n \
    --discovery-token-ca-cert-hash sha256:dc9a2a69faa3c435b69327d6083eb7177573f214ddb080e20fce068954a6ec0e

echo "============================================"
