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
local widget = require( "widget" )
local scene = storyboard.newScene()

local buttonLabel
buttonyButtons = function()
	buttonLabel="prev"
	return true
end
cattyButton = function()
	buttonLabel="cat"
	return true
end
weirdoButton = function()
	buttonLabel="alien"
	return true
end

----------------------------------------------------------------------------------
--go TO screen function--


local function goToScreen()

	-- Check which Screen to Goto
	print(buttonLabel)
	if buttonLabel=="prev" then storyboard.gotoScene( "menu_mainmenu", "zoomInOutFade", 200 ) end
	if buttonLabel=="cat"  then storyboard.gotoScene( "menu_levelselect", "zoomInOutFade", 200 ) end
	if buttonLabel=="alien"  then storyboard.gotoScene( "menu_levelselect", "zoomInOutFade", 200 ) end

	return true

end

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
		 w = display.contentWidth
		 h = display.contentHeight

		--local space1 = display.newImage( "../images/background_chapter1_level1.png" )
		--space1:setReferencePoint ( display.CenterReferencePoint )
		--space1.x = 0
		--space1.y = h/2
		
        -----------------------------------------------------------------------------
        --group:insert(space1)
		
		
		prevButton = widget.newButton{
			label="BACK",
			labelColor = { default={255}, over={128} },
			default="../images/background_leftarrow.png",
			over="../images/background_leftarrow.png",
			width=96; height=96;
			onPress=buttonyButtons,
			onRelease = goToScreen
		}
		
		prevButton.view:setReferencePoint( display.CenterReferencePoint )
		prevButton.view.x = display.contentWidth*0.1
		prevButton.view.y = display.contentHeight - 280
		
		group:insert(prevButton.view)
		
		
		catButton = widget.newButton{
			label="CATS",
			labelColor = { default={255}, over={128} },
			default="../images/cats.png",
			over="../images/cats.png",
			width=96; height=96;
			onPress = cattyButton,
			onRelease = goToScreen
		}
		
		catButton.view:setReferencePoint( display.CenterReferencePoint )
		catButton.view.x = display.contentWidth*0.7
		catButton.view.y = display.contentHeight - 100
		
		group:insert(catButton.view) 
		
		alienButton = widget.newButton{
			label="ALIEN",
			labelColor = { default={255}, over={128} },
			default="../images/alien.png",
			over="../images/alien.png",
			width=96; height=96;
			onPress = weirdoButton,
			onRelease = goToScreen
		}
		
		alienButton.view:setReferencePoint( display.CenterReferencePoint )
		alienButton.view.x = display.contentWidth*0.4
		alienButton.view.y = display.contentHeight - 100
		
		group:insert(alienButton.view)
		
		
		
		
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
        if playBtn then
			playBtn:removeSelf()	-- widgets must be manually removed
			playBtn = nil
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