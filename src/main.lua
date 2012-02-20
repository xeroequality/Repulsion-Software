-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local storyboard = require "storyboard"

-- load menu screen
--storyboard.gotoScene( "menu_levelselect" )
--storyboard.gotoScene( "menu_SP_SPMain" )
storyboard.gotoScene( "menu_splash" )
