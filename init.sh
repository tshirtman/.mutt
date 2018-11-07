#!/bin/bash
# run this script after cloning repo

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
		python3 $HOME/.neomutt/links.py
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

# setup msmtp-queue
chmod +x msmtp*
cp msmtp* ~/.local/bin/
mkdir -p ~/.neomutt/.msmtp.queue/
chmod 0700 ~/.neomutt/.msmtp.queue/
