----------------------------------------------------------
-- weapons.lua
-- Contains all parameters of material objects in game.
-- Weapon: Table storing the data of each material.
-- SEE: matTest.lua for usage example(s).
----------------------------------------------------------
Weapon = {}
--Notes
--Contact damage for units?
--Indirect prefix denotes weapons such as mortars or airstrikes
--Projectile prefix denotes weapons such as bullets and cannons

----------------------------------------------------------
-- CAT WEAPONS
-- Comment such as "BASIC" denotes main form of damage from weapon
----------------------------------------------------------

----------------------------------------------------------
-- BASIC
----------------------------------------------------------
--Basic cannonball launcher, this can be changed to a super dense hairball instead
Weapon.projectile_cannonball = {
	id=1,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccurring_damage ={
		basic=0,
		fire=0,
		corrosive=0,
		electirc=0
	},
	damage={
		basic=10,
		fire=0,
		corrosive=0,
		electric=0
	},
	bounce=0,
	density=5,
	friction=1,
	force_mult=1,
	radius=15
}

--Kitty with a sniper, big impact on single object, relatively easy to aim
Weapon.projectile_50cal = {
	id=2,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccurring_damage ={
		basic=0,
		fire=0,
		corrosive=0,
		electirc=0
	},
	damage={
		basic=10,
		fire=0,
		corrosive=0,
		electric=0
	},
	bounce=0,
	density=1,
	friction=0,
	force_mult=10,
	radius=15
}

--Cat is released from cage and directed at the enemy's base, latches onto single base object and rips it apart, very hard to aim & high damage
Weapon.projectile_crazyCat = {
	id=3,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccurring_damage ={
		basic=0,
		fire=0,
		corrosive=0,
		electirc=0
	},
	damage={
		basic=10,
		fire=0,
		corrosive=0,
		electric=0
	},
	bounce=0,
	density=1,
	friction=0,
	force_mult=10,
	radius=15
}

--Launched by demo cat, should basically stick to first surface hit then explode with small AOE & medium force
Weapon.projectile_c4 = {
	id=4,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccurring_damage ={
		basic=0,
		fire=0,
		corrosive=0,
		electirc=0
	},
	damage={
		basic=5,
		fire=5,
		corrosive=0,
		electric=0
	},
	bounce=0,
	density=0.1,
	friction=1,
	force_mult=1,
	radius=15
}

----------------------------------------------------------
-- FIRE
----------------------------------------------------------
--Cat hacks up a hairball, lights on fire and throws
Weapon.projectile_hairFireball = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccurring_damage ={
		basic=0,
		fire=5,
		corrosive=0,
		electirc=0
	},
	damage={
		basic=0,
		fire=10,
		corrosive=0,
		electric=0
	},
	bounce=0,
	density=1,
	friction=1,
	force_mult=1,
	radius=15
}

Weapon.projectile_napalmStrike = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccurring_damage ={
		basic=0,
		fire=5,
		corrosive=0,
		electirc=0
	},
	damage={
		basic=0,
		fire=10,
		corrosive=0,
		electric=0
	},
	bounce=0,
	density=1,
	friction=1,
	force_mult=1,
	radius=15
}

----------------------------------------------------------
-- CORROSIVE
----------------------------------------------------------
--Yarn is dipped in a corrosive substance then launched
Weapon.projectile_acidicYarnBall = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccurring_damage ={
		basic=0,
		fire=0,
		corrosive=5,
		electirc=0
	},
	damage={
		basic=0,
		fire=0,
		corrosive=10,
		electric=0
	},
	bounce=0,
	density=1,
	friction=1,
	force_mult=1,
	radius=15
}

--Drop from sky with medium AOE, low damage for aiming is relatively easy
Weapon.indirect_kittyLitter = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccurring_damage ={
		basic=0,
		fire=0,
		corrosive=5,
		electirc=0
	},
	damage={
		basic=0,
		fire=0,
		corrosive=10,
		electric=0
	},
	bounce=0,
	density=1,
	friction=1,
	force_mult=1,
	radius=15
}

----------------------------------------------------------
-- ELECTRIC
----------------------------------------------------------
--This could be a fat fluffy cat that is rubbed against a balloon and then thrown
Weapon.projectile_staticKitty = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccurring_damage ={
		basic=0,
		fire=0,
		corrosive=0,
		electirc=5
	},
	damage={
		basic=0,
		fire=0,
		corrosive=0,
		electric=10
	},
	bounce=0,
	density=5,
	friction=1,
	force_mult=1,
	radius=15
}

----------------------------------------------------------
-- ULTRA
----------------------------------------------------------
--Eats butterflies and poops rainbows
Weapon.projectile_neanCat = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccurring_damage ={
		basic=0,
		fire=15,
		corrosive=15,
		electirc=15
	},
	damage={
		basic=0,
		fire=50,
		corrosive=50,
		electric=50
	},
	bounce=0,
	density=5,
	friction=1,
	force_mult=1,
	radius=15
}

----------------------------------------------------------
-- ALIEN WEAPONS
----------------------------------------------------------

----------------------------------------------------------
-- BASIC
----------------------------------------------------------
--Dense mass of energy fired out of a magnetic cannon
Weapon.projectile_energyBall = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccuring_damage ={
		basic=0,
		fire=0,
		corrosive=0,
		electirc=0
	},
	damage={
		basic=3,
		fire=3,
		corrosive=0,
		electric=3
	},
	bounce=0,
	density=5,
	friction=1,
	force_mult=1,
	radius=15
}

