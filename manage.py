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
        ('.conkyrc', 'x11/conkyrc'),
        ('.config/dunst', 'x11/dunst'),
        ('.i3', 'x11/i3'),
        ('.devilspie', 'x11/devilspie')
    ),
    'all-shell': ('vim', 'zsh', 'bin'),
    'all': ('all-shell', 'dev', 'x11'),
}
BOOT = {
    'vim': lambda: sh(
        'git submodule init'
        '&& git submodule update'
        '&& vim +BundleInstall +qall',
        quiet=True, cwd=SRC_DIR
    ),
    'pacman': lambda: sh('pkglist -p', quiet=True)
}


def sh(cmd, quiet=False, **kwargs):
    code = subprocess.call(cmd, shell=True, **kwargs)
    msg = '"%s"(%s)' % (cmd, code)
    if quiet:
        return msg
    else:
        print(msg)


def create(target, files=None, boot=False, quiet=False):
    def mkdir(dest):
        dir_ = os.path.dirname(dest)
        if dir_ and not os.path.exists(dir_):
            os.makedirs(dir_)

    def clean(dest):
        bak_dir = './bak'
        bak = os.path.join(bak_dir, dest.lstrip(os.path.sep))
        if os.path.exists(bak):
            if os.path.islink(bak) or os.path.isfile(bak):
                os.unlink(bak)
            else:
                shutil.rmtree(bak)
        elif not os.path.exists(bak_dir):
            os.mkdir(bak_dir)
        mkdir(bak)
        os.rename(dest, bak)
        return (dest, bak)

    msg = ['Process "%s" target' % target]
    files = files if files else FILES[target]
    cleaned, created = [], []
    for item in files:
        if isinstance(item, str):
            msg += ['|   ' + m for m in create(item, boot=boot, quiet=True)]
            continue
        dest, src = item
        src = os.path.join(SRC_DIR, src)
        if os.path.realpath(dest) == src:
            continue
        if os.path.lexists(dest):
            cleaned.append(clean(dest))
        created.append((dest, src))
        mkdir(dest)
        os.symlink(src, dest)
    msg += ['| * backup %s to %s' % i for i in cleaned]
    msg += ['| + create %s to %s' % i for i in created]
    boot = boot and BOOT.get(target)
    if boot:
        msg += ['Boot process for "%s" target' % target]
        msg += ['| * ' + boot()]
    if quiet:
        return msg
    else:
        print('\n'.join(msg))


def process_args(args=None):
    parser = argparse.ArgumentParser()
    cmds = parser.add_subparsers(title='commands')

    def cmd(name, **kw):
        p = cmds.add_parser(name, **kw)
        p.set_defaults(cmd=name)
        p.arg = lambda *a, **kw: p.add_argument(*a, **kw) and p
        p.exe = lambda f: p.set_defaults(exe=f) and p
        return p

    cmd('init', help='init home directory')\
        .arg('-H', '--home', default='.')\
        .arg('target', choices=FILES.keys(), nargs='+')\
        .arg('-b', '--boot', action='store_true')

    cmd('pacman', help='init pacman')\
        .arg('-r', '--root', default='/home/pacman')\
        .exe(lambda args: (
            create('pacman', boot=True, files=[(args.root, 'env/pacman')])
        ))

    args = parser.parse_args(args)
    if hasattr(args, 'exe'):
        args.exe(args)
    elif args.cmd == 'init':
        if not args.target and not args.all:
            raise SystemExit('Error. Set TARGET or ALL')
        os.chdir(args.home)
        targets = args.target if args.target else FILES.keys()
        for target in targets:
            create(target, boot=args.boot)
    else:
        raise ValueError('Wrong subcommand')


if __name__ == '__main__':
    process_args()
