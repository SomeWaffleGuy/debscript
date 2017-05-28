#/bin/sh
#Testing installer/customizer
echo "$(tput setaf 2)$(tput bold)Enabling HTTPS for APT$(tput sgr 0)"
sleep 3
	apt install -y apt-transport-https
echo "$(tput setaf 1)$(tput bold)Make SURE install was successful, script will not function otherwise$(tput sgr 0)"
read -p "$(tput setaf 2)$(tput bold)Press Enter to continue$(tput sgr 0)"
echo "$(tput setaf 2)$(tput bold)Modifying sources.list and upgrading$(tput sgr 0)"
sleep 3
	echo "# Debian Testing
deb https://deb.debian.org/debian/ testing main non-free contrib
deb-src https://deb.debian.org/debian/ testing main non-free contrib

deb https://deb.debian.org/debian-security testing/updates main contrib non-free
deb-src https://deb.debian.org/debian-security testing/updates main contrib non-free" > /etc/apt/sources.list
	apt update
	apt dist-upgrade -y
echo "$(tput setaf 2)$(tput bold)Installing Arc theme and Moka icons$(tput sgr 0)"
sleep 3
	apt install -y arc-theme moka-icon-theme breeze-cursor-theme libreoffice libreoffice-gnome libreoffice-style-sifr budgie-desktop lightdm gnome-terminal gnome-software
	echo "[Icon Theme]
Inherits=breeze_cursors" > /usr/share/icons/default/index.theme
	echo "[SeatDefaults]
greeter-hide-users=false" > /usr/share/lightdm/lightdm.conf.d/01_my.conf
	echo "theme-name=Arc-Darker
icon-theme-name=Moka
font-name=Liberation Sans 10
clock-format=%l:%M %p" >> /etc/lightdm/lightdm-gtk-greeter.conf
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
		apt install -y ttf-mscorefonts-installer fonts-cabin fonts-comfortaa fonts-croscore fonts-ebgaramond fonts-ebgaramond-extra fonts-font-awesome fonts-freefont-otf fonts-freefont-ttf fonts-gfs-artemisia fonts-gfs-complutum fonts-gfs-didot fonts-gfs-neohellenic fonts-gfs-olga fonts-gfs-solomos fonts-junicode fonts-lmodern fonts-lobster fonts-lobstertwo fonts-noto-hinted fonts-oflb-asana-math fonts-sil-gentiumplus fonts-sil-gentiumplus-compact fonts-stix fonts-texgyre ttf-adf-accanthis ttf-adf-gillius ttf-adf-universalis fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core fonts-roboto
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install unrar and zip?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install -y unrar zip
	fi
	echo -n "$(tput setaf 2)$(tput bold)Install proprietary Nvidia drivers?$(tput sgr 0) "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		apt install -y nvidia-driver
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
		plymouth-set-default-theme -R joy
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
		#Not available in current Testing, uncomment if it comes back
		#echo -n "$(tput setaf 2)$(tput bold)Install Adobe Flash for Chromium?$(tput sgr 0) "
		#read answer
		#if echo "$answer" | grep -iq "^y" ;then
		#	apt install pepperflashplugin-nonfree
		#fi
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
elif echo "$answer" | grep -iq "^1" ;then
	#Install all of the usual things
	dpkg --add-architecture i386
	apt update
	apt install -y firmware-linux-nonfree libavcodec-extra mpv youtube-dl ttf-mscorefonts-installer fonts-cabin fonts-comfortaa fonts-croscore fonts-ebgaramond fonts-ebgaramond-extra fonts-font-awesome fonts-freefont-otf fonts-freefont-ttf fonts-gfs-artemisia fonts-gfs-complutum fonts-gfs-didot fonts-gfs-neohellenic fonts-gfs-olga fonts-gfs-solomos fonts-junicode fonts-lmodern fonts-lobster fonts-lobstertwo fonts-noto-hinted fonts-oflb-asana-math fonts-sil-gentiumplus fonts-sil-gentiumplus-compact fonts-stix fonts-texgyre ttf-adf-accanthis ttf-adf-gillius ttf-adf-universalis fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core fonts-roboto unrar zip plymouth plymouth-themes chromium chromium-widevine torbrowser-launcher apparmor apparmor-profiles apparmor-profiles-extra apparmor-utils steam sudo
	apt purge -y firefox-esr
	apt autoremove --purge -y
	#Setup Widevine
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	dpkg -x google-chrome-stable_current_amd64.deb ~/tmp
	mv ~/tmp/opt/google/chrome/libwidevinecdm* /usr/lib/chromium/
	rm -rf ~/tmp
	rm google-chrome-stable_current_amd64.deb
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
		apt install -y nvidia-driver
	fi
	#Edit GRUB as needed, set Plymouth theme
	perl -pi -e 's,GRUB_CMDLINE_LINUX_DEFAULT="(.*)"$,GRUB_CMDLINE_LINUX_DEFAULT="$1 splash",' /etc/default/grub
	perl -pi -e 's,GRUB_CMDLINE_LINUX="(.*)"$,GRUB_CMDLINE_LINUX="$1 apparmor=1 security=apparmor",' /etc/default/grub
	plymouth-set-default-theme -R joy
	update-grub
fi
