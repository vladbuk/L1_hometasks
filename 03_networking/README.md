# Network's hometask

## Create network between three VM

## Initial configuration

**server1**
enp0s3: 192.168.0.201/24
enp0s8: 10.72.22.1/24
enp0s9: 10.10.72.1/24

sysctl net.ipv4.ip_forward
sudo sysctl -w net.ipv4.ip_forward=1

**client1**
lo:10 172.17.32.1/24
sudo ip addr add 172.17.32.1/24 dev lo label lo:10
lo:20 172.17.42.1/24
sudo ip addr add 172.17.42.1/24 dev lo label lo:20

**client2**
ip route add 172.17.42.0/24 via 172.16.22.10
on server1
ip route add 172.17.32.0/24 via 10.72.22.20
