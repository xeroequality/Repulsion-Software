--Item ScrollView UI

UI = {
	focus = nil,
	overlayModule = nil,
	badx = 700,
	badw = 675
}

local setFocus = function(focus)
	UI.focus = focus;
end
UI.setFocus = setFocus

local getFocus = function()
	return UI.focus;
end
UI.getFocus = getFocus

local setOverlayModule = function(overlayModule)
	UI.overlayModule = overlayModule
end
UI.setOverlayModule = setOverlayModule

UI.createSlideBtn = function(which_way,place_at_back)
	local widget = require("widget")
	if which_way == "left" then --Which Direction Should the Arrow Face
		slideBtn = widget.newButton{
			default="../images/ui_btn_buildmenu_left.png",
			over="../images/ui_btn_buildmenu_left_pressed.png",
			width=35, height=35,
			onRelease=UI.slideUI
		}
	else
		slideBtn = widget.newButton{
			default="../images/ui_btn_buildmenu_right.png",
			over="../images/ui_btn_buildmenu_right_pressed.png",
			width=35, height=35,
			onRelease=UI.slideUI
		}
	end
	slideBtn.y = H/2
	if place_at_back == false then --Place it in Back?
		slideBtn.x = scrollView.bkgView.width-45
	else
		slideBtn.x = -35;
	end
end

--------------------------------------------
--               ITEM DRAG                --
--------------------------------------------
UI.dragItem = function(event)
	local phase = event.phase
	local target = event.target
	if scrollView.isOpen and overlay == false and overlay_activity == false then						-- need an and if touch.y is less than 150 so that it doesnt work when the scrollview is above the static button area
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
		UI.focus = event.target;
	elseif target.isFocus then
		if phase == "moved" then
			target.x = event.x - target.x0
			target.y = event.y - target.y0
			--Player can only place item in their area
			if target.x > UI.badx - UI.badw/2 then
				wallet = wallet + target.cost
				target:removeSelf()
				return true
			end
		elseif phase == "ended" or phase == "cancelled" then
			-- If it doesn't already have a bodyType, then add it to physics
			-- If it does, set it's body type to dynamic
			local playerCollisionFilter = { categoryBits = 2, maskBits = 3 }
			if not target.bodyType then
				if target.id < 1000 then
					physics.addBody(target, "dynamic", { density=target.density, friction=target.friction, bounce=target.bounce, shape=target.shape, filter=playerCollisionFilter })
				elseif target.id >= 1000 then
					physics.addBody( target, "dynamic",
						{ density=target.objDensity, friction=target.objFriction, bounce=target.objBounce, shape=target.objShape, filter=playerCollisionFilter },
						{ density=target.objBaseDensity, friction=target.objBaseFriction, bounce=target.objBaseBounce, shape=target.objBaseShape, filter=playerCollisionFilter }
					)
				end
			else
				target.bodyType = "dynamic"
			end
			display.getCurrentStage():setFocus(nil)
			target.isFocus = false
			--target:removeEventListener(dragItem)
		end
	end
	end
	UI.focus = target
	return true
end

--------------------------------------------
--              ITEM SELECT               --
--------------------------------------------
UI.pickItem = function(event)
	local newObj = display.newImage("")
	local phase = event.phase
	local target = event.target
	local Materials = require("materials");
	local Units = require("units")
	if phase == "began" then
		if wallet >= target.cost then
			if target.id < 1000 then
				newObj = Materials.clone(target.id)
				materialGroup:insert(newObj)
			elseif target.id >= 1000 then
				newObj = Units.clone(target.id)
				unitGroup:insert(newObj)
			else
				print("null target")
				return true
			end
			
			wallet = wallet - newObj.cost
			newObj.x = event.x
			newObj.y = event.y
			newObj.id = target.id
			newObj:toFront()
			newObj.child = "Child"; --When the Save Function Runs, It Will Save These Kind of Objects
			newObj:addEventListener("touch",UI.dragItem)
			display.getCurrentStage():setFocus(newObj)

			--Drag This Object
			newObj.isFocus = true
			newObj.x0 = event.x - newObj.x;
			newObj.y0 = event.y - newObj.y;
			-- If physics is already applied to target, make it kinematic
			if newObj.bodyType then
				newObj.bodyType = "kinematic"
				newObj:setLinearVelocity(0,0)
				newObj.angularVelocity = 0
			end
			UI.focus = newObj;
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
			local playerCollisionFilter = { categoryBits = 2, maskBits = 3 }
			if not newObj.bodyType then
				if newObj.id < 1000 then
					physics.addBody(newObj, "dynamic", { density=newObj.density, friction=newObj.friction, bounce=newObj.bounce, shape=newObj.shape, filter=playerCollisionFilter })
				elseif newObj.id >= 1000 then
					physics.addBody( newObj, "dynamic",
						{ density=newObj.objDensity, friction=newObj.objFriction, bounce=newObj.objBounce, shape=newObj.objShape, filter=playerCollisionFilter },
						{ density=newObj.objBaseDensity, friction=newObj.objBaseFriction, bounce=newObj.objBaseBounce, shape=newObj.objBaseShape, filter=playerCollisionFilter }
					)
				end
			else
				newObj.bodyType = "dynamic"
			end
			display.getCurrentStage():setFocus(nil)
			newObj.isFocus = false
		end
	end
	return true
