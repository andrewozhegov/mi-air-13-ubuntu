# Redshift
![Redshift icon](https://github.com/andrewozhegov/mi-air-13-ubuntu/blob/master/redshift/redshift-icon.png)

This tool will adjust the screen temperature depending on the time of day
***
### Installing
* Install with applet by `apt`
```
sudo apt-get install redshift-gtk
```
* or just `redshift`, if you dont need simple `gtk` ui for it
***

### Configuring
Before run this tool we need to configure it
* You also can copy [my config](https://github.com/andrewozhegov/mi-air-13-ubuntu/blob/master/redshift/redshift.conf) by this comand
```
wget -P ~/.config/ https://raw.githubusercontent.com/andrewozhegov/mi-air-13-ubuntu/master/redshift/redshift.conf
```
* Is you want to change some settings
```
sudo gedit ~/.config/redshift.conf
```
* Add `Redshift` to autostart by `Startup Applications`
