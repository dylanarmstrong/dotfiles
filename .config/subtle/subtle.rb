# -*- encoding: utf-8 -*-
#
# This program can be distributed under the terms of the GNU GPL.
# See the file COPYING.
#
# $Id: .config/subtle/subtle.rb,v 426 2012/05/23 00:03:48 unexist $
#

require "socket"

# Contrib {{{
begin
  require "#{ENV["HOME"]}/.config/subtle-contrib/ruby/launcher.rb"
  require "#{ENV["HOME"]}/.config/subtle-contrib/ruby/selector.rb"

  Subtle::Contrib::Selector.font  = "xft:Envy Code R:pixelsize=13"
  Subtle::Contrib::Launcher.fonts = [
    "xft:Envy Code R:pixelsize=80",
    "xft:Envy Code R:pixelsize=10"
  ]

  Subtle::Contrib::Launcher.browser_screen_num = 0
rescue LoadError
end # }}}

# Options {{{
set :increase_step,     5
set :border_snap,       10
set :default_gravity,   :center
set :urgent_dialogs,    false
set :honor_size_hints,  false
set :gravity_tiling,    false
#set :click_to_focus,    false
set :skip_pointer_warp, false
# }}}

# Screens {{{
screen 1 do
  top     [:title, :spacer, :views, :sublets]
  bottom  [:mpd, :spacer, :clock, :fuzzytime]
  view    0
end

# Styles {{{
style :all do
  padding    2, 6, 2, 6
  background "#1a1a1a"
  font       "xft:Envy Code R:pixelsize=10"
end

style :title do
  foreground "#FFFFFF"
end

style :views do
  foreground "#7c7c72"
  icon       "#7c7c72"

  style :focus do
    foreground    "#ffffff"
    icon          "#ffffff"
    border_bottom "#acaa53", 2
  end

  style :occupied do
    foreground    "#7c7c72"
    border_bottom "#949269", 2
  end

  style :urgent do
    foreground "#c0bd5c"
    icon       "#c0bd5c"
  end

  style :visible do
    padding_top 0
    border_top  "#494948", 2
  end
end

style :sublets do
  foreground "#7c7c72"
  icon       "#7c7c72"
end

style :separator do
  foreground "#acaa53"
  separator  "∞"
end

style :clients do
  active   "#7c7c72", 2
  inactive "#494948", 2
  margin   2
end

style :subtle do
  panel      "#1a1a1a"
  background "#595959"
  stipple    "#595959"
end
# }}}

# Gravities {{{
gravity :top_left,       [   0,   0,  50,  50 ]
gravity :top_left66,     [   0,   0,  50,  66 ]
gravity :top_left33,     [   0,   0,  50,  34 ]

gravity :top,            [   0,   0, 100,  50 ]
gravity :top75,          [   0,   0, 100,  75 ]
gravity :top66,          [   0,   0, 100,  66 ]
gravity :top33,          [   0,   0, 100,  34 ]

gravity :top_right,      [  50,   0,  50,  50 ]
gravity :top_right66,    [  50,   0,  50,  66 ]
gravity :top_right33,    [  50,   0,  50,  33 ]

gravity :left,           [   0,   0,  50, 100 ]
gravity :left66,         [   0,   0,  66, 100 ]
gravity :left33,         [   0,   0,  33, 100 ]

gravity :center,         [   0,   0, 100, 100 ]
gravity :center66,       [  17,  17,  66,  66 ]
gravity :center33,       [  33,  33,  33,  33 ]

gravity :right,          [  50,   0,  50, 100 ]
gravity :right66,        [  34,   0,  66, 100 ]
gravity :right33,        [  67,   0,  33, 100 ]

gravity :bottom_left,    [   0,  50,  50,  50 ]
gravity :bottom_left66,  [   0,  34,  50,  66 ]
gravity :bottom_left33,  [   0,  67,  50,  33 ]
gravity :bottom_left25,  [   0,  75,  50,  25 ]

