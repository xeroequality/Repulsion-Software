----------------------------------------------------------
-- materials.lua
-- Contains all parameters of material objects in game.
-- Material: Table storing the data of each material.
-- SEE: matTest.lua for usage example(s).
----------------------------------------------------------
Material = {} -- All material IDs must be from 1 to 999

------------------------------
-- Wood Plank
-- Faction: Cats
------------------------------
Material.wood_plank = {
	id=1,
	img="../images/wood_plank.png",
	img_dmg="../images/wood_plank.png",
	img_ui="../images/ui_item_wooden_plank.png",
	materialSFX="../sound/basicImpact.mp3",
	shape={
		-18,-7*0.5,
		18,-7*0.5,
		18,7*0.5,
		-18,7*0.5
	},
	scaleX=(1/6),
	scaleY=(1/6),
	maxHP=100,
	cost=50,
	resist={
		basic=1.5,
		fire=1,
		water=0.7,
		explosive=1.5,
		electric=0.5
	},
	density=0.8,
	friction=0.9,
	bounce=0
}

------------------------------
-- Wood Box
-- Faction: Cats
------------------------------
Material.wood_box = {
	id=2,
	img="../images/wood_box.png",
	img_dmg="../images/wood_box.png",
	img_ui="../images/ui_item_wooden_box.png",
	materialSFX="../sound/basicImpact.mp3",
	shape={
		-18,-18,
		18,-18,
		18,18,
		-18,18
	},
	scaleX=(1/6),
	scaleY=(1/6),
	maxHP=300,
	cost=200,
	resist={
		basic=1.5,
		fire=1,
		water=0.7,
		explosive=1.5,
		electric=0.5
	},
	density=0.9,
	friction=0.9,
	bounce=0
}

------------------------------
-- Granite Slab
-- Faction: Cats
------------------------------
Material.granite_slab = {
	id=3,
	img="../images/granite_slab.png",
	img_dmg="../images/granite_slab.png",
	img_ui="../images/ui_item_granite_slab.png",
	materialSFX="../sound/fallingWoodenBox.mp3",
	shape={
		-18,-7,
		 18,-7,
		 18, 7,
		-18, 7
	},
	scaleX=(1/6),
	scaleY=(1/6),
	maxHP=100,
	cost=75,
	resist={
		basic=1.5,
		fire=0.4,
		water=0.6,
		explosive=1.5,
		electric=0.4
	},
	density=5.0,
	friction=0.9,
	bounce=0
}

------------------------------
-- Glass Sheet
-- Faction: Cats
------------------------------
Material.glass_sheet = {
	id=4,
	img="../images/glass_sheet.png",
	img_dmg="../images/glass_sheet.png",
	img_ui="../images/ui_item_glass_sheet.png",
	materialSFX="../sound/glassImpact.mp3",
	shape={
		-18,-3,
		 18,-3,
		 18, 3,
		-18, 3
	},
	scaleX=(1/6),
	scaleY=(1/6),
	maxHP=100,
	cost=50,
	resist={
		basic=2,
		fire=0.2,
		water=0.2,
		explosive=2,
		electric=0.5
	},
	density=2.0,
	friction=0.8,
	bounce=0
}

------------------------------
-- Glass Triangle
-- Faction: Cats
------------------------------
Material.glass_tri = {
	id=5,
	img="../images/glass_triangle.png",
	img_dmg="../images/glass_triangle.png",
	img_ui="../images/ui_item_glass_triangle.png",
	materialSFX="../sound/glassBreaking.mp3",
	shape={
		  0,-18,
		 18, 18,
		-18, 18
	},
	scaleX=(1/6),
	scaleY=(1/6),
	maxHP=100,
	cost=50,
	resist={
		basic=2,
		fire=0.2,
		water=0.2,
		explosive=2,
		electric=0.5
	},
	density=2.0,
	friction=0.8,
	bounce=0
}

