# DebScript Stable
A better-than-bad Debian post-install script

Should (mostly) work and provide a basic useable system


### Instructions

```
wget https://raw.githubusercontent.com/SomeWaffleGuy/debscript/master/debscriptv2.sh
chmod +x debscriptv2.sh
./debscriptv2.sh
```

For additional configuration (Latest Firefox for example), also use DebScriptEX

```
wget https://raw.githubusercontent.com/SomeWaffleGuy/debscript/master/debscriptex.sh
chmod +x debscriptex.sh
./debscriptex.sh
```

DebScriptEX violates some principles outlined here;

https://wiki.debian.org/DontBreakDebian

If you are concerned aobut this (although in my experience it has been fine) then avoid using it.

# Additional Scripts
DebScript v1 is provided in this repo for use however you see fit. It is far more clunky but offers options the v2 script does not (Sid install for example) and likely won't outright break anytime soon.

If you use Fedora, check out;

https://github.com/SomeWaffleGuy/tippyscript

It includes a README.md with configuration tips helpful for Debian as well.
