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

--------------------------------------
-- CAT WEAPONS
--------------------------------------

--BASIC/EXPLOSIVE	
Unit.cannon = {
	id=1000,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

Unit.crazyCat = {
	id=1001,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
	img_ui="../images/ui_item_cannon.png",
	sfx="../sound/skyrocket-01.wav",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

Unit.c4 = {
	id=1002,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
	img_ui="../images/ui_item_cannon.png",
	sfx="../sound/Car_exploding.wav",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

Unit.50Cal = {
	id=1005,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
	img_ui="../images/ui_item_cannon.png",
	sfx="../sound/50_cal.wav",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}


--FIRE
Unit.hairFireBall = {
	id=1003,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
	img_ui="../images/ui_item_cannon.png",
	sfx="../sound/fire-01.wav",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

Unit.napalmStrike = {
	id=1004,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
	img_ui="../images/ui_item_cannon.png",
	sfx="../sound/bomb-04.wav",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

--ACID
Unit.acidicYarnBall = {
	id=1006,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

Unit.kittyLitter = {
	id=1007,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

--ELECTRIC
Unit.staticKitty = {
	id=1008,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

-------------------------
--ALIEN WEAPONS
-------------------------

--BASIC/EXPLOSIVE
Unit.energyBall = {
	id=1009,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
	img_ui="../images/ui_item_cannon.png",
	sfx="../sound/sweep1.wav",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

Unit.repulsionBall = {
	id=1010,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
	img_ui="../images/ui_item_cannon.png",
	sfx="../sound/sweep1.wav",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

Unit.darkMatter = {
	id=1011,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

--FIRE
Unit.laser = {
	id=1012,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
	img_ui="../images/ui_item_cannon.png",
	sfx="../sound/laser-01.wav",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

Unit.pyrokinesis = {
	id=1013,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
	img_ui="../images/ui_item_cannon.png",
	sfx="../sound/laser-02.wav",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

--CORROSIVE
Unit.acid = {
	id=1014,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}

--ELECTRIC
Unit.tesla = {
	id=1015,
	type='projectile',
	img="../images/cannon_sm.png",
	img_base="../images/cannon_base_sm.png",
	img_dmg="../images/cannon_sm.png",
	img_base_dmg="../images/cannon_base_sm.png",
	img_weapon="../images/cannonball.png",
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
	weaponProperties={
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	weapon = display.newImage(""),
	weaponExists=false,
	weaponRadius = 5,
	weaponForce = 10,
	weaponDensity=10,
	weaponFriction=0.2,
	weaponBounce=0.05
}
	-- Cannon functions below

Unit.weaponSystems = function(event)
	local clickedUnit = event.target
	print('unit type: ' .. clickedUnit.type)
	createCrosshair = function(event) -- creates crosshair when a touch event begins
		-- creates the crosshair
		local phase = event.phase
		print('clickedUnit.x: ' .. clickedUnit.x .. ' clickedUnit.y: ' .. clickedUnit.y)
		if (phase == 'began') then
			if not (clickedUnit.weaponExists) then
					if (clickedUnit.type == 'projectile') then
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
	end

	fire = function( event )
		clickedUnit.weaponExists=false
		local phase = event.phase
		if (clickedUnit.type == 'projectile') then
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
					clickedUnit.weapon = display.newImage(clickedUnit.img_weapon)
					clickedUnit.weapon:scale(clickedUnit.scaleX,clickedUnit.scaleY)
					clickedUnit.weaponExists = true
					for i=1,unitGroup.numChildren do
						-- if unitGroup[i].createCrosshair ~= nil then
							unitGroup[i]:removeEventListener('touch', Unit.weaponSystems)
						-- end
					end
					for i=1,enemyUnitGroup.numChildren do
						-- if enemyUnitGroup[i].createCrosshair ~= nil then
							enemyUnitGroup[i]:removeEventListener('touch', Unit.weaponSystems)
						-- end
					end
					-- clickedUnit:removeEventListener('touch', createCrosshair)
					-- move the image
					--print('Parallax.incX' .. Parallax.incX)
					clickedUnit.weapon.x = clickedUnit.x
					clickedUnit.weapon.y = clickedUnit.y
					unitGroup:insert(clickedUnit.weapon)
					print('unitGroup: ' .. unitGroup.numChildren)


					-- apply physics to the weapon
					if clickedUnit.x < 500 then
						print('player unit')
						local playerweaponCollisionFilter = { categoryBits = 4, maskBits = 5 } 
						physics.addBody( clickedUnit.weapon, { density=clickedUnit.weaponDensity, friction=clickedUnit.weaponFriction, bounce=clickedUnit.weaponBounce, radius=clickedUnit.weaponRadius, filter=playerweaponCollisionFilter} )
					else
						print('enemy unit')
						local enemyweaponCollisionFilter = { categoryBits = 2, maskBits = 3 } 
						physics.addBody( clickedUnit.weapon, { density=clickedUnit.weaponDensity, friction=clickedUnit.weaponFriction, bounce=clickedUnit.weaponBounce, radius=clickedUnit.weaponRadius, filter=enemyweaponCollisionFilter} )
					end
					clickedUnit.weapon.isBullet = true

					-- fire the weapon            
					clickedUnit.weapon:applyForce( (event.x - crosshair.x)*Unit.cannon.weaponForce, (event.y - (crosshair.y))*Unit.cannon.weaponForce, clickedUnit.x, clickedUnit.y )
					weaponSFX = audio.loadSound(clickedUnit.sfx)
					weaponSFXed = audio.play( weaponSFX,{channel=2} )
					-- make sure that the cannon is on top of the 
					transitionStash.newTransition = transition.to( crosshair, { alpha=0, xScale=1.0, yScale=1.0, time=0, onComplete=stopRotation} )
					showCrosshair = false									-- helps ensure that only one crosshair appears
					
					if ( crosshairLine ) then	
						crosshairLine.parent:remove( crosshairLine ) -- erase previous line, if any
					end
					
					Runtime:addEventListener('enterFrame', removeWeaponBeyondFloor)
					clickedUnit.weapon:addEventListener('collision', removeWeaponOnCollision)
				end
			end
		end
	end
	 deleteWeapon = function()
		if (clickedUnit.weaponExists) then
			print('ball deleted')
			for i=1,unitGroup.numChildren do
					unitGroup[i]:addEventListener('touch', Unit.weaponSystems)
			end
			for i=1,enemyUnitGroup.numChildren do
					enemyUnitGroup[i]:addEventListener('touch', Unit.weaponSystems)
			end
			clickedUnit.weapon:removeSelf()
			clickedUnit.weaponExists = false
		end
	end
	 removeWeaponBeyondFloor = function()
		-- Is ball entity there and still in-bounds?
			if(clickedUnit.weapon.x ~= nil or clickedUnit.weapon.y ~= nil) then	
				-- Follow the weapon while moving
				Parallax.move_abs(math.round(Parallax.currentView.x + ((clickedUnit.weapon.x - Parallax.currentView.x) * 0.1)), math.round(Parallax.currentView.y + ((clickedUnit.weapon.y - Parallax.currentView.y) * 0.1)), "moved");

			else
				-- -- Move View Back to User's Base				
				-- for i = Parallax.currentView.x, clickedUnit.x, -1 do
					-- Parallax.move_abs(Parallax.currentView.x + ((i - Parallax.currentView.x) * 0.01), clickedUnit.x, "moved");
				-- end
				
				-- End Touch Simulation and Remove Handler
				Parallax.move_abs(math.round(Parallax.currentView.x), math.round(Parallax.currentView.y), "ended");
				
				-- Remove Simulation Handle				
				Runtime:removeEventListener('enterFrame', removeWeaponBeyondFloor)
				if (clickedUnit.weaponExists) then
					clickedUnit.deleteWeapon()
				end
			end
	end	removeWeaponOnCollision = function()
		clickedUnit.weapon:removeEventListener('collision', removeWeaponOnCollision)  -- makes it so it only activates on the first collision
		print('deleting the ball')
		timerStash.newTimer = timer.performWithDelay(5000, deleteWeapon, 1)
	end
	print('inside weaponSystems')
	createCrosshair(event) -- starts the chain reaction for the weapon systems
end

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
		unitObjGroup.type=cloner.type
		obj.img_base = display.newImage(cloner.img_base)
		obj.img_dmg=cloner.img_dmg
		obj.img_base_dmg=cloner.img_base_dmg
		-- obj.id = id
		-- local t = obj.img_base
		-- t.id = id
		unitObjGroup.img_weapon=cloner.img_weapon
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
		unitObjGroup.weaponProperties={
			basic=(cloner.weaponProperties).basic,
			fire=(cloner.weaponProperties).fire,
			water=(cloner.weaponProperties).water,
			explosive=(cloner.weaponProperties).explosive,
			electric=(cloner.weaponProperties).electric
		}
		unitObjGroup.weaponExists=cloner.weaponExists
		unitObjGroup.weaponRadius=cloner.weaponRadius
		unitObjGroup.weaponForce=cloner.weaponForce
		unitObjGroup.weaponDensity=cloner.weaponDensity
		unitObjGroup.weaponFriction=cloner.weaponFriction
		unitObjGroup.weaponBounce=cloner.weaponBounce
		unitObjGroup:insert(obj)
		unitObjGroup:insert(obj.img_base)
		unitObjGroup.createCrosshair=cloner.createCrosshair
		unitObjGroup.fire=cloner.fire
		unitObjGroup.deleteWeapon=cloner.deleteWeapon
		unitObjGroup.removeWeaponBeyondFloor=cloner.removeWeaponBeyondFloor
		unitObjGroup.removeWeaponOnCollision=cloner.removeWeaponOnCollision
		
		return unitObjGroup
end

return Unit