gravity :bottom,         [   0,  50, 100,  50 ]
gravity :bottom66,       [   0,  34, 100,  66 ]
gravity :bottom33,       [   0,  67, 100,  33 ]

gravity :bottom_right,   [  50,  50,  50,  50 ]
gravity :bottom_right66, [  50,  34,  50,  66 ]
gravity :bottom_right33, [  50,  67,  50,  33 ]
gravity :bottom_right25, [  50,  75,  50,  25 ]

gravity :gimp_image,     [  10,   0,  80, 100 ]
gravity :gimp_toolbox,   [   0,   0,  10, 100 ]
gravity :gimp_dock,      [  90,   0,  10, 100 ]

gravity :dia_toolbox,    [   0,   0,  15, 100 ]
gravity :dia_diagram,    [  15,   0,  85, 100 ]
# }}}

# Grabs {{{
modkey   = "W"
gravkeys = [ "q", "w", "e", "a", "s", "d", "y", "x", "c" ]

# Views and screens
(1..4).each do |i|
  grab modkey + "-#{i}",   "ViewSwitch#{i}".to_sym
  grab modkey + "-S-#{i}", "ViewJump#{i}".to_sym
  grab modkey + "-F#{i}",  "ScreenJump#{i}".to_sym
end

grab modkey + "-Left", :ViewPrev
grab modkey + "-Right", :ViewNext

# Windows
grab modkey + "-B1",      :WindowMove
grab modkey + "-B3",      :WindowResize
grab modkey + "-S-f",     :WindowFloat
grab modkey + "-S-space", :WindowFull
grab modkey + "-S-s",     :WindowStick
grab modkey + "-S-equal", :WindowZaphod
grab modkey + "-S-r",     :WindowRaise
grab modkey + "-S-l",     :WindowLower
grab modkey + "-S-k",     :WindowKill
grab modkey + "-S-h", lambda { |c| c.retag }

# Movement
{
 WindowLeft: [ "Left", "h" ], WindowDown:  [ "Down",  "j" ],
 WindowUp:   [ "Up",   "k" ], WindowRight: [ "Right", "l" ]
}.each do |k, v|
  grab "%s-%s" % [ modkey, v.first ], k
  grab "%s-%s" % [ modkey, v.last  ], k
end

# Reload/restart
grab modkey + "-C-q",     :SubtleQuit
grab modkey + "-C-r",     :SubtleReload
grab modkey + "-C-A-r",   :SubtleRestart

# Gravity keys and focus
gravities = [
  [:top_left, :top_left33, :top_left66],
  [:top, :top33, :top66, :top75],
  [:top_right, :top_right33, :top_right66],
  [:left, :left33, :left66],
  [:center, :center33, :center66],
  [:right, :right33, :right66],
  [:bottom_left, :bottom_left25, :bottom_left33, :bottom_left66],
  [:bottom, :bottom33, :bottom66],
  [:bottom_right, :bottom_right25, :bottom_right33, :bottom_right66]
]

gravities.each_index do |i|
  # Set gravities
  grab "%s-%s" % [ modkey, gravkeys[i] ], gravities[i]

  # Focus client with gravity
  grab "%s-C-%s" % [ modkey, gravkeys[i] ], lambda { |cur|
    idx     = 0
    clients = Subtlext::Client.visible.select { |c|
      gravities[i].include?(c.gravity.name.to_sym)
    }

    # Cycle through clients with same gravity
    if clients.include?(cur)
      idx = clients.index(cur) + 1
      idx = 0 if idx >= clients.size
    end

    clients[idx].focus
  }
end

# Multimedia keys
grab "XF86AudioMute",        :VolumeToggle
grab "XF86AudioRaiseVolume", :VolumeRaise
grab "XF86AudioLowerVolume", :VolumeLower
grab "XF86AudioPlay",        :MpdToggle
grab "XF86AudioStop",        :MpdStop
grab "XF86AudioNext",        :MpdNext
grab "XF86AudioPrev",        :MpdPrevious

