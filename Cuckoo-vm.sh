#author Skovdnjbrygd
#https://github.com/Skovdnjbrygd/CuckooUsingVMCloak
#credit Archan Choudhury 
#https://github.com/archanchoudhury/Cuckoo-Script
#credit S4kur4
#https://github.com/S4kur4/AutoDeployCuckoo

# Deployment tested April 2022

# Tested on Cuckoo Sandbox v.2.0.7 running Ubuntu 18.04.6 LTS (Bionic Beaver)
# Agent.py v0.10


# Script details
# Using 'sed' to insert/replace text in the .conf files works for now (Cuckoo Sandbox v.2.0.7).
# Once Cuckoo gets a version update, the 'sed' part of the script has to be checked to make sure 
# the line numbers are still correct.

# Change the 'vmcloak init' parameters to suit your own analysis machine needs.
# Change the 'vmcloak install' parameters to install the software packages you need in your analysis machine.
# Note that some software packages like Office will need additional parameters - like a cdkey.
# Use 'vmcloak list deps' to see all the available software that can be installed on the analysis machine.

# Connectivity issues on reboot
# If the host machine is rebooted, internet access may be lost depending on what kind of network adapter is being provisioned to the VM.
# Restore internet access by executing the commands found in the network routing section.

# If the host machine is rebooted, the virtual interface used by Cuckoo to communicate with the analysis machine will be down.
# Bring it up again with:
# vboxmanage hostonlyif create && vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0

#--------------------------------------------------------------------------------------------------------------------------------------------#

# Setup virtual machine
# This part is commented because I have a local copy of the .iso saved in the same directory where the script is executed.
# Uncomment the next 4 lines if you need to download the .iso used in the analysis machine.
# echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
# echo -e '\e[1;33m *                                             Pulling Win ISO                                          *\e[0m'
# echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
# sudo wget https://cuckoo.sh/win7ultimate.iso


#Mounting Win ISO
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
echo -e '\e[1;33m *                                             Mounting Win ISO                                         *\e[0m'
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
sudo mkdir /mnt/win7
sudo chown cuckoo:cuckoo /mnt/win7/
sudo mount -o ro,loop win7ultimate.iso /mnt/win7


echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
echo -e '\e[1;33m *                                        Setting up virtual machine                                    *\e[0m'
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
sudo apt-get -y install build-essential libssl-dev libffi-dev python-dev genisoimage
sudo apt-get -y install zlib1g-dev libjpeg-dev
sudo apt-get -y install python-pip python-virtualenv python-setuptools swig


# Using VMCloak to create and prepare a Windows virtual machine that can be used by Cuckoo Sandbox
pip install -U vmcloak
vmcloak-vboxnet0
vmcloak init --verbose --win7x64 win7x64base --cpus 2 --ramsize 2048
vmcloak clone win7x64base win7x64cuckoo
vmcloak list deps
vmcloak install win7x64cuckoo adobepdf vcredist java flash ie11 chrome winrar office2007.serial=TT3M8-H3469-V89G6-8FWK7-D3Q9Q dotnet
vmcloak snapshot --count 1 win7x64cuckoo 192.168.56.1
vmcloak list vms


# Initialize Cuckoo and its configuration
cuckoo init

# Fetch supplies from the Cuckoo Community
cuckoo community


# Open MongoDB and VirusTotal
sed "45d" ~/.cuckoo/conf/reporting.conf > ~/.cuckoo/conf/tmp.conf && sed -i "/mongodb]/a\enabled = yes" ~/.cuckoo/conf/tmp.conf && rm -rf ~/.cuckoo/conf/reporting.conf && mv ~/.cuckoo/conf/tmp.conf ~/.cuckoo/conf/reporting.conf
sed "148d" ~/.cuckoo/conf/processing.conf > ~/.cuckoo/conf/tmp.conf && sed -i "/virustotal]/a\enabled = yes" ~/.cuckoo/conf/tmp.conf && rm -rf ~/.cuckoo/conf/processing.conf && mv ~/.cuckoo/conf/tmp.conf ~/.cuckoo/conf/processing.conf

