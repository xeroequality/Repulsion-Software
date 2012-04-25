local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
-- 
--      NOTE:
--      
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------
local backBtn
local level1Btn
local level2Btn
local level3Btn
local level4Btn
local level5Btn

-- 'onRelease' event listener for playBtn
local function onBtnRelease(event)
	local t = event.target
	local label = t.id
	print("released button " .. label)
	storyboard.gotoScene( label, "zoomInOutFade", 200)
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
		backBtn = widget.newButton{
			id="menu_sp_main",
			label="Back",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		backBtn.view:setReferencePoint( display.CenterReferencePoint )
		backBtn.view.x = display.contentWidth*0.1
		backBtn.view.y = display.contentHeight*0.1
        
		level1Btn = widget.newButton{
			id="sp_aliens_ch1_level1",
			label="Level 1",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		level1Btn.view:setReferencePoint( display.CenterReferencePoint )
		level1Btn.view.x = display.contentWidth*0.1
		level1Btn.view.y = display.contentHeight/2
		
		level2Btn = widget.newButton{
			id="sp_aliens_ch1_level2",
			label="Level 2",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		level2Btn.view:setReferencePoint( display.CenterReferencePoint )
		level2Btn.view.x = display.contentWidth*0.3
		level2Btn.view.y = display.contentHeight/2
		
		level3Btn = widget.newButton{
			id="sp_aliens_ch1_level3",
			label="Level 3",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		level3Btn.view:setReferencePoint( display.CenterReferencePoint )
		level3Btn.view.x = display.contentWidth*0.5
		level3Btn.view.y = display.contentHeight/2
		
		level4Btn = widget.newButton{
			id="sp_aliens_ch1_level4",
			label="Level 4",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		level4Btn.view:setReferencePoint( display.CenterReferencePoint )
		level4Btn.view.x = display.contentWidth*0.7
		level4Btn.view.y = display.contentHeight/2
		
		level5Btn = widget.newButton{
			id="sp_aliens_ch1_level5",
			label="Level 5",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		level5Btn.view:setReferencePoint( display.CenterReferencePoint )
		level5Btn.view.x = display.contentWidth*0.9
		level5Btn.view.y = display.contentHeight/2
		
		group:insert(backBtn.view)
		group:insert(level1Btn.view)
		group:insert(level2Btn.view)
		group:insert(level3Btn.view)
		group:insert(level4Btn.view)
		group:insert(level5Btn.view)
		
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
			backBtn:removeSelf()
			backBtn=nil
		end
		if level1Btn then
			level1Btn:removeSelf()
			level1Btn=nil
		end
		if level2Btn then
			level2Btn:removeSelf()
			level2Btn=nil
		end
		if level3Btn then
			level3Btn:removeSelf()
			level3Btn=nil
		end
		if level4Btn then
			level4Btn:removeSelf()
			level4Btn=nil
		end
		if level5Btn then
			level5Btn:removeSelf()
			level5Btn=nil
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