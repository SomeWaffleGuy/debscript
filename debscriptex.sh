#/bin/bash
#DebScript Extra
#Extra sauce for DebScript
echo -n "$(tput setaf 2)$(tput bold)Replace Firefox-ESR with latest Firefox? It can update itself.
(y/N)$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	wget --content-disposition "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
	tar -xvf firefox*.tar.bz2
	sudo mv firefox /opt/
	sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
	wget https://github.com/SomeWaffleGuy/debscript/raw/master/firefox.desktop
	#chmod maybe not needed? Let me know.
	chmod +x firefox.desktop
	mv firefox.desktop ~/.local/share/applications/
	wget https://github.com/SomeWaffleGuy/debscript/raw/master/firefox-equiv.deb
	sudo dpkg -i firefox-equiv.deb
	rm firefox-equiv.deb firefox*.tar.bz2
	sudo apt-get -y purge firefox-esr
	sudo apt-get -y autoremove --purge
	sudo apt-get -y install libdbus-glib-1-2
fi
echo -n "$(tput setaf 2)$(tput bold)Install Google Chrome?
(y/N)$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpg -i google-chrome-stable_current_amd64.deb
	sudo rm google-chrome-stable_current_amd64.deb
	sudo apt-get --fix-broken install -y
fi
echo -n "$(tput setaf 2)$(tput bold)Install Lutris?
(y/N)$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo "deb http://download.opensuse.org/repositories/home:/strycore/Debian_10/ ./" | sudo tee /etc/apt/sources.list.d/lutris.list
	wget -q https://download.opensuse.org/repositories/home:/strycore/Debian_10/Release.key -O- | sudo apt-key add -
	sudo apt-get update
	sudo apt-get install -y lutris
fi
echo -n "$(tput setaf 2)$(tput bold)Install BlueMaxima's Flashpoint (will also install 32-bit Wine and PHP if not installed)? 
(y/N)$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	wget https://bluepload.unstable.life/selif/flashpoint-infinity-8-2-amd64-deb.7z
	7z x flashpoint-infinity-8-2-amd64-deb.7z
	sudo dpkg -i flashpoint*.deb
	rm flashpoint*.7z flashpoint*.deb
	sudo apt-get --fix-broken install -y
	sudo mkdir /opt/flashpoint-infinity
	sudo chown $(whoami) /opt/flashpoint-infinity
	echo "$(tput setaf 2)$(tput bold)Flashpoint requires setup on first run. I suggest using the created /opt/flashpoint-infinity for this. Additional configuration is found in /usr/lib/flashpoint-infinity/config.json  $(tput sgr 0) "
fi
echo -n "$(tput setaf 2)$(tput bold)Install latest adb/fastboot? 
(y/N)$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	sudo apt-get install git
	git clone https://github.com/M0Rf30/android-udev-rules.git
	sudo cp ./android-udev-rules/51-android.rules /etc/udev/rules.d/51-android.rules
	sudo chmod a+r /etc/udev/rules.d/51-android.rules
	sudo groupadd adbusers
	sudo usermod -a -G adbusers $(whoami)
	sudo systemctl restart systemd-udevd.service
	wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
	unzip platform-tools-latest-linux.zip
	sudo cp platform-tools/adb platform-tools/fastboot platform-tools/mke2fs* platform-tools/e2fsdroid /usr/local/bin
	sudo rm -rf platform-tools platform-tools-latest-linux.zip
	wget https://github.com/SomeWaffleGuy/debscript/raw/master/adb-updater.sh
	chmod +x adb-updater.sh
	#Better method of update?
	echo "$(tput setaf 2)$(tput bold)Use the included adb-updater.sh script to update adb/fastboot as needed. $(tput sgr 0) "
fi
echo -n "$(tput setaf 2)$(tput bold)Install latest youtube-dl? 
(y/N)$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl
fi
echo -n "$(tput setaf 2)$(tput bold)Set Pulseaudio to s32le (Improves quality at slight peformance cost)? 
(y/N)$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	sudo sed -i "s/; default-sample-format = s16le/default-sample-format = s32le/g" /etc/pulse/daemon.conf
	sudo sed -i "s/; resample-method = speex-float-1/resample-method = speex-float-10/g" /etc/pulse/daemon.conf
	sudo sed -i "s/; avoid-resampling = false/avoid-resampling = true/g" /etc/pulse/daemon.conf
fi	
echo "$(tput setaf 2)$(tput bold)That's all folks! $(tput sgr 0) "
echo "$(tput setaf 2)$(tput bold)Reboot to be safe. $(tput sgr 0) "
