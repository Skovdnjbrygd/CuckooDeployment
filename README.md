# CuckooUsingVMCloak

Hejssan,

with these files one can configure and install a Cuckoo Sandbox for automated malware analysis.
The installation process takes advantage of VMCloak, which is a tool to fully create and prepare Virtual Machines that can be used by Cuckoo Sandbox.
I found this method to be alot more painless then manually building a VM that suits Cuckoo's needs.
In the name of security, these files deploy Cuckoo inside a python virtual environment.

The first two scripts install dependencies and configure them as described in the official Cuckoo manual.

In addition, the second file  (Cuckoo-Pre2of2.sh) installs the required dependencies to create a python virtual enviorment (in which Cuckoo will run).
This is not needed, but why not make it fancy (and more secure). Everything is also echoed into .bashrc to make the use of the terminal session pleasant.

The third file (Cuckoo-vm.sh), does all the heavy lifting:

  1. It creates a fully functional analysis machine (nested vm via VMcloak).
  Refer to the script to see the correct syntax on how install packages on the machine created with VMcloak. Be aware that some packages like Office require a cd-key.
  
  2. Initializes Cuckoo and its community files.
  
  3. Sets up the networking (basically internet access), as described in the manual.
  
  4. 'sed' is used to replace the default values with the correct ones in processing, reporting, routing and virtualbox .conf files found inside the .cuckoo folder.
  These "correct" values vary from host to host: hostname, interface name, what ip gets automatically assigned to guests etc.
  You can't take the 'sed' parts of the code literally, but you can see which line in each file needs to be replaced with your hardware specific information.
  After all, this is a repo of scripts to deploy Cuckoo... not auto-deploy.
  
  Credit has been given to those GitHubbians (or is it GitHubbers?) whose code has been used (and expanded upon) in this repository.
