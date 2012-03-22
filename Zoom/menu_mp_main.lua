local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------
local localBtn
local onlineBtn
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
        
        -----------------------------------------------------------------------------
                
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		localBtn = widget.newButton{
			id="menu_mp_local_main",
			label="Pass N' Play",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActivepng",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		localBtn.view:setReferencePoint( display.CenterReferencePoint )
		localBtn.view.x = display.contentWidth*0.25
		localBtn.view.y = display.contentHeight - 125
		
		onlineBtn = widget.newButton{
			id="menu_mp_online_main",
			label="Online",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		onlineBtn.view:setReferencePoint( display.CenterReferencePoint )
		onlineBtn.view.x = display.contentWidth*0.25
		onlineBtn.view.y = display.contentHeight - 200
		
		backBtn = widget.newButton{
			id="menu_mainmenu",
			labelColor = { default={255}, over={128} },
			default="../images/btn_back.png",
			over="../images/btn_back_pressed.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		backBtn.view:setReferencePoint( display.CenterReferencePoint )
		backBtn.view.x = display.contentWidth*0.75
		backBtn.view.y = display.contentHeight - 125
        
		achievementsBtn = widget.newButton{
			id="menu_achievements",
			label="Achievements",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		achievementsBtn.view:setReferencePoint( display.CenterReferencePoint )
		achievementsBtn.view.x = display.contentWidth*0.75
		achievementsBtn.view.y = display.contentHeight - 200
		
		group:insert(localBtn.view)
		group:insert(onlineBtn.view)
		group:insert(backBtn.view)
		group:insert(achievementsBtn.view)
		
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
        if localBtn then
			localBtn:removeSelf()	-- widgets must be manually removed
			localBtn=nil
        end
		if onlineBtn then
			onlineBtn:removeSelf()
			onlineBtn=nil
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