# Recover system with Live-USB
If after installing/removing some packages the system to become inoperable 
(for example, when you remove the packages responsible for the input, you lose any possibility of control your PC)
***
* Boot from Live-USB
* Find in the list of disk partitions a partition of type "Linux filesystem" (i have `/dev/nvme0n1p2`)
```
fdisk -l
```
* Mount this partition...
```
mount /dev/nvme0n1p2 /mnt
mount -t proc none /mnt/proc
mount -t sysfs sys /mnt/sys
mount -o bind /dev /mnt/dev
```
* So it is necessary
```
cp -L /etc/resolv.conf /mnt/etc/resolv.conf
```
* Go into the `chroot` environment
```
sudo chroot /mnt
```
* Let's check what apt-commands led to the collapse of your universe
```
cat /mnt/var/log/apt/history.log
```
* **Deleting/installing the necessary packages**
* Exit from `chroot` environment
```
exit
```
* Unmount all
```
sudo unmount -a
```
* REBOOT... 
* Done!
