#/bin/sh
#Stable installer/customizer
echo "$(tput setaf 2)$(tput bold)Uninstalling useless GNOME parts$(tput sgr 0)"
sleep 3
	apt purge -y gnome-maps gnome-music gnome-photos gnome-games gnome-documents gnome-dictionary polari shotwell xterm libreoffice*
	apt autoremove --purge -y
echo "$(tput setaf 2)$(tput bold)Enabling HTTPS for APT$(tput sgr 0)"
sleep 3
	apt install -y apt-transport-https
echo "$(tput setaf 2)$(tput bold)Modifying sources.list and upgrading$(tput sgr 0)"
sleep 3
	echo "# Debian Stable
deb https://deb.debian.org/debian/ stable main contrib non-free
#deb-src https://deb.debian.org/debian/ stable main contrib non-free

deb https://deb.debian.org/debian/ stable-updates main contrib non-free
#deb-src https://deb.debian.org/debian/ stable-updates main contrib non-free

deb https://deb.debian.org/debian-security stable/updates main contrib non-free
#deb-src https://deb.debian.org/debian-security stable/updates main contrib non-free

# Backports (Update codename manually for major version changes)
deb http://ftp.debian.org/debian buster-backports main contrib non-free
#deb-src http://ftp.debian.org/debian buster-backports main contrib non-free" > /etc/apt/sources.list
	apt update
	apt dist-upgrade -y
sleep 3
echo -n "$(tput setaf 2)$(tput bold)Use 12 hour time on GDM?$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo "[org/gnome/desktop/interface]
clock-format='12h'" >> /etc/gdm3/greeter.dconf-defaults
fi
dpkg-reconfigure gdm3
echo -n "$(tput setaf 2)$(tput bold)Select Install options
1: Typical Install
2: Custom Install
$(tput sgr 0)"
read answer
if echo "$answer" | grep -iq "^2" ;then
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
	echo -n "$(tput setaf 2)$(tput bold)Install mpv?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install -y mpv youtube-dl
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install extra fonts (fixes blank unicode characters)?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install -y ttf-mscorefonts-installer fonts-cabin fonts-comfortaa fonts-croscore fonts-ebgaramond fonts-ebgaramond-extra fonts-font-awesome fonts-freefont-otf fonts-freefont-ttf fonts-gfs-artemisia fonts-gfs-complutum fonts-gfs-didot fonts-gfs-neohellenic fonts-gfs-olga fonts-gfs-solomos fonts-junicode fonts-lmodern fonts-lobster fonts-lobstertwo fonts-noto-hinted fonts-oflb-asana-math fonts-sil-gentiumplus fonts-sil-gentiumplus-compact fonts-stix fonts-texgyre fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core fonts-roboto fonts-symbola
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install unrar and zip?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install -y unrar zip
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install proprietary Nvidia drivers?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install -t buster-backports -y nvidia-driver nvidia-cuda-dev nvidia-cuda-toolkit
		apt install -y nvidia-driver-libs:i386
		echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia-drm-nomodeset.conf
		sudo update-initramfs -u
	fi
	echo -n "$(tput setaf 2)$(tput bold)Enable KMS (Proprietary Nvidia users can skip this)?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		echo -n "$(tput setaf 2)$(tput bold)Which GPU?
1: Intel
2: AMD/ATI
3: Nvidia (Nouveau only)
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
	fi
	echo -n "$(tput setaf 2)$(tput bold)Enable Plymouth?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install -y plymouth plymouth-themes
		perl -pi -e 's,GRUB_CMDLINE_LINUX_DEFAULT="(.*)"$,GRUB_CMDLINE_LINUX_DEFAULT="$1 splash",' /etc/default/grub
		update-grub
		plymouth-set-default-theme -R futureprototype
	fi
	echo -n "$(tput setaf 2)$(tput bold)Which browser?
1: Firefox-ESR
2: Chromium
$(tput sgr 0)"
	read answer
	if echo "$answer" | grep -iq "^2" ;then
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
			apt install -y steam dxvk
		fi
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install Flatpak support?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install -y flatpak gnome-software-plugin-flatpak
		flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	fi
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install typical Flatpak applications?$(tput sgr 0) "
	if echo "$answer" | grep -iq "^y" ;then
		flatpak install org.gtk.Gtk3theme.Adwaita-dark org.libreoffice.LibreOffice org.gimp.GIMP org.signal.Signal com.discordapp.Discord
	fi
elif echo "$answer" | grep -iq "^1" ;then
	#Install all of the usual things
	dpkg --add-architecture i386
	apt update
	apt install -y linux-headers-amd64 firmware-linux-nonfree libavcodec-extra mpv youtube-dl ttf-mscorefonts-installer fonts-cabin fonts-comfortaa fonts-croscore fonts-ebgaramond fonts-ebgaramond-extra fonts-font-awesome fonts-freefont-otf fonts-freefont-ttf fonts-gfs-artemisia fonts-gfs-complutum fonts-gfs-didot fonts-gfs-neohellenic fonts-gfs-olga fonts-gfs-solomos fonts-junicode fonts-lmodern fonts-lobster fonts-lobstertwo fonts-noto-hinted fonts-oflb-asana-math fonts-sil-gentiumplus fonts-sil-gentiumplus-compact fonts-stix fonts-texgyre fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core fonts-roboto fonts-symbola unrar zip plymouth plymouth-themes apparmor apparmor-profiles apparmor-profiles-extra apparmor-utils steam dxvk flatpak gnome-software-plugin-flatpak
	#Add Flathub and install Flatpak applications
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install org.gtk.Gtk3theme.Adwaita-dark org.libreoffice.LibreOffice org.gimp.GIMP org.signal.Signal com.discordapp.Discord
	#Ask for GPU to set up KMS
	echo -n "$(tput setaf 2)$(tput bold)Which GPU do you have?
1: Intel
2: AMD/ATI
3: Nvidia (Nouveau)
4: Nvidia (Proprietary)
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
	elif echo "$answer" | grep -iq "^4" ;then
		apt install -t buster-backports -y nvidia-driver nvidia-cuda-dev nvidia-cuda-toolkit
		apt install -y nvidia-driver-libs:i386
		echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia-drm-nomodeset.conf
		sudo update-initramfs -u
	fi
	#Edit GRUB as needed, set Plymouth theme
	perl -pi -e 's,GRUB_CMDLINE_LINUX_DEFAULT="(.*)"$,GRUB_CMDLINE_LINUX_DEFAULT="$1 splash",' /etc/default/grub
	perl -pi -e 's,GRUB_CMDLINE_LINUX="(.*)"$,GRUB_CMDLINE_LINUX="$1 apparmor=1 security=apparmor",' /etc/default/grub
	plymouth-set-default-theme -R futureprototype
	update-grub
fi
exit 0
