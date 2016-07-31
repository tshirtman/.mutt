from os.path import expanduser

MBSYNC = '/usr/bin/mbsync'
GPG_COMMAND = '/usr/bin/gpg2 --batch --decrypt ~/.mutt/passwords.gpg | /usr/bin/jq .{} -r'  # noqa
POST_SYNC_COMMANDS = [
    ['/usr/bin/notmuch', 'new'],
    [expanduser('~/.mutt/nottoomuch-addresses.sh'), '--update']
]

conf = {
    'gmail': {
        'host': 'imap.gmail.com',
        'user': 'gabriel.pettier@gmail.com',
        'pass': "only used if pass_cmd doesn't exist",
        'pass_cmd': GPG_COMMAND.format('mail_gmail'),
        'local': 'gmail',
        'boxes': ['INBOX', u'[Gmail]/Messages envoyés', 'tangible', 'ML'],
        'ssl': True,
    },
    'tangible': {
        'host': 'mail.gandi.net',
        'user': 'gabriel@tangibledisplay.com',
        'pass': "only used if pass_cmd doesn't exist",
        'pass_cmd': GPG_COMMAND.format('mail_tangible'),
        'local': 'tangible',
        'boxes': ['INBOX', 'Sent'],
        'ssl': True,
    },
}
