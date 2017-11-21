# Install and configurate Bumblebee
This article contains information about installing Nvidia Optimus Technology (Bumblebee) in Ubuntu 16.04 on Mi Air 13
***
* Installing Bumblebee:
```
sudo add‐apt‐repository ppa:bumblebee/testing 
sudo apt update 
sudo apt upgrade 
sudo apt install bumblebee
```
* Now we need to perform the initial configuration...
```
sudo service bumblebeed stop
sudo gedit /etc/bumblebee/bumblebee.conf
```
* In `bumblebee.conf` we need to find `[driver-nvidia]` settings. Replace `nvidia-current` to version of your `nvidia-driver` (i have `nvidia-384`)
```
# colon‐separated path to the nvidia libraries 
LibraryPath=/usr/lib/nvidia‐384:/usr/lib32/nvidia‐384 
# comma‐separated path of the directory containing nvidia_drv.so and the 
# default Xorg modules path 
XorgModulePath=/usr/lib/nvidia‐384/xorg,/usr/lib/xorg/modules 
```
* **REBOOT...**

* Lets check bumblebee is working correct:
```
sudo service bumblebeed stop
sudo bumblebeed –debug
```
* If everything works correctly, you will see something like this
```
[ 1300.092823] [DEBUG] GID name: bumblebee
[ 1300.092842] [DEBUG] Power method: auto
[ 1300.092867] [DEBUG] Stop X on exit: 1
[ 1300.092886] [DEBUG] Driver: nvidia
[ 1300.092905] [DEBUG] Driver module: nvidia
[ 1300.092925] [DEBUG] Card shutdown state: 1
[ 1300.092956] [DEBUG]Configuration test passed.
[ 1300.094128] [INFO]bumblebeed 3.2.1 started
[ 1300.094444] [INFO]Switching dedicated card OFF [bbswitch]
[ 1300.123177] [INFO]Initialization completed - now handling client requests
```
* Now, not touching this terminal, run another, and enter
```
optirun --status
```
* You will see...
```
Bumblebee status: Ready (3.2.1). X inactive. Discrete video card is off.
```
* Ok, let's test bumblebee, by using `glxgears`:
```
sudo apt-get install mesa-utils
optirun glxgears
```
* While `glxgears` is running, in the third terminal check the bumblebee status
```
optirun --status
```
* You will see...
```
Bumblebee status: Ready (3.2.1). X inactive. Discrete video card is on.
```
* Stop `glxgears` (Ctrl + C in second terminal) and re-check the status of bumblebee. Now if it is off, then everything works successfully. Stop bumblebeed debug (Ctrl + C in first terminal) and run bumblebee
```
sudo service bumblebeed start
```
***
### If after waking up from suspend or hibernation `optirun --status` will show...
```
Bumblebee status: Ready (3.2.1). X inactive. Discrete video card is on.

```
* Discrete graphics works but does nothing. This problem can be fixed by running anything with `optirun`. For example...
```
optirun glxgeras
optirun --status
```
* Let's create a service file that would do something like that.
```
sudo nano /etc/systemd/system/start-optirun.service
```
* Complete the file with this text...
```
[Unit]
Description=Run optirun at resume
After=suspend.target
After=hibernate.target
After=hybrid-sleep.target

[Service]
ExecStart=/usr/bin/optirun ping -c 5 8.8.8.8 &> /dev/null

[Install]
WantedBy=suspend.target
WantedBy=hibernate.target
WantedBy=hybrid-sleep.target
```
* Use `Ctrl + o` to save file and `Ctrl + x` to exit the `nano`.
* Now it only remains to enable this script by...
```
systemctl enable start-optirun
```
* Done
