----------------------------------------------------------
-- materials.lua
-- Contains all parameters of material objects in game.
-- Material: Table storing the data of each material.
-- SEE: matTest.lua for usage example(s).
----------------------------------------------------------
Material = {}

------------------------------
-- Wood Plank
-- Faction: Cats
------------------------------
Material.wood_plank = {
	id=1,
	img="../images/wood_plank.png",
	img_dmg="../images/wood_plank.png",
	img_ui="../images/ui_item_wooden_plank.png",
	width=37,
	height=7,
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
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	bounce=0,
	density=0.8,
	friction=0.9
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
	width=37,
	height=37,
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
		basic=1,
		fire=1,
		water=1,
		explosive=1,
		electric=1
	},
	bounce=0,
	density=0.9,
	friction=0.9
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
	width=37,
	height=14,
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
		basic=1,
		fire=0.5,
		water=1,
		explosive=1,
		electric=0.5
	},
	bounce=0,
	density=5.0,
	friction=0.9
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
	width=37,
	height=6,
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
		fire=0.5,
		water=1,
		explosive=1,
		electric=0.5
	},
	bounce=0,
	density=2.0,
	friction=0.8
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
	width=37,
	height=37,
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
		fire=0.5,
		water=1,
		explosive=1,
		electric=0.5
	},
	bounce=0,
	density=2.0,
	friction=0.8
}

------------------------------
-- Wood Plank
-- Faction: Aliens
------------------------------
Material.wood_plank_alien = {
	id = 11,
	img="../images/wood_plank_alien.png",
	img_dmg="../images/wood_plank_alien.png",
	img_ui="../images/ui_item_wooden_plank_alien.png",
	width=37,
	height=6,
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
		basic=1,
		fire=0.5,
		water=1,
		explosive=1,
		electric=2
	},
	bounce=0,
	density=0.8,
	friction=1
}

------------------------------
-- Wood Box
-- Faction: Aliens
------------------------------
Material.wood_box_alien = {
	id = 12,
	img="../images/wood_box_alien.png",
	img_dmg="../images/wood_box_alien.png",
	img_ui="../images/ui_item_wooden_box_alien.png",
	width=37,
	height=37,
	shape={
		-18,-18,
		18,-18,
		18,18,
		-18,18
	},
	scaleX=(1/6),
	scaleY=(1/6),
	maxHP=100,
	cost=50,
	resist={
		basic=1,
		fire=0.5,
		water=1,
		explosive=1,
		electric=2
	},
	bounce=0,
	density=0.8,
	friction=1
}

------------------------------
-- Aerogel
-- Faction: Aliens
------------------------------
Material.aerogel = {
	id = 13,
	img="../images/aerogel.png",
	img_dmg="../images/aerogel.png",
	img_ui="../images/ui_item_aerogel.png",
	width=37,
	height=37,
	shape={
		-18,-18,
		18,-18,
		18,18,
		-18,18
	},
	scaleX=(1/6),
	scaleY=(1/6),
	maxHP=500,
	cost=400,
	resist={
		basic=1,
		fire=0.5,
		water=2,
		explosive=1,
		electric=0.5
	},
	bounce=0,
	density=0.1,
	friction=1
}

------------------------------
-- Aerogel
-- Faction: Aliens
------------------------------
Material.nanotube = {
	id = 14,
	img="../images/nanotube.png",
	img_dmg="../images/nanotube.png",
	img_ui="../images/ui_item_nanotube.png",
	width=37,
	height=14,
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
		basic=0.5,
		fire=2,
		water=1,
		explosive=1,
		electric=0.5
	},
	bounce=0,
	density=1.5,
	friction=1
}


-- Clone method:
-- Pass in an object with an "id" that matches the material,
--   that object will have all properties of that material.
Material.clone = function(id)
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
		elseif id == 11 then
			cloner = Material.wood_plank_alien
		elseif id == 12 then
			cloner = Material.wood_box_alien
		elseif id == 13 then
			cloner = Material.aerogel
		elseif id == 14 then
			cloner = Material.nanotube
		end
			obj=display.newImageRect(cloner.img, cloner.width, cloner.height)
			obj.img_dmg=cloner.img_dmg
			obj.img_ui=cloner.img_ui
			obj.shape=cloner.shape
			--obj:scale(cloner.scaleX,cloner.scaleY)
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
			obj.bounce=cloner.bounce
			obj.density=cloner.density
			obj.friction=cloner.friction
		return obj
end

return Material