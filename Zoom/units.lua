----------------------------------------------------------
-- materials.lua
-- Contains all parameters of material objects in game.
-- Material: Table storing the data of each material.
-- SEE: matTest.lua for usage example(s).
----------------------------------------------------------
Unit = {}

Material.wood_plank = {
	id=1,
	img="../images/cannon_sm",
	img_unit="../images/cannon_base_sm",
	img_dmg="../images/wood_plank.png",
	shape={-37,-7,37,-7,37,7,-37,7},
	scaleX=(1/3),
	scaleY=(1/3),
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


-- Clone method:
-- Pass in an object with a "type" that matches the material,
--   that object will have all properties of that material.
Material.clone = function(obj)
	if obj then
		if obj.type == "wood_plank" then
			cloner = Material.wood_plank
		elseif obj.type == "wood_box" then
			cloner = Material.wood_box
		elseif obj.type == "stone" then
			cloner = Material.stone
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
		return obj
	end
end

return Unit