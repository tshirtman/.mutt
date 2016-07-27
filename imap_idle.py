#!/usr/bin/env python
# coding: utf-8
# imap-idle for mbsync (or other imap sync)
# copyright (c) 2016, Gabriel Pettier
# usage:
# - edit the MBSYNC, GPG_COMMAND and conf variables to suit your
# configuration
# - run python imap_idle.py
# BSD licensed
# Please see http://en.wikipedia.org/wiki/BSD_licenses

from __future__ import unicode_literals

from threading import Thread
from imapclient import IMAPClient
from time import sleep
from subprocess import Popen, check_output
from os.path import expanduser

MBSYNC = '/usr/bin/mbsync'
GPG_COMMAND = '/usr/bin/gpg2 --batch --decrypt ~/.mutt/passwords.gpg | /usr/bin/jq .{} -r'  # noqa
POST_SYNC_COMMANDS = [
    ['/usr/bin/notmuch', 'new'],
    [expanduser('~/.mutt/nottoomuch-addresses.sh'), '--update'],
    [expanduser('~/.mutt/notify-mail'), expanduser('~/Mail/tangible/INBOX')],
    [expanduser('~/.mutt/notify-mail'), expanduser('~/Mail/Personal/INBOX')],
]

conf = [
    {
        'host': 'imap.gmail.com',
        'user': 'gabriel.pettier@gmail.com',
        'pass': "only used if pass_cmd doesn't exist",
        'pass_cmd': GPG_COMMAND.format('mail_gmail'),
        'local': 'gmail',
        'boxes': ['INBOX', u'[Gmail]/Messages envoyés', 'tangible', 'ML'],
        'ssl': True,
    },
    {
        'host': 'mail.gandi.net',
        'user': 'gabriel@tangibledisplay.com',
        'pass': "only used if pass_cmd doesn't exist",
        'pass_cmd': GPG_COMMAND.format('mail_tangible'),
        'local': 'tangible',
        'boxes': ['INBOX', 'Sent'],
        'ssl': True,
    },
]


def icheck_output(*args, **kwargs):
    print("calling, {}, {}".format(args, kwargs))
    process = Popen(*args, **kwargs)
    process.wait()


def sync(host=None, box=None):
    if not host:
        print("initial sync")
        icheck_output([MBSYNC, '-a'])
    else:
        print("syncing: {}:{}".format(host, box))
        icheck_output([MBSYNC, '{}:{}'.format(host, box)])
        print("done syncing {}:{}".format(host, box))

    for c in POST_SYNC_COMMANDS:
        icheck_output(c)


def idle_client(*args):
    while True:
        try:
            _idle_client(*args)
        except Exception as e:
            print(
                "error {} in {}:{} connection, restarting"
                .format(e, args[0], args[4]))


def _idle_client(host, ssl, user, password, box, local):
    client = IMAPClient(host, use_uid=True, ssl=ssl)
    client.login(user, password)
    try:
        client.select_folder(box)
    except:
        print("unable to select folder {}".format(box))
        return
    client.idle()

    print("connected, {}: {}".format(host, box))
    while True:
        for m in client.idle_check():
            print("event: {}, {}, {}".format(host, box, m))
            sync(local, box)
        sleep(1)


if __name__ == '__main__':
    sync()
    for c in conf:
        for box in c['boxes']:
            if 'pass_cmd' in c:
                c['pass'] = check_output([c['pass_cmd']], shell=True).strip()
            t = Thread(
                target=idle_client,
                args=(c['host'],
                      c['ssl'],
                      c['user'],
                      c['pass'],
                      box,
                      c['local']))
            t.daemon = True
            t.start()

    while True:
        sleep(3600)
