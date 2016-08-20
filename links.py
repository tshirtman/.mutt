# creat symbolic links for [Gmail] boxes, to give them a saner path to
# access
from os import listdir
from os.path import join, isdir, exists
from subprocess import check_output
from re import fullmatch


for f in listdir('[Gmail]'):
    if fullmatch('\.[\w ]*', f) and isdir(join('[Gmail]', f)):
        if not exists(f[1:]):
            check_output(['ln', '-s', join('[Gmail]', f), f[1:]])
        else:
            print("{} already exists...".format(f[1:]))
