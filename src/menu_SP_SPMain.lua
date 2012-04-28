--
-- Project: KatAstrophy
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 Jason Simmons. All Rights Reserved.
-- 
local storyboard = require( "storyboard" )local widget = require( "widget" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
-- 
--      NOTE:
--      
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
-- 
----------------------------------------------------------------------------------- Forward declaration of back button and listener-- Only used / executed once, so can be placed outside storyboard-- (as said in NOTE above)
local backBtn		local function onBackBtnRelease (event)	storyboard.gotoScene( "menu_splash", "zoomInOutFade", 500 )	return trueend
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
 --[[	Use Corona's "Widget" library to create easy buttons			label: text written on the button			labelColor: color of text initially and when pressed			default: default background image for button			over: background image when pressed			width/height: width/height of button image			onRelease: event triggered after button press]]    backBtn = widget.newButton{
		label="Back",
		labelColor = { default={255}, over={128} },
		default="../images/btn_back.png",
		over="../images/btn_back_pressed.png",
		width=200, height=100,
		onRelease = onBackBtnRelease
    }	backBtn.view:setReferencePoint( display.CenterReferencePoint )
	backBtn.view.x = display.contentWidth*0.5
	backBtn.view.y = display.contentHeight*0.5		group:insert( backBtn.view )
        
end
 
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
                
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)		
end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        
        -----------------------------------------------------------------------------
        
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        
        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)
        
        -----------------------------------------------------------------------------
        if backBtn then
			backBtn:removeSelf()	-- widgets must be manually removed
			backBtn = nil
        end        
end
 
---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )
 
-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )
 
-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )
 
-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )
 
---------------------------------------------------------------------------------
 
return scene