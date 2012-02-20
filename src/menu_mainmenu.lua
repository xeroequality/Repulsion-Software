--
-- Project: KatAstrophy
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 Jason Simmons. All Rights Reserved.
-- 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
-- 
--      NOTE:
--      
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------
 
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
        local group = self.view
 
	
        -----------------------------------------------------------------------------
                
        --      CREATE display objects and add them to 'group' here.
        --      Example use-case: Restore 'group' from previously saved state.
        
        -----------------------------------------------------------------------------
        
end
 
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
                
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)

		local sky = display.newImage( "test_bkg_clouds.png")
		sky.x = 0
		sky.y = 0
		sky:scale(3,2)
		
		-- Make the Signs--[[
		local SPsign = display.newImage("../images/background_SPsign.png")
		local MPsign = display.newImage("../images/background_MPsign.png")
		local settings_Sign = display.newImage("../images/background_Settingssign.png")
		local help_Sign = display.newImage("../images/background_Helpsign.png")
		cW = display.contentWidth/2;
		cH = display.contentHeight/2;
		
		SPsign.x = cW; SPsign.y = 45;
		
		MPsign.y = cH; MPsign.x = cW+115; MPsign:rotate(90)
		
		settings_Sign.x = cW; settings_Sign.y = cH+115; settings_Sign:rotate(180)
		
		help_Sign.y = cH; help_Sign.x = cW-115; help_Sign:rotate(270)
		
		-- Create the Earth
		local earth = display.newImage("../images/background_earth.png")
		earth.x = display.contentWidth/2
		earth.y = display.contentHeight/2]]
	group:insert(sky)
        
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
