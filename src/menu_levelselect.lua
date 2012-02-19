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

		local background = display.newImage( "../images/space.png")
		background.x = display.contentWidth / 2
		background.y = display.contentHeight / 2
		background:scale(1.5, 1.5)

		local earthSlice = display.newImage("../images/earth_slice.png" )
		earthSlice.x = display.contentWidth / 2
		earthSlice.y = display.contentHeight / 1.2
		earthSlice:scale((((0.625/1200)*(display.contentHeight)^2)-53.03),(((0.625/1200)*(display.contentHeight)^2)-53.03))
        
		local lvl1 = display.newText("1", 0, 0, native.systemFont, 70)
		lvl1.x = display.contentWidth / 10
		lvl1.y = display.contentHeight / 3
		
		local lvl2 = display.newText("2", 0, 0, native.systemFont, 70)
		lvl2.x = (display.contentWidth / 10) * 3
		lvl2.y = display.contentHeight / 3
		
		local lvl3 = display.newText("3", 0, 0, native.systemFont, 70)
		lvl3.x = (display.contentWidth / 10) * 5
		lvl3.y = display.contentHeight / 3
		
		local lvl4 = display.newText("4", 0, 0, native.systemFont, 70)
		lvl4.x = (display.contentWidth / 10) * 7
		lvl4.y = display.contentHeight / 3
		
		local lvl5 = display.newText("5", 0, 0, native.systemFont, 70)
		lvl5.x = (display.contentWidth / 10) * 9
		lvl5.y = display.contentHeight / 3
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
