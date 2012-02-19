local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local backButton = display.newRect( -30, 10, 50, 50 )function backButtonH (event)	backButton:setFillColor ( 0, 255, 0  )	storyboard.gotoScene( "menu_splash" )endbackButton:addEventListener ( "touch", backButtonH )storyboard.gotoScene( "menu_splash" )