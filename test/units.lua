----------------------------------------------------------
-- Units.lua
-- Contains all parameters of unit objects in game.
----------------------------------------------------------
local physics = require("physics")


local Flr = {
	lft = 0,
	wdth = 0
}

Unit = {} -- Unit IDs start at 1000

Unit.setFlr = function(inFloorLeft, inFloorWidth)
	Flr.lft = inFloorLeft
	Flr.wdth = inFloorWidth
end
----------------------------------------------------------
--CAT WEAPONS
----------------------------------------------------------

----------------------------------------------------------
--BASIC/EXPLOSIVE
----------------------------------------------------------
--CANNON	
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
		corrosive=1,
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
		corrosive=1,
		electric=1
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 10,
	projectileDensity=10,
	projectileFriction=0.2,
	projectileBounce=0.05,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

--CRAZY CAT
Unit.crazyCat = {
	id=1001,
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
		corrosive=1,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	projectileProperties={
		basic=10,
		fire=0,
		water=0,
		explosive=0,
		corrosive=0,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 5,
	projectileDensity=5,
	projectileFriction=0.2,
	projectileBounce=0.01,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

--C4
Unit.C4 = {
	id=1002,
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
		corrosive=1,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	projectileProperties={
		basic=0,
		fire=0,
		water=0,
		explosive=10,
		corrosive=0,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 1,
	projectileDensity=1,
	projectileFriction=100,
	projectileBounce=0.00001,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

--.50 CAL
Unit.50Cal = {
	id=1005,
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
		corrosive=1,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	projectileProperties={
		basic=10,
		fire=0,
		water=0,
		explosive=0,
		corrosive=0,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 1,
	projectileDensity=1,
	projectileFriction=0.2,
	projectileBounce=0.01,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}


----------------------------------------------------------
--FIRE
----------------------------------------------------------
--HAIR FIRE BALL
Unit.hairFireBall = {
	id=1003,
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
		fire=5,
		water=0.5,
		explosive=1,
		corrosive=1,
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
		fire=9,
		water=0,
		explosive=0,
		corrosive=0,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 1,
	projectileDensity=1,
	projectileFriction=0.2,
	projectileBounce=0.01,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

--NAPALM STRIKE
Unit.napalmStrike = {
	id=1004,
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
		fire=5,
		water=0.5,
		explosive=1,
		corrosive=1,
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
		fire=9,
		water=0,
		explosive=0,
		corrosive=0,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 3,
	projectileDensity=5,
	projectileFriction=0.2,
	projectileBounce=0.01,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}


----------------------------------------------------------
--CORROSIVE
----------------------------------------------------------
--ACIDIC YARN BALL
Unit.acidicYarnBall = {
	id=1006,
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
		explosive=5,
		corrosive=1,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	projectileProperties={
		basic=0,
		fire=0,
		water=0,
		explosive=0,
		corrosive=10,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 5,
	projectileDensity=5,
	projectileFriction=0.2,
	projectileBounce=0.01,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}


--KITTY LITTER
Unit.kittyLitter = {
	id=1007,
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
		corrosive=5,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	projectileProperties={
		basic=0,
		fire=0,
		water=0,
		explosive=0,
		corrosive=5,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 5,
	projectileDensity=5,
	projectileFriction=0.2,
	projectileBounce=0.01,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}



----------------------------------------------------------
--ELECTRIC
----------------------------------------------------------
--STATIC KITTY
Unit.staticKitty = {
	id=1008,
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
		explosive=5,
		corrosive=1,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	projectileProperties={
		basic=0,
		fire=0,
		water=0,
		explosive=0,
		corrosive=10,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 5,
	projectileDensity=5,
	projectileFriction=0.2,
	projectileBounce=0.01,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

----------------------------------------------------------
--ALIENS WEAPONS
----------------------------------------------------------
--ENERGY BALL	
Unit.energyBall = {
	id=1009,
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
		corrosive=1,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	projectileProperties={
		basic=10,
		fire=0,
		water=0,
		explosive=0,
		corrosive=0,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 10,
	projectileDensity=10,
	projectileFriction=0.2,
	projectileBounce=0.05,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

--REPULSION BALL
Unit.repulsionBall = {
	id=1010,
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
		corrosive=1,
		electric=3
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	projectileProperties={
		basic=3,
		fire=0,
		water=0,
		explosive=0,
		corrosive=0,
		electric=2
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 5,
	projectileDensity=10,
	projectileFriction=0.2,
	projectileBounce=3,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

--DARK MATTER	
Unit.darkMatter = {
	id=1011,
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
		fire=0.5,
		water=1,
		explosive=0.5,
		corrosive=1,
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
		water=0,
		explosive=7,
		corrosive=0,
		electric=1
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 10,
	projectileDensity=10,
	projectileFriction=100,
	projectileBounce=0.000000001,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

--LASER	
Unit.laser = {
	id=1012,
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
		fire=5,
		water=1,
		explosive=1,
		corrosive=1,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	projectileProperties={
		basic=3,
		fire=7,
		water=0,
		explosive=0,
		corrosive=0,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 10,
	projectileDensity=10,
	projectileFriction=0.2,
	projectileBounce=0.05,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

--PYROKINESIS
Unit.pyrokinesis = {
	id=1013,
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
		fire=10,
		water=1,
		explosive=1,
		corrosive=1,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	projectileProperties={
		basic=0,
		fire=10,
		water=0,
		explosive=0,
		corrosive=0,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 1,
	projectileDensity=1,
	projectileFriction=100,
	projectileBounce=0.01,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

--ACID
Unit.cannon = {
	id=1014,
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
		corrosive=5,
		electric=1
	},
	objDensity=10,
	objFriction=0.9,
	objBounce=0,
	objBaseDensity=10,
	objBaseFriction=0.9,
	objBaseBounce=0,
	projectileProperties={
		basic=0,
		fire=0,
		water=0,
		explosive=0,
		corrosive=10,
		electric=0
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 3,
	projectileDensity=5,
	projectileFriction=0.2,
	projectileBounce=1,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, clickedUnit.deleteBall, 1)
	end

}

--TESLA
Unit.tesla = {
	id=1015,
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
		corrosive=1,
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
		corrosive=1,
		electric=1
	},
	projectile = display.newImage(""),
	cballExists=false,
	projectileRadius = 5,
	projectileForce = 10,
	projectileDensity=10,
	projectileFriction=0.2,
	projectileBounce=0.05,
	
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
				clickedUnit.projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				clickedUnit.cballExists = true
				for i=1,unitGroup.numChildren do
					unitGroup[i]:removeEventListener('touch', unitGroup[i].createCrosshair)
				end
				for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:removeEventListener('touch', enemyUnitGroup[i].createCrosshair)
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
				unitGroup[i]:addEventListener('touch', unitGroup[i].createCrosshair)
			end
			for i=1,enemyUnitGroup.numChildren do
				enemyUnitGroup[i]:addEventListener('touch', enemyUnitGroup[i].createCrosshair)
			end
		end
	end,
	 removeballBeyondFloor = function()
		 if( clickedUnit.projectile) then
			if( clickedUnit.projectile.x < Flr.lft or clickedUnit.projectile.x > Flr.lft + Flr.wdth) then
				Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
				print('deleting the ball...2')
				clickedUnit.deleteBall()
			end      
		end
	end,
	removeballOnCollision = function()
		clickedUnit.projectile:removeEventListener('collision', clickedUnit.removeballOnCollision)  -- makes it so it only activates on the first collision
		Runtime:removeEventListener('enterFrame', clickedUnit.removeballBeyondFloor)
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
	else if id == 1001 then
		cloner = Unit.crazyCat
	else if id == 1002 then
		cloner = Unit.c4
	else if id == 1003 then
		cloner = Unit.hairFireBall
	else if id == 1004 then
		cloner = Unit.napalmStrike
	else if id == 1005 then
		cloner = Unit.50Cal
	else if id == 1006 then
		cloner = Unit.acidicYarnBall
	else if id == 1007 then
		cloner = Unit.kittyLitter
	else if id == 1008 then
		cloner = Unit.staticKitty
	else if id == 1009 then
		cloner = Unit.energyBall
	else if id == 1010 then
		cloner = Unit.repulsionBall
	else if id == 1011 then
		cloner = Unit.darkMatter
	else if id == 1012 then
		cloner = Unit.laser
	else if id == 1013 then
		cloner = Unit.pyrokinesis
	else if id == 1014 then
		cloner = Unit.acid
	else id == 1015 then
		cloner = Unit.tesla
	end
		obj=display.newImage(cloner.img)
		unitObjGroup.id=cloner.id
		obj.img_base = display.newImage(cloner.img_base)
		obj.img_dmg=cloner.img_dmg
		obj.img_base_dmg=cloner.img_base_dmg
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