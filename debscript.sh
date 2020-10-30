#/bin/bash
#DebScript: Debian customization script
#THIS SCRIPT IS EOL, use debscriptv2.sh and debscriptex.sh instead. Provided for modifaction and archival purpose.
echo "$(tput setaf 2)$(tput bold)Uninstalling useless GNOME parts...$(tput sgr 0)"
sleep 3
	sudo apt purge -y gnome-maps gnome-music gnome-photos gnome-games gnome-documents gnome-dictionary polari shotwell xterm libreoffice*
	sudo apt autoremove --purge -y
echo "$(tput setaf 2)$(tput bold)Enabling HTTPS for sudo apt...$(tput sgr 0)"
sleep 3
	sudo apt install -y sudo apt-transport-https
echo -n "$(tput setaf 2)$(tput bold)Which Debian version do you wish to run? (Use Unstable for fast updates, beware of potential breakage)
1: Stable
2: Unstable
$(tput sgr 0)"
read answer
if echo "$answer" | grep -iq "^1" ;then
	sudo su -c 'echo "# Debian Stable
deb https://deb.debian.org/debian/ stable main contrib non-free
#deb-src https://deb.debian.org/debian/ stable main contrib non-free

deb https://deb.debian.org/debian/ stable-updates main contrib non-free
#deb-src https://deb.debian.org/debian/ stable-updates main contrib non-free

deb https://deb.debian.org/debian-security stable/updates main contrib non-free
#deb-src https://deb.debian.org/debian-security stable/updates main contrib non-free

# Backports (Update codename manually for major version changes)
deb http://ftp.debian.org/debian buster-backports main contrib non-free
#deb-src http://ftp.debian.org/debian buster-backports main contrib non-free" > /etc/apt/sources.list'
	sudo apt update
	sudo apt dist-upgrade -y
elif echo "$answer" | grep -iq "^2" ;then
	sudo su -c 'echo "# Debian Sid
deb https://deb.debian.org/debian/ sid main contrib non-free
#deb-src https://deb.debian.org/debian/ sid main contrib non-free" > /etc/apt/sources.list'
	sudo apt update
	sudo apt dist-upgrade -y
fi
# 12 hour set cannot work running as user. Suggestions welcome.
#echo -n "$(tput setaf 2)$(tput bold)Use 12 hour time on GDM?
#(y/N)$(tput sgr 0) "
#read answer
#if echo "$answer" | grep -iq "^y" ;then
#	sudo echo "[org/gnome/desktop/interface]
#clock-format='12h'" >> /etc/gdm3/greeter.dconf-defaults
#fi
#sudo dpkg-reconfigure gdm3
echo "$(tput setaf 2)$(tput bold)Installing AppIndicator Extension...(tput sgr 0)"
sudo apt install -y gnome-shell-extension-appindicator
echo -n "$(tput setaf 2)$(tput bold)Select Install options
1: Typical Install
2: Custom Install
$(tput sgr 0)"
read answer
if echo "$answer" | grep -iq "^2" ;then
	echo -n "$(tput setaf 2)$(tput bold)Install Non-Free Firmware?
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt install -y firmware-linux-nonfree
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install extra media codecs?
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt install -y libavcodec-extra
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install mpv?
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt install -y mpv youtube-dl
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install extra fonts (fixes blank unicode characters)?
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt install -y ttf-mscorefonts-installer fonts-cabin fonts-comfortaa fonts-croscore fonts-ebgaramond fonts-ebgaramond-extra fonts-font-awesome fonts-freefont-otf fonts-freefont-ttf fonts-gfs-artemisia fonts-gfs-complutum fonts-gfs-didot fonts-gfs-neohellenic fonts-gfs-olga fonts-gfs-solomos fonts-junicode fonts-lmodern fonts-lobster fonts-lobstertwo fonts-noto-hinted fonts-oflb-asana-math fonts-sil-gentiumplus fonts-sil-gentiumplus-compact fonts-stix fonts-texgyre fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core fonts-roboto fonts-symbola
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install unrar and zip?
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt install -y unrar zip
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install proprietary Nvidia drivers?
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt install -y nvidia-driver nvidia-cuda-dev nvidia-cuda-toolkit
		sudo apt install -y nvidia-driver-libs:i386
		sudo echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia-drm-nomodeset.conf
		sudo update-initramfs -u
	fi
	echo -n "$(tput setaf 2)$(tput bold)Enable KMS (Proprietary Nvidia users can skip this)?
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		echo -n "$(tput setaf 2)$(tput bold)Which GPU?
1: Intel
2: AMD/ATI
3: Nvidia (Nouveau only)
$(tput sgr 0)"
		read answer
		if echo "$answer" | grep -iq "^1" ;then
		sudo su -c 'echo "# KMS
intel_agp
drm
i915 modeset=1" >> /etc/initramfs-tools/modules'
		elif echo "$answer" | grep -iq "^2" ;then
		sudo su -c 'echo "# KMS
drm
radeon modeset=1" >> /etc/initramfs-tools/modules'
		elif echo "$answer" | grep -iq "^3" ;then
		sudo su -c 'echo "# KMS
