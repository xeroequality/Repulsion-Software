--Artificial Intelligence for the computer
--local Units = require ("units")
local physics = require ("physics")
AI = {}
AI.AIShoot = function ()
	local numUnits = enemyUnitGroup.numChildren
	--picks a cannon at random (between 1 and the number of children)
	--this assumes the enemy base has units
	local pickUnit = math.random(numUnits)
	
	local selectedUnit = enemyUnitGroup[pickUnit]
	selectedUnit.projectile = display.newImage(selectedUnit.img_projectile)
	selectedUnit.projectile.power = 10;
	selectedUnit.projectile:scale(selectedUnit.scaleX,selectedUnit.scaleY)
	selectedUnit.projectile.x = selectedUnit.x
	selectedUnit.projectile.y = selectedUnit.y
	
	--add to physics
	local enemyProjectileCollisionFilter = { categoryBits = 2, maskBits = 3 } 
	physics.addBody( selectedUnit.projectile, { density=selectedUnit.projectileDensity, friction=selectedUnit.projectileFriction, bounce=selectedUnit.projectileBounce, radius=selectedUnit.projectileRadius, filter=enemyProjectileCollisionFilter} )
	selectedUnit.projectile.isBullet = true
	
	--shoot it
	selectedUnit.projectile:applyForce(10, 2, selectedUnit.projectile.x, selectedUnit.projectile.y)
	weaponSFX = audio.loadSound(selectedUnit.sfx)
	weaponSFXed = audio.play( weaponSFX,{channel=2} )
end
return AI