#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && exit 1

usage ()
{
cat <<EOF
Usage: $0 <args>
Script must be run as root!

Args:
    --home | -H		Specify home directory
    --help | -h		See this message
    --bash | -b		Install powerline for Bash (update .bashrc)
    --tmux | -t		Install powerline for tmux (update .tmux.conf)
    --vim  | -v		Install powerline for VIM (update .vimrc)
EOF
}

bashrc_upd ()
{
    echo "
# Powerline support for bash
export TERM="xterm-256color"
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. $POWERLINE_PATH/bash/powerline.sh
" >> $HOMEDIR/.bashrc
}

tmuxconf_upd ()
{
    echo "
source $POWERLINE_PATH/tmux/powerline.conf
set-option -g default-terminal screen-256color
" >> $HOMEDIR/.tmux.conf
}

vimrc_upd ()
{
    echo "
set rtp+=$POWERLINE_PATH/vim/
set laststatus=2
set showtabline=1
set t_Co=256
" >> $HOMEDIR/.vimrc
}

HOMEDIR="$HOME"
TEMPDIR="$(mktemp -d)" && cd $TEMPDIR

apt update
apt install python3 python3-pip git vim tmux
pip3 install git+git://github.com/Lokaltog/powerline

wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf

mv PowerlineSymbols.otf /usr/share/fonts/
mv 10-powerline-symbols.conf /etc/fonts/conf.d/

fc-cache -vf /usr/share/fonts/

PYTHON_PATH="$(pip3 show powerline-status | grep -m1 Location | awk '{print $2}')"
POWERLINE_PATH="$PYTHON_PATH/powerline/bindings/"

for arg in "$@"; do
    case $arg in
        --home|-H)
            shift 1
            $HOMEDIR="$1"
	        shift 1 ;;
        --bash|-b)
            [ "$BASH_DONE" -eq "1" ] || bashrc_upd && $BASH_DONE=1
	        shift 1 ;;
        --vim|-v)
            [ "$VIM_DONE" -eq "1" ] || vimrc_upd && $VIM_DONE=1
            shift 1 ;;
        --tmux|-t)
            [ "$TMUX_DONE" -eq "1" ] || tmuxconf_upd && $TMUX_DONE=1
            shift 1 ;;
     esac
done
