local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	storyboard.gotoScene( "menu_mainmenu", "fade", 200)
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
        -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		-----------------------------------------------------------------------------
		local displayObjects = {
			space1 = display.newImage( "../images/space.png" ),
			space2 = display.newImage( "../images/space.png" ),
			logo = display.newImageRect("../images/logo2.png",480,48),
			alienShips = {},
			e = display.newImageRect("../images/earth_slice.png",600,185),
			e_light1 = display.newImage("../images/earth_lightsource.png"),
			e_light2 = display.newImage("../images/earth_lightsource.png")
		}
		
		playBtn = widget.newButton{
			labelColor = { default={255}, over={128} },
			default="../images/btn_play.png",
			over="../images/btn_play_pressed.png",
			width=96, height=32,
			onRelease = onPlayBtnRelease
		}
		playBtn.view:setReferencePoint( display.CenterReferencePoint )
		playBtn.view.x = display.contentWidth*0.5
		playBtn.view.y = display.contentHeight - 125
		
		--Get the Width and Height of the Screen
		local w = display.contentWidth
		local h = display.contentHeight
		
		local o_fortuna = audio.loadStream("../sound/O Fortuna.mp3")
		local o_play = audio.play(o_fortuna, {loops=-1, fadein=0})

		--Make the Space Backgrounds
		displayObjects.space1:setReferencePoint ( display.CenterReferencePoint )
		displayObjects.space1.x = 0; displayObjects.space1.y = h/2
		displayObjects.space2:setReferencePoint ( display.CenterReferencePoint )
		displayObjects.space2.x = -w*2; displayObjects.space2.y = h/2
		
		--Move the Space Background
		local moveSpace = function(event)
			--Check to See if Any of the Backgrounds Have Moved Past a Certain Point
			if displayObjects.space1.x >= 2*w then
				displayObjects.space1.x = -2*w
			end
			if displayObjects.space2.x >= 2*w then
				displayObjects.space2.x = -2*w
			end
			--Increment the Backgrounds' X Position
			displayObjects.space1.x = displayObjects.space1.x + 1
			displayObjects.space2.x = displayObjects.space2.x + 1
		end
		
		displayObjects.logo.x = w/2; displayObjects.logo.y = h/2-80
		
		displayObjects.alienShips = {}
		local moveShips = function(event)
			for i=1,10 do
				if displayObjects.alienShips[i].loc >= 2*math.pi then
					displayObjects.alienShips[i].loc = 0
				end
				displayObjects.alienShips[i].x = w/2+(250+displayObjects.alienShips[i].spread)*math.cos(displayObjects.alienShips[i].loc)
				displayObjects.alienShips[i].y = h+(200+displayObjects.alienShips[i].spread)*math.sin(displayObjects.alienShips[i].loc)
				displayObjects.alienShips[i].loc = displayObjects.alienShips[i].loc + displayObjects.alienShips[i].step
			end
		end
		
		for i=1,10 do
			local rand = math.random(1,100)
			displayObjects.alienShips[i] = display.newImage("../images/background_UFO.png")
			displayObjects.alienShips[i]:scale(rand/500,rand/500)
			displayObjects.alienShips[i].loc = 0
			displayObjects.alienShips[i].spread = math.random(-20,20)
			rand = rand/5000
			displayObjects.alienShips[i].step = rand
		end
		
		displayObjects.e:setReferencePoint ( display.CenterReferencePoint )
		displayObjects.e.x = w/2-10; displayObjects.e.y = h-80
		displayObjects.e_light1:setReferencePoint( display.CenterReferencePoint )
		displayObjects.e_light1.x = 0; displayObjects.e_light1.y = h/2;
		displayObjects.e_light2:setReferencePoint( display.CenterReferencePoint )
		displayObjects.e_light2.x = -w*2; displayObjects.e_light2.y = h/2;
		
		--Move the Lights
		local moveLight = function(event)
			if displayObjects.e_light1.x <= -2*w then
				displayObjects.e_light1.x = 2*w
			end
			if displayObjects.e_light2.x <= -2*w then
				displayObjects.e_light2.x = 2*w
			end
			displayObjects.e_light1.x = displayObjects.e_light1.x - 1
			displayObjects.e_light2.x = displayObjects.e_light2.x - 1
		end
		
		--Add the Runtime Listeners
		Runtime:addEventListener("enterFrame",moveSpace)
		Runtime:addEventListener("enterFrame",moveLight)
		Runtime:addEventListener("enterFrame",moveShips)
		
		group:insert(displayObjects.space1)
		group:insert(displayObjects.space2)
		group:insert(displayObjects.e)
		group:insert(displayObjects.logo)
		group:insert(playBtn.view)
		for i=1,10 do
			group:insert(displayObjects.alienShips[i])
		end
		group:insert(displayObjects.e_light1)
		group:insert(displayObjects.e_light2)
        
end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        -----------------------------------------------------------------------------
		--Remove the Runtime Listeners
		Runtime:removeEventListener("enterFrame",moveSpace)
		Runtime:removeEventListener("enterFrame",moveLight)
		Runtime:removeEventListener("enterFrame",moveShips)

end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)
        -----------------------------------------------------------------------------
        if playBtn then
			playBtn:removeSelf()	-- widgets must be manually removed
			playBtn=nil
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