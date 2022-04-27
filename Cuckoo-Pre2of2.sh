#author Skovdnjbrygd
#https://github.com/Skovdnjbrygd/CuckooUsingVMCloak
#credit Archan Choudhury 
#https://github.com/archanchoudhury/Cuckoo-Script

# Deployment tested April 2022

# Tested on Cuckoo Sandbox v.2.0.7 running Ubuntu 18.04.6 LTS (Bionic Beaver)
# Agent.py v0.10


#Script details
# Remember to input the following commands after the script execution is complete:
# source ~/.bashrc   
# mkvirtualenv -p python2.7 cuckoo-test
# pip install -U pip setuptools
# pip install -U cuckoo 

#--------------------------------------------------------------------------------------------------------------------------------------------#


#Installing crypto libraries 
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
echo -e '\e[1;33m *                                  Installing Crypto Libraries                                         *\e[0m'
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
sudo apt-get install swig
sudo pip install m2crypto


# Install virtualenv
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
echo -e '\e[1;33m *                             Installing virtual environment wrapper                                   *\e[0m'
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
sudo apt-get update && sudo apt-get -y install virtualenv


# Install virtualenvwrapper
sudo apt-get -y install virtualenvwrapper

echo "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh" >> ~/.bashrc


# Install pip for python3
sudo apt-get -y install python3-pip


# Turn on bash auto-complete for pip
pip3 completion --bash >> ~/.bashrc


# Avoid installing with root
pip3 install --user virtualenvwrapper

echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc

echo "source ~/.local/bin/virtualenvwrapper.sh" >> ~/.bashrc

export WORKON_HOME=~/.virtualenvs

echo "export WORKON_HOME=~/.virtualenvs" >> ~/.bashrc

echo "export PIP_VIRTUALENV_BASE=~/.virtualenvs" >> ~/.bashrc 


echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
echo -e '\e[1;33m *                                        Script 2 of 2 Completed Successfully!                         *\e[0m'
echo -e '\e[1;33m *                                                                                                      *\e[0m'
echo -e '\e[1;33m *                            Initialize Virtual Env, Install Setuptools and Cuckoo:                    *\e[0m'
echo -e '\e[1;33m *                                                                                                      *\e[0m'
echo -e '\e[1;33m *                                 source ~/.bashrc                                                     *\e[0m'
echo -e '\e[1;33m *                                 mkvirtualenv -p python2.7 cuckoo-test                                *\e[0m'
echo -e '\e[1;33m *                                 pip install -U pip setuptools                                        *\e[0m'
echo -e '\e[1;33m *                                 pip install -U cuckoo                                                *\e[0m'  
echo -e '\e[1;33m *                                                                                                      *\e[0m'
echo -e '\e[1;33m *                            Next, Run Cuckoo-vm.sh Script                                             *\e[0m'
echo -e '\e[1;33m *------------------------------------------------------------------------------------------------------*\e[0m'
