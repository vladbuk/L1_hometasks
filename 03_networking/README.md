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

enp0s3: 10.10.72.21/24 (DHCP

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


ubuntu@server1:/etc/dhcp$ ping -c 3 10.10.72.21
PING 10.10.72.21 (10.10.72.21) 56(84) bytes of data.
64 bytes from 10.10.72.21: icmp_seq=1 ttl=64 time=0.291 ms
64 bytes from 10.10.72.21: icmp_seq=2 ttl=64 time=0.358 ms
64 bytes from 10.10.72.21: icmp_seq=3 ttl=64 time=0.379 ms

--- 10.10.72.21 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2025ms
rtt min/avg/max/mdev = 0.291/0.342/0.379/0.037 ms

ubuntu@server1:/etc/dhcp$ traceroute 10.10.72.21
traceroute to 10.10.72.21 (10.10.72.21), 64 hops max
  1   10.10.72.21  0.423ms  0.261ms  0.255ms
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
  

ubuntu@client_1:~$  ping -c 3 10.10.72.21
PING 10.10.72.21 (10.10.72.21) 56(84) bytes of data.
64 bytes from 10.10.72.21: icmp_seq=1 ttl=63 time=0.561 ms
64 bytes from 10.10.72.21: icmp_seq=2 ttl=63 time=0.648 ms
64 bytes from 10.10.72.21: icmp_seq=3 ttl=63 time=0.615 ms

--- 10.10.72.21 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2026ms
rtt min/avg/max/mdev = 0.561/0.608/0.648/0.035 ms

ubuntu@client_1:~$ traceroute 10.10.72.21
traceroute to 10.10.72.21 (10.10.72.21), 64 hops max
  1   10.72.22.1  0.164ms  0.155ms  0.174ms
  2   10.10.72.21  0.552ms  0.386ms  0.351ms


ubuntu@client_1:~$ ping -c 3 172.16.22.20
PING 172.16.22.20 (172.16.22.20) 56(84) bytes of data.
64 bytes from 172.16.22.20: icmp_seq=1 ttl=64 time=0.632 ms
64 bytes from 172.16.22.20: icmp_seq=2 ttl=64 time=0.346 ms
64 bytes from 172.16.22.20: icmp_seq=3 ttl=64 time=1.08 ms

--- 172.16.22.20 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2079ms
rtt min/avg/max/mdev = 0.346/0.688/1.087/0.305 ms

ubuntu@client_1:~$ traceroute 172.16.22.20
traceroute to 172.16.22.20 (172.16.22.20), 64 hops max
  1   172.16.22.20  0.259ms  0.219ms  0.218ms
```

From client2:
```
ubuntu@client2:~$ ping -c 3 192.168.0.201
PING 192.168.0.201 (192.168.0.201) 56(84) bytes of data.
64 bytes from 192.168.0.201: icmp_seq=1 ttl=64 time=0.411 ms
64 bytes from 192.168.0.201: icmp_seq=2 ttl=64 time=0.652 ms
64 bytes from 192.168.0.201: icmp_seq=3 ttl=64 time=0.299 ms

--- 192.168.0.201 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2083ms
rtt min/avg/max/mdev = 0.299/0.454/0.652/0.147 ms

ubuntu@client2:~$ traceroute 192.168.0.201
traceroute to 192.168.0.201 (192.168.0.201), 64 hops max
  1   192.168.0.201  0.182ms  0.219ms  0.208ms
 
 
ubuntu@client2:~$ ping -c 3 10.72.22.10
PING 10.72.22.10 (10.72.22.10) 56(84) bytes of data.
64 bytes from 10.72.22.10: icmp_seq=1 ttl=63 time=0.464 ms
64 bytes from 10.72.22.10: icmp_seq=2 ttl=63 time=0.590 ms
64 bytes from 10.72.22.10: icmp_seq=3 ttl=63 time=0.542 ms

--- 10.72.22.10 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2152ms
rtt min/avg/max/mdev = 0.464/0.532/0.590/0.051 ms

ubuntu@client2:~$ traceroute 10.72.22.10
traceroute to 10.72.22.10 (10.72.22.10), 64 hops max
  1   10.10.72.1  0.237ms  0.298ms  0.270ms
  2   10.72.22.10  0.659ms  0.446ms  0.459ms


ubuntu@client2:~$ ping -c 3 172.16.22.10
PING 172.16.22.10 (172.16.22.10) 56(84) bytes of data.
64 bytes from 172.16.22.10: icmp_seq=1 ttl=64 time=0.256 ms
64 bytes from 172.16.22.10: icmp_seq=2 ttl=64 time=1.03 ms
64 bytes from 172.16.22.10: icmp_seq=3 ttl=64 time=0.298 ms

--- 172.16.22.10 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2034ms
rtt min/avg/max/mdev = 0.256/0.528/1.031/0.356 ms

ubuntu@client2:~$ traceroute 172.16.22.10
traceroute to 172.16.22.10 (172.16.22.10), 64 hops max
  1   172.16.22.10  0.263ms  0.230ms  0.246ms
```

## Task 4: On client1 add two IP to lo and configure particular routes

To solve this task I ran commands:

```
# lo:10 172.17.32.1/24
sudo ip addr add 172.17.32.1/24 dev lo label lo:10
# lo:20 172.17.42.1/24
sudo ip addr add 172.17.42.1/24 dev lo label lo:20
```

And routes:

on client2: `sudo ip route add 172.17.42.0/24 via 172.16.22.10`

on server1: `sudo ip route add 172.17.32.0/24 via 10.72.22.21`

Results:

```
ubuntu@client2:~$ traceroute 172.17.32.1
traceroute to 172.17.32.1 (172.17.32.1), 64 hops max
  1   10.10.72.1  0.232ms  0.232ms  0.273ms
  2   172.17.32.1  0.405ms  0.432ms  0.506ms

ubuntu@client2:~$ traceroute 172.17.42.1
traceroute to 172.17.42.1 (172.17.42.1), 64 hops max
  1   172.17.42.1  0.296ms  0.165ms  0.196ms
```

## Task 5: Route sammarization

Convert network addresses to binary system:

```
172.17.32.0 = 10101100.00010001.00100000.00000000
172.17.42.0 = 10101100.00010001.00101010.00000000
```

Now сount the number of identical digits:

10101100.00010001.0010 =  **20** - This is summarizing prefix (netmask 255.255.240.0)

**Result (summarizing network or route): 172.17.32.0/20**

To add this route I used on client2: `sudo ip route add 172.17.32.0/20 via 10.10.72.1`

Lets check:
```
ubuntu@client2:~$ traceroute 172.17.32.1
traceroute to 172.17.32.1 (172.17.32.1), 64 hops max
  1   10.10.72.1  0.356ms  0.182ms  0.280ms
  2   172.17.32.1  0.460ms  0.385ms  0.374ms

ubuntu@client2:~$ traceroute 172.17.42.1
traceroute to 172.17.42.1 (172.17.42.1), 64 hops max
  1   10.10.72.1  0.192ms  0.328ms  0.157ms
  2   172.17.42.1  0.682ms  0.329ms  0.276ms
```

## Task 6: Configuring SSH

Trying from client1:
```
ssh ubuntu@192.168.0.201
ssh ubuntu@10.10.72.21
```
Everything works fine.

Trying from client2:
```
ssh ubuntu@192.168.0.201
ssh ubuntu@10.72.22.10
```
Everything also works fine. SSH works very well from the box.

## Task 7: Configuring firewall

On **server1** `sudo iptables -A INPUT -i enp0s9 -p tcp --dport 22 -j DROP`
```
ubuntu@server1:~$ sudo iptables -L -v
Chain INPUT (policy ACCEPT 508 packets, 36394 bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 DROP       tcp  --  enp0s9 any     anywhere             anywhere             tcp dpt:ssh
```

After that we can still connect to server1 from client1 but can't connect to it from client2.
```
ubuntu@client2:~$ ssh -v ubuntu@192.168.0.201
OpenSSH_7.6p1 Ubuntu-4ubuntu0.7, OpenSSL 1.0.2n  7 Dec 2017
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 19: Applying options for *
debug1: Connecting to 192.168.0.201 [192.168.0.201] port 22.
debug1: connect to address 192.168.0.201 port 22: Connection timed out
ssh: connect to host 192.168.0.201 port 22: Connection timed out
```

On **client1** `sudo iptables -A INPUT -p icmp --icmp-type 8 -d 172.17.42.1 -j REJECT`

We have got this rule:
```
ubuntu@client_1:~$ sudo iptables -L -v
Chain INPUT (policy ACCEPT 7 packets, 404 bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 REJECT     icmp --  any    any     anywhere             172.17.42.1          icmp echo-request reject-with icmp-port-unreachable
```

And ping from client2 to 172.17.42.1 doedn't works.
```
ubuntu@client2:~$ ping -c 3 172.17.42.1
PING 172.17.42.1 (172.17.42.1) 56(84) bytes of data.
From 172.17.42.1 icmp_seq=1 Destination Port Unreachable
From 172.17.42.1 icmp_seq=2 Destination Port Unreachable
From 172.17.42.1 icmp_seq=3 Destination Port Unreachable

--- 172.17.42.1 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2307ms
```

## Task 8: Configuring NAT

On server1 run: `sudo iptables -t nat -A POSTROUTING -j MASQUERADE`

Check iptables:
```
ubuntu@server1:~$ sudo iptables -t nat -L -v

Chain POSTROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
   26  1854 MASQUERADE  all  --  any    any     anywhere             anywhere
```

Let's try ping any internet host from client1:

<a href="https://litprinz-hometask.s3.eu-central-1.amazonaws.com/networking/VirtualBox_Client_1_ping-through-nat.png"><img src="https://litprinz-hometask.s3.eu-central-1.amazonaws.com/networking/VirtualBox_Client_1_ping-through-nat.png" alt="Client 1 ping through nat" width="480"/></a>

And client2:

<a href="https://litprinz-hometask.s3.eu-central-1.amazonaws.com/networking/VirtualBox_Client_2_ping-through-nat.png"><img src="https://litprinz-hometask.s3.eu-central-1.amazonaws.com/networking/VirtualBox_Client_2_ping-through-nat.png" alt="Client 2 ping through nat" width="480"/></a>

