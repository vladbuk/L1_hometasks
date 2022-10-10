hostname -I | awk '{print $1}'
ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -n 1
nmap -sP -n 192.168.0.0/24

nmap -sP -n $(ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -n 1)

nmap -sP -n $(ip -o address | awk '/scope global/ {print $4}' | head -n 1) | awk '/Nmap scan/ {print $5}'
