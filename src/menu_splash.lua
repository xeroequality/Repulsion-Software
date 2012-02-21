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
---------------------------------------------------------------------------------local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "menu_mainmenu", "flip", 200 )
	--storyboard.gotoScene( "menu_splash", "fade", 200 )
	
	return true	-- indicates successful touch
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
		 w = display.contentWidth		 h = display.contentHeight

		local space1 = display.newImage( "../images/space.png" )		space1:setReferencePoint ( display.CenterReferencePoint )
		space1.x = 0
		space1.y = h/2		local space2 = display.newImage("../images/space.png" )		--space2:setReferencePoint ( display.CenterReferencePoint )
		space2.x = -w*2
		space2.y = h/2				local function moveSpace (event)			if space1.x >= 2*w then				space1.x = -2*w			end			if space2.x >= 2*w then				space2.x = -2*w			end			--print("space1: " .. space1.x)			--print("space2: " .. space2.x)			space1.x = space1.x + 1			space2.x = space2.x + 1		end				local logo = display.newImageRect("../images/logo.png",480,154)		logo.x = w/2		logo.y = h/2-80				local e = display.newImageRect("../images/earth_slice.png",600,185)		e:setReferencePoint ( display.CenterReferencePoint )		e.x = w/2-10; e.y = h-80		local e_light1 = display.newImage("../images/earth_lightsource.png")		e_light1:setReferencePoint( display.CenterReferencePoint )		e_light1.x = 0; e_light1.y = h/2;		local e_light2 = display.newImage("../images/earth_lightsource.png")		e_light2:setReferencePoint( display.CenterReferencePoint )		e_light2.x = -w*2; e_light2.y = h/2;				local function moveLight (event)			if e_light1.x <= -2*w then				e_light1.x = 2*w			end			if e_light2.x <= -2*w then				e_light2.x = 2*w			end			e_light1.x = e_light1.x - 1			e_light2.x = e_light2.x - 1		end
		
		playBtn = widget.newButton{
			label="Play",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=100, height=50,
			onRelease = onPlayBtnRelease
		}
		playBtn.view:setReferencePoint( display.CenterReferencePoint )
		playBtn.view.x = display.contentWidth*0.5
		playBtn.view.y = display.contentHeight - 125
		
		Runtime:addEventListener( "enterFrame", moveSpace )		Runtime:addEventListener( "enterFrame", moveLight )
        -----------------------------------------------------------------------------        group:insert(space1)        group:insert(space2)        group:insert(e)        group:insert(logo)        group:insert(e_light1)        group:insert(e_light2)        group:insert(playBtn.view)
        
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
        
        -----------------------------------------------------------------------------        if playBtn then
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