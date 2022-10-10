#!/bin/bash


showSubnetIP () {
 echo "$(sudo nmap -sP -n $(ip -o address | awk '/scope global/ {print $4}' | head -n 1) | awk '/Nmap scan/ {print $5}')"
}

showPorts () {
 echo "$(sudo netstat -tulpn | grep LISTEN | awk '{print $1,$4}')"
}


main () {

MESSAGE="You have to use one parameter:\n
--all - to display IP addresses and symbolic names of all hosts in the current subnet\n
--target  - to display a list of open system TCP ports"

if [[ $# -ne 1 ]]
then
  echo -e $MESSAGE
elif [[ $1 == "--all" ]]
then
  showSubnetIP
elif [[ $1 == "--target" ]]
then
  showPorts
else
  echo -e $MESSAGE
fi

}


main $1
