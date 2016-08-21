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
read -p "do you want to build neomutt?" yn
case $yn in
	[Yy]*) sudo apt-get install debhelper dh-autoreconf docbook-xml docbook-xsl libgnutls28-dev libgpgme11-dev libidn11-dev libkrb5-dev libncursesw5-dev libsasl2-dev libtokyocabinet-dev xsltproc
		pushd /tmp
		git clone https://anonscm.debian.org/git/pkg-mutt/mutt.git || (pushd mutt; git pull; popd)
		wget http://http.debian.net/debian/pool/main/m/mutt/mutt_$(head -n 1 mutt/debian/changelog |sed -s 's/.*(\(.*\)-.*/\1/').orig.tar.gz
		pushd mutt
		dpkg-buildpackage
		popd
		sudo dpkg -i mutt*.deb
		sudo apt install -f
		popd
		break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done

while true
do
read -p "do you want to install packages (isync, gnupg2 jq tmux imapclient urlscan)" yn
case $yn in
	[Yy]*) sudo apt-get install isync gnupg2 jq tmux;
		pip install --user imapclient urlscan
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


while true
do
read -p "do you want to link gpg-agent.conf into ~/.gnupg? (Y/N)" yn
case $yn in
	[Yy]*) ln -s $HOME/.mutt/gpg-agent.conf ~/.gnupg/
		break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done


$HOME/.mutt/gen-pgp-hooks.sh > $HOME/.mutt/gpg.rc
