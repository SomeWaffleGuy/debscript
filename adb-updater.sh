#/bin/sh
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip platform-tools-latest-linux.zip
sudo cp -v platform-tools/adb platform-tools/fastboot platform-tools/mke2fs* platform-tools/e2fsdroid /usr/local/bin
sudo rm -rf platform-tools platform-tools-latest-linux.zip
exit 0
