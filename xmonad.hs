-- KLYAR's Config

-- Default
import XMonad hiding ((|||))
import Data.Monoid
import System.Exit
import XMonad.Util.Run
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
-- Layouts
import XMonad.Layout.ResizableTile        -- A alternative to Tall Layout
import XMonad.Layout.BinarySpacePartition -- Each window divides in two
import XMonad.Layout.Tabbed               -- Tabs on top
-- Layout modifiers
import XMonad.Layout.Spacing           -- Adds some space between the windows
import XMonad.Layout.NoBorders         -- Removes the borders
import XMonad.Layout.LayoutCombinators -- To combine the layouts and use JumpToLayout
import XMonad.Layout.Renamed           -- Rename the layouts
-- XMobar & Polybar
import XMonad.Hooks.ManageDocks -- To the windows don't hide the bar
import XMonad.Hooks.DynamicLog  -- To transfer data to XMobar
import qualified XMonad.DBus as D
-- Run prompt
import XMonad.Prompt
import XMonad.Prompt.Shell
-- Change volume
import XMonad.Actions.Volume -- To change the volume
import XMonad.Util.Dzen      -- To show the volume
-- More
import XMonad.Hooks.InsertPosition -- New windows will appear bellow and not above
                                   -- https://stackoverflow.com/questions/50666868/how-to-modify-order-of-tabbed-windows-in-xmonad?rq=1




alert = dzenConfig centered . show . round
centered = 
        onCurr (center 200 100)
    >=> addArgs ["-fg", "#eceff4"]
    >=> addArgs ["-bg", "#282a36"]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask  , xK_Return ), spawn $ XMonad.terminal conf)

    -- launch emacs client
    , ((modm .|. controlMask, xK_Return ), spawn "emacsclient -c")

    -- Launches Firefox
    , ((modm .|. shiftMask  , xK_b      ), spawn "firefox")

    -- Launches Nemo(File Manager)
    , ((modm .|. shiftMask  , xK_m      ), spawn "nemo")

    -- https://superuser.com/questions/389737/how-do-you-make-volume-keys-and-mute-key-work-in-xmonad
    -- volume
    , ((modm                , xK_F6     ), lowerVolume 5 >> getVolume >>= alert)
    , ((modm                , xK_F8     ), raiseVolume 5 >> getVolume >>= alert)
    , ((modm .|. shiftMask  , xK_F6     ), lowerVolume 1 >> getVolume >>= alert)
    , ((modm .|. shiftMask  , xK_F8     ), raiseVolume 1 >> getVolume >>= alert)
    , ((0                   , 0x1008FF11), lowerVolume 5 >> getVolume >>= alert)
    , ((0                   , 0x1008FF13), raiseVolume 5 >> getVolume >>= alert)
    , ((shiftMask           , 0x1008FF11), lowerVolume 1 >> getVolume >>= alert)
    , ((shiftMask           , 0x1008FF13), raiseVolume 1 >> getVolume >>= alert)
 -- , ((0                   , 0x1008FF12), toggleMute >> return ())
    , ((modm                , xK_F7     ), toggleMute >> return ())
    
    
    -- launch rofi
    , ((modm                , xK_p      ), spawn "rofi -no-config -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/blocks/launcher.rasi")

    -- launch dmenu
    , ((modm .|. shiftMask  , xK_p      ), spawn "dmenu_run -l 20")

    -- run shell
    , ((modm .|. controlMask, xK_p      ), shellPrompt def)

    -- Take a screenshot
    , ((0                   , xK_Print  ), spawn "gnome-screenshot")

    -- close focused window
    , ((modm .|. shiftMask  , xK_c      ), kill)

     -- Rotate through the available layout algorithms
    , ((modm                , xK_space  ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask  , xK_space  ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm                , xK_n      ), refresh)

    -- Move focus to the next window
    , ((modm                , xK_j      ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm                , xK_k      ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm                , xK_m      ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm                , xK_Return ), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask  , xK_j      ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask  , xK_k      ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm                , xK_h      ), sendMessage Shrink)

    -- Expand the master area
    , ((modm                , xK_l      ), sendMessage Expand)

    -- Shink the non master area
    , ((modm .|. shiftMask  , xK_h      ), sendMessage MirrorShrink)

    -- Expand the non master area
    , ((modm .|. shiftMask  , xK_l      ), sendMessage MirrorExpand)

    -- Push window back into tiling
    , ((modm                , xK_t      ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm                , xK_comma  ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm                , xK_period ), sendMessage (IncMasterN (-1)))

    -- Go to Mono Layout
    , ((modm                , xK_f      ), sendMessage $ JumpToLayout "Mono")
    
    -- Go full screen
    , ((modm .|. shiftMask  , xK_f      ), sendMessage $ JumpToLayout "Full")

    -- Quit xmonad
    , ((modm .|. shiftMask  , xK_q      ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm                , xK_q      ), spawn ("~/.cabal/bin/xmonad --recompile; ~/.cabal/bin/xmonad --restart"))

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask  , xK_slash  ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)

        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_e, xK_w] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events --
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.


