# Usage

On a Tegra board install wharfie and use it to unpack the kernel modules to root filesystem:

```
wget https://github.com/rancher/wharfie/releases/download/v0.6.7/wharfie-arm64
sudo install -m 0755 wharfie-arm64 /usr/local/bin/wharfie
rm -fv wharfie-arm64
sudo wharfie docker.io/codemowers/tegra-k3s-modules:latest /
```