end

UI.slideUI = function()
	local widget = require("widget")
	if scrollView.isOpen then
		print("closing scrollView")
		scrollView.isOpen = false
		transitionStash.newTransition = transition.to(static_menu, {time=300, y=-85} )
		transitionStash.newTransition = transition.to(scrollView.scrollview, {time=300, x=-85} )
		transitionStash.newTransition = transition.to(play_button, {time=300, y=-35} )
		transitionStash.newTransition = transition.to(rotate_button, {time=300, y=-35} )
		transitionStash.newTransition = transition.to(menu_button, {time=300, y=-35} )

		if slideBtn then
			slideBtn:removeSelf()
			UI.createSlideBtn("right",false)
			transitionStash.newTransition = transition.to(slideBtn, {time=300, x=-35} )
			transitionStash.newTransition = transition.to( goodoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=0} )
			transitionStash.newTransition = transition.to( badoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=0} )

		end
	elseif not scrollView.isOpen then
		print("opening scrollView")
		scrollView.isOpen = true
		transitionStash.newTransition = transition.to(static_menu, {time=300, y=0} )
		transitionStash.newTransition = transition.to(scrollView.scrollview, {time=300, x=0} )
		transitionStash.newTransition = transition.to(play_button, {time=300, y=35} )
		transitionStash.newTransition = transition.to(rotate_button, {time=300, y=35} )
		transitionStash.newTransition = transition.to(menu_button, {time=300, y=35} )
		if slideBtn then
			slideBtn:removeSelf()
			UI.createSlideBtn("left",true)
			transitionStash.newTransition = transition.to(slideBtn, {time=300, x=scrollView.bkgView.width-45} )
			transitionStash.newTransition = transition.to( goodoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
			transitionStash.newTransition = transition.to( badoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
		end
		--Close Overlay if Up
		if overlay == true and overlay_activity == false then
			overlay = false;
			overlay_activity = true;
			print("Here")
		end
	end
	return true
end

UI.playUI = function(event)
	slideBtn:removeSelf()
	--make it so that we cannot access it again?
	--delete it!
	-- for i=1,materialGroup.numChildren do
		-- materialGroup[i]:removeEventListener("touch",UI.dragItem)
	-- end
	print('clicked play')
	transitionStash.newTransition = transition.to(menu_button, {time=500, x=-10} )
	scrollView.destroy()
	UI.overlayModule.destroy()
	play_button:removeSelf()
	rotate_button:removeSelf()
	scrollView = nil
	play_button = nil
	rotate_button = nil;
	showCrosshair = false 										-- helps ensure that only one crosshair appears
	for i=1,unitGroup.numChildren do
		print('unitGroup: ' .. unitGroup[i].id)
		unitGroup[i]:removeEventListener("touch",UI.dragItem)
		unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
	end
	for i=1,enemyUnitGroup.numChildren do
		print('unitGroup: ' .. enemyUnitGroup[i].id)
		enemyUnitGroup[i]:removeEventListener("touch",UI.dragItem)
		enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
	end
end

UI.menuUI = function(event)
		-- Need to create a overlay and shade effect and pause the game when the menu button is pressed
	if event.phase == "began" then
		if overlay == false and overlay_activity == false then --Put Up the Overlay
			overlay_activity = true;
			overlay = true;
			local Pause = require("pause_overlay")
			materialGroup = Pause.bringMenutoFront(materialGroup)
			unitGroup = Pause.bringMenutoFront(unitGroup)
		end
	end
end

UI.rotateUI = function(event)
	if event.phase == "ended" then
		UI.focus.rotation = math.floor((UI.focus).rotation)
		UI.focus.rotation = UI.focus.rotation + 90;
		if UI.focus.width ~= UI.focus.height then UI.focus.y = UI.focus.y - (UI.focus.height/(UI.focus.width/UI.focus.height)); end
	end
end
	
UI.createMenuUI = function()
	play_button = display.newImage("../images/ui_play_button.png");
	play_button.x = 45+30; play_button.y = 35; play_button.static = "Yes"; play_button.movy = "Yes";
	rotate_button = display.newImage("../images/ui_rotate_button.png");
	rotate_button.x = 115+30; rotate_button.y = 35; rotate_button.static = "Yes"; rotate_button.movy = "Yes";
	menu_button = display.newImage("../images/ui_menu_button.png");
	menu_button.x = 185+30; menu_button.y = 35; menu_button.static = "Yes"; menu_button.movy = "Yes";
	
	play_button:addEventListener("touch",UI.playUI);
	rotate_button:addEventListener("touch",UI.rotateUI);
	menu_button:addEventListener("touch",UI.menuUI);
end

return UI;