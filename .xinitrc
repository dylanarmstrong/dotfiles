#!/bin/sh

xsetroot -cursor_name left_ptr
xrdb -merge $HOME/.Xresources

urxvtd -q -o -f &
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
unclutter -root -idle 3 &

xrandr --dpi 220

sh $HOME/.fehbg &

exec i3

