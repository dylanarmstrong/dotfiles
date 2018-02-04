#!/bin/sh

xsetroot -cursor_name left_ptr
xrdb -merge $HOME/.Xresources

#urxvtd  -q -o -f &
unclutter -root -idle 3 &

xrandr --dpi 192

redshift -l 40.741895:-73.989308 -g 0.8 -m randr &

sh $HOME/.fehbg &

dbus-launch i3