-- Tabbed style config
myTabConfig = def { activeColor         = "#303030"
                  , inactiveColor       = "#000000"
                  , urgentColor         = "#fdf6e3"
                  , activeBorderColor   = "#303030"
                  , inactiveBorderColor = "#000000"
                  , urgentBorderColor   = "#fdf6e3"
                  , activeTextColor     = "#f8f8f8"
                  , inactiveTextColor   = "#a0a0a0"
                  , urgentTextColor     = "#1ABC9C"
                  , fontName            = "xft:Bitstream Vera Sans Mono:pixelsize=12:weight=30:bold:antialias=true:hinting=true" }


myLayout = ( tiled
         ||| mirrortiled ||| bsp ||| mirrorbsp ||| mono ||| tabs ||| fullscreen)
         where

     -- default tiling algorithm partitions the screen into two panes with more adjustment
     tiled_template = withBorder 2 $ spacingWithEdge 5 $ ResizableTall nmaster delta ratio []
     
     tiled          = renamed [Replace "Tiled" ] $ avoidStruts $ tiled_template
     mirrortiled    = renamed [Replace "MTiled"] $ avoidStruts $ Mirror tiled_template

     -- Real fullscreen
     fullscreen     = renamed [Replace "Full"  ] $ noBorders $ Full

     -- Tabbed windows
     tabs           = renamed [Replace "Tabs"  ] $ avoidStruts $ noBorders $ tabbed shrinkText myTabConfig

     -- Selected window divides into two
     bsp_template   = withBorder 2 $ spacingWithEdge 5 $ emptyBSP
     
     bsp            = renamed [Replace "BSP"   ] $ avoidStruts $        bsp_template
     mirrorbsp      = renamed [Replace "MBSP"  ] $ avoidStruts $ Mirror bsp_template

     -- One window
     mono           = renamed [Replace "Mono"  ] $ avoidStruts $ withBorder 2 $ spacingWithEdge 5  Full

     -- The default number of windows in the master pane
     nmaster        = 1

     -- Default proportion of screen occupied by master pane
     ratio          = 1/2

     -- Percent of screen to increment by when resizing panes
     delta          = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = insertPosition End Newer <+> (composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Gpick"          --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ])

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--

--myPP = def { 
--    ppCurrent     = xmobarColor "#e64344" "" . wrap "|""|",
--    ppTitle           = xmobarColor "#8fbcbb" "" . shorten 32,
--    ppHiddenNoWindows = xmobarColor "#4c566a" "",
--    ppHidden          = id,
--    ppUrgent          = xmobarColor "red" "yellow",
--    ppWsSep           = " ",
--    ppSep             = " " }

fg        = "#202030"
bg        = "#dfdfff"
gray      = "#8f8f9f"
bg1       = "#4040a0"
bg2       = "#6060d0"
bg3       = "#665c54"
bg4       = "#7c6f64"

red       = "#e64344"
darkAqua  = "#2e6559"

--tons of purple
blackBlue = "#031632"
darkBlue = "#1857b4"
brightBlue = "#4e99f5"



myLogHook dbus = def
    { ppOutput = D.send dbus
    , ppCurrent = wrap ("%{B" ++ brightBlue ++ "}  ") "  %{B-}"
    , ppVisible = wrap ("%{B" ++ darkBlue ++ "}  ") "  %{B-}"
    , ppUrgent = wrap ("%{F" ++ brightBlue ++ "} ") " %{F-}"
    , ppHidden = wrap ("%{B" ++ darkBlue ++ "}  ") "  %{B-}"
    , ppHiddenNoWindows = wrap ("%{F" ++ bg ++ "} ") " %{F-}"
    , ppWsSep = ""
    , ppSep = " "
    , ppLayout = wrap ("%{B" ++ darkBlue ++ "}  ") "  %{B-}"
    , ppTitle = shorten 0
    }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  spawn "nitrogen --restore &"
  spawn "picom --experimental-backend -f &"
  spawn "setxkbmap br &"
  spawn "xsetroot -cursor_name left_ptr &"
  spawn "xset s off &"
  spawn "xset s 0 0 &"
  spawn "xset -dpms &"
  spawn "emacs --daemon &"
  spawn "polybar -q main -c ~/.config/polybar/colorblocks/config.ini"
  --spawn "polybar -q main -c ~/.config/polybar/hack/config.ini"

main :: IO ()
main = do
    -- xmproc0 <- spawnPipe "xmobar -x 0 /home/kreis/.config/xmobar/xmobarrc"
    -- Connect to DBus
    dbus <- D.connect
    -- Request access (needed when sending messages)
    D.requestAccess dbus
    xmonad $ docks def {
        -- Basic configurations
        terminal           = "gnome-terminal",
        focusFollowsMouse  = False,
        clickJustFocuses   = False,
        borderWidth        = 2,
        modMask            = mod4Mask,
        workspaces         = ["Web", "2", "3", "4", "5", "6", "7", "8", "9"],
        normalBorderColor  = "#2d253a",
        focusedBorderColor = "#ffc587",

        -- Key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

        -- Hooks
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = dynamicLogWithPP (myLogHook dbus),
        startupHook        = myStartupHook }
    

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines [
    "The mod keys are 'super' and 'caps'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Control-p    Launch Run prompt",
    "mod-Shift-c      Kill the focused window",
    "mod-Space        Rotate through the layouts",
    "mod-Shift-Space  Reset the layout to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-j  Move focus to the next window",
    "mod-k  Move focus to the previous window",
    "mod-m  Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging" ]
