#!/usr/bin/env python3
import argparse
import collections
import os
import shutil
import subprocess

SRC_DIR = os.path.realpath(os.path.dirname(__file__))
FILES = collections.OrderedDict((
    ('vim', (
        ('.vimrc', 'env/vim/init.vim'),
        ('.vim', 'env/vim'),
    )),
    ('nvim', (
        ('.config/nvim', 'env/nvim'),
    )),
    ('shell', (
        ('.zshrc', 'env/zshrc'),
        # ('.zsh', 'var/zsh'),
        ('.tmux.conf', 'env/tmux.conf'),
    )),
    ('bin', (
        ('bin', 'bin'),
        ('cbin', 'cbin'),
    )),
    ('dev', (
        ('.gitconfig', 'env/gitconfig'),
        ('.gitignore', 'env/gitignore'),
        ('.hgrc', 'env/hgrc'),
        ('.hgignore', 'env/hgignore'),
        ('.pythonrc', 'env/pythonrc'),
    )),
    ('x11', (
        ('.xinitrc', 'x11/xinitrc'),
        ('.i3', 'x11/i3'),
        ('.config/fontconfig/fonts.conf', 'x11/fonts.conf'),
        ('.config/systemd/user/goreman.service', 'x11/goreman.service'),
        ('.config/dunst/dunstrc', 'x11/dunstrc'),
        ('.config/tilix/schemes/everforest.json', 'x11/theme/tilix-everforest.json'),
        ('.local/share/xfce4/terminal/colorschemes/everforest-dark-soft.theme', 'x11/theme/xfce-terminal-everforest.theme'),
        ('.local/share/rofi/themes/everforest.rasi', 'x11/theme/rofi-everforest.rasi'),
    )),
    ('all-shell', ('vim', 'nvim', 'shell', 'bin')),
    ('all', ('all-shell', 'dev', 'x11')),
))
BOOT = {
    'x11': 'dconf load /com/gexperts/Tilix/ < x11/tilix.dconf',
    'vim': 'bin/vimup i && /bin/vimup c',
    'nvim': 'OPTS="-d env/nvim/bundle/ -r env/nvim/init.vim" && bin/vimup i $OPTS && bin/vimup c $OPTS',
    'pacman': 'bin/pkglist -p'
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
        subprocess.check_call(boot, shell=True, cwd=SRC_DIR)
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
