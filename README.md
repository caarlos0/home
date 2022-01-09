# home

🚶‍♂️ Staying home...

---

# setting up new cluster

Nodes are `pi3` and `pi4`, IPs `192.168.68.109` and `192.168.68.110` respectively.

## setup hosts

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
sudo apt install -qy avahi-daemon              # makes pi3.local and pi4.local work :)
sudo apt install -qy linux-modules-extra-raspi # needed for k3s

sudo timedatectl set-ntp true
sudo timedatectl set-timezone America/Sao_Paulo
sudo timedatectl timesync-status
date

sudo reboot
```

## setup adguard

> only on pi4

```sh
scp ./files/adguard/config.yaml pi4:/tmp/


ssh pi4 # node that will run adguard only
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
# sudo /opt/AdGuardHome/AdGuardHome -s start|stop|restart|status|install|uninstall
sudo cp -f /tmp/config.yaml /opt/AdGuardHome/AdGuardHome.yaml
sudo /opt/AdGuardHome/AdGuardHome -s restart
```

## setup tailscale

```sh
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale
sudo tailscale up -authkey $TSKEY
```

## setup k3s

```sh
k3sup install --user ubuntu --ip 192.168.68.110 --local-path ~/.kube/config
k3sup join --user ubuntu --ip 192.168.68.109 --server-ip 192.168.68.110

kubectl config set-context default
kubectl get nodes -w -owide
```

## install stuff

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add influxdata https://helm.influxdata.com
helm repo add traefik https://helm.traefik.io/traefik
helm repo update

helm repo update
./yolo
```
