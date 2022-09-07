# home

🚶‍♂️ Staying home...

---

# setting up new cluster

Nodes are `pi3` and `pi4`, IPs `192.168.68.109` and `192.168.68.110` respectively.

## setup hosts

> TODO: I should probably make part of this in one host, then duplicate the
> sd-card. This shit takes forever to finish.

```sh
# export IP=192.168.68.109
# export IP=192.168.68.110

# make ssh pi3 and ssh pi4 work
echo '
Host pi3 pi4
  User ubuntu

Host pi3
  HostName pi3.local

Host pi4
  HostName pi4.local
' >>~/.ssh/config

# will ask to change password et al
ssh ubuntu@$IP

# copy ssh pubkey
ssh-copy-id ubuntu@$IP

# ssh again
ssh ubuntu@$IP

# sudo hostname pi3
# sudo hostname pi4
hostname | sudo tee /etc/hostname
sudo sed -i'' "s/127.0.0.1 localhost/127.0.0.1 localhost $(hostname)/" /etc/hosts
sudo apt update
sudo apt upgrade -qy
sudo dpkg-reconfigure unattended-upgrades
sudo reboot
sudo apt autoremove
sudo apt autoclean
sudo apt install -qy avahi-daemon              # makes pi3.local and pi4.local work :)
sudo apt install -qy linux-modules-extra-raspi # needed for k3s, takes forever, especially on the pi3


sudo timedatectl set-ntp true
sudo timedatectl set-timezone America/Sao_Paulo
sudo timedatectl timesync-status
date

sudo reboot
```

## setup tailscale

```sh
curl -fssl https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
curl -fssl https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale
sudo tailscale up -authkey $tskey
```

## setup k3s

```sh
curl -sLS https://get.k3sup.dev | sh
k3sup install --user ubuntu --ip 192.168.68.110 --local-path ~/.kube/config --ssh-key ~/.ssh/id_ed25519
k3sup join --user ubuntu --ip 192.168.68.109 --server-ip 192.168.68.110 --ssh-key ~/.ssh/id_ed25519

kubectl config set-context default
kubectl get nodes -w -owide
```

## install stuff

```sh
flux create source helm prometheus-community --url https://prometheus-community.github.io/helm-charts
flux create source helm grafana --url https://grafana.github.io/helm-charts
flux create source helm influxdata --url https://helm.influxdata.com
flux create source helm traefik --url https://helm.traefik.io/traefik
```
