from setuptools import setup


setup(
    name='mailsync',
    version='1.0',
    py_modules=['imap_idle'],
    install_requires=[
        'Click',
        'ImapClient',
        'libtmux',
        'colorama',
    ],
    entry_points='''
        [console_scripts]
        mailsync=imap_idle:cli
    '''
)
