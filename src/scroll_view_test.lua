local widget = require "widget" 
----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------
 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
-- 
--      NOTE: 
--      
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
-- 
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
        
        -----------------------------------------------------------------------------
                
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)
        
        -----------------------------------------------------------------------------
        require ( "physics" )
		
		local space1 = display.newImage( "../images/space.png" )
		space1:setReferencePoint ( display.CenterReferencePoint )
		space1.x = 0
		space1.y = display.contentHeight/2
		
physics.start()
physics.setGravity( 0, 10 )

  -- Create a new ScrollView widget:
local scrollView = widget.newScrollView{ left = display.contentWidth -55, width = 100, height=320, maskFile="../images/mask100x320.png" }

local pipe = display.newRect( 150, 0, 120, 80 )
physics.addBody(pipe, "static", {isSensor = true})
 
pipe:addEventListener("collision", pipe)
 
function pipe:collision (event)
        event.other:removeSelf()
end
 
local floor = display.newRect(0, 300, 400, 20)
physics.addBody(floor, "static")
local spawner = display.newRect( display.contentWidth, 40, 40, 40 )
spawner:setFillColor(150, 100, 0)
scrollView:insert(spawner)

local obj1 = display.newRect(display.contentWidth, 300, 10, 20)
obj1:setFillColor(140,20,10)
scrollView:insert(obj1)



local function spawnMyObject (event)
        if event.phase == "began" then
                local myObject = display.newCircle( 100, 100, 25 )
				myObject:setFillColor(200, 200, 200)
                physics.addBody(myObject, "dynamic", { density=0.2, friction=0.1, bounce=0.5, radius = 25})
                        local function dragObject (event)
								--scrollView:insert(myObject)
								--display.getCurrentStage():setFocus(myObject)
                                myObject.x = event.x
                                myObject.y = event.y
								myObject.bodyType = "dynamic"
								--if event.phase == "ended" or event.phase == "cancelled" then myObject.bodyType = "dynamic" end
                        end
                myObject:addEventListener("touch", dragObject)
        end
end
spawner:addEventListener("touch", spawnMyObject)
end


 
-- group:insert(scrollView.view)

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