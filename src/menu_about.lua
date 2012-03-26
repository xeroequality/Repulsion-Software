local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------
local backBtn

-- 'onRelease' event listener for playBtn
local function onBackBtnRelease()
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
        
        
        --Make the Repulsion Software Logo
		local RepLogo = display.newImage("../images/logo_RepulsionSoftware.png");
		RepLogo.x = display.contentWidth*0.60; RepLogo.y = display.contentHeight -200; RepLogo:scale(0.4,0.4); RepLogo.alpha = 0.75;
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		-----------------------------------------------------------------------------
		backBtn = widget.newButton{
			id="menu_mainmenu",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=80, height=40,
			onRelease = onBackBtnRelease
		}
    backBtn.view:setReferencePoint( display.CenterReferencePoint )
		backBtn.view.x = display.contentWidth*0.90
		backBtn.view.y = display.contentHeight -290
		
		group:insert(backBtn.view)
                
        local textObj = display.newText("", 0,0, (2*(display.contentWidth)),(1.8*(display.contentHeight)),native.systemFont,24);
        textObj.alpha = 1;
        
        textObj.x = (display.contentWidth/2);
        textObj.y = (display.contentHeight-170);        
        textObj:scale(.5,.5)
        textObj.text="About Us \n \n Team Members: \n Neeti Pathak \n Phillip Lee Fatt \n Jason Simmons \n David Greene \n Travis Smith \n Nickolas Wilson \n Matt Martin \n Christopher Collazo \n Scott Davis \n \n Questions/Suggestions? Email us at RepulsionSoftware@gmail.com \n \n We are a group a students from the Univerity of Florida enrolled in the Introduction to Software Engineering class, where our main objective is to learn the process of developing software from the ground up. We hope you enjoy playing our game and welcome your feedback!"
        
        group:insert(textObj)
		group:insert(RepLogo)
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
        
        if textObj then
            textObj:removeSelf()
            textObj=nil
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