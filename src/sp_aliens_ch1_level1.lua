local storyboard = require( "storyboard" )
local widget = require( "widget" )
local physics = require( "physics" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
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
		physics.start()
        
		------------------------------------------------
		-- Parralax Environment
		------------------------------------------------
		local parallax = require( "parallax" )
		local w = display.contentWidth
		local w3 = w * 3
		local h = display.contentHeight 

		-- create new parallax scene
		local myScene = parallax.newScene(
		{
			width = w3,
			height = h,
			bottom = h,
			left = 0,
			repeated = false
		} )
		
		-- Foreground (City Scape...)
		myScene:newLayer(
		{
			image = "../images/background_chapter1_level1_foreground.png",
			width = 960,
			height = 332,
			top = 0,
			bottom = 320,
			left = 0,
			speed = 1,
			repeated = "horizontal"
		} )

		-- repeated sky background
		myScene:newLayer(
		{
			image = "../images/background_chapter1_level1_background.png",
			width = 1500,
			height = 320,
			top = 0,
			left = 0,
			speed = 0.6,
			repeated = "horizontal"
		} )


		-- repeated floor foreground
		local floor = display.newImage("../images/background_chapter1_level1_floor.png")
		floor.x = 0
		floor.y = h
		floor.width = 1500
		floor.myName = "floor"
		
		physics.addBody( floor, "static", { friction=0.5, bounce=0.3 } )

		------------------------------------------------
		-- Functions
		------------------------------------------------
		local function onTouch( event )

			local phase = event.phase

			if phase == "began" then
				-- set scene to 'focused'
				display.getCurrentStage():setFocus( myScene, event.id )
				-- store location as previous
				myScene.xPrev = event.x
				myScene.yPrev = event.y
				
			elseif phase == "moved" then
				-- move scene as the event moves
				myScene:move( event.x - myScene.xPrev, event.y - myScene.yPrev )
				-- store location as previous
				myScene.xPrev = event.x
				myScene.yPrev = event.y
			
			elseif phase == "ended" or phase == "cancelled" then
				-- un-focus scene
				display.getCurrentStage():setFocus( myScene, nil )

			end
			
			return true
			
		end

		

		--------------------------------------------
		-- Events
		--------------------------------------------
		myScene:addEventListener( "touch", onTouch )
		
		
		--------------------------------------------
		-- Enemy Structure
		--------------------------------------------
		local crate1 = display.newImage( "../images/test_crate.png" )
		crate1.x = 180; crate1.y = 100
		crate1.myName = "first crate"

		local crate2 = display.newImage( "../images/test_crate.png" )
		crate2.x = 180; crate2.y = 0
		crate2.myName = "second crate"

		physics.addBody( crate1, { density=3.0, friction=0.5, bounce=0.3 } )
		physics.addBody( crate2, { density=3.0, friction=0.5, bounce=0.3 } )
		
		
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		-----------------------------------------------------------------------------

		group:insert(myScene)
		group:insert(crate1)
		group:insert(crate2)
		group:insert(floor)

end
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        -----------------------------------------------------------------------------
		
        local num = group.numChildren;
		while num >= 1 do
			group:remove(num)
			num = num - 1
		end
		
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