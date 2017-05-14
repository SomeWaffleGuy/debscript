#/bin/sh
#Scrip with the intention of setting up a custom Debian Testing or Sid install from
#current Testing isos, may or may not ever actually work
echo "$(tput setaf 1)$(tput bold)An Internet connection is REQUIRED$(tput sgr 0)"
echo "$USER" > user
if [ $(cat user) = root ]
then
	echo "$(tput setaf 1)$(tput bold)Must run as non-root user$(tput sgr 0)"
	exit
fi
touch show-clock-date
touch 12-hour
echo -n "$(tput setaf 2)$(tput bold)Which Debian version do you wish to run?
1:Testing
2:Sid
$(tput sgr 0)"
read answer
if echo "$answer" | grep -iq "^1" ;then
	wget https://raw.githubusercontent.com/SomeWaffleGuy/debscript/master/testing.sh
	chmod +x testing.sh
	su -c './testing.sh'
elif echo "$answer" | grep -iq "^2" ;then
	wget https://raw.githubusercontent.com/SomeWaffleGuy/debscript/master/sid.sh
	chmod +x sid.sh
	su -c './sid.sh'
fi
gnome-shell-extension-tool -e user-theme
gsettings set org.gnome.desktop.interface gtk-theme "Arc-Darker"
gsettings set org.gnome.desktop.interface icon-theme "Moka"
gsettings set org.gnome.desktop.interface cursor-theme "DMZ-White"
gsettings set org.gnome.shell.extensions.user-theme name "Arc-Dark"
if [ $(cat show-clock-date) = true ]
then
gsettings set org.gnome.desktop.interface clock-show-date "true"
fi
if [ $(cat 12-hour) = true ]
then
gsettings set org.gnome.desktop.interface clock-format "12h"
fi
rm show-clock-date 12-hour
exit 0