------------------------------
-- Wood Plank
-- Faction: Aliens
------------------------------
Material.wood_plank_alien = {
	id = 100,
	img="../images/wood_plank_alien.png",
	img_dmg="../images/wood_plank_alien.png",
	img_ui="../images/ui_item_wooden_plank_alien.png",
	materialSFX="../sound/basicImpact.mp3",
	shape={
		-18,-3,
		 18,-3,
		 18, 3,
		-18, 3
	},
	scaleX=(1/6),
	scaleY=(1/6),
	maxHP=100,
	cost=50,
	resist={
		basic=1.5,
		fire=1,
		water=0.7,
		explosive=1.5,
		electric=0.5
	},
	density=0.8,
	friction=1,
	bounce=0
}

------------------------------
-- Wood Box
-- Faction: Aliens
------------------------------
Material.wood_box_alien = {
	id = 101,
	img="../images/wood_box_alien.png",
	img_dmg="../images/wood_box_alien.png",
	img_ui="../images/ui_item_wooden_box_alien.png",
	materialSFX="../sound/basicImpact.mp3",
	shape={
		-18,-18,
		18,-18,
		18,18,
		-18,18
	},
	scaleX=(1/6),
	scaleY=(1/6),
	maxHP=30,
	cost=50,
	resist={
		basic=1,
		fire=0.4,
		water=0.7,
		explosive=1.0,
		electric=2
	},
	density=0.8,
	friction=1,
	bounce=0
}

------------------------------
-- Aerogel
-- Faction: Aliens
------------------------------
Material.aerogel = {
	id = 102,
	img="../images/aerogel.png",
	img_dmg="../images/aerogel.png",
	img_ui="../images/ui_item_aerogel.png",
	materialSFX="../sound/fireBall.mp3",
	shape={
		-18,-18,
		18,-18,
		18,18,
		-18,18
	},
	scaleX=(1/6),
	scaleY=(1/6),
	maxHP=15,
	cost=400,
	resist={
		basic=1,
		fire=0.2,
		water=0.5,
		explosive=0.7,
		electric=0.2
	},
	density=0.1,
	friction=1,
	bounce=0
}

------------------------------
-- Carbon Nanotube
-- Faction: Aliens
------------------------------
Material.nanotube = {
	id = 103,
	img="../images/nanotube.png",
	img_dmg="../images/nanotube.png",
	img_ui="../images/ui_item_nanotube.png",
	materialSFX="../sound/fallingWoodenBox.mp3",
	shape={
		-18,-7,
		 18,-7,
		 18, 7,
		-18, 7
	},
	scaleX=(1/6),
	scaleY=(1/6),
	maxHP=500,
	cost=150,
	resist={
		basic=0.4,
		fire=1.4,
		water=0.5,
		explosive=1,
		electric=0.4
	},
	density=1.5,
	friction=1,
	bounce=0
}


-- Clone method:
-- Pass in an object with an "id" that matches the material,
--   that object will have all properties of that material.
Material.clone = function(id)
		print(id);
		if id == 1 then
			cloner = Material.wood_plank
		elseif id == 2 then
			cloner = Material.wood_box
		elseif id == 3 then
			cloner = Material.granite_slab
		elseif id == 4 then
			cloner = Material.glass_sheet
		elseif id == 5 then
			cloner = Material.glass_tri
		elseif id == 100 then
			cloner = Material.wood_plank_alien
		elseif id == 101 then
			cloner = Material.wood_box_alien
		elseif id == 102 then
			cloner = Material.aerogel
		elseif id == 103 then
			cloner = Material.nanotube
		end
			obj=display.newImage(cloner.img)
			obj.id=cloner.id
			obj.img_dmg=cloner.img_dmg
			obj.img_ui=cloner.img_ui
			obj.materialSFX=cloner.materialSFX
			obj.shape=cloner.shape
			obj:scale(cloner.scaleX,cloner.scaleY)
			obj.maxHP=cloner.maxHP
			obj.currentHP=cloner.maxHP
			obj.cost=cloner.cost
			obj.resist={
				basic=(cloner.resist).basic,
				fire=(cloner.resist).fire,
				water=(cloner.resist).water,
				explosive=(cloner.resist).explosive,
				electric=(cloner.resist).electric
			}
			obj.density=cloner.density
			obj.friction=cloner.friction
			obj.bounce=cloner.bounce
		return obj
end

return Material