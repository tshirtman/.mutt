# creat symbolic links for [Gmail] boxes, to give them a saner path to
# access
from os import listdir
from os.path import join, isdir, exists
from subprocess import check_output
from re import fullmatch
from imapclient import imap_utf7


for f in listdir(b'[Gmail]'):
    if fullmatch(b'\..*', f) and isdir(join(b'[Gmail]', f)):
        transcoded = imap_utf7.decode(f[1:]).encode('utf8')
        if not exists(f[1:]):
            check_output(['ln', '-s', join(b'[Gmail]', f), transcoded])
        else:
            print("{} already exists...".format(f[1:]))