drm
nouveau modeset=1" >> /etc/initramfs-tools/modules'
		fi
	fi
	echo -n "$(tput setaf 2)$(tput bold)Enable Plymouth?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt install -y plymouth plymouth-themes
		sudo perl -pi -e 's,GRUB_CMDLINE_LINUX_DEFAULT="(.*)"$,GRUB_CMDLINE_LINUX_DEFAULT="$1 splash",' /etc/default/grub
		sudo update-grub
		sudo plymouth-set-default-theme -R futureprototype
	fi
	echo -n "$(tput setaf 2)$(tput bold)Which browser?
1: Firefox-ESR
2: Chromium
$(tput sgr 0)"
	read answer
	if echo "$answer" | grep -iq "^2" ;then
		sudo apt install -y chromium
		sudo apt purge -y firefox-esr
		sudo apt autoremove --purge -y
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install AppArmor and Profiles?
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt install -y apparmor apparmor-profiles apparmor-profiles-extra apparmor-utils
		sudo perl -pi -e 's,GRUB_CMDLINE_LINUX="(.*)"$,GRUB_CMDLINE_LINUX="$1 apparmor=1 security=apparmor",' /etc/default/grub
		sudo update-grub
	fi
	echo -n "$(tput setaf 2)$(tput bold)Enable multiarch?
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo dpkg --add-architecture i386
		sudo apt update
		echo -n "$(tput setaf 2)$(tput bold)Install Steam?
(y/N)$(tput sgr 0) "
		read answer
		if echo "$answer" | grep -iq "^y" ;then
			sudo apt install -y steam dxvk
		fi
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install Flatpak support?
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt install -y flatpak gnome-software-plugin-flatpak
		sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	fi
elif echo "$answer" | grep -iq "^1" ;then
	#Install all of the usual things
	sudo dpkg --add-architecture i386
	sudo apt update
	sudo apt install -y linux-headers-amd64 firmware-linux-nonfree libavcodec-extra mpv youtube-dl ttf-mscorefonts-installer fonts-cabin fonts-comfortaa fonts-croscore fonts-ebgaramond fonts-ebgaramond-extra fonts-font-awesome fonts-freefont-otf fonts-freefont-ttf fonts-gfs-artemisia fonts-gfs-complutum fonts-gfs-didot fonts-gfs-neohellenic fonts-gfs-olga fonts-gfs-solomos fonts-junicode fonts-lmodern fonts-lobster fonts-lobstertwo fonts-noto-hinted fonts-oflb-asana-math fonts-sil-gentiumplus fonts-sil-gentiumplus-compact fonts-stix fonts-texgyre fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core fonts-roboto fonts-symbola unrar zip plymouth plymouth-themes apparmor apparmor-profiles apparmor-profiles-extra apparmor-utils steam dxvk flatpak gnome-software-plugin-flatpak
	#Add Flathub
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	#Ask for GPU to set up KMS
	echo -n "$(tput setaf 2)$(tput bold)Select GPU
1: Intel
2: AMD/ATI
3: Nvidia (Nouveau)
4: Nvidia (Proprietary)
$(tput sgr 0)"
	read answer
	if echo "$answer" | grep -iq "^1" ;then
	sudo echo "# KMS
intel_agp
drm
i915 modeset=1" >> /etc/initramfs-tools/modules
	elif echo "$answer" | grep -iq "^2" ;then
	sudo echo "# KMS
drm
radeon modeset=1" >> /etc/initramfs-tools/modules
	elif echo "$answer" | grep -iq "^3" ;then
	sudo echo "# KMS
drm
nouveau modeset=1" >> /etc/initramfs-tools/modules
	elif echo "$answer" | grep -iq "^4" ;then
		sudo apt install -y nvidia-driver nvidia-cuda-dev nvidia-cuda-toolkit
		sudo apt install -y nvidia-driver-libs:i386
		sudo echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia-drm-nomodeset.conf
		sudo update-initramfs -u
	fi
	#Edit GRUB as needed, set Plymouth theme
	sudo perl -pi -e 's,GRUB_CMDLINE_LINUX_DEFAULT="(.*)"$,GRUB_CMDLINE_LINUX_DEFAULT="$1 splash",' /etc/default/grub
	sudo perl -pi -e 's,GRUB_CMDLINE_LINUX="(.*)"$,GRUB_CMDLINE_LINUX="$1 apparmor=1 security=apparmor",' /etc/default/grub
	sudo plymouth-set-default-theme -R futureprototype
	sudo update-grub
fi
echo "$(tput setaf 2)$(tput bold)Making GNOME more useable...$(tput sgr 0)"
# Commented  out stuff not currently working in Stable
#gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.desktop.interface clock-show-date 'true'
gsettings set org.gnome.desktop.interface clock-show-weekday 'true'
#gsettings set org.gnome.desktop.interface enable-hot-corners 'false'
gsettings set org.gnome.desktop.interface show-battery-percentage 'true'
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.nautilus.preferences show-create-link 'true'
gsettings set org.gnome.nautilus.preferences thumbnail-limit '4096'
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'standard'
gsettings set org.gnome.gedit.preferences.editor bracket-matching 'false'
gsettings set org.gnome.gedit.preferences.editor highlight-current-line 'false'
echo -n "$(tput setaf 2)$(tput bold)Use dark theme? 
(y/N)$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
fi
echo "$(tput setaf 2)$(tput bold)RESTART REQUIRED TO COMPLETE SETUP$(tput sgr 0)"
exit 0
