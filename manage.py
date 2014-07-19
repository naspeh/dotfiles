#!/usr/bin/env python
import argparse
import collections
import os
import shutil
import subprocess

SRC_DIR = os.path.realpath(os.path.dirname(__file__))
FILES = collections.OrderedDict((
    ('vim', (
        ('.vimrc', 'env/vim/rc'),
        ('.vim', 'env/vim'),
    )),
    ('zsh', (
        ('.zshrc', 'env/zshrc'),
        ('.zsh', 'var/zsh'),
    )),
    ('bin', (
        ('bin', 'bin'),
    )),
    ('dev', (
        ('.gitconfig', 'env/gitconfig'),
        ('.gitignore', 'env/gitignore'),
        ('.hgrc', 'env/hgrc'),
        ('.hgignore', 'env/hgignore'),
        ('.pip', 'var/pip'),
        ('.pip/pip.conf', 'env/pip.conf'),
    )),
    ('x11', (
        ('.xinitrc', 'x11/xinitrc'),
        ('.i3', 'x11/i3'),
        ('.conkyrc', 'x11/conkyrc'),
        ('.config/dunst/dunstrc', 'x11/dunstrc'),
        ('.config/sxhkd/sxhkdrc', 'x11/sxhkdrc'),
        ('.devilspie/common.ds', 'x11/devilspie.ds'),
    )),
    ('all-shell', ('vim', 'zsh', 'bin')),
    ('all', ('all-shell', 'dev', 'x11')),
))
BOOT = {
    'vim': '{0}/bin/vimup i && {0}/bin/vimup c'.format(SRC_DIR),
    'pacman': '{}/bin/pkglist -p'.format(SRC_DIR)
}


def create(target, files=None, boot=False, indent=''):
    def mkdir(dest, child=True):
        dir_ = os.path.dirname(dest) if child else dest
        if not dir_:
            return
        if not child:
            rmpath(dir_)
        if not os.path.exists(dir_):
            os.makedirs(dir_)

    def rmpath(dest):
        if os.path.exists(dest) or os.path.lexists(dest):
            if os.path.islink(dest) or os.path.isfile(dest):
                os.unlink(dest)
            else:
                shutil.rmtree(dest)

    def clean(dest):
        bak_dir = './bak'
        if not os.path.exists(bak_dir):
            os.mkdir(bak_dir)
        bak = os.path.join(bak_dir, dest.lstrip(os.path.sep))
        rmpath(bak)
        mkdir(bak)
        os.rename(dest, bak)
        return (dest, bak)

    info = lambda msg: print('%s%s' % (indent, msg))
    info('Process "%s" target' % target)
    files = files if files else FILES[target]
    for item in files:
        if isinstance(item, str):
            create(item, boot=boot, indent='|   ')
            continue
        dest, src = item
        src = os.path.join(SRC_DIR, src)
        if not os.path.exists(src):
            mkdir(src, child=False)
        if os.path.realpath(dest) == src:
            continue
        if os.path.lexists(dest):
            info('| * backup %s to %s' % clean(dest))
        info('| + create %s to %s' % (dest, src))
        mkdir(dest)
        os.symlink(src, dest)
    boot = boot and BOOT.get(target)
    if boot:
        info('Boot process for "%s" target' % target)
        info('| * %r' % boot)
        print('----- OUTPUT -----')
        subprocess.check_call(boot, shell=True)
        print('------------------')


def process_args(args=None):
    parser = argparse.ArgumentParser()
    cmds = parser.add_subparsers(title='commands')

    def cmd(name, **kw):
        p = cmds.add_parser(name, **kw)
        p.set_defaults(cmd=name)
        p.arg = lambda *a, **kw: p.add_argument(*a, **kw) and p
        p.exe = lambda f: p.set_defaults(exe=f) and p

        p.arg('-H', '--home', default=os.path.expanduser('~'))
        return p

    cmd('init', help='init home directory')\
        .arg('target', choices=FILES.keys(), nargs='+')\
        .arg('-b', '--boot', action='store_true')

    cmd('pacman', help='init pacman')\
        .arg('-r', '--root', default='/home')

    args = parser.parse_args(args)
    os.chdir(args.home)

    if args.cmd == 'init':
        print('Working directory: %s' % args.home)
        targets = args.target if args.target else FILES.keys()
        for target in targets:
            create(target, boot=args.boot)
    elif args.cmd == 'pacman':
        os.chdir(args.root)
        create('pacman', boot=True, files=(
            ('pacman', 'var/pacman'),
            ('pacman/pacman.conf', 'env/pacman.conf')
        ))
    else:
        raise ValueError('Wrong subcommand')


if __name__ == '__main__':
    process_args()
