----------------------------------------------------------
-- module_levelfunc.lua
-- Contains table for functions used in SP levels
----------------------------------------------------------
local Materials = require( "materials" )

local LevelFuncs = {
	group = nil,
	physics = nil,
	scrollView = nil,
	wallet = nil,
	focus = nil
}

local function passParams (params)
	if ( params.groupVar ) then
		LevelFuncs.group = params.groupVar
	end
	if ( params.physicsVar ) then
		LevelFuncs.physics = params.physicsVar
	end
	if ( params.scrollViewVar ) then
		LevelFuncs.scrollView = params.scrollViewVar
	end
	if ( params.walletVar ) then
		LevelFuncs.wallet = params.walletVar
	end
	if ( params.focusVar ) then
		LevelFuncs.focus = params.focusVar
	end
end
LevelFuncs.passParams = passParams

local function dragItem (event)
	local phase = event.phase
	local target = event.target
	if LevelFuncs.scrollView.isOpen then
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
					physics.addBody(target, "dynamic", {density=target.density, friction=target.friction, bounce=target.bounce--[[, shape=target.shape]] })
				else
					target.bodyType = "dynamic"
				end
				display.getCurrentStage():setFocus(nil)
				target.isFocus = false
			end
		end
	end
	return true
end
LevelFuncs.dragItem = dragItem

local function pickItem (event)
	local phase = event.phase
	local target = event.target
	local newObj = {}
	if phase == "began" then
		if LevelFuncs.wallet >= Material.getCostByID(target.id) then
			newObj.id = target.id
			newObj = Materials.clone(newObj)
			LevelFuncs.wallet = LevelFuncs.wallet - newObj.cost
			--newObj.view:scale(newObj.scaleX,newObj.scaleY)
			newObj.view.x = event.x
			newObj.view.y = event.y
			newObj.view:addEventListener("touch",LevelFuncs.dragItem)
			display.getCurrentStage():setFocus(newObj.view)
			--[[
			--Drag This Object
			display.getCurrentStage():setFocus(newObj.view)
			newObj.isFocus = true
			newObj.x0 = event.x - newObj.view.x
			newObj.y0 = event.y - newObj.view.y
			-- If physics is already applied to target, make it kinematic
			if newObj.view.bodyType then
				newObj.view.bodyType = "kinematic"
				newObj.view:setLinearVelocity(0,0)
				newObj.view.angularVelocity = 0
			end
			LevelFuncs.group:insert(newObj.view)
		else
			print("not enough money!")
			return true
		end
	end
	if newObj.isFocus then
		if phase == "moved" then
			newObj.view.x = event.x - newObj.x0
			newObj.view.y = event.y - newObj.y0
		elseif phase == "ended" or phase == "cancelled" then
			-- If it doesn't already have a bodyType, then add it to physics
			-- If it does, set it's body type to dynamic
			if not newObj.bodyType then
				physics.addBody(newObj.view, "dynamic", {density=newObj.density, friction=newObj.friction, bounce=newObj.bounce })
			else
				newObj.view.bodyType = "dynamic"
			end
			display.getCurrentStage():setFocus(nil)
			newObj.isFocus = false]]
		end
	end
	return true
end
LevelFuncs.pickItem = pickItem

return LevelFuncs