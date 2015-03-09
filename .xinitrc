#!/bin/sh

xsetroot -cursor_name left_ptr
xrdb -merge $HOME/.Xresources

urxvtd -q -o -f &
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
unclutter -root -idle 3 &
sh $HOME/.fehbg &
#exec xbindkeys &

# xrandr 1920x1080 (16:9)  #
#xrandr --newmode "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120
#xrandr --addmode eDP1 1920x1080_60.00
#xrandr --output eDP1 --mode 1920x1080_60.00

# xrandr 1920x1200 (16:10) #
#xrandr --newmode "1920x1200_60.00" 193.24 1920 2056 2256 2592 1200 1203 1209 1245
#xrandr --addmode eDP1 1920x1200_60.00
#xrandr --output eDP1 --mode 1920x1200_60.00

# xrandr 1680x1050 (16:10) #
xrandr --newmode "1680x1050_60.00" 146.25 1680 1784 1960 2240 1050 1053 1059 1089
xrandr --addmode eDP1 1680x1050_60.00
xrandr --output eDP1 --mode 1680x1050_60.00

exec i3
#exec evilwm -nosoliddrag -fg "#69B8ED" -bg "#4983A9" -snap 10 -term "urxvtc" -mask1 mod4 -mask2 mod4
#exec $HOME/src/evilpoison/evilpoison 
#exec $HOME/src/goomwwm/goomwwm
#exec $HOME/src/monsterwm/monsterwm
#exec $HOME/src/scrotwm/linux/scrotwm
#exec musca
#exec ratpoison
#exec subtle
#exec scrotwm
#exec herbstluftwm --autostart $HOME/.config/herbstluftwm/autostart
#exec spectrwm
#exec wmfs
#exec awesome
#exec xmonad
#exec stumpwm
#exec echinus