--Energy ball that has high bounce but does small damage.
Weapon.projectile_repulsionBall = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccuring_damage ={
		basic=0,
		fire=0,
		corrosive=0,
		electirc=0
	},
	damage={
		basic=3,
		fire=0,
		corrosive=0,
		electric=2
	},
	bounce=5,
	density=2,
	friction=1,
	force_mult=1,
	radius=15
}

--Ball that explodes on contact with matter
Weapon.projectile_antiMatter = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccuring_damage ={
		basic=0,
		fire=0,
		corrosive=0,
		electirc=0
	},
	damage={
		basic=3,
		fire=0,
		corrosive=0,
		electric=2
	},
	bounce=5,
	density=2,
	friction=1,
	force_mult=1,
	radius=15
}

----------------------------------------------------------
-- FIRE
----------------------------------------------------------
--Laser = fire, straight beam i.e. star wars laser blaster
Weapon.projectile_laser = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccuring_damage ={
		basic=0,
		fire=5,
		corrosive=0,
		electirc=0
	},
	damage={
		basic=0,
		fire=10,
		corrosive=0,
		electric=0
	},
	bounce=0,
	density=5,
	friction=1,
	force_mult=1,
	radius=15
}

--Set things on fire with the mind, rains fire from the sky
Weapon.indirect_pyrokinesis = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccuring_damage ={
		basic=0,
		fire=2,
		corrosive=0,
		electirc=0
	},
	damage={
		basic=0,
		fire=6,
		corrosive=0,
		electric=0
	},
	bounce=0,
	density=5,
	friction=1,
	force_mult=1,
	radius=15
}


----------------------------------------------------------
-- CORROSIVE
----------------------------------------------------------
--Have to figure out what exactly this is going to be
Weapon.projectile_acid = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccuring_damage ={
		basic=0,
		fire=0,
		corrosive=0,
		electirc=5
	},
	damage={
		basic=0,
		fire=0,
		corrosive=10,
		electric=0
	},
	bounce=0,
	density=1,
	friction=1,
	force_mult=1,
	radius=15
}

----------------------------------------------------------
-- ELECTRIC
----------------------------------------------------------
--It shoots lightning
Weapon.projectile_tesla = {
	id=,
	img="../images/cannonball.png",
	img_dmg="../images/cannonball.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
	reoccuring_damage ={
		basic=0,
		fire=0,
		corrosive=0,
		electirc=5
	},
	damage={
		basic=0,
		fire=0,
		corrosive=0,
		electric=10
	},
	bounce=0,
	density=1,
	friction=1,
	force_mult=1,
	radius=15
}


-- Clone method:
-- Pass in an object with a "type" that matches the weapon,
--   that object will have all properties of that weapon.
Weapon.clone = function(obj)
	if obj then
	--Cat Weapons
		--Basic
		if obj.type == "projectile_cannonball" then
			cloner = Weapon.projectile_cannonball
		elseif obj.type == "projectile_50cal" then
			cloner = Weapon.projectile_50cal
		elseif obj.type == "projectile_crazyCat" then
			cloner = Weapon.projectile_crazyCat
		elseif obj.type == "projectile_c4" then
			cloner = Weapon.projectile_c4
		--Fire
		elseif obj.type == "projectile_hairFireBall" then
			cloner = Weapon.projectile_hairFireBall
		elseif obj.type == "projectile_napalmStrike" then
			cloner = Weapon.projectile_napalmStrike
		--Corrosive
		elseif obj.type == "projectile_acidicYarnBall" then
			cloner = Weapon.projectile_acidicYarnBall
		elseif obj.type == "projectile_kittyLitter" then
			cloner = Weapon.projectile_kittyLitter
		--Electric
		elseif obj.type == "projectile_staticKitty" then
			cloner = Weapon.projectile_staticKitty
		--Ultra
		elseif obj.type == "projectile_neanCat" then
			cloner = Weapon.projectile_neanCat
	--Alien Weapons
		--Basic
		elseif obj.type == "projectile_energyBall" then
			cloner = Weapon.projectile_energyBall
		elseif obj.type == "projectile_repulsionBall" then
			cloner = Weapon.projectile_repulsionBall
		--Fire
		elseif obj.type == "projectile_laser" then
			cloner = Weapon.projectile_laser
		--Corrosive
		elseif obj.type == "projectile_acid" then
			cloner = Weapon.projectile_acid
		--Electric
		elseif obj.type == "projectile_tesla" then
			cloner = Weapon.projectile_tesla
		end
			obj.id=cloner.id
			obj.img=cloner.img
			obj.shape=cloner.shape
			obj.scaleX=cloner.scaleX
			obj.scaleY=cloner.scaleY
			obj.reoccuring_damage ={
				basic=(clonder.reoccuring_damage).basic,
				fire=(clonder.reoccuring_damage).fire,
				corrosive=(clonder.reoccuring_damage).corrosive,
				electirc=(clonder.reoccuring_damage).electric
			}
			obj.damage={
				basic=(cloner.damage_mult).basic,
				fire=(cloner.damage_mult).fire,
				corrosive=(cloner.damage_mult).corrosive,
				electric=(cloner.damage_mult).electric
			}
			obj.bounce=cloner.bounce
			obj.density=cloner.density
			obj.friction=cloner.friction
			obj.force_mult=cloner.force_mult
			obj.radius=cloner.radius
		return obj
	end
end

return Weapon