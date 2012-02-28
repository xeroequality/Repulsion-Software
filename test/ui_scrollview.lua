local storyboard = require( "storyboard" )
local widget 	 = require( "widget" )
local scrollview = require( "scrollview" )
local physics 	 = require( "physics" )
local parallax 	 = require( "parallax" )
local Materials  = require( "materials" )
local Enemy 	 = require( "enemybase" )
local scene 	 = storyboard.newScene()
 
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
		
		physics.start()
 
        -----------------------------------------------------------------------------
        --      CREATE display objects and add them to 'group' here.
        --      Example use-case: Restore 'group' from previously saved state.        
        -----------------------------------------------------------------------------
		W = display.contentWidth
		H = display.contentHeight
				
		------------------------------------------------
		--                  PARRALAX                  --
		------------------------------------------------
		-- Create new parallax scene
		local myScene = parallax.newScene(
		{
			width = 1500,
			height = H,
			bottom = H,
			left = 0,
			repeated = false,
			group = group
		} )
		-- Midground Front (City Scape)
		myScene:newLayer(
		{
			image = "background_chapter1_level1_foreground.png",
			width = 960, height = H,
			top = 50, bottom = H,
			left = 0,
			speed = 0.7,
			repeated = "horizontal"
		} )
		-- Midground Back (City Scape)
		myScene:newLayer(
		{
			image = "background_chapter1_level1_foreground.png",
			width = 960, height = H,
			top = 0, bottom = H,
			left = -300,
			speed = 0.6,
			repeated = "horizontal"
		} )
		-- Background (Sky)
		myScene:newLayer(
		{
			image = "background_chapter1_level1_background.png",
			width = 1500, height = H,
			top = 0,
			left = 0,
			speed = 0.5,
			repeated = "horizontal"
		} )

		------------------------------------------------
		-- Functions
		-----------------------------------------------

		--Shift the Scene
		local newx = 0;
		function shiftScene(event)
			if event.phase == "began" then
				newx = event.x
				myScene.xPrev = event.x
			end
			for i=2,group.numChildren do
				local child = group[i]
				
				-- Move within Screen Limits
				if (group[1].x + (event.x-newx)) > 0 then
					-- child.x = 0
				elseif (group[1].x + (event.x-newx)) < - (display.contentWidth + 7.75) then
					-- child.x = W*3
				else
					child.x = child.x + (event.x-newx)
				end
				
				myScene:move( event.x - myScene.xPrev, 0 )
				-- store location as previous
				myScene.xPrev = event.x
			end
			newx = event.x
			
		end

		--------------------------------------------
		-- Events
		--------------------------------------------
		myScene:addEventListener("touch", shiftScene)

