local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------
local catBtn
local alienBtn
local backBtn
local achievementsBtn

-- 'onRelease' event listener for playBtn
local function onBtnRelease(event)
	local t = event.target
	local label = t.id
	print("released button " .. label)
	storyboard.gotoScene( label, "fade", 200)
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
		
		--Get the Width and Height of the Screen
		local w = display.contentWidth
		local h = display.contentHeight
		
		--Make the Space Backgrounds
		local space1 = display.newImage( "../images/space.png" )
		space1:setReferencePoint ( display.CenterReferencePoint )
		space1.x = 0; space1.y = h/2
		local space2 = display.newImage("../images/space.png" )
		space2:setReferencePoint ( display.CenterReferencePoint )
		space2.x = -w*2; space2.y = h/2
		
		--Move the Space Background
		moveSpace = function(event)
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
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		-----------------------------------------------------------------------------
		catBtn = widget.newButton{
			id="menu_sp_cats_levelselect",
			labelColor = { default={255}, over={128} },
			default="../images/btn_chooseCats.png",
			over="../images/btn_chooseCats_pressed.png",
			width=280, height=195,
			onRelease = onBtnRelease
		}
		catBtn.view:setReferencePoint( display.CenterReferencePoint )
		catBtn.view.x = (w/2)+70
		catBtn.view.y = (h/2)+30
		
		alienBtn = widget.newButton{
			id="menu_sp_aliens_levelselect",
			labelColor = { default={255}, over={128} },
			default="../images/btn_chooseAliens.png",
			over="../images/btn_chooseAliens_pressed.png",
			width=280, height=195,
			onRelease = onBtnRelease
		}
		alienBtn.view:setReferencePoint( display.CenterReferencePoint )
		alienBtn.view.x = (w/2)-80
		alienBtn.view.y = (h/2)+30
		
		backBtn = widget.newButton{
			id="menu_mainmenu",
			labelColor = { default={255}, over={128} },
			default="../images/btn_back.png",
			over="../images/btn_back_pressed.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		backBtn.view:setReferencePoint( display.CenterReferencePoint )
		backBtn.view.x = 70
		backBtn.view.y = 50
        
		achievementsBtn = widget.newButton{
			id="menu_achievements",
			labelColor = { default={255}, over={128} },
			default="../images/btn_achievements.png",
			over="../images/btn_achievements_pressed.png",
			width=64, height=64,
			onRelease = onBtnRelease
		}
		achievementsBtn.view:setReferencePoint( display.CenterReferencePoint )
		achievementsBtn.view.x = w-70
		achievementsBtn.view.y = 50
		
		--Runtime Listeners
		Runtime:addEventListener("enterFrame",moveSpace)
		
		group:insert(space1)
		group:insert(space2)
		group:insert(catBtn.view)
		group:insert(alienBtn.view)
		group:insert(backBtn.view)
		group:insert(achievementsBtn.view)
		
end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        -----------------------------------------------------------------------------
        --Remove the Runtime Listeners
		Runtime:removeEventListener("enterFrame",moveSpace)
		
        local num = group.numChildren;
		while num >= 1 do
			group:remove(num)
			num = num - 1
		end
		
		moveSpace = nil;
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)
        -----------------------------------------------------------------------------
        if catBtn then
			catBtn:removeSelf()	-- widgets must be manually removed
			catBtn=nil
        end
		if alienBtn then
			alienBtn:removeSelf()
			alienBtn=nil
		end
		if backBtn then
			backBtn:removeSelf()
			backBtn=nil
		end
		if achievementsBtn then
			achievementsBtn:removeSelf()
			achievementsBtn=nil
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