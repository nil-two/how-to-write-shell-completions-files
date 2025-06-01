#!/usr/bin/python3
import argparse
import os


def main():
    parser = argparse.ArgumentParser(prog='egame')
    parser.add_argument('-c', '--color', type=str)
    parser.add_argument('-g', '--gui', action='store_true')
    parser.add_argument('game', type=str)
    args = parser.parse_args()

    emacs_args = ['emacs']
    if args.color == 'never' and args.game == 'tetris':
        emacs_args += ['--eval', '(setq tetris-use-color nil)']
    elif args.color is not None:
        emacs_args += [f'--color={args.color}']
    if not args.gui:
        emacs_args += ['-nw']
    emacs_args += ['-f', args.game]

    os.execvp('emacs', emacs_args)


if __name__ == '__main__':
    main()
