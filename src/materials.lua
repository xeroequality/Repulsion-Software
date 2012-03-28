----------------------------------------------------------
-- materials.lua
-- Contains all parameters of material objects in game.
-- Material: Table storing the data of each material.
-- SEE: matTest.lua for usage example(s).
----------------------------------------------------------
Material = {}

Material.wood_plank = {
	id=1,
	img="../images/wood_plank.png",
	img_dmg="../images/wood_plank.png",
	shape={-37*0.5,-7*0.5,37*0.5,-7*0.5,37*0.5,7*0.5,-37*0.5,7*0.5},
	scaleX=(1/3)*0.5,
	scaleY=(1/3)*0.5,
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
	friction=0.9,
	ui = {
		img="../images/ui_item_wooden_plank.png",
		text="$50"
	}
}

Material.wood_box = {
	id=2,
	img="../images/wood_box.png",
	img_dmg="../images/wood_box.png",
	shape={-37*0.5,-37*0.5,37*0.5,-37*0.5,37*0.5,37*0.5,-37*0.5,37*0.5},
	scaleX=(1/3)*0.5,
	scaleY=(1/3)*0.5,
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
	density=2.0,
	friction=0.9,
	ui = {
		img="../images/ui_item_wooden_box.png",
		text="$200"
	}
}


-- Clone method:
-- Pass in an object with a "type" that matches the material,
--   that object will have all properties of that material.
Material.clone = function(obj)
	if obj then
		if obj.type == "wood_plank" then
			cloner = Material.wood_plank
		elseif obj.type == "wood_box" then
			cloner = Material.wood_box
		end
			obj.id=cloner.id
			obj.img=cloner.img
			obj.img_dmg=cloner.img_dmg
			obj.shape=cloner.shape
			obj.scaleX=cloner.scaleX
			obj.scaleY=cloner.scaleY
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
			obj.ui={
				img=cloner.ui.img,
				text=cloner.ui.text
			}
		return obj
	end
end

return Material