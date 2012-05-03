local Units = require("units")
--Item ScrollView UI

UI = {
	uiGroup = display.newGroup(),
	play_button = nil,
	rotate_button = nil,
	menu_button = nil,
	play_pressed = false,
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
		slideBtn.x = 40
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
	local bool = true;
	if scrollView == nil then
		bool = true;
	else
		if scrollView.isOpen then
			bool = true
		else
			--bool = false
		end
	end
	if bool == true and overlay == false and overlay_activity == false then						-- need an and if touch.y is less than 150 so that it doesnt work when the scrollview is above the static button area
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
			--Check If Object is in the Vicinity of the Rotate Button
			UI.rotate_button.alpha = 1;
			if target.x >= (UI.rotate_button.x-30) and target.x <= (UI.rotate_button.x+30) then
				if target.y >= (UI.rotate_button.y-30) and target.y <= (UI.rotate_button.y+30) then
					target:rotate(1)
					UI.rotate_button.alpha = 0.25;
				end
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
			UI.rotate_button.alpha = 1;
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
	-- local Pause = require("pause_overlay");
	if phase == "began" then
		if wallet >= target.cost then
			if target.id < 1000 then
				newObj = Materials.clone(target.id)
				materialGroup:insert(newObj)
				-- Pause.bringMenutoFront(materialGroup);
				--Update Achievements with Weapons Bought
				Achievements.update("materialsBought",1);
			elseif target.id >= 1000 then
				newObj = Units.clone(target.id)
				unitGroup:insert(newObj)
				-- Pause.bringMenutoFront(unitGroup);
				--Update Achievements with Materials Bought
				Achievements.update("weaponsBought",1);
			else
				print("null target")
				return true
			end
			
			--Update Achievements with Total Objects Bought
			Achievements.update("objectsBought",1);
			
			wallet = wallet - newObj.cost
			--Update Achievements in Total Spent
			Achievements.update("totalSpent",newObj.cost);
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
			-- local Pause = require("pause_overlay")
			-- Pause.bringMenutoFront(materialGroup);
			-- Pause.bringMenutoFront(unitGroup)
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
	if scrollView ~= nil and scrollView.isOpen then
		print("closing scrollView")
		scrollView.isOpen = false
		transitionStash.newTransition = transition.to(static_menu, {time=300, y=-85} )
		transitionStash.newTransition = transition.to(scrollView.scrollview, {time=300, x=-85} )
		transitionStash.newTransition = transition.to(UI.play_button, {time=300, y=-35} )
		transitionStash.newTransition = transition.to(UI.rotate_button, {time=300, y=-35} )
		transitionStash.newTransition = transition.to(UI.menu_button, {time=300, y=-35} )

		if slideBtn then
			slideBtn:removeSelf()
			UI.createSlideBtn("right",false)
			transitionStash.newTransition = transition.to(slideBtn, {time=300, x=-35} )
			transitionStash.newTransition = transition.to( goodoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=0} )
			transitionStash.newTransition = transition.to( badoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=0} )

		end
	elseif scrollView ~= nil and not scrollView.isOpen then
		print("opening scrollView")
		scrollView.isOpen = true
		transitionStash.newTransition = transition.to(static_menu, {time=300, y=0} )
		transitionStash.newTransition = transition.to(scrollView.scrollview, {time=300, x=0} )
		transitionStash.newTransition = transition.to(UI.play_button, {time=300, y=35} )
		transitionStash.newTransition = transition.to(UI.rotate_button, {time=300, y=35} )
		transitionStash.newTransition = transition.to(UI.menu_button, {time=300, y=35} )
		if slideBtn then
			slideBtn:removeSelf()
			UI.createSlideBtn("left",true)
			transitionStash.newTransition = transition.to(slideBtn, {time=300, x=40} )
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
	for i=1,materialGroup.numChildren do
		materialGroup[i]:removeEventListener("touch",UI.dragItem)
	end
	print('clicked play')
	UI.play_pressed = true 
	transitionStash.newTransition = transition.to(UI.menu_button, {time=500, x=-10} )
	scrollView.destroy()
	UI.overlayModule.destroy()
	UI.play_button:removeSelf()
	UI.rotate_button:removeSelf()
	--scrollView = nil
	--UI.play_button = nil
	--UI.rotate_button = nil;
	whichPlayer = 0 				-- initializes tracking who's turn it is.
	for i=1,unitGroup.numChildren do
		print('unitGroup: ' .. unitGroup[i].id)
		unitGroup[i]:removeEventListener("touch",UI.dragItem)
		unitGroup[i]:addEventListener('touch', Units.weaponSystems)
	end
	if enableAI == false then
		for i=1,enemyUnitGroup.numChildren do
			print('unitGroup: ' .. enemyUnitGroup[i].id)
			enemyUnitGroup[i]:removeEventListener("touch",UI.dragItem)
			enemyUnitGroup[i]:addEventListener('touch', Units.weaponSystems)
		end
	end
	--Convert Money Left Over to Score
	Score.addtoScore(math.ceil(wallet*1.5));
	--Figure Percentage
	local pert = (wallet/levelWallet)*100;
	if pert > Achievements.getValue("maxPercentageofMoneyKept") then
		Achievements.replace("maxPercentageofMoneyKept",pert);
	end
	print("Percentage: "..pert);
	wallet = 0;
