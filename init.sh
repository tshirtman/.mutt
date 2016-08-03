#!/bin/bash
# run this script after cloning repo

while true
do
read -p "do you want to link muttrc to ~/.muttrc (Y/N)" yn
case $yn in
	[Yy]*) ln -s $PWD/muttrc ~/.muttrc; break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done

while true
do
read -p "do you want to link mbsyncrc to ~/.mbsyncrc (Y/N)" yn
case $yn in
	[Yy]*) ln -s $PWD/mbsyncrc ~/.mbsyncrc; break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done

while true
do
read -p "link mailsync.conf into ~/.config/mailsync/mailsync.conf?" yn
case $yn in
	[Yy]*) mkdir -p ~/.config/mailsync
		ln $PWD/mailsync.conf ~/.config/mailsync/mailsync.conf
		break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done


while true
do
read -p "do you want to install packages (isync, mutt-patches notmuch-mutt gnupg2)" yn
case $yn in
	[Yy]*) sudo apt-get install isync mutt-patched notmuch-mutt gnupg2;
		pip install --user imapclient
		break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done

$HOME/.mutt/gen-pgp-hooks.sh > $HOME/.mutt/gpg.rc
