# home

🚶‍♂️ Staying home...

---

# setting up new cluster

Nodes are `pi3` and `pi4`, IPs `192.168.68.109` and `192.168.68.110` respectively.

## setup hosts

```sh
# export IP=192.168.68.109
# export IP=192.168.68.110

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
sudo apt install -qy avahi-daemon # makes pi3.local and pi4.local work :)
sudo reboot
```

## adguard needs to listen on port 53

```sh
ssh ubuntu@$IP

echo "DNSStubListener=no" | sudo tee -a /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved.service
```

## setup k3s

```sh
k3sup install --user ubuntu --host pi4.local --ip 192.168.68.110 --local-path kubeconfig
k3sup join --user ubuntu --host pi3.local --ip 192.168.68.109 --server-ip 192.168.68.110

set -xg KUBECONFIG $PWD/kubeconfig
kubectl get nodes -w -owide
```

## install stuff

```
terraform apply
```
