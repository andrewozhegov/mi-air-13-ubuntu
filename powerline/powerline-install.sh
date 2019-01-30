#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && exit 1

apt install python3 python3-pip git vim tmux
pip3 install git+git://github.com/Lokaltog/powerline

TEMPDIR="$(mktemp -d)" && cd $TEMPDIR

wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf

mv PowerlineSymbols.otf /usr/share/fonts/
mv 10-powerline-symbols.conf /etc/fonts/conf.d/

fc-cache -vf /usr/share/fonts/

PYTHON_PATH="$(pip3 show powerline-status | grep Location | awk '{print $2}')"
POWERLINE_PATH="$PYTHON_PATH/powerline/bindings"

echo "
# Powerline support for bash
export TERM="xterm-256color"
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. $POWERLINE_PATH/bash/powerline.sh
" >> $HOME/.bashrc

echo "
set rtp+=$POWERLINE_PATH/vim/
set laststatus=2
set showtabline=1
set t_Co=256
" >> $HOME/.vimrc

echo "
source $POWERLINE_PATH/tmux/powerline.conf
set-option -g default-terminal screen-256color
" >> $HOME/.tmux.conf
