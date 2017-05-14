#/bin/sh
#Sid installer/customizer
echo "$(tput setaf 2)$(tput bold)Uninstalling useless GNOME parts$(tput sgr 0)"
sleep 3
	apt purge -y gnome-maps gnome-music gnome-photos gnome-games gnome-documents gnome-weather gnome-dictionary polari
	apt autoremove --purge -y
echo "$(tput setaf 2)$(tput bold)Enabling HTTPS for APT$(tput sgr 0)"
sleep 3
	apt install -y apt-transport-https
echo "$(tput setaf 1)$(tput bold)Make SURE intall was successful, script will not function otherwise$(tput sgr 0)"
read -p "$(tput setaf 2)$(tput bold)Press Enter to continue$(tput sgr 0)"
echo "$(tput setaf 2)$(tput bold)Modifying sources.list and upgrading$(tput sgr 0)"
sleep 3
	echo "# Debian Sid
deb https://deb.debian.org/debian/ sid main non-free contrib
deb-src https://deb.debian.org/debian/ sid main non-free contrib" > /etc/apt/sources.list
	apt update
	apt dist-upgrade -y
echo "$(tput setaf 2)$(tput bold)Installing Arc theme and Moka icons$(tput sgr 0)"
sleep 3
	apt install -y arc-theme moka-icon-theme dmz-cursor-theme
	echo "[org/gnome/desktop/interface]
gtk-theme='Arc-Darker'
icon-theme='Moka'
cursor-theme='DMZ-White'" >> /etc/gdm3/greeter.dconf-defaults
	echo "[Icon Theme]
Inherits=DMZ-White" > /usr/share/icons/default/index.theme
echo -n "$(tput setaf 2)$(tput bold)Show date on clock (does not work on GDM)?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo "true" > show-clock-date
fi
echo -n "$(tput setaf 2)$(tput bold)Use 12 hour time?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo "clock-format='12h'" >> /etc/gdm3/greeter.dconf-defaults
	echo "true" > 12-hour
fi
dpkg-reconfigure gdm3
echo -n "$(tput setaf 2)$(tput bold)Install Non-Free Firmware?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	apt install -y firmware-linux-nonfree
fi
echo -n "$(tput setaf 2)$(tput bold)Install extra media codecs?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	apt install -y libavcodec-extra
fi
echo -n "$(tput setaf 2)$(tput bold)Install extra fonts (fixes blank unicode characters)?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	apt install -y fonts-cabin fonts-comfortaa fonts-croscore fonts-ebgaramond fonts-ebgaramond-extra fonts-font-awesome fonts-freefont-otf fonts-freefont-ttf fonts-gfs-artemisia fonts-gfs-complutum fonts-gfs-didot fonts-gfs-neohellenic fonts-gfs-olga fonts-gfs-solomos fonts-junicode fonts-lmodern fonts-lobster fonts-lobstertwo fonts-noto-hinted fonts-oflb-asana-math fonts-sil-gentiumplus fonts-sil-gentiumplus-compact fonts-stix fonts-texgyre ttf-adf-accanthis ttf-adf-gillius ttf-adf-universalis fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core fonts-roboto
fi
echo -n "$(tput setaf 2)$(tput bold)Install unrar?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	apt install -y unrar
fi
echo -n "$(tput setaf 2)$(tput bold)Enable KMS?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo -n "$(tput setaf 2)$(tput bold)Which GPU?
1:Intel
2:AMD/ATI
3:Nouveau
$(tput sgr 0)"
	read answer
	if echo "$answer" | grep -iq "^1" ;then
	echo "# KMS
intel_agp
drm
i915 modeset=1" >> /etc/initramfs-tools/modules
	elif echo "$answer" | grep -iq "^2" ;then
	echo "# KMS
drm
radeon modeset=1" >> /etc/initramfs-tools/modules
	elif echo "$answer" | grep -iq "^3" ;then
	echo "# KMS
drm
nouveau modeset=1" >> /etc/initramfs-tools/modules
	fi
	echo -n "$(tput setaf 2)$(tput bold)Enable Plymouth?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install -y plymouth plymouth-themes
		perl -pi -e 's,GRUB_CMDLINE_LINUX_DEFAULT="(.*)"$,GRUB_CMDLINE_LINUX_DEFAULT="$1 splash",' /etc/default/grub
		update-grub
		plymouth-set-default-theme -R spinner
	fi
fi
echo -n "$(tput setaf 2)$(tput bold)Which browser?
1:Firefox-ESR
2:Firefox
3:Chromium
$(tput sgr 0)"
read answer
if echo "$answer" | grep -iq "^3" ;then
	apt install -y chromium
	apt purge -y firefox-esr
	apt autoremove --purge -y
	echo -n "$(tput setaf 2)$(tput bold)Install Adobe Flash for Chromium?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install pepperflashplugin-nonfree
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install Widevine for Chromium?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install -y chromium-widevine 
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		dpkg -x google-chrome-stable_current_amd64.deb ~/tmp
		mv ~/tmp/opt/google/chrome/libwidevinecdm* /usr/lib/chromium/
		rm -rf ~/tmp
		rm google-chrome-stable_current_amd64.deb
	fi
elif echo "$answer" | grep -iq "^2" ;then
	apt install firefox
	apt purge -y firefox-esr
	apt autoremove --purge -y
fi
echo -n "$(tput setaf 2)$(tput bold)Include Tor Browser?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	apt install -y torbrowser-launcher
fi
echo -n "$(tput setaf 2)$(tput bold)Install AppArmor and Profiles?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	apt install -y apparmor apparmor-profiles apparmor-profiles-extra apparmor-utils
	perl -pi -e 's,GRUB_CMDLINE_LINUX="(.*)"$,GRUB_CMDLINE_LINUX="$1 apparmor=1 security=apparmor",' /etc/default/grub
	update-grub
fi
echo -n "$(tput setaf 2)$(tput bold)Enable multiarch?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	dpkg --add-architecture i386
	apt update
	echo -n "$(tput setaf 2)$(tput bold)Install Steam?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install -y steam
	fi
fi
echo -n "$(tput setaf 2)$(tput bold)Install Flatpak support?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	apt install -y flatpak gnome-software-plugin-flatpak
fi
echo -n "$(tput setaf 2)$(tput bold)Install sudo?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	apt install -y sudo
	echo -n "$(tput setaf 2)$(tput bold)Add $(cat user) to sudo group?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		usermod -a -G sudo $(cat user)
		echo -n "$(tput setaf 2)$(tput bold)Disable root password?$(tput sgr 0) "
		read answer
		if echo "$answer" | grep -iq "^y" ;then
			passwd -l root
		fi
	fi
fi
echo "$(tput setaf 2)$(tput bold)Setup complete$(tput sgr 0)"
exit 0
