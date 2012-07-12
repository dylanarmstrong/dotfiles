# -*- encoding: utf-8 -*-
#

require "socket"

begin
  require "#{ENV["HOME"]}/.config/subtle/ruby/launcher.rb"
  require "#{ENV["HOME"]}/.config/subtle/ruby/selector.rb"

  Subtle::Contrib::Selector.font  = "xft:Envy Code R:pixelsize=13"
  Subtle::Contrib::Launcher.fonts = [
    "xft:Envy Code R:pixelsize=80",
    "xft:Envy Code R:pixelsize=10"
  ]

rescue LoadError
end

grab "W-p" do
  Subtle::Contrib::Launcher.run
end

grab "W-Tab" do
  Subtle::Contrib::Selector.run
end

set :increase_step, 5
set :border_snap, 10
set :default_gravity, :center
set :urgent_dialogs, false
set :honor_size_hints, false
set :gravity_tiling, false
set :click_to_focus, false
set :skip_pointer_warp, false
set :skip_urgent_warp, false

screen 1 do
  top    [ :title, :spacer, :fuzzytime, :separator, :views]
  bottom [ ]
end

style :all do
  #background  "#202020"
  #icon        "#757575"
  #border      "#303030", 0
  padding     0, 3
  #padding     2, 6, 2, 6
  #font        "xft:Terminus:pixelsize=10"
  font        "-*-*-*-*-*-*-10-*-*-*-*-*-*-*"
  #font        "xft:sans-8"
end

style :title do
  foreground "#FFFFFF"
end

# Style for the all views
style :views do
  foreground  "#757575"

  # Style for the active views
  style :focus do
    foreground  "#69B8ED"
  end

  # Style for urgent window titles and views
  style :urgent do
    foreground  "#ff9800"
  end

  # Style for occupied views (views with clients)
  style :occupied do
    foreground  "#4983A9"
  end
end

# Style for sublets
style :sublets do
  foreground  "#757575"
end

# Style for separator
style :separator do
  foreground  "#757575"
  separator   "|"
end

# Style for focus window title
style :title do
  foreground  "#69B8ED"
end

# Style for active/inactive windows
style :clients do
  active    "#69B8ED", 2
  inactive  "#4983A9", 2
  margin    4
end

# Style for subtle
style :subtle do
  margin      0, 0, 0, 0
  panel       "#202020"
  stipple     "#757575"
end

gravity :top_left,       [   0,   0,  50,  50 ]
gravity :top_left66,     [   0,   0,  50,  66 ]
gravity :top_left33,     [   0,   0,  50,  34 ]

gravity :top,            [   0,   0, 100,  50 ]
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

gravity :bottom,         [   0,  50, 100,  50 ]
gravity :bottom66,       [   0,  34, 100,  66 ]
gravity :bottom33,       [   0,  67, 100,  33 ]

gravity :bottom_right,   [  50,  50,  50,  50 ]
gravity :bottom_right66, [  50,  34,  50,  66 ]
gravity :bottom_right33, [  50,  67,  50,  33 ]

gravity :gimp_image,     [  10,   0,  80, 100 ]
gravity :gimp_toolbox,   [   0,   0,  10, 100 ]
gravity :gimp_dock,      [  90,   0,  10, 100 ]

(1..4).each do |i|
  grab "W-#{i}",   "ViewSwitch#{i}".to_sym
  grab "W-S-#{i}", "ViewJump#{i}".to_sym
end

grab "W-Left", :ViewPrev
grab "W-Right", :ViewNext

grab "W-C-r", :SubtleReload
grab "W-C-S-r", :SubtleRestart
grab "W-C-q", :SubtleQuit

grab "W-f", :WindowFloat
grab "W-space", :WindowFull
grab "W-S-s", :WindowStick
grab "W-r", :WindowRaise
grab "W-l", :WindowLower
grab "W-S-k", :WindowKill

grab "W-q", [ :top_left,     :top_left66,     :top_left33     ]
grab "W-w", [ :top,          :top66,          :top33          ]
grab "W-e", [ :top_right,    :top_right66,    :top_right33    ]
grab "W-a", [ :left,         :left66,         :left33         ]
grab "W-s", [ :center,       :center66,       :center33       ]
grab "W-d", [ :right,        :right66,        :right33        ]
grab "W-z", [ :bottom_left,  :bottom_left66,  :bottom_left33  ]
grab "W-x", [ :bottom,       :bottom66,       :bottom33       ]
grab "W-c", [ :bottom_right, :bottom_right66, :bottom_right33 ]

grab "W-Return", "urxvtc"
grab "W-S-o", "luakit"

grab "S-F2" do |c|
  puts c.name
end

grab "S-F3" do
  puts Subtlext::VERSION
end

grab "W-S-d", "xinput --set-prop 'bcm5974' 'Device Enabled' 0"
grab "W-S-r", "xinput --set-prop 'bcm5974' 'Device Enabled' 1"

tag "terms",   "xterm|[u]?rxvt[c]?"
tag "browser", "uzbl|firefox|jumanji|luakit|surf|dwb|google-chrome"

tag "fixed" do
  geometry [ 10, 10, 100, 100 ]
  stick    true
end

tag "gravity" do
  gravity :center
end

# Modes
tag "mplayer" do
  match "mplayer"
  float true
end

tag "float" do
  match "display"
  float true
end

view "1", "terms|default"
view "2",   "browser"
view "3",   "mplayer"
