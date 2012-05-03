#!/bin/sh

xsetroot -solid \#3f3f3f
xsetroot -cursor_name left_ptr
xrdb -merge ~/.Xresources

urxvtd -q -o -f &
export GTK2_RC_FILES="$HOME/.gtkrc-2.0" 
unclutter -root -idle 3 &
sh $HOME/.fehbg &
exec xbindkeys &

#exec ~/src/evilwm/evilwm -fg "#69B8ED" -bg "#4983A9" -snap 10 -term "urxvtc -e tmux" -mask1 mod4 -mask2 mod4

exec evilwm -nosoliddrag -fg "#69B8ED" -bg "#4983A9" -snap 10 -term "urxvtc" -mask1 mod4 -mask2 mod4
#exec herbstluftwm
#exec spectrwm
#exec wmfs
#exec awesome
