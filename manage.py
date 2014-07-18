#!/usr/bin/env python
import argparse
import os
import shutil
import subprocess

SRC_DIR = os.path.realpath(os.path.dirname(__file__))
FILES = {
    'vim': (
        ('.vimrc', 'env/vim/rc'),
        ('.vim', 'env/vim'),
    ),
    'zsh': (
        ('.zshrc', 'env/zsh/rc'),
        ('.zsh', 'env/zsh'),
    ),
    'bin': (
        ('bin', 'bin'),
    ),
    'dev': (
        ('.gitconfig', 'env/gitconfig'),
        ('.gitignore', 'env/gitignore'),
        ('.hgrc', 'env/hgrc'),
        ('.hgignore', 'env/hgignore'),
        ('.pip', 'env/pip'),
    ),
    'x11': (
        ('.xinitrc', 'x11/xinitrc'),
        ('.i3', 'x11/i3'),
        ('.conkyrc', 'x11/conkyrc'),
        ('.config/dunst/dunstrc', 'x11/dunstrc'),
        ('.config/sxhkd/sxhkdrc', 'x11/sxhkdrc'),
        ('.devilspie/common.ds', 'x11/devilspie.ds'),
    ),
    'all-shell': ('vim', 'zsh', 'bin'),
    'all': ('all-shell', 'dev', 'x11'),
}
BOOT = {
    'vim': '{0}/bin/vimup i && {0}/bin/vimup c'.format(SRC_DIR),
    'bin': (
        '[ -d {0} ] || virtualenv {0}'
        ' && source {0}bin/activate'
        ' && pip install -Ur bin/requirements.txt'
        ' && pip freeze'
        .format('bin/env/')
    ),
    'pacman': '{}/bin/pkglist -p'.format(SRC_DIR)
}


def create(target, files=None, boot=False, indent=''):
    def mkdir(dest):
        dir_ = os.path.dirname(dest)
        if not dir_:
            return
        if os.path.lexists(dir_):
            clean(dir_)
        if not os.path.exists(dir_):
            os.makedirs(dir_)

    def clean(dest):
        bak_dir = './bak'
        bak = os.path.join(bak_dir, dest.lstrip(os.path.sep))
        if os.path.exists(bak) or os.path.lexists(bak):
            if os.path.islink(bak) or os.path.isfile(bak):
                os.unlink(bak)
            else:
                shutil.rmtree(bak)
        if not os.path.exists(bak_dir):
            os.mkdir(bak_dir)
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
        .arg('-r', '--root', default='/home/pacman')\
        .exe(lambda a: (
            create('pacman', boot=True, files=[(a.root, 'env/pacman')])
        ))

    args = parser.parse_args(args)
    os.chdir(args.home)

    if hasattr(args, 'exe'):
        args.exe(args)
    elif args.cmd == 'init':
        print('Working directory: %s' % args.home)
        targets = args.target if args.target else FILES.keys()
        for target in targets:
            create(target, boot=args.boot)
    else:
        raise ValueError('Wrong subcommand')


if __name__ == '__main__':
    process_args()
