#/bin/sh
#Scrip with the intention of setting up a custom Debian Sid install from
#current Testing, may or may not ever actually work
echo "$(tput setaf 1)$(tput bold)An Internet connection is REQUIRED$(tput sgr 0)"
echo "$USER" > user
if [ $(cat user) = root ]
then
	echo "$(tput setaf 1)$(tput bold)Must run as non-root user$(tput sgr 0)"
	exit
fi
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
exit 0
