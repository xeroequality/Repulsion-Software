----------------------------------------------------------
-- Units.lua
-- Contains all parameters of unit objects in game.
----------------------------------------------------------
local sprite			= require( "sprite" )
local physics 			= require( "physics" )
local Parallax			= require( "module_parallax" )


local Flr = {
	lft = 0,
	wdth = 0
}

Unit = {} -- Unit IDs start at 1000

Unit.setFlr = function(inFloorLeft, inFloorWidth)
	Flr.lft = inFloorLeft
	Flr.wdth = inFloorWidth
end
	
Unit.cannon = {
	id=1000,
	type='projectile',
	img="../images/weapon_cat_cannon.png",
	img_base="../images/weapon_cat_cannon_base.png",
	img_dmg="../images/weapon_cat_cannon.png",
	img_base_dmg="../images/weapon_cat_cannon_base.png",
	img_weapon="../images/projectile_cannonball.png",
	img_ui="../images/ui_item_catCannon.png",
	sfx="../sound/single_cannon_shot.wav",
	rotation=0,
	translate={
		x=-20,
		y=-50
	},
	objShape={	 	-- obj (weapon) array of shape vertices
		-10,0,			-- Top left point going clockwise
		-10,-20,
		40,-20,
		40,0			-- Bottom left
	},
	objBaseShape={	-- obj (base) array of shape vertices
		-10,0,			-- Top left point going clockwise
		40,0,
		40,15,
		-10,15			-- Bottom left
	},
	scaleX=(2/5),
	scaleY=(2/5),
	maxHP=100,
	cost=500,
	resist={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	weapon = display.newImage(""),
	weaponScaleX=(2/3),
	weaponScaleY=(2/3),
	weaponExists=false,
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

--------------------------------------------------------------------------------------------------
--										ALIEN WEAPONS											--
--------------------------------------------------------------------------------------------------

--BASIC/EXPLOSIVE
Unit.energyBall = {
	id=1009,
	type='energy',
	img="../images/weapon_alien_energyBall.png",
	img_base="../images/weapon_alien_base.png",
	img_dmg="../images/weapon_alien_energyBall.png",
	img_base_dmg="../images/weapon_alien_base.png",
	img_weapon="../images/projectile_energyBall.png",
	img_ui="../images/ui_item_energyBall.png",
	sfx="../sound/energyBall.mp3",
	rotation=0,
	translate={
		x=40,
		y=80
	},
	objShape={	 	-- obj (weapon) array of shape vertices
		20,0,			-- Top left point going clockwise
		20,50,
		60,50,
		60,0			-- Bottom left
	},
	objBaseShape={	-- obj (base) array of shape vertices
		0,50,			-- Top left point going clockwise
		50,50,
		50,60,
		0,60			-- Bottom left
	},
	scaleX=(1/3),
	scaleY=(1/3),
	maxHP=100,
	cost=500,
	resist={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	weapon = display.newImage(""),
	weaponScaleX=(2/3),
	weaponScaleY=(2/3),
	weaponExists=false,
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

Unit.repulsionBall = {
	id=1010,
	type='energy',
	img="../images/weapon_alien_repulsionBall.png",
	img_base="../images/weapon_alien_base.png",
	img_dmg="../images/weapon_alien_repulsionBall.png",
	img_base_dmg="../images/weapon_alien_base.png",
	img_weapon="../images/projectile_repulsionBall.png",
	img_ui="../images/ui_item_repulsionBall.png",
	sfx="../sound/repulsionBall.mp3",
	rotation=0,
	translate={
		x=40,
		y=80
	},
	objShape={	 	-- obj (weapon) array of shape vertices
		20,0,			-- Top left point going clockwise
		20,50,
		60,50,
		60,0			-- Bottom left
	},
	objBaseShape={	-- obj (base) array of shape vertices
		0,50,			-- Top left point going clockwise
		50,50,
		50,60,
		0,60			-- Bottom left
	},
	scaleX=(1/3),
	scaleY=(1/3),
	maxHP=100,
	cost=500,
	resist={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	weapon = display.newImage(""),
	weaponScaleX=(1/3),
	weaponScaleY=(1/3),
	weaponExists=false,
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

Unit.weaponSystems = function(event)
	local clickedUnit = event.target
	local selectedUnit
	print('unit type: ' .. clickedUnit.type)
	createCrosshair = function(event) -- creates crosshair when a touch event begins
		-- creates the crosshair
		local phase = event.phase
		print('clickedUnit.x: ' .. clickedUnit.x .. ' clickedUnit.y: ' .. clickedUnit.y)
		if math.mod(whichPlayer, 2) == 0 then -- if even (starting at zero being even) then player's turn otherwise AI's turn
			if (phase == 'began') then
				if not (clickedUnit.weaponExists) then
						if (clickedUnit.type == 'projectile' or clickedUnit.type == 'energy') then
							if not (showCrosshair) then										-- helps ensure that only one crosshair appears
								crosshair = display.newImage( "../images/crosshair.png" )				-- prints crosshair	
								crosshair.x = display.contentWidth - 300
								crosshair.y = display.contentHeight - 200
								showCrosshair = transition.to( crosshair, { alpha=1, xScale=0.5, yScale=0.5, time=200 } )
								transitionStash.newTransition = showCrosshair;
								startRotation = function()
								crosshair.rotation = crosshair.rotation + 4
							end
							Runtime:addEventListener( "enterFrame", startRotation )
							crosshair:addEventListener('touch',fire)
						end
						-- elseif (clickedUnit.type == 'projectile') then 				-- use this format to call the different weapon type functions
					end
				end
			end
		else
			fire()
		end
	end

	fire = function( event )
		if math.mod(whichPlayer, 2) == 0 then -- if even (starting at zero being even) then player's turn otherwise AI's turn
			local phase = event.phase
			if (clickedUnit.type == 'projectile' or clickedUnit.type == 'energy') then
				if "began" == phase then
					display.getCurrentStage():setFocus( crosshair )
					crosshair.isFocus = true
					crosshairLine = nil
				elseif crosshair.isFocus then
					if "moved" == phase then
						
						if ( crosshairLine ) then
							crosshairLine.parent:remove( crosshairLine ) -- erase previous line, if any
						end		
							
						crosshairLine = display.newLine(crosshair.x,crosshair.y, event.x,event.y) -- draws the line from the crosshair
						local deltaYDivX = (event.y-crosshair.y)/(event.x-crosshair.x)
						if (event.y-crosshair.y)-(event.x-crosshair.x) == 0 then
							deltaYDivX = 0
						end
						local cannonRotation = (180/math.pi)*math.atan(deltaYDivX) - clickedUnit.rotation -- rotates the cannon based on the trajectory line
						local whichUnitIndex
						if clickedUnit.id == 1000 then
							whichUnitIndex = 1
						else
							whichUnitIndex = 2
						end
						if (event.x < crosshair.x) then
							clickedUnit[whichUnitIndex].rotation = cannonRotation + 180  -- since arctan goes from -pi/2 to pi/2, this is necessary to make the cannon point backwards
						else
							clickedUnit[whichUnitIndex].rotation = cannonRotation
						end
						crosshairLine:setColor( 0, 255, 0, 200 )
						crosshairLine.width = 8
						
					elseif "ended" == phase or "cancelled" == phase then 						-- have this happen after collision is detected.
						display.getCurrentStage():setFocus( nil )
						crosshair.isFocus = false
							
						local stopRotation = function()
							Runtime:removeEventListener( "enterFrame", startRotation )
						end

						-- make a new image
						clickedUnit.weapon = sprite.newSpriteSheet(clickedUnit.img_weapon, 19, 19)
						local weaponSpriteSet = sprite.newSpriteSet(clickedUnit.weapon,1,3)

						sprite.add(weaponSpriteSet,"clickedUnit.weapon",1,3,500,0)

						weaponSpriteInstance = sprite.newSprite(weaponSpriteSet)
						weaponSpriteInstance:prepare("clickedUnit.weapon")
						weaponSpriteInstance:play()
						weaponSpriteInstance:scale(clickedUnit.weaponScaleX,clickedUnit.weaponScaleY)
						clickedUnit.weaponExists = true
						for i=1,unitGroup.numChildren do
								unitGroup[i]:removeEventListener('touch', Unit.weaponSystems)
						end
						for i=1,enemyUnitGroup.numChildren do
								enemyUnitGroup[i]:removeEventListener('touch', Unit.weaponSystems)
						end

						-- move the image
						weaponSpriteInstance.x = clickedUnit.x + clickedUnit.translateX 				-- need to work on this
						weaponSpriteInstance.y = clickedUnit.y + clickedUnit.translateY					-- and this
						unitGroup:insert(weaponSpriteInstance)
						print('unitGroup: ' .. unitGroup.numChildren)


						-- apply physics to the weapon
						if clickedUnit.x < 500 then
							print('player unit')
							local playerweaponCollisionFilter = { categoryBits = 4, maskBits = 5 } 
							physics.addBody( weaponSpriteInstance, { density=clickedUnit.weaponDensity, friction=clickedUnit.weaponFriction, bounce=clickedUnit.weaponBounce, radius=clickedUnit.weaponRadius, filter=playerweaponCollisionFilter} )
						else
							print('enemy unit')
							local enemyweaponCollisionFilter = { categoryBits = 2, maskBits = 3 } 
							physics.addBody( weaponSpriteInstance, { density=clickedUnit.weaponDensity, friction=clickedUnit.weaponFriction, bounce=clickedUnit.weaponBounce, radius=clickedUnit.weaponRadius, filter=enemyweaponCollisionFilter} )
						end
						weaponSpriteInstance.isBullet = true

						-- fire the weapon            
						weaponSpriteInstance:applyForce( (event.x - crosshair.x)*Unit.cannon.weaponForce, (event.y - (crosshair.y))*Unit.cannon.weaponForce, clickedUnit.x, clickedUnit.y )
						weaponSFX = audio.loadSound(clickedUnit.sfx)
						weaponSFXed = audio.play( weaponSFX,{channel=2} )
						-- make sure that the cannon is on top of the 
						transitionStash.newTransition = transition.to( crosshair, { alpha=0, xScale=1.0, yScale=1.0, time=0, onComplete=stopRotation} )
						showCrosshair = false									-- helps ensure that only one crosshair appears
						
						if ( crosshairLine ) then	
							crosshairLine.parent:remove( crosshairLine ) -- erase previous line, if any
						end
						
						Runtime:addEventListener('enterFrame', removeWeaponBeyondFloor)
						weaponSpriteInstance:addEventListener('collision', removeWeaponOnCollision)
					end
				end
			end
		else
			selectedUnit = enemyUnitGroup[math.random(1,enemyUnitGroup.numChildren)]

			-- local deltaYDivX = (-1)*math.random(0,180)
			-- local cannonRotation = (180/math.pi)*math.atan(deltaYDivX) - selectedUnit.rotation -- rotates the cannon based on the trajectory line
			-- local whichUnitIndex
			-- if selectedUnit.id == 1000 then
				-- whichUnitIndex = 1
			-- else
				-- whichUnitIndex = 2
			-- end
			-- selectedUnit[whichUnitIndex].rotation = cannonRotation

			-- make a new image
			selectedUnit.weapon = sprite.newSpriteSheet(selectedUnit.img_weapon, 19, 19)
			local weaponSpriteSet = sprite.newSpriteSet(selectedUnit.weapon,1,3)

			sprite.add(weaponSpriteSet,"selectedUnit.weapon",3,1,500,0)

			weaponSpriteInstance = sprite.newSprite(weaponSpriteSet)
			weaponSpriteInstance:prepare("selectedUnit.weapon")
			weaponSpriteInstance:play()
			weaponSpriteInstance:scale(selectedUnit.weaponScaleX,selectedUnit.weaponScaleY)
			
			selectedUnit.weaponExists = true
			for i=1,unitGroup.numChildren do
				unitGroup[i]:removeEventListener('touch', Unit.weaponSystems)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:removeEventListener('touch', Unit.weaponSystems)
			end

			-- move the image
			weaponSpriteInstance.x = selectedUnit.x + selectedUnit.translateX 				-- need to work on this
			weaponSpriteInstance.y = selectedUnit.y + selectedUnit.translateY					-- and this
			enemyUnitGroup:insert(weaponSpriteInstance)

			-- apply physics to the weapon
			print('enemy unit')
			local enemyweaponCollisionFilter = { categoryBits = 2, maskBits = 3 } 
			physics.addBody( weaponSpriteInstance, { density=selectedUnit.weaponDensity, friction=selectedUnit.weaponFriction, bounce=selectedUnit.weaponBounce, radius=selectedUnit.weaponRadius, filter=enemyweaponCollisionFilter} )
			weaponSpriteInstance.isBullet = true

			-- fire the weapon
			-- AI stuff I couldn't get working right
			--[[local yForce = -100
			selectedTarget = unitGroup[math.random(1,unitGroup.numChildren)]
			local range = (selectedUnit.x - selectedTarget.x)
			local gx, gy = physics.getGravity()
			print('gravity: ' .. gy)
			print('range: ' .. range)
			local xForce = (yForce*gy*range)/math.sqrt(math.abs(4*math.pow(yForce,2)-math.pow(gy,2)*math.pow(range,2)))
			print('g^2*r^2: ' .. math.pow(gy,2)*math.pow(range,2))
			print('xforce: ' .. xForce)
			local cannonRotation = (180/math.pi)*math.atan(yForce/xForce)
			selectedUnit.rotation = cannonRotation]]--
			
			weaponSpriteInstance:applyForce( -500, -100, selectedUnit.x, selectedUnit.y )
			weaponSFX = audio.loadSound(selectedUnit.sfx)
			weaponSFXed = audio.play( weaponSFX,{channel=2} )
			Runtime:addEventListener('enterFrame', removeWeaponBeyondFloor)
			weaponSpriteInstance:addEventListener('collision', removeWeaponOnCollision)
		end
	end
	deleteWeapon = function()
		Runtime:removeEventListener('enterFrame', removeWeaponBeyondFloor)
		if (clickedUnit.weaponExists) then
			clickedUnit.weaponExists = false
			clickedUnit.parent:remove( clickedUnit.weapon )
		elseif (selectedUnit.weaponExists) then
			selectedUnit.weaponExists = false
			selectedUnit.parent:remove( selectedUnit.weapon )
		end
		print('ball deleted')
		weaponSpriteInstance:removeSelf()
		whichPlayer = whichPlayer + 1
		if (unitGroup.numChildren >= 1 and enemyUnitGroup.numChildren  >= 1) then
			if math.mod(whichPlayer, 2) == 0 then -- if even (starting at zero being even) then player's turn otherwise AI's turn
				for i=1,unitGroup.numChildren do
						unitGroup[i]:addEventListener('touch', Unit.weaponSystems)
				end
				-- enable this to enable pass and play
				-- for i=1,enemyUnitGroup.numChildren do
						-- enemyUnitGroup[i]:addEventListener('touch', Unit.weaponSystems)
				-- end
			else
				timerStash.newTimer = timer.performWithDelay(2000, fire, 1)
			end
		else
			-- Game is over
			if math.mod(whichPlayer, 2) == 0 then -- if even (starting at zero being even) then player's turn otherwise AI's turn
				print('Computer has won the game')
			else 
				print('Player has won the game')
			end
		end
	end
	removeWeaponBeyondFloor = function()
		--Is ball entity there and still in-bounds?
		if(weaponSpriteInstance.x ~= nil or weaponSpriteInstance.y ~= nil) and (not (weaponSpriteInstance.x < Flr.lft or weaponSpriteInstance.x > Flr.lft + Flr.wdth)) then	
			-- Follow the weapon while moving
			Parallax.move_abs(math.round(Parallax.currentView.x + ((weaponSpriteInstance.x - Parallax.currentView.x) * 0.1)), math.round(Parallax.currentView.y + ((weaponSpriteInstance.y - Parallax.currentView.y) * 0.1)), "moved");
		else
			Runtime:removeEventListener('enterFrame', removeWeaponBeyondFloor)
			-- Move View Back to User's Base
			local whereTo
			if math.mod(whichPlayer, 2) == 0 then -- if even (starting at zero being even) then player's turn otherwise AI's turn
				whereTo = math.round(enemyUnitGroup.x)
				for i = math.round(Parallax.currentView.x), whereTo, 1 do
					timerStash.newTimer = timer.performWithDelay(1000, Parallax.move_abs((Parallax.currentView.x + ((i - Parallax.currentView.x))), 0, "moved"), 1)
					-- Parallax.move_abs(Parallax.currentView.x + ((i - Parallax.currentView.x) * 0.01), 0, "moved");
				end
			else
				whereTo = math.round(clickedUnit.x)
				for i = math.round(Parallax.currentView.x), whereTo, -1 do
					timerStash.newTimer = timer.performWithDelay(1000, Parallax.move_abs((Parallax.currentView.x + ((i - Parallax.currentView.x))), 0, "moved"), 1)
					-- Parallax.move_abs(Parallax.currentView.x + ((i - Parallax.currentView.x) * 0.01), 0, "moved");
				end
			end
			Runtime:removeEventListener('enterFrame', removeWeaponBeyondFloor)
			Parallax.move_abs(math.round(Parallax.currentView.x), math.round(Parallax.currentView.y), "ended");
			-- Remove Simulation Handle				
			if (clickedUnit.weaponExists) then
					print('deleting clickedUnit weapon 2')
					deleteWeapon()
			elseif (selectedUnit.weaponExists) then
					print('deleting selectedUnit weapon 2')
					deleteWeapon()
			end
		end
	end
	removeWeaponOnCollision = function()
		weaponSpriteInstance:removeEventListener('collision', removeWeaponOnCollision)  -- makes it so it only activates on the first collision
		print('deleting the ball')
		if (clickedUnit.weaponExists) then
			if clickedUnit.type == 'projectile' then
				weaponSpriteInstance:pause()
			end
		elseif (selectedUnit.weaponExists) then
			if selectedUnit.type == 'projectile' then
				weaponSpriteInstance:pause()
			end
		end
		timerStash.newTimer = timer.performWithDelay(5000, deleteWeapon, 1)
	end
	
	
	print('Inside weaponSystems')
	createCrosshair(event) -- starts the chain reaction for the weapon systems
end

-- Clone method:
-- Pass in an id that matches the unit's id,
--   that object will have all properties of that unit.
	
Unit.clone = function(id)
	unitObjGroup = display.newGroup()
	if id == 1000 then
		cloner = Unit.cannon
	elseif id == 1009 then
		cloner = Unit.energyBall
	elseif id == 1010 then
		cloner = Unit.repulsionBall
	end
		local obj=display.newImage(cloner.img)
		unitObjGroup.id=cloner.id
		unitObjGroup.type=cloner.type
		obj.img_base = display.newImage(cloner.img_base)
		obj.img_dmg=cloner.img_dmg
		obj.img_base_dmg=cloner.img_base_dmg
		unitObjGroup.img_weapon=cloner.img_weapon
		unitObjGroup.sfx=cloner.sfx
		obj.rotation=cloner.rotation
		unitObjGroup.translateX=cloner.translate.x
		unitObjGroup.translateY=cloner.translate.y
		obj:translate(cloner.translate.x,cloner.translate.y)
		unitObjGroup.objShape=cloner.objShape
		unitObjGroup.objBaseShape=cloner.objBaseShape
		unitObjGroup.scaleX=cloner.scaleX
		unitObjGroup.scaleY=cloner.scaleY
		unitObjGroup:scale(cloner.scaleX,cloner.scaleY)
		unitObjGroup.maxHP=cloner.maxHP
		unitObjGroup.currentHP=cloner.maxHP
		unitObjGroup.cost=cloner.cost
		unitObjGroup.resist={
			basic=(cloner.resist).basic,
			fire=(cloner.resist).fire,
			water=(cloner.resist).water,
			explosive=(cloner.resist).explosive,
			electric=(cloner.resist).electric
		}
		unitObjGroup.objDensity=cloner.objDensity
		unitObjGroup.objFriction=cloner.objFriction
		unitObjGroup.objBounce=cloner.objBounce
		unitObjGroup.objBaseDensity=cloner.objBaseDensity
		unitObjGroup.objBaseFriction=cloner.objBaseFriction
		unitObjGroup.objBaseBounce=cloner.objBaseBounce
		unitObjGroup.weaponExists=cloner.weaponExists
		unitObjGroup.weaponScaleX=cloner.weaponScaleX
		unitObjGroup.weaponScaleY=cloner.weaponScaleY
		unitObjGroup.weaponProperties={
			basic=(cloner.weaponProperties).basic,
			fire=(cloner.weaponProperties).fire,
			water=(cloner.weaponProperties).water,
			explosive=(cloner.weaponProperties).explosive,
			electric=(cloner.weaponProperties).electric
		}
		unitObjGroup.weaponRadius=cloner.weaponRadius
		unitObjGroup.weaponForce=cloner.weaponForce
		unitObjGroup.weaponDensity=cloner.weaponDensity
		unitObjGroup.weaponFriction=cloner.weaponFriction
		unitObjGroup.weaponBounce=cloner.weaponBounce
		if id == 1000 then
			unitObjGroup:insert(obj)
			unitObjGroup:insert(obj.img_base)
		else
			unitObjGroup:insert(obj.img_base)
			unitObjGroup:insert(obj)
		end
		unitObjGroup.createCrosshair=cloner.createCrosshair
		unitObjGroup.fire=cloner.fire
		unitObjGroup.deleteWeapon=cloner.deleteWeapon
		unitObjGroup.removeWeaponBeyondFloor=cloner.removeWeaponBeyondFloor
		unitObjGroup.removeWeaponOnCollision=cloner.removeWeaponOnCollision
		
		return unitObjGroup
end

return Unit