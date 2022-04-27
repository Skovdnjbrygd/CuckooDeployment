#author Skovdnjbrygd
#https://github.com/Skovdnjbrygd/CuckooUsingVMCloak/
#credit Archan Choudhury 
#https://github.com/archanchoudhury/Cuckoo-Script

# Tested on Cuckoo Sandbox v.2.0.7 running Ubuntu 18.04.6 LTS (Bionic Beaver)
# Agent.py v0.10

# Deployment enviorment details
# I chose to use VMware Workstation as the top level of virtualization because in testing I found that the vmcloak phase of
# the script took about 20 minutes compared to the 4-7 hours it took when I used VirtualBox.

# The machine in which Cuckoo will be installed is a virtualmachine with 2 cpu's and 4gb ram.
# It is being hosted by VMware® Workstation 16 Pro build-19376536 on Windows 10 Pro (latest build April 2022).
# The virtualized analysis machine running inside the virtualized Cuckoo machine is running VirtualBox v5.2.42_Ubuntu-r137960. 
# The Cuckoo machine has one analysis machine running through nested virtualization with 2 cpu's and 2gb ram.


# Script details
# Running 'sudo su cuckoo' during the script stops the execution of the script and throws you back to the terminal command line.
# Therefore run the command at the very end of the script, so that it doesn’t matter if you get thrown out.


# System update
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
echo -e '\e[1;33m *                                   Upgrading and Updating the system                                  *\e[0m'
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
sudo apt update -y
sudo apt upgrade -y


# Install dependencies
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
echo -e '\e[1;33m *                                   Installing Prelim Dependencies                                     *\e[0m'
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
sudo apt-get install python python-pip python-dev libffi-dev libssl-dev -y
sudo apt-get install python-virtualenv python-setuptools -y
sudo apt-get install libjpeg-dev zlib1g-dev swig -y
sudo apt-get install mongodb -y
sudo apt-get install postgresql libpq-dev -y
sudo apt install virtualbox -y
sudo apt-get install tcpdump apparmor-utils -y


# Create and assign proper pcap user and permisson
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
echo -e '\e[1;33m *                            Getting the Privileges Fixed for tcpdump                                  *\e[0m'
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
sudo groupadd pcap
sudo usermod -a -G pcap cuckoo
sudo usermod -a -G vboxusers cuckoo
sudo chgrp pcap /usr/sbin/tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump
getcap /usr/sbin/tcpdump
sudo aa-disable /usr/sbin/tcpdump


echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
echo -e '\e[1;33m *                                 Script 1 of 2 Completed Successfully!                                *\e[0m'
echo -e '\e[1;33m *                                                                                                      *\e[0m'
echo -e '\e[1;33m *                                 Next, Run Cuckoo-Pre2of2.sh Script                                   *\e[0m'
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'


# Adding this at the very end since it kills the script execution
sudo su cuckoo
