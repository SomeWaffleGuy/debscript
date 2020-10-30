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
	sudo apt-get purge firefox-esr
	sudo apt-get autoremove --purge
fi
echo -n "$(tput setaf 2)$(tput bold)Install BlueMaxima's Flashpoint (will also install 32-bit Wine and PHP if not installed)? 
(y/N)$(tput sgr 0) "
read answer
if echo "$answer" | grep -iq "^y" ;then
	wget https://bluepload.unstable.life/selif/flashpoint-infinity-8-2-amd64-deb.7z
	7za e flashpoint-*.7z
	sudo dpkg -i flashpoint-*.deb
	rm flashpoint-*.deb flashpoint-*.7z
	sudo apt-get --fix-broken install
	sudo mkdir /opt/flashpoint-infinity
	sudo chown $(whoami) /opt/flashpoint-infinity
	echo "$(tput setaf 2)$(tput bold)Flashpoint requires setup on first run, I recommend using the /opt/flashpoint-infinity directory created for this purpose. $(tput sgr 0) "
fi
echo -n "$(tput setaf 2)$(tput bold)Install the latest adb/fastboot? 
(y/N)$(tput sgr 0) "
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
echo -n "$(tput setaf 2)$(tput bold)Set Pulseaudio to s32le (Improves quality at slight peformance cost)? 
(y/N)$(tput sgr 0) "
if echo "$answer" | grep -iq "^y" ;then
	sudo sed -i "s/; default-sample-format = s16le/default-sample-format = s32le/g" /etc/pulse/daemon.conf
	sudo sed -i "s/; resample-method = speex-float-1/resample-method = speex-float-10/g" /etc/pulse/daemon.conf
	sudo sed -i "s/; avoid-resampling = false/avoid-resampling = true/g" /etc/pulse/daemon.conf
fi	
echo "$(tput setaf 2)$(tput bold)That's all folks! $(tput sgr 0) "
echo "$(tput setaf 2)$(tput bold)Reboot to be safe. $(tput sgr 0) "
