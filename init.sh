#!/bin/bash
# run this script after cloning repo

ln -sf $PWD/mbsyncrc ~/.mbsyncrc
ln -sf $PWD/notmuch-config ~/.notmuch-config

mkdir -p ~/.config/mailsync
ln -sf $PWD/mailsync.conf ~/.config/mailsync/mailsync.conf


while true
do
read -p "do you want to install packages (isync, gnupg2 jq tmux imapclient urlscan)" yn
case $yn in
	[Yy]*) sudo apt-get install isync gnupg2 jq tmux;
		pip install --user imapclient urlscan mutt_ics
		break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done

while true
do
read -p "do you want to install systemd service for mailsync?" yn
case $yn in
	[Yy]*)  mkdir -p ~/.config/system/user/
		cp $PWD/mailsync.service ~/.config/systemd/user/
		systemctl enable mailsync.service --user
		systemctl start mailsync.service --user
		break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done


while true
do
read -p "do you want to link gpg-agent.conf into ~/.gnupg? (Y/N)" yn
case $yn in
	[Yy]*) ln -s $HOME/.neomutt/gpg-agent.conf ~/.gnupg/
		break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done

if [ ! $(which electron) ]
then
	while true
	do
	read -p "do you want to install electron into ~/.local/node-modules? (Y/N)" yn
	case $yn in
		[Yy]*) pushd ~/.local/
			npm install electron
			popd
			break;;
		[Nn]*) break;;
		*) echo "please answer yes or no";;
	esac
	done
fi

while true
do
read -p "link email.html into /usr/share/pandoc/data/templates/email.html? (Y/N)" yn
case $yn in
	[Yy]*) sudo ln -s email.html /usr/share/pandoc/data/templates
		break;;
	[Nn]*) break;;
	*) echo "please answer yes or no";;
esac
done

pushd $HOME/Mail/Personal
python3 $HOME/.neomutt/links.py
popd

pushd $HOME/Mail/Partoo
python3 $HOME/.neomutt/links.py
popd

# setup msmtp-queue
chmod +x msmtp*
cp msmtp* ~/.local/bin/
mkdir -p ~/.neomutt/.msmtp.queue/
chmod 0700 ~/.neomutt/.msmtp.queue/
