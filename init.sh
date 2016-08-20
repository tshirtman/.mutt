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
read -p "do you want to link notmuch-config to ~/.notmuch-config (Y/N)" yn
case $yn in
	[Yy]*) ln -s $PWD/notmuch-config ~/.notmuch-config; break;;
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
	[Yy]*) sudo apt-get install isync mutt-patched notmuch-mutt gnupg2 jq tmux;
		pip install --user imapclient
		break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done

while true
do
read -p "do you want to install systemd service for mailsync?" yn
case $yn in
	[Yy]*) sudo cp $PWD/mailsync.service /etc/systemd/system/
		sudo systemctl enable mailsync.service
		break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done

while true
do
read -p "do you want to link [Gmail]/.* mailboxes into their parent dir? (Y/N)" yn
case $yn in
	[Yy]*) pushd $HOME/Mail/Personal
		python3 $HOME/.mutt/links.py
		popd
		break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done


$HOME/.mutt/gen-pgp-hooks.sh > $HOME/.mutt/gpg.rc
