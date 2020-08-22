#/bin/sh
#Scrip with the intention of setting up a custom Debian install from the current Stable iso, may or may not ever actually work as intended
echo "$(tput setaf 1)$(tput bold)An Internet connection is REQUIRED$(tput sgr 0)"
if [ $USER = root ]
then
	echo "$(tput setaf 1)$(tput bold)Must run as non-root user$(tput sgr 0)"
	exit
fi
echo -n "$(tput setaf 2)$(tput bold)Which Debian version do you wish to run? (Most typical Desktop users will likely want Unstable, especially NVIDIA users and gamers)
1: Stable
2: Ubstable
$(tput sgr 0)"
#Testing was removed due to being a generally unrecommened version to run on daily use devices. If you still want to install Testing, edit the sources.list for sid.sh and it should MOSTLY work fine.
read answer
if echo "$answer" | grep -iq "^1" ;then
	wget https://raw.githubusercontent.com/SomeWaffleGuy/debscript/master/stable.sh
	chmod +x stable.sh
	sudo './stable.sh'
elif echo "$answer" | grep -iq "^2" ;then
	wget https://raw.githubusercontent.com/SomeWaffleGuy/debscript/master/sid.sh
	chmod +x sid.sh
	sudo './sid.sh'
fi
#Sets GNOME fonts to RGB instead of Greyscale
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
echo "$(tput setaf 1)$(tput bold)Some features won't work until after a reboot$(tput sgr 0)"
exit 0
