#/bin/sh
#Testing installer/customizer
echo "$(tput setaf 2)$(tput bold)Uninstalling useless GNOME parts$(tput sgr 0)"
sleep 3
	apt purge -y gnome-maps gnome-music gnome-photos gnome-games gnome-documents gnome-weather gnome-dictionary polari libreoffice libreoffice-*
	apt autoremove --purge -y
echo "$(tput setaf 2)$(tput bold)Enabling HTTPS for APT$(tput sgr 0)"
sleep 3
	apt install -y apt-transport-https
echo "$(tput setaf 2)$(tput bold)Modifying sources.list and upgrading$(tput sgr 0)"
sleep 3
	rm /etc/apt/sources.list
	echo "# Debian Testing
deb https://deb.debian.org/debian/ testing main non-free contrib
deb-src https://deb.debian.org/debian/ testing main non-free contrib

deb https://deb.debian.org/debian-security testing/updates main contrib non-free
deb-src https://deb.debian.org/debian-security testing/updates main contrib non-free" > /etc/apt/sources.list
	apt update
	apt dist-upgrade -y
echo -n "$(tput setaf 2)$(tput bold)Install Non-Free Firmware?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	apt install -y firmware-linux-nonfree
fi
echo -n "$(tput setaf 2)$(tput bold)Enable KMS?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo -n "$(tput setaf 2)$(tput bold)Which GPU?
1:Intel
2:AMD/ATI
3:Nouveau
$(tput sgr 0) "
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
$(tput sgr 0) "
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
	flatpak remote-add --user --gpg-import=gnome-sdk.gpg gnome https://sdk.gnome.org/repo/
	flatpak install --user gnome org.gnome.Platform 3.24
	echo -n "$(tput setaf 2)$(tput bold)Download Discord and LibreOffice Flatpak files?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		su $(cat user) -c 'wget http://download.documentfoundation.org/libreoffice/flatpak/latest/LibreOffice.flatpak'
		su $(cat user) -c 'wget https://dl.tingping.se/flatpak/discord.flatpakref'
	fi
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
rm wget-log*
echo "$(tput setaf 2)$(tput bold)Setup complete$(tput sgr 0)"
exit 0
