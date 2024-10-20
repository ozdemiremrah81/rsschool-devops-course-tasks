updated task3 readme
preiously created pem file used to connect the k3s cluster.
download the kubectl config file from : 

scp -i app1_natgw_keypair.pem ubuntu@13.60.183.152:/etc/rancher/k3s/k3s.yaml k3s.yaml
update the server ip address in k3s.yaml
from:    server: https://127.0.0.1:6443
to:  server:https://publicip:6443
and kubectl works from my local machine.