# Programs
grab modkey + "-Return", "urxvt"
grab modkey + "-f", "firefox"

# Contrib
grab modkey + "-p" do
  Subtle::Contrib::Launcher.run
end

grab modkey + "-o" do
  Subtle::Contrib::Selector.run
end

# Scratchpad
grab modkey + "-y" do
  if (c = Subtlext::Client.first("scratch"))
    c.toggle_stick
    c.focus
  elsif (c = Subtlext::Subtle.spawn("urxvt -name scratch"))
    c.tags  = []
    c.flags = [ :stick ]
  end
end

# Tabbing
grab modkey + "-Tab" do
  Subtlext::Client.recent[1].focus
end

# Tags {{{
tag "terms" do
  match    instance: "xterm|urxvt"
  gravity  :center
  resize   true
end

tag "browser" do
  match "navigator|(google\-)?chrom[e|ium]|firefox|dwb"
  gravity :center
end

tag "mplayer" do
  match   "mplayer"
  float   true
  stick   1
end

tag "stick" do
  match  "dialog|subtly|python|gtk.rb|display|pychrom|skype|xev|evince|exe|<unknown>|plugin-container"
  stick  true
  float  true
end

tag "urgent" do
  stick  true
  urgent true
  float  true
end

tag "dialogs" do
  match  "sun-awt-X11-XDialogPeer"
  match type: [ :dialog, :splash ]
  stick true
end

tag "gimp" do
  match role: "gimp.*"

  on_match do |c|
    c.gravity = ("gimp_" + c.role.split("-")[1]).to_sym
  end
end
# }}}

# Views {{{
www_re    = "browser"
icons     = true

iconpath = "#{ENV["HOME"]}/.local/share/icons"

space = {
  :cannon  => Subtlext::Icon.new("#{iconpath}/cannon.xbm"),
  :ufo     => Subtlext::Icon.new("#{iconpath}/ufo.xbm"),
  :shelter => Subtlext::Icon.new("#{iconpath}/shelter.xbm"),
  :terms   => Subtlext::Icon.new("#{iconpath}/invader1.xbm"),
  :www     => Subtlext::Icon.new("#{iconpath}/invader2.xbm"),
  :void    => Subtlext::Icon.new("#{iconpath}/invader3.xbm"),
  :sketch  => Subtlext::Icon.new("#{iconpath}/invader4.xbm"),
  :test    => Subtlext::Icon.new("#{iconpath}/invader5.xbm"),
  :editor  => Subtlext::Icon.new("#{iconpath}/invader6.xbm")
}

view "terms" do
  match     "terms"
  icon      Subtlext::Icon.new("#{iconpath}/cannon.xbm")
  icon_only icons
end

view "www" do
  match     www_re
  #icon      "#{iconpath}/world.xbm"
  icon      Subtlext::Icon.new("#{iconpath}/ufo.xbm")
  icon_only icons
end

view "void" do
  match     "default"
  #icon      "#{iconpath}/quote.xbm"
  icon      Subtlext::Icon.new("#{iconpath}/invader3.xbm")
  icon_only icons
end

view "sketch" do
  match     "gimp"
  icon      Subtlext::Icon.new("#{iconpath}/invader4.xbm")
  icon_only icons
end

on :view_focus do |v|
  views = Hash[*Subtlext::Screen.all.map { |s|
    [ s.view.name.to_sym, space[space.keys[s.id]] ] }.flatten
  ]

  Subtlext::View.all.each do |va|
    sym = va.name.to_sym

    if views.keys.include?(sym)
      va.icon.copy_area(views[sym])
    else
      va.icon.copy_area(space[va.name.to_sym])
    end
  end

  Subtlext::Subtle.render
end
# }}}

# Sublets {{{
sublet :clock do
  format_string "%a %b %d,"
end
# }}}