# If you have a VirusTotal account you can use the key tied to your account, instead of the default one VirusTotal has given to Cuckoo
# sed "160d" ~/.cuckoo/conf/processing.conf > ~/.cuckoo/conf/tmp.conf && sed -i "/ and while being shared with all our users, it shouldn't affect your use./a\key = insert_private_VirusTotalKey_here" ~/.cuckoo/conf/tmp.conf && rm -rf ~/.cuckoo/conf/processing.conf && mv ~/.cuckoo/conf/tmp.conf ~/.cuckoo/conf/processing.conf

# Assign the interface that your hostmachine uses for internet access, in this case ens33
sed "19d" ~/.cuckoo/conf/routing.conf > ~/.cuckoo/conf/tmp.conf && sed -i "/ (For example, to use eth0 as dirty line: \"internet = eth0\")./a\internet = ens33" ~/.cuckoo/conf/tmp.conf && rm -rf ~/.cuckoo/conf/routing.conf && mv ~/.cuckoo/conf/tmp.conf ~/.cuckoo/conf/routing.conf


while read -r vm ip; do cuckoo machine --add $vm $ip; done < <(vmcloak list vms)


# Remove mentions of cuckoo1 from the label and machine sections of virtualbox.conf 
# These were generated during the 'while read -r vm ip;...' command above
# Replaces the mentions with the current analysis machine IP
sed "18d" ~/.cuckoo/conf/virtualbox.conf > ~/.cuckoo/conf/tmp.conf && sed -i "/ on the respective machine. (E.g. cuckoo1,cuckoo2,cuckoo3)/a\machines = 192.168.56.11" ~/.cuckoo/conf/tmp.conf && rm -rf ~/.cuckoo/conf/virtualbox.conf && mv ~/.cuckoo/conf/tmp.conf ~/.cuckoo/conf/virtualbox.conf
sed -i '25c[192.168.56.11]' /home/cuckoo/.cuckoo/conf/virtualbox.conf
sed "28d" ~/.cuckoo/conf/virtualbox.conf > ~/.cuckoo/conf/tmp.conf && sed -i "/ VirtualBox configuration./a\label = 192.168.56.11" ~/.cuckoo/conf/tmp.conf && rm -rf ~/.cuckoo/conf/virtualbox.conf && mv ~/.cuckoo/conf/tmp.conf ~/.cuckoo/conf/virtualbox.conf


# Setting up network routing so the analysis machine can connect both to the host and the internet
sudo sysctl -w net.ipv4.conf.vboxnet0.forwarding=1
sudo sysctl -w net.ipv4.conf.ens33.forwarding=1
sudo iptables -t nat -A POSTROUTING -o ens33 -s 192.168.56.0/24 -j MASQUERADE
sudo iptables -P FORWARD DROP
sudo iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -s 192.168.56.0/24 -j ACCEPT  


echo -e '\e[1;33m *-------------------------------------------------------------------------------------------------------*\e[0m'
echo -e '\e[1;33m *                                        Process Completed Successfully!                                *\e[0m'
echo -e '\e[1;33m *                                                                                                       *\e[0m'                       
echo -e '\e[1;33m *                                 Follow the Final Steps to Interact with Cuckoo:                       *\e[0m'
echo -e '\e[1;33m *                                                                                                       *\e[0m' 
echo -e '\e[1;33m *     open new terminal 1: cuckoo rooter --sudo --group cuckoo                                          *\e[0m'
echo -e '\e[1;33m *     open new terminal 2: cuckoo                                                                       *\e[0m'
echo -e '\e[1;33m *     open new terminal 3: cuckoo web --host 127.0.0.1 --port 8080 (vboxnet0 and internet ip also work) *\e[0m'
echo -e '\e[1;33m *-------------------------------------------------------------------------------------------------------*\e[0m'
