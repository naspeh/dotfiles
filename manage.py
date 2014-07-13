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
    'vim': (
        # Update submodules with Vundle
        'cd %s' % SRC_DIR +
        ' && git submodule init'
        ' && git submodule update'

        # Install and update plugins
        ' && cd -'
        ' && vim -u .vimrc +BundleInstall! +qall'
    ),
    'bin': (
        '[ -d {0} ] || virtualenv {0}'
        ' && source {0}bin/activate'
        ' && pip install -Ur bin/requirements.txt'
        ' && pip freeze'
        .format('bin/env/')
    ),
    'pacman': 'pkglist -p'
}


def create(target, files=None, boot=False, indent='', home='./'):
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
        return p

    cmd('init', help='init home directory')\
        .arg('-H', '--home', default=os.path.expanduser('~'))\
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
        print('Working directory: %s' % args.home)
        targets = args.target if args.target else FILES.keys()
        for target in targets:
            create(target, boot=args.boot, home=args.home.rstrip('/') + '/')
    else:
        raise ValueError('Wrong subcommand')


if __name__ == '__main__':
    process_args()