end

UI.menuUI = function(event)
		-- Need to create a overlay and shade effect and pause the game when the menu button is pressed
	if event.phase == "began" then
		if overlay == false and overlay_activity == false then --Put Up the Overlay
			overlay_activity = true;
			overlay = true;
			-- local Pause = require("pause_overlay")
			-- Pause.bringMenutoFront(materialGroup)
			-- Pause.bringMenutoFront(unitGroup)
		end
	end
end

UI.rotateUI = function(event)
	if UI.focus.id < 1000 then --Rotate Only Materials
		if event.phase == "began" then
			physics.pause(); --Pause the Physics
			--Make the Rotation an Integer
			UI.focus.rotation = math.floor((UI.focus).rotation);
			--Move the Material Up a Bit
			if UI.focus.width ~= UI.focus.height then UI.focus.y = UI.focus.y - ((UI.focus.height/(UI.focus.width/UI.focus.height))*1.5); end
		end
		--Rotate the Thingy
		UI.focus.rotation = UI.focus.rotation+10;
		--Once It's Over...
		if event.phase == "ended" and UI.focus.id < 1000 then --Rotate Only Materials
			physics.start() --Restart the Function
		end
	end
end
	
UI.createMenuUI = function()
	if UI.play_button == nil then
		UI.play_button = display.newImage("../images/ui_play_button.png");
		UI.play_button.x = 45+30; UI.play_button.y = 35; UI.play_button.static = "Yes"; UI.play_button.movy = "Yes";
		UI.uiGroup:insert(UI.play_button)
	end
	if UI.rotate_button == nil then
		UI.rotate_button = display.newImage("../images/ui_rotate_button.png");
		UI.rotate_button.x = 115+30; UI.rotate_button.y = 35; UI.rotate_button.static = "Yes"; UI.rotate_button.movy = "Yes";
		UI.uiGroup:insert(UI.rotate_button)
	end
	if UI.menu_button == nil then
		UI.menu_button = display.newImage("../images/ui_menu_button.png");
		UI.menu_button.x = 185+30; UI.menu_button.y = 35; UI.menu_button.static = "Yes"; UI.menu_button.movy = "Yes";
		UI.uiGroup:insert(UI.menu_button)
	end
	
	UI.play_button:addEventListener("touch",UI.playUI);
	UI.rotate_button:addEventListener("touch",UI.rotateUI);
	UI.menu_button:addEventListener("touch",UI.menuUI);
end

---------------------------------
-------    COLLISION    ---------
---------------------------------

--Collision

UI.hit = function(event)
	local sound_threshold = 4;
		if event.force >= sound_threshold then
			--Collision Sounds
			objectSFX = audio.loadSound(event.target.materialSFX)
			objectSFXed = audio.play(objectSFX,{channel=5})
			--End Collision Sounds
		end


	local threshold = 5;
	--if (event.other).power ~= nil then
		if event.force >= threshold then
			local damage = math.ceil((event.force)/1.5);
			(event.target).currentHP = (event.target).currentHP - damage;
			if event.target.child == nil then
				Score.addtoScore(damage);
			end
			print((event.target).currentHP)
			local h = (event.target).currentHP; local m = (event.target).maxHP;
			if h < 0 then h = 0; end
			local p = math.ceil(4*(h/m));
			(event.target).alpha = (p/4)
			if (event.target).currentHP <= 0 then
				if (event.target).cost ~= nil and event.target.child == nil then
					Score.addtoScore(math.ceil((event.target).cost * 1.5));
					if (event.target).id >= 1000 then
						--Give Bonus Points for Destroying an Enemy Unit
						Score.addtoScore(2500)
						--Add Destroyed Weapons to Achievements
						Achievements.update("weaponsDestroyed",1);
					else
						--Add Destroyed Materials to Achievements
						Achievements.update("materialsDestroyed",1);
					end
					--Add Destroyed Objects to Achievements
					Achievements.update("destroyedObjects",1);
				end
				(event.target):removeSelf()
			end
			print(Achievements.getValue("totalScore"));
		end
	--end
end

return UI;