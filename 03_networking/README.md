# Network's hometask: Create network between three VM

## Task 1: configure static IP on server1

To solve this task I configured netplan editing file `/etc/netplan/00-installer-config.yaml`:
```
network:
  ethernets:
    enp0s3:
      addresses:
      - 192.168.0.201/24
      gateway4: 192.168.0.1
      nameservers:
        addresses:
        - 8.8.8.8
        - 8.8.4.4
        search:
        - vm.dom
    enp0s8:
      addresses:
      - 10.72.22.1/24
      #gateway4: 10.72.22.1
      nameservers:
        addresses:
        - 10.72.22.1
        search:
        - vm.dom
    enp0s9:
      addresses:
      - 10.10.72.1/24
      #gateway4: 10.10.72.1
      nameservers:
        addresses:
        - 10.10.72.1
        search:
        - vm.dom
  version: 2
```
After apply netplan I got three netwokr interfacec with IP addresses:

enp0s3: 192.168.0.201/24

enp0s8: 10.72.22.1/24

enp0s9: 10.10.72.1/24

## Task 2: setup DHCP service on server1

I installed DHCP server running command:
```
sudo apt install isc-dhcp-server
```

Then I added these strings to /etc/dhcp/dhcpd.conf:

```
subnet 10.72.22.0 netmask 255.255.255.0 {
  range 10.72.22.10 10.72.22.20;
  option routers 10.72.22.1;
  option subnet-mask 255.255.255.0;
  option domain-name-servers 192.168.0.1, 8.8.8.8;
  option domain-name "vm.dom";
}

subnet 10.10.72.0 netmask 255.255.255.0 {
  range 10.10.72.20 10.10.72.30;
  option routers 10.10.72.1;
  option subnet-mask 255.255.255.0;
  option domain-name-servers 192.168.0.1, 8.8.8.8;
  option domain-name "vm.dom";
}
```

And restart DHCP service:
```
sudo systemctl restart isc-dhcp-server.service
```

To provide tcp packets transport through server1 I enabled ip forwarding:
```
sysctl net.ipv4.ip_forward
sudo sysctl -w net.ipv4.ip_forward=1
```

**client1**

enp0s3: 10.72.22.10/24 (DHCP)

enp0s8: 172.16.22.10/24 (Static)

**client2**

enp0s3: 10.10.72.20/24 (DHCP

enp0s8: 172.16.22.20 (Static)

**WiFi Router in home network**

IP: 192.168.0.1

Additional static routes:

10.72.22.0	mask 255.255.255.0	via 192.168.0.201

10.10.72.0	mask 255.255.255.0	via 192.168.0.201

## Task 1: 

ip route add 172.17.42.0/24 via 172.16.22.10
on server1
ip route add 172.17.32.0/24 via 10.72.22.20
