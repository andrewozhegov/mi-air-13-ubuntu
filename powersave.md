# Install Ubuntu and Powersave settings
This article contains instructions for installing and configuring power-saving for Ubuntu 16.04 on Mi Notebook Air 13.3
***
* Before installing the system, we will need an Internet connection
```
sudo modprobe ‐r acer_wmi 
sudo service network‐manager restart 
```
* Installing Ubuntu...
* Reboot...
* After rebooting, again you will need to treat wi-fi
```
sudo modprobe ‐r acer_wmi 
sudo service network‐manager restart
```
* We don't have to repeat it ad infinitum, so...
```
sudo ‐i 
echo 'blacklist acer_wmi' >> /etc/modprobe.d/blacklist.conf 
exit
```
* Ok, now we need to install the driver for Nvidia discrete graphics. Start by adding the repository
```
sudo add‐apt‐repository ppa:graphics‐drivers/ppa 
```
* Now update the package list and the packages themselves
```
sudo apt update 
sudo apt dist‐upgrade
```
* Go to **System Settings → Software & Updates → Additional Drivers** and choose the discrete graphics driver (i chose nvidia-384), as well choose software for CPU

* Execute the command...
```
sudo update-initramfs -u
```
* I have this warning...
```
W: Possible missing firmware /lib/firmware/i915/kbl_dmc_ver1_01.bin for module i915
```
* Let's fix this warning...
```
cd /tmp
wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915/kbl_dmc_ver1_01.bin
sudo cp /tmp/kbl_dmc_ver1_01.bin /lib/firmware/i915/kbl_dmc_ver1_01.bin 
sudo update-initramfs -k $(uname -r) -u
```
* Goog! Let's activate Laptop Mode
```
sudo ‐i 
echo 5 > /proc/sys/vm/laptop_mode
exit 
```
* After installing Nvidia-driver, we can use `prime-select` to choose the intel graphics as prime. 
* Immediately check the result...
```
sudo prime‐select intel 
sudo prime‐select query 
```
* Done
***
### Some features that will help you with powersave
* Use this command to check the power consumption of your laptop...
```
upower -d
```
* **Powertop** will help you to optimize battery usage...
```
sudo apt-get install powertop
sudo powetop
```
* **TLP** (Linux Advanced Power Management) - a very useful utility
```
installing and configuring the TLP I will describe in another article
```
* The use of **Nvidia Optimus Technology** also has a positive effect on energy saving

[Install and configurate Bumblebee](https://github.com/andrewozhegov/mi-air-13-ubuntu/blob/master/bumblebee.md)
***
### Some features too
* Mi Air 13 has 8 gb of RAM, and you can safely disable the swap partition
```
sudo swapoff -a
```
