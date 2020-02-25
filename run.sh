#/bin/sh
#Scrip with the intention of setting up a custom Debian install from current Stable or Testing iso, may or may not ever actually work
echo "$(tput setaf 1)$(tput bold)An Internet connection is REQUIRED$(tput sgr 0)"
echo "$USER" > user
if [ $(cat user) = root ]
then
	echo "$(tput setaf 1)$(tput bold)Must run as non-root user$(tput sgr 0)"
	exit
fi
echo -n "$(tput setaf 2)$(tput bold)Which Debian version do you wish to run?
1: Stable
2: Testing (NOT Reccomended)
3: Sid
$(tput sgr 0)"
read answer
if echo "$answer" | grep -iq "^1" ;then
	wget https://raw.githubusercontent.com/SomeWaffleGuy/debscript/master/stable.sh
	chmod +x stable.sh
	sudo './stable.sh'
elif echo "$answer" | grep -iq "^2" ;then
	wget https://raw.githubusercontent.com/SomeWaffleGuy/debscript/master/testing.sh
	chmod +x testing.sh
	sudo './testing.sh'
elif echo "$answer" | grep -iq "^3" ;then
	wget https://raw.githubusercontent.com/SomeWaffleGuy/debscript/master/sid.sh
	chmod +x sid.sh
	sudo './sid.sh'
fi
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
echo "$(tput setaf 1)$(tput bold)Some features won't work until after a reboot$(tput sgr 0)"
exit 0
