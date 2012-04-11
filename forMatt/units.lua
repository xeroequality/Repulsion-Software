----------------------------------------------------------
-- Units.lua
-- Contains all parameters of unit objects in game.
local physics = require("physics")
----------------------------------------------------------
Unit = {}

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
	shape={
		-18.5,-18.5,
		18.5,-18.5,
		18.5,18.5,
		-18.5,18.5
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
	bounce=0,
	density=0.8,
	friction=0.9,
	createCrosshair=function(event)
		-- creates the crosshair
		local phase = event.phase
		clickedUnit = event.target
		if (phase == 'began') then
			if not (cballExists) then
				if not (showCrosshair) then	     -- helps ensure that only one crosshair appears
					crosshair = display.newImage( "../images/crosshair.png" )-- prints crosshair	
					crosshair.x = display.contentWidth - 300
					crosshair.y = display.contentHeight - 200
					showCrosshair = transition.to(crosshair, { alpha=1, xScale=0.5, yScale=0.5, time=200 })
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
		
		
	forceMultiplier = 10,
	fire = function( event )
	local cBallExists=false
		local phase = event.phase
		if "began" == phase then
			print('clickedUnit.x: ' .. clickedUnit.x .. ' clickedUnit.y: ' .. clickedUnit.y)
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
				local cannonRotation = (180/math.pi)*math.atan((event.y-crosshair.y)/(event.x-crosshair.x)) -- rotates the cannon based on the trajectory line
				if (event.x < crosshair.x) then
					clickedUnit[1].rotation = cannonRotation + 180  -- since arctan goes from -pi/2 to pi/2, this is necessary to make the cannon point backwards
				else
					clickedUnit[1].rotation = cannonRotation
				end
				crosshairLine:setColor( 0, 255, 0, 200 )
				crosshairLine.width = 8
				
			elseif "ended" == phase or "cancelled" == phase then  -- have this happen after collision is detected.
			display.getCurrentStage():setFocus( nil )
			crosshair.isFocus = false
				
			local stopRotation = function()
				Runtime:removeEventListener( "enterFrame", startRotation )
			end
			
				-- make a new image
				projectile = display.newImage(obj.img_projectile)
				projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				cballExists = true

				-- move the image
				--print('Parallax.incX' .. Parallax.incX)
				projectile.x = clickedUnit.x
				projectile.y = clickedUnit.y
				projectile.weapon = 5;
				unitGroup:insert(projectile)
				print('unitGroup: ' .. unitGroup.numChildren)


				-- apply physics to the projectile
				physics.addBody( projectile, { density=3.0, friction=0.2, bounce=0.05, radius=15 } )
				projectile.isBullet = true

				-- fire the projectile            
				projectile:applyForce( (event.x - crosshair.x)*Unit.cannon.forceMultiplier, (event.y - (crosshair.y))*Unit.cannon.forceMultiplier, clickedUnit.x, clickedUnit.y )
				weaponSFX = audio.loadSound(clickedUnit.sfx)
				weaponSFXed = audio.play(weaponSFX,{channel=2} )
				-- make sure that the cannon is on top of the 
				transitionStash.newTransition = transition.to( crosshair, { alpha=0, xScale=1.0, yScale=1.0, time=0, onComplete=stopRotation} )
				showCrosshair = false   -- helps ensure that only one crosshair appears
				
				if ( crosshairLine ) then	
					crosshairLine.parent:remove( crosshairLine ) -- erase previous line, if any
				end
				
				local deleteBall = function()
					if (cballExists) then
						projectile:removeSelf()
						cballExists = false
						print('ball deleted')
					end
				end
				
				local removeballbeyondfloor = function()
					 if( projectile) then
						if( projectile.x < floorleft or projectile.x > floorleft + floorwidth) then
							Runtime:removeEventListener('enterFrame', removeballbeyondfloor)
							print('deleting the ball...2')
							deleteBall()
						end      
					end
				end

				Runtime:addEventListener('enterFrame', removeballbeyondfloor)
				
				local removeballcollision = function()
					projectile:removeEventListener('collision', removeballcollision)  
					-- makes it so it only activates on the first collision
					Runtime:removeEventListener('enterFrame', removeballbeyondfloor)
					--print('deleting the ball')
					timerStash.newTimer = timer.performWithDelay(5000, deleteBall, 1)
				end
				
				projectile:addEventListener('collision', removeballcollision)
				
			end --ends inner if-else
		end --ends outer if-else
	end --ends function
	
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
		obj.img_projectile=cloner.img_projectile
		unitObjGroup.sfx=cloner.sfx
		obj.rotation=cloner.rotation
		obj:translate(cloner.translate.x,cloner.translate.y)
		unitObjGroup.shape=cloner.shape
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
		unitObjGroup.createCrosshair=cloner.createCrosshair
		unitObjGroup.fire=cloner.fire
		unitObjGroup.bounce=cloner.bounce
		unitObjGroup.density=cloner.density
		unitObjGroup.friction=cloner.friction
		unitObjGroup:insert(obj)
		unitObjGroup:insert(obj.img_base)
		return unitObjGroup
end

return Unit