end
 
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		-----------------------------------------------------------------------------
		
		--------------------------------------------
		--                PRESETS                 --
		--------------------------------------------
		local music_bg = audio.loadStream("../sound/Bounty 30.mp3");
		local o_play = audio.play(music_bg);
		
		physics.start()
		local slideBtn
		--------------------
		-- Material Objects
		--------------------
		local wood_plank = Materials.wood_plank
		local wood_box = Materials.wood_box
		local stone = Materials.stone
		
		---------
		-- Floor
		---------
		local floor = display.newRect(-5*W,H-10,W*11,10)
		floor:setFillColor(0)
		physics.addBody(floor, "static", {friction=0.9, bounce=0.05} )
		group:insert(floor)
		
		local wallet = 1000;
		
		--------------------------------------------
		--              SCROLLVIEW                --
		--------------------------------------------
		local scroll_topBound = 0
		local scroll_bottomBound = 0
		
		local scroll_bkg = display.newImage("ui_bkg_buildmenu.png")
		scroll_bkg.x = 0
		local item1 = display.newImage("ui_item_wooden_plank.png")
			item1.id=wood_plank.id
			item1:setReferencePoint(display.CenterReferencePoint)
			item1.x = 0; item1.y = 35
			item1.text = display.newText("$"..wood_plank.cost,0,0,native.systemFont,28)
			item1.text:scale(0.5,0.5)
			item1.text:setTextColor(0)
			item1.text.x=0; item1.text.y=item1.y
		local item2 = display.newImage("ui_item_wooden_box.png")
			item2.id=wood_box.id
			item2:setReferencePoint(display.CenterReferencePoint)
			item2.x = 0; item2.y = H
			item2.text = display.newText("$"..wood_box.cost,0,0,native.systemFont,28)
			item2.text:scale(0.5,0.5)
			item2.text:setTextColor(0)
			item2.text.x=0; item2.text.y=item2.y
		local item3 = display.newImage("ui_item_stone.png")
			item3.id=stone.id
			item3:setReferencePoint(display.CenterReferencePoint)
			item3.x = 0; item3.y = 2*H
			item3.text = display.newText("$"..stone.cost,0,0,native.systemFont,28)
			item3.text:scale(0.5,0.5)
			item3.text:setTextColor(0)
			item3.text.x=0; item3.text.y=item3.y
		local item4 = display.newImage("ui_item_null.png")
			item4.id=4
			item4:setReferencePoint(display.CenterReferencePoint)
			item4.x = 0; item4.y = 3*H - 35
		
		local cost = {wood_plank.cost,wood_box.cost,stone.cost}
		
		-- Create scrollView
			-- "isOpen" is for the whether it is "out" (visible) or "in" (offscreen)
			-- Insert all items that belong to scrollView
		local scrollView = scrollview.new{ top=scroll_topBound, bottom=scroll_bottomBound }
		scrollView.isOpen = true
		scrollView:insert(scroll_bkg)
		scrollView:insert(item1)
		scrollView:insert(item1.text)
		scrollView:insert(item2)
		scrollView:insert(item2.text)
		scrollView:insert(item3)
		scrollView:insert(item3.text)
		scrollView:insert(item4)

		
		-- Event for when open/close button is pressed
			-- If scrollView is "open", close it
			-- If scrollView is "closed", open it
		local function slideUI (event)
			if scrollView.isOpen then
				print("closing scrollView")
				scrollView.isOpen = false
				transition.to(scrollView, {time=300, x=-85} )
				if slideBtn then
					slideBtn:removeSelf()
					slideBtn = widget.newButton{
						default="ui_btn_buildmenu_right.png",
						over="ui_btn_buildmenu_right_pressed.png",
						width=35, height=35,
						onRelease=slideUI
					}
					slideBtn.y = H/2
					slideBtn.x = scroll_bkg.width-45
					transition.to(slideBtn, {time=300, x=-35} )
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
					slideBtn.x = -35
					transition.to(slideBtn, {time=300, x=scroll_bkg.width-45} )
				end
			end
			return true
		end
		
		slideBtn = widget.newButton{
			default="ui_btn_buildmenu_left.png",
			over="ui_btn_buildmenu_left_pressed.png",
			width=35, height=35,
			onRelease=slideUI
		}
		slideBtn.y = H/2
		slideBtn.x = scroll_bkg.width-45
		
		--------------------------------------------
		--               ITEM DRAG                --
		--------------------------------------------
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
				focus = event.target;
			elseif target.isFocus then
				if phase == "moved" then
					target.x = event.x - target.x0
					target.y = event.y - target.y0
					if target.y > H then
						-- Player can remove object and add money back by dropping below floor
						wallet = wallet + target.cost
						target:removeSelf()
						return true
					end
				elseif phase == "ended" or phase == "cancelled" then
					-- If it doesn't already have a bodyType, then add it to physics
					-- If it does, set it's body type to dynamic
					if not target.bodyType then
						physics.addBody(target, "dynamic", {friction=target.friction, shape=target.shape })
					else
						target.bodyType = "dynamic"
					end
					display.getCurrentStage():setFocus(nil)
					target.isFocus = false
					--target:removeEventListener(dragItem)
				end
			end
			focus = target
			return true
		end
		
		local focus = 0;
		--------------------------------------------
		--              ITEM SELECT               --
		--------------------------------------------
		-- Event for selecting an item from scrollView
		local function pickItem (event)
			local phase = event.phase
			local target = event.target
			if phase == "began" then
				if wallet >= cost[target.id] then
					if target.id == 1 then
						newObj = display.newImage("wood_plank.png")
						newObj.type = "wood_plank"
					elseif target.id == 2 then
						newObj = display.newImage("wood_box.png")
						newObj.type = "wood_box"
					elseif target.id == 3 then
						newObj = display.newImage("stone.png")
						newObj.type = "stone"
					else
						print("null target")
						return true
					end
					newObj = Materials.clone(newObj)
					wallet = wallet - newObj.cost
					newObj:scale(newObj.scaleX,newObj.scaleY)
					newObj.x = event.x
					newObj.y = event.y
					newObj:addEventListener("touch",dragItem)
					display.getCurrentStage():setFocus(newObj)
				
					--Drag This Object
					display.getCurrentStage():setFocus(newObj)
					newObj.isFocus = true
					newObj.x0 = event.x - newObj.x
					newObj.y0 = event.y - newObj.y
					-- If physics is already applied to target, make it kinematic
					if newObj.bodyType then
						newObj.bodyType = "kinematic"
						newObj:setLinearVelocity(0,0)
						newObj.angularVelocity = 0
					end
					focus = newObj;
					group:insert(newObj)
				else
					print("not enough money!")
					return true
				end
			end
			if newObj.isFocus then
				if phase == "moved" then
					newObj.x = event.x - newObj.x0
					newObj.y = event.y - newObj.y0
				elseif phase == "ended" or phase == "cancelled" then
					-- If it doesn't already have a bodyType, then add it to physics
					-- If it does, set it's body type to dynamic
					if not newObj.bodyType then
						physics.addBody(newObj, "dynamic", {friction=newObj.friction, shape=newObj.shape })
					else
						newObj.bodyType = "dynamic"
					end
					newObj.collision = damage
				newObj:addEventListener( "collision", newObj )
					display.getCurrentStage():setFocus(nil)
					newObj.isFocus = false
				end
			end
			return true
		end
		
		item1:addEventListener("touch",pickItem)
		item2:addEventListener("touch",pickItem)
		item3:addEventListener("touch",pickItem)
		item4:addEventListener("touch",pickItem)
		
		--Focus HP
		local HPText = display.newText("",0,0,native.systemFont,32);
		HPText:scale(0.5,0.5)
		HPText.x = display.contentWidth/2+120; HPText.y = 100; HPText:setTextColor(0);
		function showHP(event)
			if focus ~= 0 then
				HPText.text = "This Object's HP is "..focus.maxHP.."\nCost: "..focus.cost.."\nBasicR: "..(focus.resist).basic;
				HPText.text = HPText.text.."\nFireR: "..(focus.resist).fire.."\nWaterR: "..(focus.resist).water.."\nExplosiveR: "..(focus.resist).explosive;
				HPText.text = HPText.text.."\nElectricR: "..(focus.resist).electric;
			end
		end
		Runtime:addEventListener("enterFrame",showHP);

		
		local MONEY = display.newText("You Have $"..wallet,0,0,native.systemFont,12);
		MONEY.x = display.contentWidth/2; MONEY.y = 15;
		MONEY:setTextColor(255,0,0)
		
		function updateMONEY(event)
			MONEY.text = "You Have $"..wallet;
		end
		Runtime:addEventListener("enterFrame",updateMONEY)
		
		----------------------------------------------
		--           GENERATE ENEMY BASE            --
		----------------------------------------------
		-- In future levels, the ONLY thing that needs to change is the first line:
		local enemy = Enemy.level1
		for i=1,enemy.numObjects do
			local obj = {}
			local baseX = enemy.baseX;
			local baseY = enemy.baseY;
			obj.type = enemy.types[i]
			-- first clone: so obj.img refers to proper image
			-- second clone: to pass data to object
			obj = Materials.clone(obj)
			obj = display.newImage(obj.img)
			obj = Materials.clone(obj)
			obj:scale(obj.scaleX,obj.scaleY)
			obj.x = enemy.x_vals[i]+baseX;
			obj.y = enemy.y_vals[i]+baseY;
			obj.rotation = enemy.rotations[i]
			physics.addBody(obj, {density=obj.density,friction=obj.friction,bounce=obj.bounce,shape=obj.shape} )
			group:insert(obj)
		end
		
		--group:insert(scrollView)
		--group:insert(slideBtn.view)
		group:insert(MONEY)
		group:insert(HPText)
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