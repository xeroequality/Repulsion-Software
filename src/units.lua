----------------------------------------------------------
-- Units.lua
-- Contains all parameters of unit objects in game.
----------------------------------------------------------
local physics = require("physics")
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
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_projectile="../images/cannonball.png",
	img_ui="../images/ui_item_cannon.png",
	sfx="../sound/Single_cannon_shot.wav",
	rotation=0,
	translate={
		x=8,
		y=-30
	},
	objShape={	 	-- obj (weapon) array of shape vertices
		0,10,			-- Top left point going clockwise
		0,-10,
		40,-10,
		40,10			-- Bottom left
	},
	objBaseShape={	-- obj (base) array of shape vertices
		0,10,			-- Top left point going clockwise
		40,10,
		40,23,
		0,23			-- Bottom left
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
	projectileProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 10,
	projectileDensity=10,
	projectileFriction=0.2,
	projectileBounce=0.05,
	power = 15, --Power of the Cannon Ball
	
	-- Cannon functions below

	createCrosshair = function(event) -- creates crosshair when a touch event begins
		-- creates the crosshair
		local phase = event.phase
		clickedUnit = event.target
		print('clickedUnit.x: ' .. clickedUnit.x .. ' clickedUnit.y: ' .. clickedUnit.y)
		if (phase == 'began') then
			if not (clickedUnit.cballExists) then
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
				crosshair:addEventListener('touch',Unit.cannon.fire)
				end
			end
		end
	end,

	fire = function( event )
		clickedUnit.cballExists=false
		local phase = event.phase
		if "began" == phase then
			display.getCurrentStage():setFocus( crosshair )
			crosshair.isFocus = true
			crosshairLine = nil
			--cannonLine = nil
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
				if (event.x < crosshair.x) then
					clickedUnit[1].rotation = cannonRotation + 180  -- since arctan goes from -pi/2 to pi/2, this is necessary to make the cannon point backwards
				else
					clickedUnit[1].rotation = cannonRotation
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
				clickedUnit.projectile = display.newImage(clickedUnit.img_projectile)
				clickedUnit.projectile.power = 10;
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					if unitGroup[i].createCrosshair ~= nil then
						unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
					end
				end
				for i=1,enemyUnitGroup.numChildren do
					if enemyUnitGroup[i].createCrosshair ~= nil then
						enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
					end
				end

				-- move the image
				--print('Parallax.incX' .. Parallax.incX)
				clickedUnit.projectile.x = clickedUnit.x
				clickedUnit.projectile.y = clickedUnit.y
				unitGroup:insert(clickedUnit.projectile)
				print('unitGroup: ' .. unitGroup.numChildren)


				-- apply physics to the projectile
				if clickedUnit.x < 500 then
					print('player unit')
					local playerProjectileCollisionFilter = { categoryBits = 4, maskBits = 5 } 
					physics.addBody( clickedUnit.projectile, { density=clickedUnit.projectileDensity, friction=clickedUnit.projectileFriction, bounce=clickedUnit.projectileBounce, radius=clickedUnit.projectileRadius, filter=playerProjectileCollisionFilter} )
				else
					print('enemy unit')
					local enemyProjectileCollisionFilter = { categoryBits = 2, maskBits = 3 } 
					physics.addBody( clickedUnit.projectile, { density=clickedUnit.projectileDensity, friction=clickedUnit.projectileFriction, bounce=clickedUnit.projectileBounce, radius=clickedUnit.projectileRadius, filter=enemyProjectileCollisionFilter} )
				end
				clickedUnit.projectile.isBullet = true

				-- fire the projectile            
				clickedUnit.projectile:applyForce( (event.x - crosshair.x)*Unit.cannon.projectileForce, (event.y - (crosshair.y))*Unit.cannon.projectileForce, clickedUnit.x, clickedUnit.y )
				weaponSFX = audio.loadSound(clickedUnit.sfx)
				weaponSFXed = audio.play( weaponSFX,{channel=2} )
				-- make sure that the cannon is on top of the 
				transitionStash.newTransition = transition.to( crosshair, { alpha=0, xScale=1.0, yScale=1.0, time=0, onComplete=stopRotation} )
				showCrosshair = false									-- helps ensure that only one crosshair appears
				
				if ( crosshairLine ) then	
					crosshairLine.parent:remove( crosshairLine ) -- erase previous line, if any
				end
				
				Runtime:addEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				clickedUnit.projectile:addEventListener('collision', clickedUnit.removeballOnCollision)
			end
		end
	end,
	 deleteBall = function()
		if (clickedUnit.cballExists) then
			clickedUnit.projectile:removeSelf()
			clickedUnit.cballExists = false
			print('ball deleted')
			for i=1,unitGroup.numChildren do
				if unitGroup[i].createCrosshair ~= nil then
					unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
				end
			end
			for i=1,enemyUnitGroup.numChildren do
				if enemyUnitGroup[i].createCrosshair ~= nil then
					enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
				end
			end
		end
	end,
	 removeballBeyondFloor = function()
	
		-- Is ball entity there and still in-bounds?
			if(clickedUnit.projectile.x ~= nil or clickedUnit.projectile.y ~= nil) and (not (clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth)) then	
				-- Follow the Projectile while moving
				Parallax.move_abs(math.round(Parallax.currentView.x + ((clickedUnit.projectile.x - Parallax.currentView.x) * 0.1)), math.round(Parallax.currentView.y + ((clickedUnit.projectile.y - Parallax.currentView.y) * 0.1)), "moved");

			else
				-- Move View Back to User's Base				
				for i = Parallax.currentView.x, 0, -0.1 do
					print(Parallax.currentView.x);
					Parallax.move_abs(Parallax.currentView.x + ((i - Parallax.currentView.x) * 0.01), 0, "moved");
				end
				
				-- End Touch Simulation and Remove Handler
				Parallax.move_abs(math.round(Parallax.currentView.x), math.round(Parallax.currentView.y), "ended");
				
				-- Remove Simulation Handle				
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('Ball went out of bounds. Deleting...')
				clickedUnit.deleteBall()				
			end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

-- Clone method:
-- Pass in an id that matches the unit's id,
--   that object will have all properties of that unit.
	
Unit.clone = function(id)
	unitObjGroup = display.newGroup()
	if id == 1000 then
		cloner = Unit.cannon
	end
		obj=display.newImage(cloner.img)
		unitObjGroup.id=cloner.id
		obj.img_base = display.newImage(cloner.img_base)
		obj.img_dmg=cloner.img_dmg
		obj.img_base_dmg=cloner.img_base_dmg
		obj.id = id
		local t = obj.img_base
		t.id = id
		unitObjGroup.img_projectile=cloner.img_projectile
		unitObjGroup.sfx=cloner.sfx
		obj.rotation=cloner.rotation
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
		unitObjGroup.projectileProperties={
			basic=(cloner.projectileProperties).basic,
			fire=(cloner.projectileProperties).fire,
			water=(cloner.projectileProperties).water,
			explosive=(cloner.projectileProperties).explosive,
			electric=(cloner.projectileProperties).electric
		}
		unitObjGroup.cballExists=cloner.cballExists
		unitObjGroup.projectileRadius=cloner.projectileRadius
		unitObjGroup.projectileForce=cloner.projectileForce
		unitObjGroup.projectileDensity=cloner.projectileDensity
		unitObjGroup.projectileFriction=cloner.projectileFriction
		unitObjGroup.projectileBounce=cloner.projectileBounce
		unitObjGroup:insert(obj)
		unitObjGroup:insert(obj.img_base)
		unitObjGroup.createCrosshair=cloner.createCrosshair
		unitObjGroup.fire=cloner.fire
		unitObjGroup.deleteBall=cloner.deleteBall
		unitObjGroup.removeballBeyondFloor=cloner.removeballBeyondFloor
		unitObjGroup.removeballOnCollision=cloner.removeballOnCollision
		return unitObjGroup
end

return Unit