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
		local active = true;
		
		--O FORTUNA!!!!
		-- local o_fortuna = audio.loadStream("../sound/O Fortuna.mp3");
		local o_fortuna = audio.loadStream("../sound/O Fortuna.mp3");
		local o_play = audio.play(o_fortuna, {channel= 1, loops=-1, fadein=0});

		--Make the Space Backgrounds
		local space1 = display.newImage( "../images/space.png" )
		space1:setReferencePoint ( display.CenterReferencePoint )
		space1.x = 0; space1.y = h/2
		local space2 = display.newImage("../images/space.png" )
		space2:setReferencePoint ( display.CenterReferencePoint )
		space2.x = -w*2; space2.y = h/2
		
		--Move the Space Background
		function moveSpace(event)
			--Check to See if Any of the Backgrounds Have Moved Past a Certain Point
			if space1.x >= 2*w then
				space1.x = -2*w
			end
			if space2.x >= 2*w then
				space2.x = -2*w
			end
			--Increment the Backgrounds' X Position
			space1.x = space1.x + 1
			space2.x = space2.x + 1
		end
		
		local logo = display.newImageRect("../images/logo2.png",480,48)
		logo.x = w/2; logo.y = h/2-80
		
		local e = display.newImageRect("../images/earth_slice.png",600,185)
		e:setReferencePoint ( display.CenterReferencePoint )
		e.x = w/2-10; e.y = h-80
		local e_light1 = display.newImage("../images/earth_lightsource.png")
		e_light1:setReferencePoint( display.CenterReferencePoint )
		e_light1.x = 0; e_light1.y = h/2;
		local e_light2 = display.newImage("../images/earth_lightsource.png")
		e_light2:setReferencePoint( display.CenterReferencePoint )
		e_light2.x = -w*2; e_light2.y = h/2;
		
		--Move the Lights
		function moveLight (event)
			if active == true then
				if e_light1.x <= -2*w then
					e_light1.x = 2*w
				end
				if e_light2.x <= -2*w then
					e_light2.x = 2*w
				end
				e_light1.x = e_light1.x - 1
				e_light2.x = e_light2.x - 1
			end
		end
		
		--Add the Runtime Listeners
		Runtime:addEventListener("enterFrame",moveSpace)
		Runtime:addEventListener("enterFrame",moveLight)
		
		group:insert(space1)
		group:insert(space2)
		group:insert(e)
		group:insert(logo)
		group:insert(playBtn.view)
		group:insert(e_light1)
		group:insert(e_light2)
        
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