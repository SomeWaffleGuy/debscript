#/bin/bash
#DebScript Stable: A Better Debian Install Script
echo "$(tput setaf 2)$(tput bold)This script will configure a fresh install of Debian with the default Debian Desktop selection (GNOME) to be what I consider a useable desktop. This includes$(tput sgr 0)$(tput setaf 1)$(tput bold) NON-FREE SOFTWARE AND DRIVERS$(tput sgr 0)$(tput setaf 2)$(tput bold) and suggests software which may be subject to restrictions under local law. $(tput sgr 0)"
echo -n "$(tput setaf 2)$(tput bold)Continue? 
(y/N)$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo "$(tput setaf 2)$(tput bold)Uninstalling useless GNOME parts...$(tput sgr 0)"
		sudo apt-get purge -y gnome-maps gnome-music gnome-photos gnome-games gnome-documents gnome-dictionary polari shotwell xterm libreoffice*
		sudo apt-get autoremove --purge -y
	echo "$(tput setaf 2)$(tput bold)Modifying sources.list...$(tput sgr 0)"
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
		sudo apt-get update
		sudo dpkg --add-architecture i386
		sudo apt-get update
		sudo apt-get dist-upgrade -y
	echo "$(tput setaf 2)$(tput bold)Installing necessary backports...$(tput sgr 0)"
		sudo apt-get install -t buster-backports firmware-linux linux-image-amd64 linux-headers-amd64 flatpak -y
	echo -n "$(tput setaf 2)$(tput bold)Install Intel Network Drivers? 
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt-get install -t buster-backports firmware-iwlwifi -y
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install Realtek Network Drivers? 
(y/N)$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt-get install -t buster-backports firmware-realtek -y
	fi
	sudo apt-get autoremove --purge
	echo -n "$(tput setaf 2)$(tput bold)Which GPU do you have?
1: Intel
2: AMD/ATI
3: Nvidia w/ Nouveau (Not recommended)
4: Nvidia w/ proprietary driver $(tput sgr 0)"
	read answer
	if echo "$answer" | grep -iq "^1" ;then
		sudo apt-get install -y intel-media-va-driver-non-free
		sudo su -c 'echo "# KMS
intel_agp
drm
i915 modeset=1" >> /etc/initramfs-tools/modules'
		elif echo "$answer" | grep -iq "^2" ;then
		sudo apt-get install -t buster-backports firmware-amd-graphics -y
		sudo su -c 'echo "# KMS
drm
radeon modeset=1" >> /etc/initramfs-tools/modules'
		elif echo "$answer" | grep -iq "^3" ;then
		sudo su -c 'echo "# KMS
drm
nouveau modeset=1" >> /etc/initramfs-tools/modules'
		elif echo "$answer" | grep -iq "^4" ;then
		sudo su -c 'echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia-drm-nomodeset.conf'
		sudo apt-get install -t buster-backports nvidia-driver nvidia-cuda-dev nvidia-cuda-toolkit nvidia-driver-libs:i386 -y
	fi
	echo "$(tput setaf 2)$(tput bold)Installing typical applications...(tput sgr 0)"
		sudo apt-get install -y gnome-shell-extension-appindicator libavcodec-extra mpv ttf-mscorefonts-installer fonts-cabin fonts-comfortaa fonts-croscore fonts-ebgaramond fonts-ebgaramond-extra fonts-font-awesome fonts-freefont-otf fonts-freefont-ttf fonts-gfs-artemisia fonts-gfs-complutum fonts-gfs-didot fonts-gfs-neohellenic fonts-gfs-olga fonts-gfs-solomos fonts-junicode fonts-lmodern fonts-lobster fonts-lobstertwo fonts-noto-hinted fonts-oflb-asana-math fonts-sil-gentiumplus fonts-sil-gentiumplus-compact fonts-stix fonts-texgyre fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core fonts-roboto fonts-symbola unrar zip plymouth plymouth-themes apparmor apparmor-profiles apparmor-profiles-extra apparmor-utils steam dxvk gnome-software-plugin-flatpak
		sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	echo "$(tput setaf 2)$(tput bold)Enabling Plymouth and AppArmor...$(tput sgr 0) "
		sudo perl -pi -e 's,GRUB_CMDLINE_LINUX_DEFAULT="(.*)"$,GRUB_CMDLINE_LINUX_DEFAULT="$1 splash",' /etc/default/grub
		sudo perl -pi -e 's,GRUB_CMDLINE_LINUX="(.*)"$,GRUB_CMDLINE_LINUX="$1 apparmor=1 security=apparmor",' /etc/default/grub
		sudo update-grub
		sudo plymouth-set-default-theme -R futureprototype
		sudo update-initramfs -u
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
	echo "$(tput setaf 2)$(tput bold)Some things cannot be automated as of yet, for example the AppIndicator Extension must be enabled manually after restarting GNOME (Fixed in later GNOME versions, so the code is included here for that eventuality) and 12-hour time in GDM must be set manually. 12-hour GDM time is commented at the end of this script.$(tput sgr 0)"
	echo "$(tput setaf 2)$(tput bold)Setup complete, please restart your system.$(tput sgr 0)"
fi
#As root (sudo -i) run;
#echo "[org/gnome/desktop/interface]
#clock-format='12h'" >> /etc/gdm3/greeter.dconf-defaults
#dpkg-reconfigure gdm3
#
#MAKE SURE NOT TO INCLUDE COMMENTING (#)
exit 0
