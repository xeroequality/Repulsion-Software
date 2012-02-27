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
		
        background = display.newRect(0,0,W*3,H)
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
		
		local floor = display.newRect(0,H-10,W*20,10)
		floor:setFillColor(0)
		physics.addBody(floor, "static", {friction=0.9, bounce=0.05} )
		group:insert(floor)
		
		local scroll_topBound = 0
		local scroll_bottomBound = 0
		local wallet = 1000;
		
		
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
		
		local cost = {200,50,100,50}
		local costs = {50,200,100,50}
		
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
		
		local scroll_text = {};
		for i = 1, 4 do
			scroll_text[i] = display.newText("$"..costs[i],0,0,native.systemFont,12);
			scroll_text[i].x = 35; scroll_text[i].y = H*(i-1)+35
			scroll_text[i]:setReferencePoint(display.CenterReferencePoint)
			scrollView:insert(scroll_text[i]);
			scroll_text[i]:setTextColor(0,0,0)
		end

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
				focus = event.target;
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
			focus = target
			return true
		end
		
		--[[Check for Fallen Objects
		local function fallenItem(event)
			for i = 1, nowPlace do
				local u = physicalObj[i];
				if u.y >= (display.contentHeight*3) then
					wallet = wallet + cost[u.id];
					u:removeSelf();
				end
			end
		end
		Runtime:addEventListener("enterFrame",fallenItem);--]]
		local physicalObj = {}
		local stats = {}
		--Stats are {HP,Cost,Basic Resistance,FireR,WaterR,ExplosiveR,ElectricR,RecursiveDamage}
		local HPMax = {50,25,20,9001}
		local nowPlace = 1;
		local focus = 0;
		local function damage(self,event)
			HP[self.id] = HP[self.id] - event.force;
			print(event.force)
		end
		-- Event for selecting an item from scrollView
		local function pickItem (event)
			local phase = event.phase
			local target = event.target
			if phase == "began" and wallet >= cost[target.id] then
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
				wallet = wallet - cost[target.id]
				newObj:scale(1/3,1/3)
				newObj.x = event.x
				newObj.y = event.y
				newObj.id = nowPlace
				stats[nowPlace] = {HPMax[target.id],cost[target.id],1,1,0,1,0.75,0};
				nowPlace = nowPlace + 1;
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
			end
			
			if newObj.isFocus then
				if phase == "moved" then
					newObj.x = event.x - newObj.x0
					newObj.y = event.y - newObj.y0
				elseif phase == "ended" or phase == "cancelled" then
					-- If it doesn't already have a bodyType, then add it to physics
					-- If it does, set it's body type to dynamic
					if not newObj.bodyType then
						physics.addBody(newObj, "dynamic", {friction=0.9, shape=newObj.shape })
					else
						newObj.bodyType = "dynamic"
					end
					newObj.collision = damage
				newObj:addEventListener( "collision", newObj )
					display.getCurrentStage():setFocus(nil)
					newObj.isFocus = false
					--target:removeEventListener(dragItem)
				end
			end
			
			--
			return true
		end
		
		--Focus HP
		local HPText = display.newText("HP: ",0,0,native.systemFont,16);
		HPText.x = display.contentWidth/2+120; HPText.y = 100; HPText:setTextColor(255,0,255);
		function showHP(event)
			if focus ~= 0 then
				HPText.text = "This Object's HP is "..stats[focus.id][1].."\nCost: "..stats[focus.id][2].."\nBasicR: "..stats[focus.id][3];
				HPText.text = HPText.text.."\nFireR: "..stats[focus.id][4].."\nWaterR: "..stats[focus.id][5].."\nExplosiveR: "..stats[focus.id][6];
				HPText.text = HPText.text.."\nElectricR: "..stats[focus.id][7].."\nRecursive Damage: "..stats[focus.id][8];
			end
		end
		Runtime:addEventListener("enterFrame",showHP);
		
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
		
		local MONEY = display.newText("You Have $"..wallet,0,0,native.systemFont,12);
		MONEY.x = display.contentWidth/2; MONEY.y = display.contentHeight/8;
		MONEY:setTextColor(255,0,0)
		
		function updateMONEY(event)
			MONEY.text = "You Have $"..wallet;
		end
		Runtime:addEventListener("enterFrame",updateMONEY)
		
		--Shift the Scene
		local newx = 0;
		local function shiftScene(event)
			if event.phase == "began" then
				newx = event.x
			end
			for i=1,group.numChildren do
			  local child = group[i]
			  child.x = child.x + (event.x-newx)
			end
			newx = event.x
		end
		background:addEventListener("touch",shiftScene)
		
		local once = false
		--[[
		newObj:scale(1/3,1/3)
		newObj = display.newImage("wood_box.png")
					newObj.shape={-37,-37,37,-37,37,37,-37,37}
				elseif target.id == 2 then
					newObj = display.newImage("wood_plank.png")
					newObj.shape={-37,-7,37,-7,37,7,-37,7}
				elseif target.id == 3 then
					newObj = display.newImage("stone.png")
					newObj.shape={-37,-37,37,-37,37,37,-37,37}
				else
				--]]
		function makeAlienStructure(event)
			if once == false then
				once = true;
				local objs = {};
				local index = 1;
				local baseX = 300;
				local baseY = (H-10);
				
				--Get Some Info
				local path = system.pathForFile( "Alien Structure.txt", system.ResourceDirectory )
				local mpath = system.pathForFile( "Box Stats.txt", system.ResourceDirectory )
				local mfile = io.open( mpath, "r" )
				local file = io.open( path, "r" )
				local saveData; local mData;
				local str = "";
				local commencement = false; --Start Getting Some Data
				local mStart = false; --Material Commencement
				local linenum = 0; local mLineNum = 0;
				for line in file:lines() do
					saveData = line;
					
					--Find the Level Info
					print(saveData)
					if commencement == false then
						if saveData == "Start" then commencement = true end --If This is it, then Continue
					else
						linenum = linenum + 1;
						--Make the Material
						if linenum == 1 then
							mStart = false;
							if saveData == "Wood Plank" then
								--Get That Info from Box Stats.txt
								for otherline in mfile:lines() do
									mData = otherline;
									print("MMM "..mData)
									if mStart == false then
										if mData == saveData then
											mStart = true;
											mLineNum = 0;
											stats[nowPlace] = {};
										end
									else
										mLineNum = mLineNum + 1;
										--Get the Base Image
										if mLineNum == 1 then
											objs[index] = display.newImage(mData);
											objs[index].id = nowPlace;
										end
										--Get the Damaged Image
										--Make the Vertices
										if mLineNum == 3 then
											objs[index].shape={-37,-7,37,-7,37,7,-37,7}
										end
										--Get the XScale
										if mLineNum == 4 then
											n = tonumber(mData)
											objs[index]:scale(n,1);
										end
										--Get the YScale
										if mLineNum == 5 then
											n = tonumber(mData)
											objs[index]:scale(1,n);
										end
										--Get the HP
										if mLineNum == 6 then
											n = tonumber(mData)
											stats[nowPlace][1] = n
										end
										--Get the Cost
										if mLineNum == 7 then
											n = tonumber(mData)
											stats[nowPlace][2] = n
										end
										--Get the Basic Resistance
										if mLineNum >= 8 and mLineNum <= 12 then
											n = tonumber(mData)
											stats[nowPlace][3+(mLineNum-8)] = n
										end
										--Get the Bounce
										if mLineNum == 13 then
											n = tonumber(mData)
											b = n
										end
										--Get the Density
										if mLineNum == 14 then
											n = tonumber(mData)
											d = n
										end
										--Get the Friction
										if mLineNum == 15 then
											n = tonumber(mData)
											f = n
										end
										--Get the Radius
										if mLineNum == 16 then
											n = tonumber(mData)
											if n == 0 then
												physics.addBody(objs[index], "dynamic", {bounce = b, density = d, friction = f, shape=objs[index].shape })
											else
												physics.addBody(objs[index], "dynamic", {bounce = b, density = d, friction = f, radius = n, shape=objs[index].shape })
											end
										end
										--Get the Exit Sprite
										--Exit
										if mLineNum == 18 then
											mStart = false;
											mLineNum = 0;
										end
									end
								end
							end
							if saveData == "Wood Box" then
								objs[index] = display.newImage("wood_box.png");
								objs[index].shape={-37,-37,37,-37,37,37,-37,37}
								objs[index]:scale(1/3,1/3);
							end
						end
						--Close mfile and Reopen
						io.close(mfile);
						mfile = io.open( mpath, "r" )
						--Get the X Coordinate
						if linenum == 2 then
							n = tonumber(saveData)
							objs[index].x = baseX+n;
						end
						--Get the Y Coordinate
						if linenum == 3 then
							n = tonumber(saveData)
							objs[index].y = baseY+n;
						end
						--Get the Rotation Angle
						if linenum == 4 then
							n = tonumber(saveData)
							objs[index]:rotate(n);
						end
						if linenum == 5 then
							commencement = false;
							linenum = 0;
							group:insert(objs[index]);
							index = index + 1;
							nowPlace = nowPlace + 1;
						end
					end
					
				end
				io.close( mfile )
				io.close( file )
				
			end
		end
		Runtime:addEventListener("enterFrame",makeAlienStructure)
		
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