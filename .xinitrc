#!/bin/sh

xsetroot -cursor_name left_ptr
xrdb -merge $HOME/.Xresources

urxvtd -q -o -f &
unclutter -root -idle 3 &

xrandr --dpi 192

sh $HOME/.fehbg &

dbus-launch i3

