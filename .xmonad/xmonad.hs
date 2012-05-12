import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Actions.CycleWS
import XMonad.Prompt
import XMonad.Prompt.Shell

import XMonad.Layout.Spacing

myTerminal      = "urxvtc -e tmux"
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
myBorderWidth   = 1
myModMask       = mod4Mask
myNumlockMask   = 0
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
myFont = "-*-montecarlo-medium-r-normal-*-11-*-*-*-c-*-*-*"
myNormalFGColor = "#ffffff"
myNormalBGColor = "#0f0f0f"
myFocusedFGColor = "#f0f0f0"
myFocusedBGColor = "#333333"
myUrgentFGColor = "#0099ff"
myUrgentBGColor = "#0077ff"
myXPConfig = defaultXPConfig
    { font = "" ++ myFont ++ ""
    , bgColor = "" ++ myNormalBGColor ++ ""
    , fgColor = "" ++ myNormalFGColor ++ ""
    , fgHLight = "" ++ myNormalFGColor ++ ""
    , bgHLight = "" ++ myUrgentBGColor ++ ""
    , borderColor = "" ++ myFocusedBorderColor ++ ""
    , promptBorderWidth = 1
    , position = Bottom
    , height = 16
    , historySize = 100
    }

myNormalBorderColor  = "#4983A9"
myFocusedBorderColor = "#69B8ED"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)
    , ((modm,               xK_p     ), shellPrompt myXPConfig)
    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm,               xK_n     ), refresh)
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_j     ), windows W.focusDown)
    , ((modm,               xK_k     ), windows W.focusUp  )
    , ((modm,               xK_m     ), windows W.focusMaster  )
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((modm,               xK_comma ), sendMessage (IncMasterN 1))
    , ((modm,               xK_period), sendMessage (IncMasterN (-1)))
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modm,               xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    , ((modm,               xK_Left), prevWS)
    , ((modm,               xK_Right), nextWS)
    ]
    ++

    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

myLayout = spacing 3 $ Tall 1 (3/100) (1/2)
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat ]
myEventHook = mempty
myLogHook = return ()
myStartupHook = return ()
main = xmonad defaults
defaults = defaultConfig {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys               = myKeys,
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
