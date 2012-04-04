----------------------------------------------------------
-- Units.lua
-- Contains all parameters of unit objects in game.
----------------------------------------------------------
Unit = {} -- Unit IDs start at 1000

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
	projectileRadius = 5,
	projectileForce = 10,
	projectileDensity=10,
	projectileFriction=0.2,
	projectileBounce=0.05

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
		unitObjGroup.projectileRadius=cloner.projectileRadius
		unitObjGroup.projectileForce=cloner.projectileForce
		unitObjGroup.projectileDensity=cloner.projectileDensity
		unitObjGroup.projectileFriction=cloner.projectileFriction
		unitObjGroup.projectileBounce=cloner.projectileBounce
		unitObjGroup:insert(obj)
		unitObjGroup:insert(obj.img_base)
		return unitObjGroup
end

return Unit