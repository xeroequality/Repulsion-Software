local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scrollview = require( "scrollview" )
local physics = require( "physics" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
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
		W = display.contentWidth
		H = display.contentHeight
		
        local background = display.newRect(0,0,W,H)
		background:setFillColor(255)
		
		group:insert(background)
end
 
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		-----------------------------------------------------------------------------
		physics.start()
		local slideBtn
		
		local floor = display.newRect(0,H-10,W,10)
		floor:setFillColor(0)
		physics.addBody(floor, "static", {friction=0.9, bounce=0.05} )
		group:insert(floor)
		
		local scroll_topBound = 0
		local scroll_bottomBound = 0
		
		
		-- Options to be inserted into the scrollView:
			-- Background Image
			-- Define all items that belong to scrollView
		local scroll_bkg = display.newImage("ui_bkg_buildmenu.png")
		local scroll_item1 = display.newImage("ui_item_wooden_box.png")
		scroll_item1.name="wooden box"
		scroll_item1.id=1
		scroll_item1:setReferencePoint(display.CenterReferencePoint)
		scroll_item1.x = 35
		scroll_item1.y = H
		local scroll_item2 = display.newImage("ui_item_wooden_plank.png")
		scroll_item2.name="wooden plank"
		scroll_item2.id=2
		scroll_item2:setReferencePoint(display.CenterReferencePoint)
		scroll_item2.x = 35
		scroll_item2.y = 35
		local scroll_item3 = display.newImage("ui_item_stone.png")
		scroll_item3.name="large stone"
		scroll_item3.id=3
		scroll_item3:setReferencePoint(display.CenterReferencePoint)
		scroll_item3.x = 35
		scroll_item3.y = 2*H
		local scroll_item4 = display.newImage("ui_item_null.png")
		scroll_item4.name="null item"
		scroll_item4.id=4
		scroll_item4:setReferencePoint(display.CenterReferencePoint)
		scroll_item4.x = 35
		scroll_item4.y = 3*H - 35
		
		-- Create scrollView
			-- "isOpen" is for the whether it is "out" (visible) or "in" (offscreen)
			-- Insert all items that belong to scrollView
		local scrollView = scrollview.new{ top=scroll_topBound, bottom=scroll_bottomBound }
		scrollView.isOpen = true
		scrollView:insert(scroll_bkg)
		scrollView:insert(scroll_item1)
		scrollView:insert(scroll_item2)
		scrollView:insert(scroll_item3)
		scrollView:insert(scroll_item4)

		-- Event for when open/close button is pressed
			-- If scrollView is "open", close it
			-- If scrollView is "closed", open it
		local function slideUI (event)
			if scrollView.isOpen then
				print("closing scrollView")
				scrollView.isOpen = false
				transition.to(scrollView, {time=300, x=-80} )
				if slideBtn then
					slideBtn:removeSelf()
					slideBtn = widget.newButton{
						default="ui_btn_buildmenu_right.png",
						over="ui_btn_buildmenu_right_pressed.png",
						width=35, height=35,
						onRelease=slideUI
					}
					slideBtn.y = H/2
					slideBtn.x = scroll_bkg.width
					transition.to(slideBtn, {time=300, x=10} )
				end
			elseif not scrollView.isOpen then
				print("opening scrollView")
				scrollView.isOpen = true
				transition.to(scrollView, {time=300, x=0} )
				if slideBtn then
					slideBtn:removeSelf()
					slideBtn = widget.newButton{
						default="ui_btn_buildmenu_left.png",
						over="ui_btn_buildmenu_left_pressed.png",
						width=35, height=35,
						onRelease=slideUI
					}
					slideBtn.y = H/2
					slideBtn.x = 10
					transition.to(slideBtn, {time=300, x=scroll_bkg.width} )
				end
			end
			return true
		end
		
		-- Event for dragging an item
		local function dragItem (event)
			local phase = event.phase
			local target = event.target
			if phase == "began" then
				display.getCurrentStage():setFocus(target)
				target.isFocus = true
				target.x0 = event.x - target.x
				target.y0 = event.y - target.y
				-- If physics is already applied to target, make it kinematic
				if target.bodyType then
					target.bodyType = "kinematic"
					target:setLinearVelocity(0,0)
					target.angularVelocity = 0
				end
			elseif target.isFocus then
				if phase == "moved" then
					target.x = event.x - target.x0
					target.y = event.y - target.y0
				elseif phase == "ended" or phase == "cancelled" then
					-- If it doesn't already have a bodyType, then add it to physics
					-- If it does, set it's body type to dynamic
					if not target.bodyType then
						physics.addBody(target, "dynamic", {friction=0.9, shape=target.shape })
					else
						target.bodyType = "dynamic"
					end
					display.getCurrentStage():setFocus(nil)
					target.isFocus = false
					--target:removeEventListener(dragItem)
				end
			end
			return true
		end
		
		-- Event for selecting an item from scrollView
		local function pickItem (event)
			local phase = event.phase
			local target = event.target
			if phase == "began" then
				if target.id == 1 then
					newObj = display.newImage("wood_box.png")
					newObj.shape={-37,-37,37,-37,37,37,-37,37}
				elseif target.id == 2 then
					newObj = display.newImage("wood_plank.png")
					newObj.shape={-37,-7,37,-7,37,7,-37,7}
				elseif target.id == 3 then
					newObj = display.newImage("stone.png")
					newObj.shape={-37,-37,37,-37,37,37,-37,37}
				else
					print("null target")
					return true
				end
				newObj:scale(1/3,1/3)
				newObj.x = event.x
				newObj.y = event.y
				newObj:addEventListener("touch",dragItem)
				display.getCurrentStage():setFocus(newObj)
			end
			group:insert(newObj)
			return true
		end
		
		scroll_item1:addEventListener("touch",pickItem)
		scroll_item2:addEventListener("touch",pickItem)
		scroll_item3:addEventListener("touch",pickItem)
		scroll_item4:addEventListener("touch",pickItem)
		
		slideBtn = widget.newButton{
			default="ui_btn_buildmenu_left.png",
			over="ui_btn_buildmenu_left_pressed.png",
			width=35, height=35,
			onRelease=slideUI
		}
		slideBtn.y = H/2
		slideBtn.x = scroll_bkg.width
		
		group:insert(scrollView)
		group:insert(slideBtn.view)
end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        -----------------------------------------------------------------------------
		--Remove the Runtime Listeners
		scrollGroup:removeEventListener(scroll)
		
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)
        -----------------------------------------------------------------------------
		if slideBtn then
			slideBtn:removeSelf()
			slideBtn = nil
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