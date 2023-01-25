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
After apply netplan I've got three network interfaces with IP addresses:

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
### Other VM's network parameters:

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

## Task 3: Testing connection between virtual machines

From server1:

```
ubuntu@server1:/etc/netplan$ ping -c 3 10.72.22.10
PING 10.72.22.10 (10.72.22.10) 56(84) bytes of data.
64 bytes from 10.72.22.10: icmp_seq=1 ttl=64 time=0.398 ms
64 bytes from 10.72.22.10: icmp_seq=2 ttl=64 time=0.355 ms
64 bytes from 10.72.22.10: icmp_seq=3 ttl=64 time=0.339 ms

--- 10.72.22.10 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2033ms
rtt min/avg/max/mdev = 0.339/0.364/0.398/0.024 ms
ubuntu@server1:/etc/netplan$ traceroute 10.72.22.10
traceroute to 10.72.22.10 (10.72.22.10), 64 hops max
  1   10.72.22.10  0.258ms  0.305ms  0.260ms
ubuntu@server1:/etc/netplan$


ubuntu@server1:/etc/netplan$ ping -c 3 10.10.72.20
PING 10.10.72.20 (10.10.72.20) 56(84) bytes of data.
64 bytes from 10.10.72.20: icmp_seq=1 ttl=64 time=0.493 ms
64 bytes from 10.10.72.20: icmp_seq=2 ttl=64 time=0.400 ms
64 bytes from 10.10.72.20: icmp_seq=3 ttl=64 time=0.589 ms

--- 10.10.72.20 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2115ms
rtt min/avg/max/mdev = 0.400/0.494/0.589/0.077 ms
ubuntu@server1:/etc/netplan$ traceroute 10.10.72.20
traceroute to 10.10.72.20 (10.10.72.20), 64 hops max
  1   10.10.72.20  0.423ms !*  0.234ms !*  0.255ms !*
```

From client1:
```
ubuntu@client_1:~$ ping -c 3 192.168.0.201
PING 192.168.0.201 (192.168.0.201) 56(84) bytes of data.
64 bytes from 192.168.0.201: icmp_seq=1 ttl=64 time=0.230 ms
64 bytes from 192.168.0.201: icmp_seq=2 ttl=64 time=0.333 ms
64 bytes from 192.168.0.201: icmp_seq=3 ttl=64 time=0.446 ms

--- 192.168.0.201 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2304ms
rtt min/avg/max/mdev = 0.230/0.336/0.446/0.089 ms
ubuntu@client_1:~$ traceroute 192.168.0.201
traceroute to 192.168.0.201 (192.168.0.201), 64 hops max
  1   192.168.0.201  0.157ms  0.330ms  0.298ms
```

From client2 (CentOS 7):
```
[root@client2 ~]# ping -c 3 192.168.0.201
PING 192.168.0.201 (192.168.0.201) 56(84) bytes of data.
64 bytes from 192.168.0.201: icmp_seq=1 ttl=64 time=0.300 ms
64 bytes from 192.168.0.201: icmp_seq=2 ttl=64 time=0.380 ms
64 bytes from 192.168.0.201: icmp_seq=3 ttl=64 time=0.314 ms

--- 192.168.0.201 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.300/0.331/0.380/0.037 ms
[root@client2 ~]# traceroute 192.168.0.201
traceroute to 192.168.0.201 (192.168.0.201), 30 hops max, 60 byte packets
 1  192.168.0.201 (192.168.0.201)  0.252 ms  0.199 ms  0.224 ms
 
 
[root@client2 ~]# ping -c 3 10.72.22.10
PING 10.72.22.10 (10.72.22.10) 56(84) bytes of data.
64 bytes from 10.72.22.10: icmp_seq=1 ttl=63 time=0.703 ms
64 bytes from 10.72.22.10: icmp_seq=2 ttl=63 time=1.12 ms
64 bytes from 10.72.22.10: icmp_seq=3 ttl=63 time=0.698 ms

--- 10.72.22.10 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 0.698/0.843/1.129/0.203 ms
[root@client2 ~]# traceroute 10.72.22.10
traceroute to 10.72.22.10 (10.72.22.10), 30 hops max, 60 byte packets
 1  gateway (10.10.72.1)  0.293 ms  0.209 ms  0.199 ms
 2  10.72.22.10 (10.72.22.10)  0.581 ms  0.953 ms  0.948 ms
```


ip route add 172.17.42.0/24 via 172.16.22.10
on server1
ip route add 172.17.32.0/24 via 10.72.22.20
