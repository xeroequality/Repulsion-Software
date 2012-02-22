local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------
local spBtn
local mpBtn
local settingsBtn
local aboutBtn

local function onBtnRelease(event)
	-- t refers to which button you clicked
	-- label is the "id" field of that button
	local t = event.target
	local label = t.id
	print("released button " .. label)
	storyboard.gotoScene( label, "fade", 200)
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
		-----------------------------------------------------------------------------
		spBtn = widget.newButton{
			id="menu_sp_main",
			label="Single Player",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		spBtn.view:setReferencePoint( display.CenterReferencePoint )
		spBtn.view.x = display.contentWidth*0.25
		spBtn.view.y = display.contentHeight - 125
		
		mpBtn = widget.newButton{
			id="menu_mp_main",
			label="Multiplayer",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		mpBtn.view:setReferencePoint( display.CenterReferencePoint )
		mpBtn.view.x = display.contentWidth*0.25
		mpBtn.view.y = display.contentHeight - 200
		
		settingsBtn = widget.newButton{
			id="menu_settings",
			label="Settings",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		settingsBtn.view:setReferencePoint( display.CenterReferencePoint )
		settingsBtn.view.x = display.contentWidth*0.75
		settingsBtn.view.y = display.contentHeight - 125
        
		aboutBtn = widget.newButton{
			id="menu_about",
			label="About Us",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBtnRelease
		}
		aboutBtn.view:setReferencePoint( display.CenterReferencePoint )
		aboutBtn.view.x = display.contentWidth*0.75
		aboutBtn.view.y = display.contentHeight - 200
		
		group:insert(spBtn.view)
		group:insert(mpBtn.view)
		group:insert(settingsBtn.view)
		group:insert(aboutBtn.view)
		
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
        if spBtn then
			spBtn:removeSelf()	-- widgets must be manually removed
			spBtn=nil
        end
		if mpBtn then
			mpBtn:removeSelf()
			mpBtn=nil
		end
		if settingsBtn then
			settingsBtn:removeSelf()
			settingsBtn=nil
		end
		if aboutBtn then
			aboutBtn:removeSelf()
			aboutBtn=nil
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